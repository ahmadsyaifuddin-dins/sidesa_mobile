import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SnackbarHelper {
  // --- FUNGSI UTAMA (DRY) ---
  static void _showSnackbar({
    required String title,
    required String message,
    required ContentType contentType,
    double duration = 3.0,
  }) {
    Get.rawSnackbar(
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.TOP, 
      margin: const EdgeInsets.only(top: 16),
      duration: Duration(milliseconds: (duration * 1000).toInt()),
      
      // TAMBAHAN GETX UNTUK FITUR CLOSE
      isDismissible: true, // Mengizinkan swipe untuk menutup
      dismissDirection: DismissDirection.horizontal, // Arah swipe ke samping
      onTap: (snack) {
        Get.closeCurrentSnackbar(); // Menutup snackbar saat seluruh area di-tap
      },

      // MEMATIKAN TOMBOL X BAWAAN PACKAGE AGAR TIDAK BENTROK
      messageText: IgnorePointer(
        child: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );
  }

  // 1. Tipe Success
  static void success({required String title, required String message, double duration = 3}) {
    _showSnackbar(title: title, message: message, contentType: ContentType.success, duration: duration);
  }

  // 2. Tipe Error (Menggunakan ContentType.failure)
  static void error({required String title, required String message, double duration = 3}) {
    _showSnackbar(title: title, message: message, contentType: ContentType.failure, duration: duration);
  }

  // 3. Tipe Info
  static void info({required String title, required String message, double duration = 3}) {
    _showSnackbar(title: title, message: message, contentType: ContentType.help, duration: duration);
  }

  // 4. Tipe Warning
  static void warning({required String title, required String message, double duration = 3}) {
    _showSnackbar(title: title, message: message, contentType: ContentType.warning, duration: duration);
  }

  // 5. Tipe Waiting (Dialihkan ke desain Help)
  static void waiting({required String title, required String message, double duration = 3}) {
    _showSnackbar(title: title, message: message, contentType: ContentType.help, duration: duration);
  }
}