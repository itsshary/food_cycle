import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String donatorId;
  final String needyId;
  final DateTime createdAt;
  final String userStatus;
  final String location;
  final String deviceToken;
  final String image;
  final double rating;

  UserModel({
    required this.uid,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.role = '',
    this.donatorId = '',
    this.needyId = '',
    DateTime? createdAt,
    this.userStatus = '',
    this.location = '',
    this.deviceToken = '',
    this.image = '',
    this.rating = 0.0,
  }) : createdAt = createdAt ?? DateTime.now(); // default fallback

  /// Convert model to map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'donatorId': donatorId,
      'needyId': needyId,
      'createdAt': createdAt,
      'userstatus': userStatus,
      'location': location,
      'devicetoken': deviceToken,
      'image': image,
      'rating': rating,
    };
  }

  /// Create model from map (from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      donatorId: map['donatorId'] ?? '',
      needyId: map['needyId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      userStatus: map['userstatus'] ?? 'Pending',
      location: map['location'] ?? '',
      deviceToken: map['devicetoken'] ?? '',
      image: map['image'] ?? '',
      rating: (map['rating'] as num).toDouble(),
    );
  }
}
