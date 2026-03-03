import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {

    await _messaging.requestPermission();

    String? token = await _messaging.getToken();

    if (token != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'fcmToken': token});
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${message.notification!.title}\n${message.notification!.body}",
            ),
          ),
        );
      }
    });
  }
}