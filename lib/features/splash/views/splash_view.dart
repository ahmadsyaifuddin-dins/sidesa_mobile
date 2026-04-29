import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Put Controller biar logic jalan (misal: delay 3 detik lalu ke Dashboard/Login)
    Get.put(SplashController());

    return Scaffold(
      backgroundColor:
          Colors.white, // Background putih agar menyatu dengan background logo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo SIDESA yang baru (Daun Digital)
            Image.asset(
              'assets/SIDESA_MOBILE.png',
              width:
                  160, // Ukuran bisa disesuaikan (besarkan/kecilkan sesuai selera)
              height: 160,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 24),

            const Text(
              "SIDESA Mobile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors
                    .blue, // Nanti bisa diganti ke Colors.green jika ingin senada dengan daun
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Layanan Desa Digital",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 50),

            // Loading indikator
            const CircularProgressIndicator(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
