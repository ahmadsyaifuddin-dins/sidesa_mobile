import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; 
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // UBAH BAGIAN INI: Membungkus Logo dengan Animasi Bawaan Flutter
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500), // Durasi 1.5 detik
              curve: Curves.easeOutBack, // Efek memantul halus di akhir
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    // Memastikan nilai opacity tidak lebih dari 1.0 atau kurang dari 0.0
                    opacity: value.clamp(0.0, 1.0), 
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/SIDESA_MOBILE.png',
                width: 160, 
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Teks SIDESA Mobile dan Subtitle-nya
            Text(
              "SIDESA Mobile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary, 
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Layanan Desa Digital",
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 50),
            
            // Animasi Loading Spinkit
            SpinKitDancingSquare(
              color: theme.colorScheme.primary, 
              size: 50.0, 
            ),
          ],
        ),
      ),
    );
  }
}