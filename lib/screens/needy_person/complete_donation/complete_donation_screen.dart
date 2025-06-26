// View: complete_donation_screen.dart
import 'package:flutter/material.dart';
import 'package:food_cycle/provider/completed_donation.dart';
import 'package:provider/provider.dart';
import 'package:food_cycle/screens/needy_person/complete_donation/widget/shimmereeffectcomplete.dart';
import 'package:food_cycle/resources/componets/custom_button/custom_button.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CompleteDonationScreen extends StatelessWidget {
  const CompleteDonationScreen({super.key});

  void _showRatingDialog(
      BuildContext context, String donatorUid, CompleteDonationViewModel vm) {
    double rating = 1.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rate the Donor"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("How was your experience with the donor?"),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (newRating) => rating = newRating,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () async {
                await vm.submitRating(donatorUid, rating);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Rating submitted successfully!")),
                );
              },
              child:
                  const Text("Submit", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompleteDonationViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Completed Donations",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        body: Consumer<CompleteDonationViewModel>(
          builder: (context, vm, child) {
            return StreamBuilder(
              stream: vm.getCompletedDonations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        const Shimmereeffectcomplete(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Completed donations available.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                final activeDonations = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: activeDonations.length,
                  itemBuilder: (context, index) {
                    final donation = activeDonations[index];
                    return FutureBuilder(
                      future: vm.getUserDetails(donation['uid']),
                      builder: (context, userSnap) {
                        if (userSnap.connectionState ==
                            ConnectionState.waiting) {
                          return const Shimmereeffectcomplete();
                        }

                        if (!userSnap.hasData ||
                            userSnap.data!.data() == null) {
                          return const Center(child: Text("No user found"));
                        }

                        final userData =
                            userSnap.data!.data() as Map<String, dynamic>;
                        final donatorName =
                            "${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}";

                        return FutureBuilder(
                          future: vm.hasUserRated(donation['uid']),
                          builder: (context, ratingSnap) {
                            final hasRated = ratingSnap.data ?? false;

                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                donation['imageUrl']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              donation['foodItem'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Donor: $donatorName",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Text("Status: ",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Row(
                                                  children: [
                                                    Text("Completed",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green
                                                                .shade700)),
                                                    const Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                        size: 28),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            if (!hasRated)
                                              CustomButton(
                                                text: 'Give Rating',
                                                color: Colors.green,
                                                onTap: () => _showRatingDialog(
                                                    context,
                                                    donation['uid'],
                                                    vm),
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
                    );
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
