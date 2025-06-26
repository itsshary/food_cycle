import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Color primaryColor = const Color(0xFF018C04); // Green theme color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      backgroundColor: Colors.grey[200], // Light background for contrast
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("donations").get(),
        builder: (context, donatorsnapshot) {
          if (donatorsnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!donatorsnapshot.hasData || donatorsnapshot.data == null) {
            return const Center(child: Text("No donations found."));
          }

          return FutureBuilder(
            future: FirebaseFirestore.instance.collection("users").get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text("No users found."));
              }

              // Get total users count
              int totalUsers = snapshot.data!.docs.length;
              var users = snapshot.data!.docs;

              // Count users with 'Pending' status
              int pendingUsers = snapshot.data!.docs
                  .where((doc) => doc['userstatus'] == 'Pending')
                  .length;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Dashboard Cards
                      SizedBox(
                        height: 130,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildDashboardCard("Total Users",
                                totalUsers.toString(), Colors.amber),
                            _buildDashboardCard(
                                "Total Donations",
                                donatorsnapshot.data!.docs.length.toString(),
                                Colors.red),
                            _buildDashboardCard("Pending Users",
                                pendingUsers.toString(), Colors.blue),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Users List
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                "Users List",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const Divider(),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  var user = users[index].data();
                                  return Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: primaryColor,
                                        child: Text(
                                          user['firstName'][0].toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      title: Text(
                                        "${user['firstName']} ${user['lastName']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Role: ${user['role']}",
                                        style:
                                            TextStyle(color: Colors.grey[700]),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Improved Dashboard Card
  Widget _buildDashboardCard(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
