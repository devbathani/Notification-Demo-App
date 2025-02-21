import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? fcmToken;
  @override
  void initState() {
    getFCMToken();
    super.initState();
  }

  void getFCMToken() async {
    // Get Token for Testing
    await _messaging.getToken().then((token) {
      log("FCM Token: $token");
      setState(() {
        fcmToken = token!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Notifications"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(
            fcmToken ?? "Waiting for notifications...",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
