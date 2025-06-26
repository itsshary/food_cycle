import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_cycle/utils/dummy/dummy_data.dart';
import 'package:food_cycle/utils/app_textstyle.dart';
import 'package:food_cycle/screens/donater_screen/details_view_donation.dart';

import 'package:food_cycle/screens/donater_screen/widgets/row_widget_home_screen.dart';

class DonaterHomeScreen extends StatefulWidget {
  const DonaterHomeScreen({super.key});

  @override
  State<DonaterHomeScreen> createState() => _DonaterHomeScreenState();
}

class _DonaterHomeScreenState extends State<DonaterHomeScreen> {
  final id = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Donater Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
              ));
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final String donatorName =
                "${userData['firstName']} ${userData['lastName']}";
            final String imagedonator = userData['image'];
            final String role = "${userData['role']}";

            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('donations')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!
                            .uid) // Filter by current user UID
                    .where('donationStatus',
                        isEqualTo:
                            'active') // Filter by 'active' donation status
                    .snapshots(),
                builder: (context, strsnapshot) {
                  if (strsnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final activeDonationsCount = strsnapshot.data?.docs.length ??
                      0; // Active donations count

                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('donations')
                          .where('uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!
                                  .uid) // Filter by current user UID
                          .snapshots(),
                      builder: (context, totalsnapshot) {
                        if (strsnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.green,
                          ));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Colors.green,
                          );
                        }
                        final totaldonations =
                            totalsnapshot.data?.docs.length ?? 0;
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(id)
                                .collection(id)
                                .snapshots(),
                            builder: (context, reatingsnapshot) {
                              if (reatingsnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.green,
                                ));
                              }

                              final ratingDocs =
                                  reatingsnapshot.data?.docs ?? [];
                              double total = 0;
                              for (var doc in ratingDocs) {
                                total += (doc['rating'] ?? 0).toDouble();
                              }
                              double avgRating = ratingDocs.isNotEmpty
                                  ? total / ratingDocs.length
                                  : 0;
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Carousel Slider

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CarouselSlider(
                                            items: DummyData.carouselImages
                                                .map((imageUrl) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            imageUrl),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black
                                                              .withOpacity(0.4),
                                                          Colors.transparent
                                                        ],
                                                        begin: Alignment
                                                            .bottomCenter,
                                                        end:
                                                            Alignment.topCenter,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                            options: CarouselOptions(
                                              height: 160,
                                              enlargeCenterPage: true,
                                              autoPlay: true,
                                              viewportFraction: 0.85,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Card
                                    Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 5,
                                      shadowColor: Colors.grey.shade300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Donator Info
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: NetworkImage(
                                                    imagedonator.isEmpty
                                                        ? "https://cdn.creazilla.com/icons/3432052/blank-profile-picture-icon-lg.png"
                                                        : imagedonator,
                                                  ),
                                                ),
                                                const SizedBox(width: 15.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              donatorName,
                                                              style: AppTextstyle()
                                                                  .commontextstylebalckcolor
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        role,
                                                        style: AppTextstyle()
                                                            .commontextstylebalckcolor
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              color: Colors.grey
                                                                  .shade700,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),

                                            // Stats Section (Using Column)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.volunteer_activism,
                                                      color: Colors.pink,
                                                      size: 24),
                                                  title: Text(
                                                      "${activeDonationsCount.toString()} Active Donations",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.card_giftcard,
                                                      color: Colors.deepPurple,
                                                      size: 24),
                                                  title: Text(
                                                      "$totaldonations Total Donations",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.star,
                                                      color: Colors.deepOrange,
                                                      size: 24),
                                                  title: Row(
                                                    children: [
                                                      Text(
                                                        "${ratingDocs.isEmpty ? "No ratings yet" : avgRating.toStringAsFixed(1)} Rating",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      ratingDocs.isEmpty
                                                          ? const SizedBox()
                                                          : RatingBarIndicator(
                                                              rating: avgRating,
                                                              itemBuilder: (context,
                                                                      index) =>
                                                                  const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 18,
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Donations List
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("donations")
                                          .where('uid', isEqualTo: id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              "No donations found",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                          );
                                        }

                                        var donations = snapshot.data!.docs;

                                        return Column(
                                          children: donations.map((doc) {
                                            var donation = doc.data();
                                            String imageUrl =
                                                donation['imageUrl'] ?? '';
                                            String foodItem =
                                                donation['foodItem'] ?? '';
                                            String donationid =
                                                donation['donationid'] ?? '';
                                            String quantity =
                                                donation['quantity'] ?? '';
                                            String description =
                                                donation['description'] ?? '';
                                            String endtime =
                                                donation['endTime'] ?? '';
                                            String startTime =
                                                donation['startTime'] ?? '';
                                            int distance =
                                                donation['distance'] ?? 0;
                                            String donationStatus =
                                                donation['donationStatus'] ??
                                                    '';

                                            String foodType =
                                                donation['foodType'] ?? '';
                                            final Map<String, dynamic>
                                                location =
                                                userData['location'] ?? {};
                                            double latitude =
                                                location['latitude'] ?? 0.0;
                                            double longitude =
                                                location['longitude'] ?? 0.0;

                                            return InkWell(
                                              onTap: () async {
                                                String address = await DummyData
                                                    .getAddressFromLatLng(
                                                        latitude, longitude);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsViewDonation(
                                                              description:
                                                                  description,
                                                              donatername:
                                                                  donatorName,
                                                              donationId:
                                                                  donationid,
                                                              endtime: endtime,
                                                              foodstatus:
                                                                  donationStatus,
                                                              images: imageUrl,
                                                              itemname:
                                                                  foodItem,
                                                              km: distance,
                                                              location: address,
                                                              pickingtime:
                                                                  startTime,
                                                              quantity:
                                                                  quantity,
                                                            )));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  elevation: 3,
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Image.network(
                                                            imageUrl,
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              FoodItemRow(
                                                                  foodvalue:
                                                                      "Food Item",
                                                                  foodItem:
                                                                      foodItem),
                                                              FoodItemRow(
                                                                  foodvalue:
                                                                      "Food Type",
                                                                  foodItem:
                                                                      foodType),
                                                              IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              AlertDialog(
                                                                                backgroundColor: Colors.black,
                                                                                title: const Text(
                                                                                  "Confirm Delete",
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                                content: const Text(
                                                                                  "Are you sure you want to delete your Donation?",
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    style: TextButton.styleFrom(foregroundColor: Colors.green, overlayColor: Colors.green),
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context); // Close dialog
                                                                                    },
                                                                                    child: const Text(
                                                                                      "Cancel",
                                                                                      style: TextStyle(color: Colors.green),
                                                                                    ),
                                                                                  ),
                                                                                  TextButton(
                                                                                    style: TextButton.styleFrom(
                                                                                      foregroundColor: Colors.red,
                                                                                      overlayColor: Colors.red.withOpacity(0.2),
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      Navigator.pop(context); // Close dialog
                                                                                      await FirebaseFirestore.instance.collection('donations').doc(donation['donationid']).delete();
                                                                                    },
                                                                                    child: const Text(
                                                                                      "OK",
                                                                                      style: TextStyle(color: Colors.red),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ));
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      });
                });
          },
        ),
      ),
    );
  }
}
