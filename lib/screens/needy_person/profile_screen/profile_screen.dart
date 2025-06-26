import 'package:flutter/material.dart';
import 'package:food_cycle/provider/needy_profile_vm.dart';
import 'package:food_cycle/resources/componets/loading_widget/loading_widget.dart';
import 'package:food_cycle/screens/auth_screen/login_screen/login_screen.dart';
import 'package:food_cycle/screens/needy_person/profile_update_needy/needy_profile_update.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class NeedyProfileScreen extends StatelessWidget {
  const NeedyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NeedyProfileViewModel(),
      child: Consumer<NeedyProfileViewModel>(
        builder: (context, vm, _) {
          if (vm.uid.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            });
            return const SizedBox.shrink();
          }

          return ModalProgressHUD(
            inAsyncCall: vm.isLoading,
            progressIndicator: LoadingBar(),
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Profile Screen",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green,
              ),
              body: StreamBuilder(
                stream: vm.userStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.green));
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text("User data not found"));
                  }

                  final data = snapshot.data!;
                  final firstName = data['firstName'] ?? '';
                  final lastName = data['lastName'] ?? '';
                  final email = data['email'] ?? '';
                  final phone = data['phone'] ?? '';
                  final role = data['role'] ?? '';
                  final imageUrl = data['image'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(imageUrl.isNotEmpty
                              ? imageUrl
                              : "https://cdn4.iconfinder.com/data/icons/evil-icons-user-interface/64/avatar-512.png"),
                        ),
                        const SizedBox(height: 16),
                        Text("$firstName $lastName",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(email,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text("+92$phone",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 24),
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.location_on,
                                    color: Colors.green),
                                title: const Text("Address",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(vm.address),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            NeedyProfileUpdate(uid: vm.uid),
                                      ));
                                },
                                leading: const Icon(Icons.edit_square,
                                    color: Colors.green),
                                title: const Text("Update Profile",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              ListTile(
                                leading: const Icon(Icons.type_specimen,
                                    color: Colors.green),
                                title: const Text("Account Type",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(role),
                              ),
                              ListTile(
                                leading: const Icon(Icons.logout,
                                    color: Colors.green),
                                title: const Text("Log Out",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onTap: () => vm.logout(context),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.delete, color: Colors.red),
                                title: const Text("Delete Account",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: const Text("Confirm Delete",
                                        style: TextStyle(color: Colors.white)),
                                    content: const Text(
                                        "Are you sure you want to delete your account?",
                                        style: TextStyle(color: Colors.white)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel",
                                            style:
                                                TextStyle(color: Colors.green)),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await vm.deleteAccount(context);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const LoginScreen()),
                                              (route) => false);
                                        },
                                        child: const Text("OK",
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
