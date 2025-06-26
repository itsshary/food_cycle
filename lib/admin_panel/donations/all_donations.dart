import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/utils/app_textstyle.dart';
import 'package:food_cycle/utils/color_resources.dart';

class AllDonations extends StatefulWidget {
  static const String id = 'alldonations';
  const AllDonations({super.key});

  @override
  State<AllDonations> createState() => _AllDonationsState();
}

class _AllDonationsState extends State<AllDonations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Donations")),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("donations").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No active donations found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          var donations = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 1200
                        ? 3
                        : constraints.maxWidth > 800
                            ? 2
                            : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: donations.length,
                  itemBuilder: (context, index) {
                    var donation = donations[index].data();
                    var docId = donations[index].id;

                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              donation['imageUrl'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image, size: 150),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  donation['foodItem'],
                                  style: AppTextstyle()
                                      .commontextstylebalckcolor
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  donation['foodType'],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Available from: ${donation['startTime']} to ${donation['endTime']}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DonationDetailsScreen(
                                                    donation: donation),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: const Text(
                                        "View Details",
                                        style: TextStyle(
                                            color: ColorResources.whiteColor),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        _confirmDelete(docId);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Donation"),
          content: const Text("Are you sure you want to delete this donation?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("donations")
                    .doc(docId)
                    .delete()
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Donation deleted successfully")),
                  );
                  Navigator.pop(context);
                  setState(() {});
                });
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class DonationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> donation;

  const DonationDetailsScreen({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          donation['foodItem'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // Ensures scrolling
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          donation['imageUrl'],
                                          height: 300,
                                          width: 300,
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image,
                                                size: 100, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Title
                                  Text(
                                    donation['foodItem'],
                                    style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),

                                  // Food Type
                                  Row(
                                    children: [
                                      const Icon(Icons.fastfood,
                                          color: Colors.orange),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Food Type: ${donation['foodType']}",
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Status
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Status: ${donation['donationStatus']}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Description
                                  const Text(
                                    "Description:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    donation['description'],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 20),

                                  // Availability Time
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Available from: ${donation['startTime']} to ${donation['endTime']}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
