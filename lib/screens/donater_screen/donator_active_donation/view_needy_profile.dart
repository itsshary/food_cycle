import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewNeedyProfile extends StatefulWidget {
  final String useruid;
  const ViewNeedyProfile({super.key, required this.useruid});

  @override
  State<ViewNeedyProfile> createState() => _ViewNeedyProfileState();
}

class _ViewNeedyProfileState extends State<ViewNeedyProfile> {
  String? address;

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "N/A";
    DateTime date = timestamp.toDate();
    return DateFormat("d MMMM yyyy").format(date);
  }

  Future<void> fetchAddress(double latitude, double longitude) async {
    String newAddress = await getAddressFromLatLng(latitude, longitude);
    if (mounted) {
      setState(() {
        address = newAddress;
      });
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.locality}, ${place.administrativeArea}";
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return "Address not found";
  }

  Future<void> dialNumber(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Needy Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.useruid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User not found."));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          // Get location from Firestore
          final Map<String, dynamic>? location = userData['location'];
          double latitude = location?['latitude'] ?? 0.0;
          double longitude = location?['longitude'] ?? 0.0;

          // Fetch address if not already fetched
          if (latitude != 0.0 && longitude != 0.0 && address == null) {
            fetchAddress(latitude, longitude);
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData['image']
                                    ?.toString()
                                    .isNotEmpty ==
                                true
                            ? userData['image']
                            : "https://cdn.creazilla.com/icons/3432052/blank-profile-picture-icon-lg.png"),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${userData['firstName'] ?? 'N/A'} ${userData['lastName'] ?? ''}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userData['email'] ?? 'N/A',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Divider(thickness: 1, height: 20),
                      _buildProfileRow(
                          "📅 First Joined", formatDate(userData['createdAt'])),
                      InkWell(
                          onTap: () async {
                            await dialNumber(userData['phone'].toString());
                          },
                          child: _buildProfileRow(
                              "📞 Phone", userData['phone'] ?? 'N/A')),
                      _buildProfileRow(
                          "📍 Location", address ?? "Fetching address..."),
                      _buildProfileRow("🎭 Role", userData['role'] ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
