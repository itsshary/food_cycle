// lib/services/donation_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationService {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getDonation(String donationId) async {
    final doc = await _firestore.collection('donations').doc(donationId).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> activateDonation(String donationId, String userId) async {
    await _firestore.collection('donations').doc(donationId).update({
      'donationStatus': 'active',
      'activeuseruid': userId,
    });
  }

  Future<void> saveNotification({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection('notifications')
        .doc(userId)
        .collection('notifications')
        .doc()
        .set(data);
  }

  Future<String?> getDeviceToken(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.exists ? userDoc.get('devicetoken') : null;
  }
}
