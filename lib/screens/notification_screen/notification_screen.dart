import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/utils/color_resources.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  RemoteMessage? message;
  NotificationScreen({super.key, this.message});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.whiteColor),
        backgroundColor: ColorResources.primaryColor,
        title: const Text(
          'Notification Screen',
          style: TextStyle(
            color: ColorResources.whiteColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(uid)
            .collection('notifications')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              String docID = snapshot.data!.docs[index].id.toString();
              return GestureDetector(
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(uid)
                      .collection('notifications')
                      .doc(docID)
                      .update({"isSeen": true});
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 105,
                    child: Card(
                      color: snapshot.data!.docs[index]['isSeen']
                          ? Colors.white
                          : Colors.green.shade100,
                      elevation: 10,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(snapshot.data!.docs[index]['isSeen']
                              ? Icons.done
                              : Icons.notification_add),
                        ),
                        title: Text(snapshot.data!.docs[index]['title']),
                        subtitle: Text(
                            "Picking Timing ${snapshot.data!.docs[index]['donationTiming']}"),
                        trailing: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: snapshot.data!.docs[index]['isSeen']
                                  ? Colors.white
                                  : Colors.red,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
