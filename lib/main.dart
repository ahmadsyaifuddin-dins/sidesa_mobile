import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Wajib ditambahkan
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'core/services/fcm_service.dart';
import 'core/services/pusher_service.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Sekadar inisialisasi minimal agar Firebase tahu ada pesan masuk
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print(" Pesan masuk di background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Hive (Kode asli Mas Dins)
  await Hive.initFlutter();
  await Hive.openBox('settings'); 
  
  // 2. Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Daftarkan fungsi Background Handler untuk notifikasi
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 4. Jalankan Service FCM kita secara asinkron (untuk Foreground Notif)
  await Get.putAsync(() => FcmService().init());
  await Get.putAsync(() => PusherService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SIDESA AMKOTENG Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      
      // AKTIFKAN INI SEKARANG:
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}