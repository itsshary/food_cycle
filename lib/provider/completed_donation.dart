// ViewModel: complete_donation_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteDonationViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCompletedDonations() {
    return _firestore
        .collection('donations')
        .where('donationStatus', isEqualTo: 'Completed')
        .where('activeuseruid', isEqualTo: _auth.currentUser!.uid)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserDetails(String uid) async {
    return await _firestore.collection("users").doc(uid).get();
  }

  Future<bool> hasUserRated(String donatorUid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(donatorUid)
        .collection(donatorUid)
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> submitRating(String donatorUid, double rating) async {
    await _firestore
        .collection('users')
        .doc(donatorUid)
        .collection(donatorUid)
        .add({
      'rating': rating,
      'userId': _auth.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
