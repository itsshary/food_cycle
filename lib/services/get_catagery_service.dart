// services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class GetCatageryService {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getDonationsByCategory(String categoryName) {
    return _firestore
        .collection('donations')
        .where('foodItem', isEqualTo: categoryName)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserById(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }
}
