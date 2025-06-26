import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class NeedyProfileViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String address = "Loading address...";
  User? currentUser;

  NeedyProfileViewModel() {
    currentUser = _auth.currentUser;
    if (currentUser != null) {
      fetchAddress();
    }
  }

  String get uid => currentUser?.uid ?? '';

  Future<void> fetchAddress() async {
    try {
      final userData = await _firestore.collection('users').doc(uid).get();
      if (!userData.exists) return;

      final location = userData['location'] ?? {};
      double lat = location['latitude'] ?? 0.0;
      double lng = location['longitude'] ?? 0.0;

      if (lat != 0.0 && lng != 0.0) {
        final placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address =
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        } else {
          address = "No address found";
        }
      } else {
        address = "Invalid coordinates";
      }
    } catch (e) {
      address = "Failed to get address";
    }
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pop();
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestore.collection('users').doc(uid).delete();
      await _auth.currentUser?.delete();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Stream<DocumentSnapshot> get userStream {
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
