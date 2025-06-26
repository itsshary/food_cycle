import 'dart:convert';
import 'dart:io';
import 'package:food_cycle/resources/componets/loading_widget/loading_widget.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_cycle/resources/componets/custom_button/custom_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore_for_file: avoid_print, unused_local_variable , use_build_context_synchronously
class DontaerProfileUpdate extends StatefulWidget {
  final String uid;
  const DontaerProfileUpdate({super.key, required this.uid});

  @override
  State<DontaerProfileUpdate> createState() => _DontaerProfileUpdateState();
}

class _DontaerProfileUpdateState extends State<DontaerProfileUpdate> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isloading = false;
  File? _selectedImage;
  String? _uploadedImageUrl;
  String? _existingImageUrl;

  final ImagePicker _picker = ImagePicker();

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Image upload function
  Future<String?> uploadFileToImageKit(File file, String fileName) async {
    const String imageKitUrl = "https://upload.imagekit.io/api/v1/files/upload";
    const String publicApiKey =
        "private_54sywIDgv2WQFF01+kWU5HIRkpc="; // Replace with your key.

    try {
      final request = http.MultipartRequest("POST", Uri.parse(imageKitUrl));
      request.fields['fileName'] = fileName;
      request.fields['folder'] = "/uploads";
      request.fields['useUniqueFileName'] = "true";
      request.headers['Authorization'] =
          'Basic ${base64Encode(utf8.encode("$publicApiKey:"))}';

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);
        return decodedResponse['url'];
      } else {
        throw Exception("Failed to upload file: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("ImageKit Upload Error: $e");
      return null;
    }
  }

  // Function to update Firestore profile

  // Function to update Firestore profile
  Future<void> _updateProfile() async {
    try {
      setState(() {
        isloading = true;
      });

      // Only update the image if selected
      String? uploadedImageUrl;
      if (_selectedImage != null) {
        uploadedImageUrl =
            await uploadFileToImageKit(_selectedImage!, "profile_image");
      }

      // Prepare the data for update
      Map<String, dynamic> updatedData = {};

      // Update fields that have changed
      if (_nameController.text.isNotEmpty) {
        updatedData['firstName'] = _nameController.text.trim();
      }
      if (_lastNameController.text.isNotEmpty) {
        updatedData['lastName'] = _lastNameController.text.trim();
      }
      if (_phoneNumber.text.isNotEmpty) {
        updatedData['phone'] = _phoneNumber.text.trim();
      }

      // Only update the image URL if a new one is uploaded
      if (uploadedImageUrl != null) {
        updatedData['image'] = uploadedImageUrl;
      }

      // Update Firestore
      await _firestore.collection('users').doc(widget.uid).update(updatedData);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile updated!")));

      // ✅ Clear text fields after successful update
      _nameController.clear();
      _lastNameController.clear();
      _phoneNumber.clear();

      setState(() {
        isloading = false;
      });
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      progressIndicator: const LoadingBar(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(
                      color: Colors.white,
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.green)),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    radius: 70,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (_existingImageUrl != null &&
                                _existingImageUrl!.isNotEmpty
                            ? NetworkImage(_existingImageUrl!)
                            : null),
                    child: (_selectedImage == null &&
                            (_existingImageUrl == null ||
                                _existingImageUrl!.isEmpty))
                        ? const Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 35,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    focusColor: Colors.green,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            style: BorderStyle.solid, color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0)),
                    fillColor: Colors.green.shade100,
                    hintText: 'Enter First Name',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    focusColor: Colors.green,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            style: BorderStyle.solid, color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0)),
                    fillColor: Colors.green.shade100,
                    hintText: 'Enter Last Name',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                IntlPhoneField(
                  controller: _phoneNumber,
                  decoration: InputDecoration(
                    focusColor: Colors.green,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            style: BorderStyle.solid, color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Colors.green.shade100,
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  initialCountryCode: 'PK',
                  onChanged: (phone) {},
                ),
                const SizedBox(height: 10.0),
                CustomButton(
                    text: "Update Profile",
                    color: Colors.green,
                    onTap: _updateProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
