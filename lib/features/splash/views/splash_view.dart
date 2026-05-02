import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // 1. IMPORT SPINKIT DI SINI
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Put Controller biar logic jalan (misal: delay 3 detik lalu ke Dashboard/Login)
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo SIDESA yang baru (Daun Digital)
            Image.asset(
              'assets/SIDESA_MOBILE.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            const Text(
              "SIDESA Mobile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Layanan Desa Digital",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 50),

            const SpinKitThreeBounce(
              color: Colors.blue, // Sesuaikan dengan warna primer SIDESA
              size: 25.0, // Ukurannya dibuat pas, tidak terlalu besar/kecil
            ),
          ],
        ),
      ),
    );
  }
}
