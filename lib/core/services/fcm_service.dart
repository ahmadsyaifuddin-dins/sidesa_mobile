import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../features/aduan/controllers/aduan_controller.dart';
import '../../features/surat/controllers/surat_controller.dart';

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
        AndroidInitializationSettings('@drawable/ic_notif');
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
      _refreshDataSilently();
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
          icon: '@drawable/ic_notif',
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

  static void _refreshDataSilently() {
    if (Get.isRegistered<AduanController>())
      Get.find<AduanController>().fetchRiwayatAduan();
    if (Get.isRegistered<SuratController>())
      Get.find<SuratController>().fetchHistory();
  }

  static void _handleRouting(Map<String, dynamic> data) {
    try {
      // 1. Tarik data terbaru di background
      _refreshDataSilently();

      final type = data['type'];
      final id = data['id'];

      if (type == null || id == null) return;

      // 2. FIX: Beri jeda 400 milidetik agar Navigator GetX tidak glitch
      // saat aplikasi baru saja "bangun" dari background.
      Future.delayed(const Duration(milliseconds: 400), () {
        if (type == 'aduan') {
          Get.toNamed(Routes.DETAIL_ADUAN, arguments: id.toString());
        } else if (type == 'surat') {
          Get.toNamed(Routes.DETAIL_SURAT, arguments: id.toString());
        }
      });
    } catch (e) {
      debugPrint("Routing Error: $e");
    }
  }
}
