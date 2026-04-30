// Lokasi: lib/features/dashboard/views/widgets/digital_id_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sidesa_mobile/core/config/api_config.dart';
import 'package:sidesa_mobile/features/dashboard/controllers/dashboard_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DigitalIdCard extends StatelessWidget {
  const DigitalIdCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      width: double.infinity,
      // Hapus padding di sini, kita pindahkan ke dalam Stack -> Padding
      decoration: BoxDecoration(
        // Gradient mirip warna dasar KTP asli (Biru Muda cerah ke Putih kebiruan)
        gradient: LinearGradient(
          colors: [Colors.blueAccent.shade100, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // Gunakan ClipRRect agar gambar peta tidak keluar dari border radius kartu
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // --- LAYER 1: BACKGROUND WATERMARK PETA NKRI ---
            Positioned(
              right: -50, // Geser sedikit ke kanan
              bottom: -20, // Geser sedikit ke bawah
              child: Opacity(
                opacity:
                    0.15, // Transparansi siluet agar halus seperti watermark
                // Pastikan asset peta sudah didaftarkan di pubspec.yaml
                child: Image.asset(
                  'assets/map_nkri.png',
                  width: 350,
                  fit: BoxFit.contain,
                  // Mengubah warna asli gambar PNG menjadi biru tua/hitam (opsional)
                  color: Colors.blue[900],
                ),
              ),
            ),

            // --- LAYER 2: KONTEN DATA WARGA ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Kartu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SIDESA Mobile",
                        style: TextStyle(
                          color: Colors.blue[900], // Ubah ke warna gelap
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[900]?.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade900,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          "KARTU WARGA DIGITAL",
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Data Warga
                  Obx(
                    () => Text(
                      controller.userName.value.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black87, // Teks gelap khas KTP
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => Text(
                      controller.userNik.value,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Footer Kartu & QR Code Kecil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Desa Anjir Muara Kota Tengah",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Dokumen Digital Sah",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // QR Code yang bisa di-tap
                      GestureDetector(
                        onTap: () => _showQrBottomSheet(context, controller),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Obx(() {
                            final nik = controller.userNik.value;
                            final webUrl = nik.isNotEmpty
                                ? "${ApiConfig.webUrl}/identitas-warga/$nik"
                                : "SIDESA_GUEST";

                            return QrImageView(
                              data: webUrl,
                              version: QrVersions.auto,
                              size: 55.0,
                              backgroundColor: Colors.transparent,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.black87,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.black87,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FUNGSI BOTTOM SHEET PREVIEW & REDIRECT ---
  void _showQrBottomSheet(
    BuildContext context,
    DashboardController controller,
  ) {
    final String nik = controller.userNik.value;
    final String nama = controller.userName.value;
    final String webUrl = nik.isNotEmpty
        ? "${ApiConfig.webUrl}/identitas-warga/$nik"
        : "";

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Menyesuaikan tinggi konten
          children: [
            // Handle bar kecil di atas bottom sheet
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Kartu Warga Digital",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // QR Code Besar
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100, width: 2),
              ),
              child: QrImageView(
                data: webUrl.isNotEmpty ? webUrl : "SIDESA_GUEST",
                version: QrVersions.auto,
                size: 180.0,
              ),
            ),
            const SizedBox(height: 20),

            // Preview Data Warga
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    nama.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "NIK: $nik",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Buka Web Verifikasi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.open_in_browser),
                label: const Text(
                  "Verifikasi Lanjut via Web",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (webUrl.isNotEmpty) {
                    final Uri url = Uri.parse(webUrl);
                    try {
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        Get.snackbar(
                          "Gagal",
                          "Tidak dapat membuka browser",
                          backgroundColor: Colors.red[100],
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Gagal membuka link: $e",
                        backgroundColor: Colors.red[100],
                      );
                    }
                  } else {
                    Get.snackbar(
                      "Info",
                      "Data NIK tidak valid",
                      backgroundColor: Colors.orange[100],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
