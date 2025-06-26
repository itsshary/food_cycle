import 'package:flutter/material.dart';
import 'package:food_cycle/repositories/auth_repository.dart';
import 'package:food_cycle/resources/toast_ms/toast_msg.dart';
import 'package:food_cycle/screens/auth_screen/admin_approvel_screen/admin_aproval_screen.dart';
import 'package:food_cycle/screens/show-location/location_screen.dart';

class LoginViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();

  bool isLoading = false;

  final LoginRepository _repository = LoginRepository();

  Future<void> loginFun(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final userDoc = result['userDoc'];
      final String status = userDoc['userstatus'] ?? '';
      final String role = userDoc['role'] ?? '';

      if (userDoc.exists) {
        if (status == "Pending") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminAprovalScreen()),
          );
        } else if (role == 'Needy' || role == 'Donater') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LocationScreen(role: role)),
          );
        } else {
          ToastMsg().showToast("Invalid role, please contact support.");
        }
      } else {
        ToastMsg().showToast("User data not found.");
      }
    } catch (e) {
      ToastMsg().showToast(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}
