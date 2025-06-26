import 'package:flutter/material.dart';
import 'package:food_cycle/resources/toast_ms/toast_msg.dart';
import 'package:food_cycle/screens/auth_screen/admin_approvel_screen/admin_aproval_screen.dart';
import 'package:food_cycle/screens/show-location/location_screen.dart';
import '../repositories/register_repository.dart';

class RegisterViewModel with ChangeNotifier {
  final RegisterRepository repository;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedRole;
  bool isLoading = false;

  RegisterViewModel(this.repository);

  Future<void> registerUser(BuildContext context) async {
    if (!formKey.currentState!.validate() || selectedRole == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final (user, status) = await repository.registerUser(
        email: emailController.text,
        password: passwordController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        role: selectedRole!,
      );

      isLoading = false;
      notifyListeners();

      if (status == "Active") {
        ToastMsg().showToast("Registered Successfully");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => LocationScreen(role: selectedRole!)),
          (route) => false,
        );
      } else {
        ToastMsg().showToast("Account pending admin approval");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AdminAprovalScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ToastMsg().showToast(e.toString());
    }
  }
}
