import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';

class FcmService extends GetxService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  Future<FcmService> init() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _initLocalNotif();
      _listenFCM();
    }
    return this;
  }

  Future<void> _initLocalNotif() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _localNotif.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleRouting(data);
        }
      },
    );
  }

  void _listenFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) _showLocalNotif(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleRouting(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        Future.delayed(
          const Duration(seconds: 1),
          () => _handleRouting(message.data),
        );
      }
    });
  }

  static void _showLocalNotif(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'sidesa_channel_id',
          'SIDESA Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    // FIX: Menggunakan named parameters untuk id, title, body, dan notificationDetails
    _localNotif.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: jsonEncode(message.data),
    );
  }

  static void _handleRouting(Map<String, dynamic> data) {
    try {
      final type = data['type'];
      final id = data['id'];

      if (type == null || id == null) return;

      if (type == 'aduan') {
        Get.toNamed(Routes.DETAIL_ADUAN, arguments: id.toString());
      } else if (type == 'surat') {
        Get.toNamed(Routes.DETAIL_SURAT, arguments: id.toString());
      }
    } catch (e) {
      debugPrint("Routing Error: $e");
    }
  }
}
