import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FcmService extends GetxService {
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  Future<FcmService> init() async {
    print("🚀 FcmService mulai diinisialisasi...");

    // 1. Cek Status Izin
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);
    print("🔔 Status Izin Notif OS: ${settings.authorizationStatus}");

    // 2. Setup Local Notif
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    await _localNotif.initialize(settings: initSettings);
    print("✅ Local Notif Plugin siap!");

    // 3. Setup Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'sidesa_high_importance',
      'Notifikasi Penting SIDESA',
      description: 'Channel untuk notifikasi surat dan aduan',
      importance: Importance.max,
      playSound: true,
    );

    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // 4. Tangkap Notifikasi (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📨 YEY! Pesan masuk saat aplikasi DIBUKA!");
      print("   -> Judul: ${message.notification?.title}");
      print("   -> Body: ${message.notification?.body}");
      print("   -> Data Tambahan: ${message.data}");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        try {
          // PASTIKAN ADA LABEL id:, title:, body:, dan notificationDetails:
          _localNotif.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
              ),
            ),
          );
          print("🔊 Pop-up Local Notification berhasil dipicu!");
        } catch (e) {
          print("❌ Gagal memicu Pop-up Local Notif: $e");
        }
      } else {
        print("⚠️ Pesan masuk, tapi tidak ada objek 'notification'-nya.");
      }
    });

    return this;
  }
}
