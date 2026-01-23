import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';

class DigitalIdCard extends StatelessWidget {
  const DigitalIdCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return AspectRatio(
      aspectRatio: 1.58,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Hiasan
            Positioned(top: -40, right: -40, child: _circleDecor()),
            Positioned(bottom: -40, left: -40, child: _circleDecor()),

            // Konten Kartu
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header Kartu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "KARTU WARGA DIGITAL",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.nfc, color: Colors.white54, size: 20),
                    ],
                  ),

                  // Body Kartu (NIK & Nama)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Obx(() => Text(
                              controller.userNik.value.isNotEmpty
                                  ? controller.userNik.value
                                  : "---- ---- ---- ----",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier',
                              ),
                            )),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Obx(() => Text(
                              controller.userName.value.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )),
                      ),
                    ],
                  ),

                  // Footer Kartu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Text("Verified Member",
                            style: TextStyle(color: Colors.white, fontSize: 9)),
                      ),
                      const Icon(Icons.qr_code, color: Colors.white, size: 24),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleDecor() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }
}