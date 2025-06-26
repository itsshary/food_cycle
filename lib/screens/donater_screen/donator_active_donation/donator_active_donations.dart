import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/screens/donater_screen/donator_active_donation/view_details_donation.dart';

class DonatorActiveDonations extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  DonatorActiveDonations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Active Donations",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('donationStatus', isEqualTo: 'active')
            .where('uid', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("No active donations found.",
                    style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          var donations = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              var donation = donations[index].data() as Map<String, dynamic>;
              final String imageUrl = donation['imageUrl'] ?? '';
              final String foodItem = donation['foodItem'] ?? 'Unknown Item';
              final String foodQuantity =
                  donation['quantity'] ?? 'Unknown Quantity';
              final String donationStatus =
                  donation['donationStatus'] ?? 'Unknown';
              final String description =
                  donation['description'] ?? 'No description';
              final String foodStatus = donation['foodType'] ?? 'Unknown Type';
              final String activeUserUid =
                  donation['activeuseruid'] ?? 'Unknown';

              final String donationId = donation['donationid'] ?? '';
              final int distance = donation['distance'] ?? 0;
              final String pickingTime =
                  donation['startTime'] ?? 'Not specified';
              final String endTime = donation['endTime'] ?? 'Not specified';
              final String donationstatus =
                  donation['donationStatus'] ?? 'Not specified';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewDetailsDonation(
                                description: description,
                                endtime: endTime,
                                foodstatus: foodStatus,
                                images: imageUrl,
                                activeuseruid: activeUserUid,
                                itemname: foodItem,
                                km: distance,
                                donationstatus: donationstatus,
                                pickingtime: pickingTime,
                                quantity: foodQuantity,
                                donationId: donationId,
                              )));
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported,
                                    size: 80, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(foodItem,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text("Quantity: $foodQuantity",
                                  style: TextStyle(color: Colors.grey[700])),
                              Text("Food Type: $foodStatus",
                                  style: TextStyle(color: Colors.grey[700])),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    donationStatus == 'Completed'
                                        ? "Completed"
                                        : "Active",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: donationStatus == 'Completed'
                                            ? Colors.green
                                            : Colors.orange),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await updateStatus(donationId);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: donationStatus == 'Completed'
                                          ? Colors.green
                                          : Colors.black,
                                      size: donationStatus == 'Completed'
                                          ? 30
                                          : 25,
                                    ),
                                    tooltip: "Mark as Completed",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Update donation status
  Future<void> updateStatus(String donationId) async {
    await FirebaseFirestore.instance
        .collection("donations")
        .doc(donationId)
        .update({
      "donationStatus": "Completed",
    });
  }
}
