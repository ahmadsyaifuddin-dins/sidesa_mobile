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
    
    // 1. Ambil context dan tema
    final context = Get.context!;
    final theme = Theme.of(context);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      // 2. Pastikan background popup ikut menjadi gelap di Dark Mode
      dialogBackgroundColor: theme.cardColor, 
      title: "Pilih Metode Pengajuan",
      titleTextStyle: TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.bold, 
        color: theme.colorScheme.onSurface // Judul dinamis
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            Text(
              "Pilih platform untuk mengajukan surat Anda hari ini:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            // OPSI 1: VIA APLIKASI (NATIVE)
            _buildOptionCard(
              context: context, // Lempar context
              title: "Via Aplikasi (Cepat)",
              baseColor: Colors.blue, // Cukup berikan warna dasar
              icon: Icons.phone_android_rounded,
              description: TextSpan(
                text: "Sangat cocok untuk surat umum (seperti ",
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                children: const [
                  TextSpan(text: "SKU, SKTM, Kelahiran, dll", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
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
              context: context, // Lempar context
              title: "Via Website (Lengkap)",
              baseColor: Colors.orange, // Cukup berikan warna dasar
              icon: Icons.language_rounded,
              description: TextSpan(
                text: "Pilih opsi ini jika surat yang Anda cari ",
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                children: const [
                  TextSpan(text: "tidak tersedia", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
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
      // 3. Tombol batal menggunakan warna dinamis agar terbaca
      btnCancelColor: theme.colorScheme.surfaceVariant,
      buttonsTextStyle: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
      btnCancelOnPress: () {},
    ).show();
  }

  // Widget internal agar kodenya tidak berulang di dalam dialog
  static Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required Color baseColor, // Diubah dari MaterialColor menjadi Color agar bisa pakai withOpacity
    required IconData icon,
    required TextSpan description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          // 4. Gunakan withOpacity untuk background dan border
          color: baseColor.withOpacity(0.1),
          border: Border.all(color: baseColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.2), 
                shape: BoxShape.circle
              ),
              child: Icon(icon, color: baseColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 15, 
                      color: theme.colorScheme.onSurface, // Teks judul menjadi dinamis
                    ),
                  ),
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