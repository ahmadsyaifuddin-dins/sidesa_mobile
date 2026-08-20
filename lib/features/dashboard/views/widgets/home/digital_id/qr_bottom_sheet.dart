// Lokasi: lib/features/dashboard/views/widgets/home/digital_id/qr_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sidesa_mobile/core/config/api_config.dart';
import 'package:sidesa_mobile/features/dashboard/controllers/dashboard_controller.dart';

void showQrBottomSheet(BuildContext context, DashboardController controller) {
  final String nik = controller.userNik.value;
  final String nama = controller.userName.value;
  final String webUrl = nik.isNotEmpty
      ? "${ApiConfig.webUrl}/identitas-warga/$nik"
      : "";

  final theme = Theme.of(context);

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // Background sheet mengikuti tema
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Garis Handle (Drag Indicator)
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant, // Warna abu-abu dinamis
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            "Kartu Warga Digital",
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          // --- KOTAK QR CODE (WAJIB TETAP PUTIH) ---
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white, // Wajib putih demi scanner fisik
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 2),
            ),
            child: QrImageView(
              data: webUrl.isNotEmpty ? webUrl : "SIDESA_GUEST",
              version: QrVersions.auto,
              size: 180.0,
              backgroundColor: Colors.white, // Paksa putih
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black, // Paksa hitam
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black, // Paksa hitam
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- KOTAK INFO NAMA & NIK ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1), // Biru pudar/transparan
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  nama.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "NIK: $nik",
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontFamily: 'Courier',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- TOMBOL VERIFIKASI ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
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