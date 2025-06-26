import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeAgoWidget extends StatelessWidget {
  final Timestamp timestamp;

  const TimeAgoWidget({super.key, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        timestamp.toDate(); // Convert Firebase Timestamp to DateTime
    String timeAgo = timeago.format(dateTime,
        locale: 'en_short'); // Convert to "time ago" format

    return Text(
      timeAgo, // Example: "36m ago", "2h ago", "1d ago"
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
}
