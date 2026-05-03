import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';
// Menggunakan package import agar path lebih rapi dan menghindari error
import 'package:sidesa_mobile/core/config/api_config.dart';
import 'package:sidesa_mobile/features/dashboard/controllers/dashboard_controller.dart';

void showQrBottomSheet(BuildContext context, DashboardController controller) {
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
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      SnackbarHelper.error(
                        title: "Gagal",
                        message: "Tidak dapat membuka browser",
                      );
                    }
                  } catch (e) {
                    SnackbarHelper.error(
                      title: "Error",
                      message: "Gagal membuka link: $e",
                    );
                  }
                } else {
                  SnackbarHelper.info(
                    title: "Info",
                    message: "Data NIK tidak valid",
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
