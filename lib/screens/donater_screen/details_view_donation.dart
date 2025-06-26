import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailsViewDonation extends StatefulWidget {
  final String itemname;
  final String donatername;
  final String images;
  final String quantity;
  final String pickingtime;
  final String endtime;
  final String location;
  final String description;
  final int km;
  final String foodstatus;
  final String donationId;

  const DetailsViewDonation({
    super.key,
    required this.itemname,
    required this.images,
    required this.donationId,
    required this.quantity,
    required this.km,
    required this.location,
    required this.endtime,
    required this.pickingtime,
    required this.foodstatus,
    required this.description,
    required this.donatername,
  });

  @override
  State<DetailsViewDonation> createState() => _DetailsViewDonationState();
}

class _DetailsViewDonationState extends State<DetailsViewDonation> {
  String donationStatus = "inactive";
  String activeUserUid = "";
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _checkDonationStatus();
  }

  Future<void> _checkDonationStatus() async {
    DocumentSnapshot donationSnapshot = await FirebaseFirestore.instance
        .collection('donations')
        .doc(widget.donationId)
        .get();

    if (donationSnapshot.exists) {
      setState(() {
        donationStatus = donationSnapshot.get('donationStatus') ?? "inactive";
        activeUserUid = donationSnapshot.get('activeuseruid') ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Donation Details",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(widget.images,
                    fit: BoxFit.cover, width: double.infinity, height: 250),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              children: [
                _buildInfoRow(Icons.fastfood, "Food Item", widget.itemname),
                _buildInfoRow(Icons.person, "Donator Name", widget.donatername),
                _buildInfoRow(Icons.access_time, "Pickup Time",
                    "${widget.pickingtime} - ${widget.endtime}"),
                _buildInfoRow(Icons.place, "Location", widget.location),
                _buildInfoRow(
                    Icons.description, "Description", widget.description),
              ],
            ),
            const SizedBox(height: 10),
            _buildCard(
              children: [
                _buildStatusRow(),
                _buildInfoRow(Icons.category, "Quantity", widget.quantity),
                _buildInfoRow(
                    Icons.check_circle, "Food Status", widget.foodstatus),
                _buildInfoRow(
                    Icons.directions_walk, "Distance", "${widget.km} km"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isDescription = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: isDescription
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: isDescription ? 5 : 1, // Limit description to 5 lines
              overflow:
                  isDescription ? TextOverflow.ellipsis : TextOverflow.visible,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      color: const Color.fromARGB(255, 223, 240, 224),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6, // Increased elevation for better shadow
      shadowColor: Colors.grey.withOpacity(0.5), // Added shadow color
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildStatusRow() {
    Color statusColor = donationStatus == "Completed"
        ? Colors.blue
        : donationStatus == "active"
            ? Colors.green
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.infoCircle, color: statusColor),
          const SizedBox(width: 10),
          const Text("Donation Status",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(
            donationStatus.toUpperCase(),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: statusColor),
          ),
        ],
      ),
    );
  }
}
