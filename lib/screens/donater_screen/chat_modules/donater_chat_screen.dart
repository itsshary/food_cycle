import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/utils/images.dart';

class DonaterChatScreen extends StatefulWidget {
  final String needyUid;
  final String donatorUid;
  final String needyimage;
  final String needname;

  const DonaterChatScreen({
    super.key,
    required this.needyUid,
    required this.donatorUid,
    required this.needyimage,
    required this.needname,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DonaterChatScreenState createState() => _DonaterChatScreenState();
}

class _DonaterChatScreenState extends State<DonaterChatScreen> {
  TextEditingController messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Generate a unique chat ID based on the two user IDs
  String getChatId() {
    List<String> ids = [widget.needyUid, widget.donatorUid];
    ids.sort(); // Ensures consistent order
    return ids.join("_");
  }

  /// Function to send a message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    String chatId = getChatId();
    String currentUserId = _auth.currentUser!.uid;
    String otherUserId =
        currentUserId == widget.needyUid ? widget.donatorUid : widget.needyUid;

    // Save message in Firestore
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'receiverId': otherUserId,
      'text': messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update chat metadata for preview in chat list
    await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'lastMessage': messageController.text.trim(),
      'lastMessageTime': FieldValue.serverTimestamp(),
      'users': [widget.needyUid, widget.donatorUid],
    }, SetOptions(merge: true));

    messageController.clear();
  }

  /// Function to fetch messages
  Stream<QuerySnapshot> getMessages() {
    String chatId = getChatId();

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.needname),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.needyimage.isEmpty
                ? AppImages.noImage
                : widget.needyimage),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((doc) {
                    bool isMe = doc['senderId'] == _auth.currentUser!.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(doc['text']),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      focusColor: Colors.green,
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              style: BorderStyle.solid, color: Colors.green),
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
