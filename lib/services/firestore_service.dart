import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cycle/models/donation_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel? user) async {
    await _firestore.collection('users').doc(user!.uid).set(user.toMap());
  }

  Future<String> getUserStatus(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.get('userstatus');
  }

  Stream<List<DonationModel>> getDonations() {
    return FirebaseFirestore.instance.collection('donations').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return DonationModel.fromMap(doc.data(), doc.id);
        }).toList();
      },
    );
  }

  Future<Map<String, dynamic>?> getUserById(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }
}
