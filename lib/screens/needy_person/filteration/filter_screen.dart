
import 'package:flutter/material.dart';
import 'package:food_cycle/provider/filter_search.dart';
import 'package:provider/provider.dart';
import 'package:food_cycle/screens/needy_person/filteration/widget/filter_dialog_widget.dart';
import 'package:food_cycle/screens/needy_person/items_details_checking/items_details_checking.dart';
import 'package:food_cycle/utils/dummy/dummy_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterSearchScreen extends StatelessWidget {
  const FilterSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _openFilterDialog(context),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Donation Filter Search",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Consumer<FilterSearchViewModel>(
        builder: (context, viewModel, child) {
          final donations = viewModel.filteredDonations;
          if (donations.isEmpty) {
            return const Center(child: Text("No results yet."));
          }

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final data = donations[index].data() as Map<String, dynamic>;
              final foodItem = data['foodItem'] ?? 'Unnamed Food';
              final foodType = data['foodType'] ?? 'Unknown';
              final deliveryType = data['deliveryType'] ?? 'Unknown';
              final distance = data['distance'] ?? 'N/A';
              final uid = data['uid'] ?? 'N/A';
              final imageUrl = data['imageUrl'] ?? '';
              final donationStatus = data['donationStatus'] ?? '';

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.green));
                  }
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const ListTile(
                        title: Text("Unknown Donator"),
                        subtitle: Text("User data not found."));
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final donatorName =
                      "${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}"
                          .trim();
                  final location = userData['location'] ?? {};
                  final latitude = location['latitude'] ?? 0.0;
                  final longitude = location['longitude'] ?? 0.0;

                  return GestureDetector(
                    onTap: () async {
                      final address = await DummyData.getAddressFromLatLng(
                          latitude, longitude);
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            description: data['description'],
                            donatername: donatorName,
                            donationId: data['donationid'] ?? "",
                            endtime: data['endTime'],
                            foodstatus: foodType,
                            images: imageUrl,
                            itemname: data['foodItem'] ?? "",
                            km: distance is int ? distance : 0,
                            location: address,
                            pickingtime: data['startTime'] ?? "",
                            quantity: data['quantity'] ?? "",
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl,
                                width: 60, height: 60, fit: BoxFit.cover)
                            : const Icon(Icons.food_bank,
                                size: 60, color: Colors.green),
                        title: Text(foodItem,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(
                          'Type: $foodType | Distance: $distance km | Delivery: $deliveryType',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: donationStatus.isNotEmpty
                            ? Text(
                                donationStatus,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: donationStatus == 'Completed'
                                      ? Colors.blue
                                      : donationStatus == 'active'
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              )
                            : null,
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

  Future<void> _openFilterDialog(BuildContext context) async {
    final filters = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const FilterDialog(),
    );

    if (filters != null) {
      final viewModel =
        
          Provider.of<FilterSearchViewModel>(context, listen: false);
      try {
        await viewModel.applyFilters(filters);
      } catch (e) {
      
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to fetch data. Check filter values.")),
        );
      }
    }
  }
}
