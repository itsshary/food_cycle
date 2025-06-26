import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItemsDetailsChecking extends StatefulWidget {
  final String itemname;
  final String images;
  final String donatorId;
  final String needyId;

  const ItemsDetailsChecking({
    super.key,
    required this.itemname,
    required this.images,
    required this.donatorId,
    required this.needyId,
  });

  @override
  State<ItemsDetailsChecking> createState() => _ItemsDetailsCheckingState();
}

class _ItemsDetailsCheckingState extends State<ItemsDetailsChecking> {
  late GoogleMapController _mapController;
  LatLng? _donatorLocation;
  LatLng? _needyLocation;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  // Fetch locations of donator and needy from Firestore
  Future<void> _fetchLocations() async {
    try {
      final donatorDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.donatorId)
          .get();
      final needyDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.needyId)
          .get();

      if (donatorDoc.exists && needyDoc.exists) {
        final donatorData = donatorDoc.data()!;
        final needyData = needyDoc.data()!;

        setState(() {
          _donatorLocation = LatLng(
            donatorData['location']['latitude'],
            donatorData['location']['longitude'],
          );
          _needyLocation = LatLng(
            needyData['location']['latitude'],
            needyData['location']['longitude'],
          );

          // Draw polyline between the locations
          _drawPolyline();
        });
      }
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  // Draw a polyline between donator and needy
  void _drawPolyline() {
    if (_donatorLocation != null && _needyLocation != null) {
      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: [_donatorLocation!, _needyLocation!],
      );

      setState(() {
        _polylines = {polyline};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _donatorLocation != null && _needyLocation != null
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _donatorLocation!,
                      zoom: 12,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('donator'),
                        position: _donatorLocation!,
                        infoWindow: const InfoWindow(title: 'Donator Location'),
                      ),
                      Marker(
                        markerId: const MarkerId('needy'),
                        position: _needyLocation!,
                        infoWindow: const InfoWindow(title: 'Needy Location'),
                      ),
                    },
                    polylines: _polylines,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
