import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_cycle/resources/componets/loading_widget/loading_widget.dart';
import 'package:food_cycle/screens/bottom_navigation/bottom_navigationbar.dart';
import 'package:food_cycle/screens/donater_screen/donater_bottom_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:food_cycle/resources/toast_ms/toast_msg.dart';

class LocationScreen extends StatefulWidget {
  final String role; // Pass the user's role from the previous screen

  const LocationScreen({super.key, required this.role});

  @override
  // ignore: library_private_types_in_public_api
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get the current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _mapController.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    } catch (e) {
      ToastMsg().showToast("Error getting location: $e");
    }
  }

  // Determine the user's position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Save the user's location to Firestore
  Future<void> _saveLocation() async {
    try {
      setState(() {
        isLoading = true;
      });
      String uid = _auth.currentUser!.uid;

      await _firestore.collection('users').doc(uid).update({
        'location': {
          'latitude': _currentPosition.latitude,
          'longitude': _currentPosition.longitude,
        },
      });

      setState(() {
        isLoading = false;
      });

      ToastMsg().showToast("Location saved successfully");

      if (widget.role == 'Needy') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CustomBottomBar()),
          (route) => false,
        );
      } else if (widget.role == 'Donater') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DonaterBottomBar()),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ToastMsg().showToast("Failed to save location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: LoadingBar())
          : Stack(
              children: [
                // Fixed GoogleMap without Expanded
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("current_location"),
                        position: _currentPosition,
                        infoWindow: const InfoWindow(title: "Current Location"),
                      ),
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: Colors.black,
                          ),
                          onPressed: _getCurrentLocation,
                          child: const Text(
                            "Find Current Location",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: _saveLocation,
                        child: const Text(
                          "Save Location",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
