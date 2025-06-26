import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_cycle/services/firebase_auth_service.dart';

class LoginRepository {
  final LoginService _service = LoginService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    UserCredential userCredential = await _service.signIn(email, password);
    DocumentSnapshot userDoc =
        await _service.getUserData(userCredential.user!.uid);

    return {
      'uid': userCredential.user!.uid,
      'userDoc': userDoc,
    };
  }
}
