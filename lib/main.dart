import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Init Database Lokal
  await Hive.initFlutter();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SIDESA AMKOTENG Mobile',
      debugShowCheckedModeBanner: false,
      
      // Tema Aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // Konfigurasi GetX Routing
      // initialRoute: AppPages.INITIAL, // Nanti diaktifkan pas LoginView jadi
      // getPages: AppPages.routes,      // Nanti diaktifkan
      
      // SEMENTARA BIAR GAK ERROR PAS DI-RUN:
      home: const Scaffold(
        body: Center(child: Text("SIDESA Mobile (GetX Setup Complete)")),
      ),
    );
  }
}