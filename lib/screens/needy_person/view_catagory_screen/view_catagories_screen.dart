// views/view_categories_screen.dart
import 'package:flutter/material.dart';
import 'package:food_cycle/provider/view_categoriesvml.dart';
import 'package:food_cycle/utils/color_resources.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_textstyle.dart';
import '../../../models/donation_model.dart';
import '../../../utils/dummy/dummy_data.dart';
import '../items_details_checking/items_details_checking.dart';

class ViewCategoriesScreen extends StatelessWidget {
  final String categoryName;

  const ViewCategoriesScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ViewCategoriesViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white)),
          backgroundColor: ColorResources.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<ViewCategoriesViewModel>(
          builder: (context, viewModel, _) {
            return StreamBuilder<List<DonationModel>>(
              stream: viewModel.getDonations(categoryName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: ColorResources.primaryColor));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No donations available for this category.",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)));
                }

                final donations = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: donations.length,
                  itemBuilder: (context, index) {
                    final donation = donations[index];

                    return FutureBuilder<Map<String, dynamic>>(
                        future: viewModel.getUserData(donation.uid),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: ColorResources.primaryColor));
                          }

                          final userData = userSnapshot.data;
                          if (userData == null) {
                            return const Center(child: Text("User not found"));
                          }

                          final name =
                              "${userData['firstName']} ${userData['lastName']}"
                                  .trim();
                          final location = userData['location'] ?? {};
                          final lat = location['latitude'] ?? 0.0;
                          final long = location['longitude'] ?? 0.0;

                          return GestureDetector(
                            onTap: () async {
                              final address =
                                  await DummyData.getAddressFromLatLng(
                                      lat, long);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    description: donation.description,
                                    donatername: name,
                                    donationId: donation.donationId,
                                    endtime: donation.endTime,
                                    foodstatus: donation.donationStatus,
                                    images: donation.imageUrl,
                                    itemname: donation.foodItem,
                                    km: donation.distance,
                                    location: address,
                                    pickingtime: donation.startTime,
                                    quantity: donation.quantity,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      donation.imageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          donation.foodItem,
                                          style: AppTextstyle()
                                              .commontextstylebalckcolor
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Type: ${donation.foodType}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Time: ${donation.startTime} - ${donation.endTime}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color:
                                                  ColorResources.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
