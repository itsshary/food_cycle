import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_cycle/provider/needy_update_profile_viewmodel.dart';
import 'package:food_cycle/resources/componets/custom_button/custom_button.dart';
import 'package:food_cycle/resources/componets/loading_widget/loading_widget.dart';
import 'package:food_cycle/utils/extension.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class NeedyProfileUpdate extends StatelessWidget {
  final String uid;
  const NeedyProfileUpdate({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NeedyUpdateProfileViewmodel()..fetchUser(uid),
      child: Consumer<NeedyUpdateProfileViewmodel>(
        builder: (context, vm, _) {
          return ModalProgressHUD(
            inAsyncCall: vm.isLoading,
            progressIndicator: const LoadingBar(),
            child: Scaffold(
              bottomSheet: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 60,
                  child: CustomButton(
                    text: "Update Profile",
                    color: Colors.green,
                    onTap: () => vm.updateProfile(uid),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButton(
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.green),
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        final picked = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          vm.setImage(File(picked.path));
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        radius: 70,
                        backgroundImage: vm.selectedImage != null
                            ? FileImage(vm.selectedImage!)
                            : (vm.existingImageUrl != null &&
                                    vm.existingImageUrl!.isNotEmpty
                                ? NetworkImage(vm.existingImageUrl!)
                                : null) as ImageProvider?,
                        child: (vm.selectedImage == null &&
                                (vm.existingImageUrl == null ||
                                    vm.existingImageUrl!.isEmpty))
                            ? const Icon(Icons.camera_alt,
                                color: Colors.green, size: 35)
                            : null,
                      ),
                    ),
                    10.sH,
                    TextFormField(
                      controller: vm.nameController,
                      decoration: InputDecoration(
                        hintText: "Enter First Name",
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    10.sH,
                    TextFormField(
                      controller: vm.lastNameController,
                      decoration: InputDecoration(
                        hintText: "Enter Last Name",
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    10.sH,
                    TextFormField(
                      controller: vm.mobileController,
                      decoration: InputDecoration(
                        hintText: "Enter Mobile Number",
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
