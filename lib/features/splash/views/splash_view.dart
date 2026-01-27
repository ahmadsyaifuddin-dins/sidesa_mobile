import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Put Controller biar logic jalan
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white, // Atau Colors.blue[900] biar elegan
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti Icon ini dengan Gambar Logo Desamu nanti (Image.asset)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_outlined, 
                size: 80, 
                color: Colors.blue
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              "SIDESA Mobile",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 2
              ),
            ),
            
            const SizedBox(height: 10),
            const Text(
              "Layanan Desa Digital",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 50),

            // Loading muter-muter kecil di bawah
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}