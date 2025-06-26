import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/screens/needy_person/needy_active_donation/widget/card_donation_widget_needy.dart';
import 'package:food_cycle/screens/needy_person/needy_active_donation/widget/shimmer_effect_widget.dart';
import 'package:food_cycle/services/active_donation_neddy_service.dart';

class NeedyActiveDonation extends StatefulWidget {
  const NeedyActiveDonation({super.key});

  @override
  State<NeedyActiveDonation> createState() => _NeedyActiveDonationState();
}

class _NeedyActiveDonationState extends State<NeedyActiveDonation> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Active Donations",
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
            .where('activeuseruid', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildShimmerList();
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

          return ListView.builder(
            itemCount: activeDonations.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final donation = activeDonations[index];
              return FutureBuilder<Map<String, dynamic>?>(
                future:
                    ActiveDonationNeddyService.fetchUserData(donation['uid']),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return buildShimmerEffect();
                  }

                  if (userSnapshot.data == null) {
                    return const SizedBox.shrink();
                  }

                  final userData = userSnapshot.data!;
                  final String donatorName =
                      "${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}";
                  return DonationCard(
                    donation: donation,
                    donatorName: donatorName,
                    donatorImage: userData['image'] ?? '',
                    needyUid: currentUserId,
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
