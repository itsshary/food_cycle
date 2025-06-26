import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildStatusRow(String donationStatus) {
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
