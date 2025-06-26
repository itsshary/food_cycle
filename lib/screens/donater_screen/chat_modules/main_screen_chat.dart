import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/utils/images.dart';
import 'package:shimmer/shimmer.dart';
import 'donater_chat_screen.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({super.key});

  @override
  _ChatMainScreenState createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch chat list for the current user
  Stream<QuerySnapshot> getChatList() {
    String currentUserId = _auth.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: currentUserId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Messages",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getChatList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListTile(
                      leading: const CircleAvatar(
                          backgroundColor: Colors.white, radius: 30),
                      title: Container(height: 12, color: Colors.white),
                      subtitle: Container(height: 10, color: Colors.white),
                    ),
                  ),
                );
              },
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No chats available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chat = snapshot.data!.docs[index];
              List<dynamic> users = chat['users'];

              // Determine the other user's ID
              String currentUserId = _auth.currentUser!.uid;
              String otherUserId =
                  users.firstWhere((id) => id != currentUserId);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          leading: const CircleAvatar(
                              backgroundColor: Colors.white, radius: 30),
                          title: Container(height: 12, color: Colors.white),
                          subtitle: Container(height: 10, color: Colors.white),
                        ),
                      ),
                    );
                  }

                  var userData = userSnapshot.data!;
                  String name =
                      "${userData['firstName']} ${userData['lastName']}";
                  String imageUrl = userData['image'] ?? '';

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage(AppImages.noImage)
                                  as ImageProvider,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          chat['lastMessage'] ?? "No messages yet",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: const Icon(Icons.chat, color: Colors.green),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonaterChatScreen(
                                needyUid: currentUserId == users[0]
                                    ? users[1]
                                    : users[0],
                                donatorUid: currentUserId,
                                needyimage: imageUrl,
                                needname: name,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
