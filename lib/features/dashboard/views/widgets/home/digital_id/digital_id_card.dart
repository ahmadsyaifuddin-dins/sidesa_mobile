import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sidesa_mobile/core/config/api_config.dart';
import 'package:sidesa_mobile/features/dashboard/controllers/dashboard_controller.dart';
// Import fungsi bottom sheet yang sudah kita pisahkan
import 'qr_bottom_sheet.dart';

class DigitalIdCard extends StatelessWidget {
  const DigitalIdCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              bottom: -20,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  'assets/map_nkri.png',
                  width: 350,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SIDESA Mobile",
                        style: TextStyle(
                          color: Colors.white,
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white54, width: 0.5),
                        ),
                        child: const Text(
                          "KARTU WARGA DIGITAL",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Obx(
                    () => Text(
                      controller.userName.value.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
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
                        color: Colors.blue.shade100,
                        fontSize: 16,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
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
                              color: Colors.blue.shade100,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Dokumen Digital Sah",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        // Panggil fungsi eksternal
                        onTap: () => showQrBottomSheet(context, controller),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
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
}
