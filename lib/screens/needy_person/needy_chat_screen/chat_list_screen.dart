import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cycle/screens/needy_person/needy_chat_screen/needy_chat_screen.dart';
import 'package:food_cycle/utils/images.dart';
import 'package:shimmer/shimmer.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final id = FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat Screen",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('donationStatus', isEqualTo: 'active')
            .where('activeuseruid', isEqualTo: id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => shimmerEffect(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No active donations available.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          final activeDonations = snapshot.data!.docs;
          Set<String> displayedNames = {}; // Track displayed names

          return ListView.builder(
            itemCount: activeDonations.length,
            itemBuilder: (context, index) {
              final donation = activeDonations[index];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(donation['uid'])
                    .get(),
                builder: (context, usersSnapshot) {
                  if (usersSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return shimmerEffect();
                  }
                  if (!usersSnapshot.hasData ||
                      usersSnapshot.data!.data() == null) {
                    return const SizedBox(); // Skip rendering if no user found
                  }
                  final userData =
                      usersSnapshot.data!.data() as Map<String, dynamic>;
                  final String donatorName =
                      "${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}"
                          .trim();
                  final String images = "${userData['image']}";

                  // Skip if the user has already been displayed
                  if (displayedNames.contains(donatorName)) {
                    return const SizedBox();
                  }

                  displayedNames.add(donatorName);

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NeedyChatScreen(
                                needyUid: donation['activeuseruid'],
                                donatorUid: donation['uid'],
                                donaterimage: images,
                                donatername: donatorName,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: images.isNotEmpty
                              ? NetworkImage(images)
                              : const AssetImage(AppImages.noImage)
                                  as ImageProvider,
                        ),
                        title: Text(
                          donatorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: const Text(
                          "Tap to chat",
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: const Icon(
                          Icons.chat,
                          color: Colors.green,
                        ),
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

  Widget shimmerEffect() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
            ),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 16,
              width: 100,
              color: Colors.white,
            ),
          ),
          subtitle: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 12,
              width: 60,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
