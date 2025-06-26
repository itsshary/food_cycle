import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BadgeProvider with ChangeNotifier {
  final String userId;

  BadgeProvider({required this.userId}) {
    fetchBadgeCount();
    listenToBadgeChanges();
  }

  int _badgeCount = 0;
  int get badgeCount => _badgeCount;

  Future<void> fetchBadgeCount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('notifications')
          .get();

      _badgeCount = snapshot.docs.length;
      notifyListeners();
    } catch (e) {
      print('Error fetching badge count: $e');
    }
  }

  void listenToBadgeChanges() {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('notifications')
        .where('isSeen', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      _badgeCount = snapshot.docs.length;
      notifyListeners();
    });
  }
}
