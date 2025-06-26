import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_cycle/services/image_kit_service.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class NeedyUpdateProfileViewmodel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final ImageKitService _imageKitService = ImageKitService();

  UserModel? user;
  bool isLoading = false;
  File? selectedImage;
  String? existingImageUrl;

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();

  Future<void> fetchUser(String uid) async {
    isLoading = true;
    notifyListeners();

    user = await _userRepository.fetchUser(uid);
    if (user != null) {
      nameController.text = user!.firstName;
      lastNameController.text = user!.lastName;
      mobileController.text = user!.phone;
      existingImageUrl = user!.image;
    }

    isLoading = false;
    notifyListeners();
  }

  void setImage(File image) {
    selectedImage = image;
    notifyListeners();
  }

  Future<void> updateProfile(String uid) async {
    isLoading = true;
    notifyListeners();

    String? imageUrl = existingImageUrl;
    if (selectedImage != null) {
      final uploaded =
          await _imageKitService.uploadImage(selectedImage!, "profile_image");
      if (uploaded != null) imageUrl = uploaded;
    }

    final updatedUser = UserModel(
      firstName: nameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phone: mobileController.text.trim(),
      image: imageUrl ?? "",
      uid: uid,
    );

    await _userRepository.updateUser(uid, updatedUser);

    isLoading = false;
    notifyListeners();
  }
}
