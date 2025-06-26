// lib/view_model/donation_details_view_model.dart
import 'package:flutter/material.dart';
import 'package:food_cycle/services/donation_service.dart';
import 'package:food_cycle/notification/notification_service/notification_service.dart';

class DonationDetailsViewModel extends ChangeNotifier {
  final DonationService _service = DonationService();

  String donationStatus = "inactive";
  String activeUserUid = "";

  Future<void> fetchDonationDetails(String donationId) async {
    final data = await _service.getDonation(donationId);
    if (data != null) {
      donationStatus = data['donationStatus'] ?? 'inactive';
      activeUserUid = data['activeuseruid'] ?? '';
      notifyListeners();
    }
  }

  Future<void> activateDonation(
    String donationId,
    String userId,
    String itemName,
    String description,
    String image,
    String pickingTime,
    String endTime,
    String location,
    String foodstatus,
  ) async {
    await _service.activateDonation(donationId, userId);
    donationStatus = "active";
    activeUserUid = userId;
    notifyListeners();

    final token = await _service.getDeviceToken(userId);
    await _service.saveNotification(
      userId: userId,
      data: {
        'title': 'Donation $itemName is Active Successfully',
        'body': description,
        'isSeen': false,
        'image': image,
        'donationTiming': "$pickingTime---$endTime",
        'location': location,
        'foodtype': foodstatus,
        'createdAt': DateTime.now(),
      },
    );

    if (token != null) {
      NotificationService.sendNotificationUsingApi(
        token: token,
        title: 'Active Donation Successfully',
        body: 'Check The details on Active Donation Screen',
        data: {'screen': 'notification'},
      );
    }
  }
}
