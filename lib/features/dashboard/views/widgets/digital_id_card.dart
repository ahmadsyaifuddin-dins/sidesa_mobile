// Lokasi: lib/features/dashboard/views/widgets/digital_id_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import package QR
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Verified Member",
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                      
                      // BAGIAN QR CODE YANG DIUPDATE WARNANYA
                      GestureDetector(
                        onTap: () {
                          _showQrDialog(controller.userNik.value);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            // Background transparan tipis agar menyatu dengan kartu biru
                            color: Colors.white.withOpacity(0.1), 
                            borderRadius: BorderRadius.circular(8),
                            // Border putih tipis agar ada batas yang rapi
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1), 
                          ),
                          child: Obx(() => QrImageView(
                            data: controller.userNik.value.isNotEmpty 
                                ? controller.userNik.value 
                                : "SIDESA_GUEST",
                            version: QrVersions.auto,
                            size: 55.0,
                            backgroundColor: Colors.transparent, // Background QR murni transparan
                            // Mengubah warna kotak penanda (mata) QR menjadi putih
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Colors.white, 
                            ),
                            // Mengubah warna titik-titik data QR menjadi putih
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ),
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

  // Menambahkan fungsi dialog GetX untuk menampilkan QR Code besar
  void _showQrDialog(String nik) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Agar tinggi dialog menyesuaikan konten
            children: [
              const Text(
                "Scan QR Code",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              QrImageView(
                data: nik.isNotEmpty ? nik : "SIDESA_GUEST",
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 20),
              const Text(
                "Tunjukkan QR Code ini kepada petugas balai desa untuk verifikasi identitas Anda.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(), // Menggunakan GetX untuk menutup dialog
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}