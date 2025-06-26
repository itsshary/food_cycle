import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordViewModel extends ChangeNotifier {
  final FirebaseAuth _auth;

  ForgetPasswordViewModel({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  bool _isLoading = false;
  String? _error;
  String? _success;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get success => _success;

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    _success = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _success = "Password reset link sent! Check your email.";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        _error = "No user found with this email.";
      } else if (e.code == "invalid-email") {
        _error = "Invalid email format.";
      } else {
        _error = "Something went wrong. Please try again.";
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
