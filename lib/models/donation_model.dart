import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String donationId;
  final String uid;
  final String activeUserUid;
  final String foodItem;
  final String foodType;
  final String deliveryType;
  final int distance;
  final String startTime;
  final String endTime;
  final String description;
  final String quantity;
  final String imageUrl;
  final String donationStatus;
  final Timestamp? timestamp;

  DonationModel({
    required this.donationId,
    required this.uid,
    required this.activeUserUid,
    required this.foodItem,
    required this.foodType,
    required this.deliveryType,
    required this.distance,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.quantity,
    required this.imageUrl,
    required this.donationStatus,
    this.timestamp,
  });

  factory DonationModel.fromMap(Map<String, dynamic> data, String docId) {
    return DonationModel(
      donationId: data['donationid'] ?? docId,
      uid: data['uid'] ?? '',
      activeUserUid: data['activeuseruid'] ?? '',
      foodItem: data['foodItem'] ?? '',
      foodType: data['foodType'] ?? '',
      deliveryType: data['deliveryType'] ?? '',
      distance: data['distance'] ?? 0,
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      donationStatus: data['donationStatus'] ?? '',
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'donationid': donationId,
      'uid': uid,
      'activeuseruid': activeUserUid,
      'foodItem': foodItem,
      'foodType': foodType,
      'deliveryType': deliveryType,
      'distance': distance,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'donationStatus': donationStatus,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }
}
