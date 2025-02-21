import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // Request Permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("Permission granted");
    } else {
      log("Permission denied");
      return;
    }

    // Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground Notification: ${message.notification?.title}");
      Fluttertoast.showToast(
          msg: "Foreground Notification: ${message.notification?.title}");
      _showNotification(message);
    });

    // Background Notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Opened from Background: ${message.notification?.title}");
      Fluttertoast.showToast(
          msg: "Opened from Background: ${message.notification?.title}");
    });

    // Terminated State
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log("Opened from Terminated State: ${message.notification?.title}");
        Fluttertoast.showToast(
            msg:
                "Opened from Terminated State: ${message.notification?.title}");
      }
    });

    // Get Token for Testing
    _messaging.getToken().then((token) {
      log("FCM Token: $token");
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }
}
