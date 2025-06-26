import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/resources/componets/loading_widget/loading_widget.dart';
import 'package:food_cycle/screens/auth_screen/login_screen/login_screen.dart';
import 'package:food_cycle/screens/donater_screen/donator_active_donation/completed_donations/complete_donation.dart';
import 'package:food_cycle/screens/donater_screen/donator_active_donation/donator_active_donations.dart';
import 'package:food_cycle/screens/donater_screen/dontaer_profile_update.dart';
import 'package:geocoding/geocoding.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DonaterProfileScreen extends StatefulWidget {
  const DonaterProfileScreen({super.key});

  @override
  State<DonaterProfileScreen> createState() => _DonaterProfileScreenState();
}

class _DonaterProfileScreenState extends State<DonaterProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String address = "Loading address...";
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    final String uid = _auth.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      });
      return; // Early return if the user is not authenticated
    }
    final userData = await _firestore.collection('users').doc(uid).get();

    if (userData.exists) {
      // Extract location data from Firestore JSON object
      final Map<String, dynamic> location = userData['location'] ?? {};
      double latitude = location['latitude'] ?? 0.0;
      double longitude = location['longitude'] ?? 0.0;

      // Check if latitude and longitude are valid
      if (latitude != 0.0 && longitude != 0.0) {
        try {
          // Perform reverse geocoding
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latitude, longitude);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            setState(() {
              address =
                  "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
            });
          } else {
            setState(() {
              address = "No address found";
            });
          }
        } catch (e) {
          setState(() {
            address = "Failed to get address";
          });
          print("Error in reverse geocoding: $e");
        }
      } else {
        setState(() {
          address = "Invalid coordinates";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    final String uid = currentUser?.uid ?? '';

    // Immediate redirect if UID is empty
    if (uid.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      });
      return const SizedBox.shrink(); // Return empty widget while redirecting
    }

    return ModalProgressHUD(
      inAsyncCall: isloading,
      progressIndicator: const LoadingBar(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Profile",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),
          body: StreamBuilder(
            stream: _firestore.collection('users').doc(uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.green,
                ));
              }

              if (snapshot.hasError) {
                return const Center(child: Text("An error occurred"));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text("User data not found"));
              }

              final userData = snapshot.data!;
              final String firstName = userData['firstName'] ?? '';
              final String lastName = userData['lastName'] ?? '';
              final String email = userData['email'] ?? '';
              final String phone = userData['phone'] ?? '';
              final String role = userData['role'] ?? '';
              final String myuid = userData['uid'] ?? '';

              final String imageUrl = userData['image'] ?? '';
              if (myuid.isEmpty) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : const NetworkImage(
                              "https://cdn.creazilla.com/icons/3432052/blank-profile-picture-icon-lg.png"),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "$firstName $lastName",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "+92$phone",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.green,
                            ),
                            title: const Text("Address"),
                            subtitle: Text(address),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            title: const Text("Update Profile"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DontaerProfileUpdate(
                                            uid: uid,
                                          )));
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.type_specimen,
                              color: Colors.green,
                            ),
                            title: const Text("Account Type"),
                            subtitle: Text(role),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.notifications_active_sharp,
                              color: Colors.green,
                            ),
                            title: const Text("Active Donation"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DonatorActiveDonations()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.notifications_active_sharp,
                              color: Colors.green,
                            ),
                            title: const Text("Complete Donations"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CompleteDonation()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.green,
                            ),
                            title: const Text("Log Out"),
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false);
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            title: const Text(
                              "Delete Account",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: const Text(
                                    "Confirm Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to delete your account?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.green,
                                          overlayColor: Colors.green),
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        overlayColor:
                                            Colors.red.withOpacity(0.2),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context); // Close dialog

                                        try {
                                          await deleteUserAndData(uid, context);
                                        } catch (e) {
                                          setState(() {
                                            isloading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Failed to delete account: $e")),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }

//   Future<void> deleteUserAccount(BuildContext context) async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;

//     try {
//       if (uid.isEmpty) {
//         // Redirect to login screen if UID is empty
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//           (route) => false,
//         );
//         return; // Prevent further execution
//       }
//       await FirebaseAuth.instance.currentUser?.delete().then(
//         (value) async {
//           setState(() {
//             isloading = true;
//           });
//           final donationSnapshot = await _firestore
//               .collection('donations')
//               .where('uid', isEqualTo: uid)
//               .get();

//           if (donationSnapshot.docs.isNotEmpty) {
//             for (var doc in donationSnapshot.docs) {
//               await doc.reference.delete();
//             }
//           }
//           await _firestore.collection('users').doc(uid).delete();
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(uid)
//               .collection(uid)
//               .doc()
//               .delete();
//           setState(() {
//             isloading = false;
//           });
//         },
//       );
//     } catch (e) {
//       setState(() {
//         isloading = false;
//       });
//       rethrow;
//     }
//   }
// }

  Future<void> deleteUserAndData(String uid, BuildContext context) async {
    try {
      setState(() {
        isloading = true;
      });

      // Delete all user donations
      final donationSnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('uid', isEqualTo: uid)
          .get();

      for (var doc in donationSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete subcollection (all docs in users/uid/uid)
      final subCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(uid);

      final subSnapshot = await subCollection.get();

      for (var doc in subSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user document
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await FirebaseAuth.instance.currentUser?.delete();

      setState(() {
        isloading = false;
      });

      // 🔁 Navigate to LoginScreen and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        isloading = false;
      });
      rethrow;
    }
  }
}
