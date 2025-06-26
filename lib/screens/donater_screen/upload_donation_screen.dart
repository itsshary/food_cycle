import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/notification/notification_service/notification_service.dart';
import 'package:food_cycle/resources/componets/custom_button/custom_button.dart';
import 'package:food_cycle/resources/componets/loading_widget/loading_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore_for_file: avoid_print, unused_local_variable,use_build_context_synchronously
class UploadDonationScreen extends StatefulWidget {
  const UploadDonationScreen({super.key});

  @override
  State<UploadDonationScreen> createState() => _UploadDonationScreenState();
}

class _UploadDonationScreenState extends State<UploadDonationScreen> {
  bool isloading = false;
  final List<String> foodItems = [
    'Bread',
    'Chicken',
    'Rice',
    'Milk',
    'Fruits',
    'Vegetables',
    'Fast Food',
    'Other',
  ];
  final List<String> foodTypes = ['Fresh', 'Frozen', 'Canned', 'Else'];
  final List<String> deliveryTypes = ['Delivery', 'Direct-hands off'];
  final String donationId = DateTime.now().microsecondsSinceEpoch.toString();
  var pickedImage;
  String? selectedFoodItem;
  String? selectedFoodType;
  String? selectedDeliveryType;
  double _sliderValue = 5.0;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  // Method to pick an image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      pickedImage = File(pickedFile.path);
    });
  }

  Future<void> pickTimeRange(BuildContext context) async {
    final startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (startTime == null) return;

    final endTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (endTime == null) return;

    if (startTime.hour > endTime.hour ||
        (startTime.hour == endTime.hour &&
            startTime.minute >= endTime.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End time must be after start time.")),
      );
      return;
    }

    setState(() {
      selectedStartTime = startTime;
      selectedEndTime = endTime;
    });
  }

  // Method to upload image to ImageKit
  Future<String?> uploadFileToImageKit(File file, String fileName) async {
    const String imageKitUrl = "https://upload.imagekit.io/api/v1/files/upload";
    const String publicApiKey =
        "private_54sywIDgv2WQFF01+kWU5HIRkpc="; // Replace this

    try {
      final request = http.MultipartRequest("POST", Uri.parse(imageKitUrl));
      request.fields['fileName'] = fileName;
      request.fields['folder'] = "/uploads";
      request.fields['useUniqueFileName'] = "true";
      request.headers['Authorization'] =
          'Basic ${base64Encode(utf8.encode("$publicApiKey:"))}';

      // Attach the file
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
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

  // Function to upload donation data to Firebase Firestore
  Future<void> uploadDonationData() async {
    final auth = FirebaseAuth.instance;
    String id = auth.currentUser!.uid;

    // Generate a unique donationId for each new submission
    final String donationId = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      setState(() {
        isloading = true;
      });
      String? imageUrl;
      if (pickedImage != null) {
        final String fileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        imageUrl = await uploadFileToImageKit(pickedImage, fileName);
        if (imageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Image upload failed. Please try again.")),
          );
          return;
        }
      }

      final donationData = {
        'donationid': donationId, // Ensure a new ID is generated per donation
        'uid': id,
        'activeuseruid': '',
        'foodItem': selectedFoodItem,
        'foodType': selectedFoodType,
        'deliveryType': selectedDeliveryType,
        'distance': _sliderValue.toInt(),
        'startTime': selectedStartTime?.format(context) ?? '',
        'endTime': selectedEndTime?.format(context) ?? '',
        'description': descriptionController.text,
        'quantity': quantityController.text,
        'imageUrl': imageUrl ?? '',
        'donationStatus': "inactive",
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .set(donationData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donation submitted successfully!")),
      );
      NotificationService.sendNotificationToTopic(
        body: 'Check the Details of New Donation',
        title: 'New Donation is Added',
        data: {'screen': 'NeedyHomeScreen'},
        topic: "Needy",
      );

      setState(() {
        selectedFoodItem = null;
        selectedFoodType = null;
        selectedDeliveryType = null;
        _sliderValue = 5.0;
        selectedStartTime = null;
        selectedEndTime = null;
        descriptionController.clear();
        quantityController.clear();
        pickedImage = null;
        isloading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      setState(() {
        isloading = false;
      });
      print('Upload Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      progressIndicator: const LoadingBar(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Upload Donation",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedFoodItem,
                  hint: const Text("Select Food Item"),
                  items: foodItems.map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFoodItem = value;
                    });
                  },
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 1, 110, 4)), // Green color when focused
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .grey), // Default grey border when not focused
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: selectedFoodType,
                  hint: const Text("Select Food Type"),
                  items: foodTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFoodType = value;
                    });
                  },
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 1, 110, 4)), // Green color when focused
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .grey), // Default grey border when not focused
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                InkWell(
                  onTap: () {
                    pickImage();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: 180,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: pickedImage != null
                          ? Image.file(
                              pickedImage,
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child: Text(
                                'Tap To Select Image',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: selectedDeliveryType,
                  hint: const Text("Select Delivery Type"),
                  items: deliveryTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDeliveryType = value;
                    });
                  },
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 1, 110, 4)), // Green color when focused
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .grey), // Default grey border when not focused
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Slider(
                  value: _sliderValue,
                  activeColor: Colors.green,
                  min: 1.0,
                  max: 30.0,
                  divisions: 25,
                  label: '${_sliderValue.toInt()} km',
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                ),
                Text('Selected Distance: ${_sliderValue.toInt()} km'),
                const SizedBox(height: 20.0),
                ElevatedButton.icon(
                  onPressed: () => pickTimeRange(context),
                  icon: const Icon(Icons.access_time, color: Colors.green),
                  label: const Text(
                    "Select Time Range",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                if (selectedStartTime != null && selectedEndTime != null)
                  Text(
                    'Time Range: ${selectedStartTime!.format(context)} - ${selectedEndTime!.format(context)}',
                  ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    focusColor: Colors.green,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            style: BorderStyle.solid, color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: "Description",
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    focusColor: Colors.green,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            style: BorderStyle.solid, color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: "Quantity",
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  onTap: uploadDonationData,
                  color: Colors.green,
                  text: "Submit Food For Donation",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
