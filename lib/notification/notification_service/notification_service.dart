import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:food_cycle/notification/server_key/server_key.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    try {
      String serverKey = await ServerKey().getServerKeyToken();
      print("Notification server key => $serverKey");

      String url =
          "https://fcm.googleapis.com/v1/projects/food-cycle-app/messages:send";

      var headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      };

      Map<String, dynamic> message = {
        "message": {
          "token": token,
          "notification": {
            "body": body,
            "title": title,
          },
          "data": data,
        }
      };

      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Notification sent successfully!");
        }
      } else {
        if (kDebugMode) {
          print("Failed to send notification: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("Response body: ${response.body}");
        }
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  static Future<void> sendNotificationToTopic({
    required String topic,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    try {
      String serverKey = await ServerKey().getServerKeyToken();
      print("Notification server key => $serverKey");

      String url =
          "https://fcm.googleapis.com/v1/projects/food-cycle-app/messages:send";

      var headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      };

      Map<String, dynamic> message = {
        "message": {
          "topic": topic,
          "notification": {
            "body": body,
            "title": title,
          },
          "data": data,
        }
      };

      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Topic notification sent successfully!");
        }
      } else {
        if (kDebugMode) {
          print("Failed to send topic notification: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      }
    } catch (e) {
      print("Error sending topic notification: $e");
    }
  }
}
