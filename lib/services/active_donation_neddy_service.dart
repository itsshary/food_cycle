import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActiveDonationNeddyService {
  static Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      return userSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      return null;
    }
  }
}
