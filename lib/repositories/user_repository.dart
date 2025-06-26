import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> fetchUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) return UserModel.fromMap(doc.data()!);
    } catch (_) {}
    return null;
  }

  Future<void> updateUser(String uid, UserModel user) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update(user.toMap().cast<Object, Object?>());
  }
}
