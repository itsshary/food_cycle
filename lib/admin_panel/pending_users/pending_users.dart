import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/notification/notification_service/notification_service.dart';

class PendingUsers extends StatefulWidget {
  static const String id = 'pendingusers';
  const PendingUsers({super.key});

  @override
  State<PendingUsers> createState() => _PendingUsersState();
}

class _PendingUsersState extends State<PendingUsers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to update user status
  Future<void> _updateUserStatus(String userId, String devicetoken) async {
    await _firestore.collection("users").doc(userId).update({
      "userstatus": "Active",
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User status updated to Active"),
        backgroundColor: Colors.green,
      ),
    );
    NotificationService.sendNotificationUsingApi(
      body: 'Check Now The App',
      data: {'screen': 'loginscreen'},
      title: 'Congratulation Your Account Is Activated',
      token: devicetoken,
    );
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pending Users")),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore
            .collection("users")
            .where('userstatus', isEqualTo: 'Pending')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No pending users found.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          var pendingUsers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pendingUsers.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              var user = pendingUsers[index];
              String userId = user.id;
              String userName = user["firstName"];
              String status = user['userstatus'];
              String devicetoken = user['devicetoken'];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Chip(
                    label: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () async {
                      await _updateUserStatus(userId, devicetoken);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
