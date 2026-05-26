import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import 'package:sidesa_mobile/core/config/api_config.dart';

class SuratDialogHelper {
  static void showPengajuanSurat() {
    if (Get.context == null) return;

    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "Pilih Metode Pengajuan",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            const Text(
              "Pilih platform untuk mengajukan surat Anda hari ini:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            // OPSI 1: VIA APLIKASI (NATIVE)
            _buildOptionCard(
              title: "Via Aplikasi (Cepat)",
              baseColor: Colors.blue,
              icon: Icons.phone_android_rounded,
              description: TextSpan(
                text: "Sangat cocok untuk surat umum (seperti ",
                style: TextStyle(fontSize: 12, color: Colors.blue[800], height: 1.3),
                children: const [
                  TextSpan(text: "SKU, SKTM, Kelahiran, dll", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ") karena formnya jauh lebih "),
                  TextSpan(text: "simpel dan praktis.", style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
              onTap: () {
                Get.back(); // Tutup dialog
                Get.toNamed('/buat-surat'); // Arahkan ke halaman native
              },
            ),

            const SizedBox(height: 12),

            // OPSI 2: VIA WEBSITE (LENGKAP)
            _buildOptionCard(
              title: "Via Website (Lengkap)",
              baseColor: Colors.orange,
              icon: Icons.language_rounded,
              description: TextSpan(
                text: "Pilih opsi ini jika surat yang Anda cari ",
                style: TextStyle(fontSize: 12, color: Colors.orange[800], height: 1.3),
                children: const [
                  TextSpan(text: "tidak tersedia", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: " di aplikasi, atau membutuhkan upload dokumen yang "),
                  TextSpan(text: "sangat banyak.", style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
              onTap: () async {
                Get.back(); // Tutup dialog
                
                // MENGGUNAKAN APICONFIG.WEBURL YANG SUDAH DINAMIS
                final String urlSurat = '${ApiConfig.webUrl}/layanan-surat/buat';
                final Uri url = Uri.parse(urlSurat);

                try {
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    SnackbarHelper.error(title: "Gagal", message: "Tidak dapat membuka browser");
                  }
                } catch (e) {
                  SnackbarHelper.error(title: "Error", message: "Gagal membuka link: $e");
                }
              },
            ),
          ],
        ),
      ),
      btnCancelText: "Batal",
      btnCancelColor: Colors.grey[400],
      btnCancelOnPress: () {},
    ).show();
  }

  // Widget internal agar kodenya tidak berulang di dalam dialog
  static Widget _buildOptionCard({
    required String title,
    required MaterialColor baseColor,
    required IconData icon,
    required TextSpan description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: baseColor[50],
          border: Border.all(color: baseColor[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: baseColor[100], shape: BoxShape.circle),
              child: Icon(icon, color: baseColor[700], size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: baseColor[900])),
                  const SizedBox(height: 5),
                  Text.rich(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}