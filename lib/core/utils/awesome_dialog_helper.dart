import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';

class AwesomeDialogHelper {
  /// Dialog Konfirmasi (Bisa dipakai untuk Logout, Hapus Data, dll)
  static void showConfirm({
    required String title,
    required String desc,
    required VoidCallback btnOkOnPress,
    DialogType dialogType = DialogType.warning,
    String btnOkText = 'Ya',
    String btnCancelText = 'Batal',
  }) {
    if (Get.context != null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: dialogType,
        animType: AnimType.bottomSlide,
        title: title,
        desc: desc,
        btnCancelOnPress: () {}, // Menutup dialog secara otomatis
        btnOkOnPress: btnOkOnPress,
        btnOkText: btnOkText,
        btnCancelText: btnCancelText,
        btnOkColor: (dialogType == DialogType.error || dialogType == DialogType.warning) 
            ? Colors.red 
            : const Color(0xFF00CA71), // Warna default hijau success
        btnCancelColor: Colors.grey[600],
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        descTextStyle: const TextStyle(fontSize: 14),
      ).show();
    }
  }

  /// Dialog Success (Untuk notifikasi sukses insert data, dll)
  static void showSuccess({
    required String title,
    required String desc,
    VoidCallback? btnOkOnPress, // Opsional jika ada aksi setelah OK
  }) {
    if (Get.context != null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: title,
        desc: desc,
        btnOkOnPress: btnOkOnPress ?? () {}, // Jika null, hanya tutup dialog
        btnOkText: 'OK',
        btnOkColor: const Color(0xFF00CA71),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        descTextStyle: const TextStyle(fontSize: 14),
      ).show();
    }
  }

  /// Dialog Error (Untuk notifikasi gagal API, validasi, dll)
  static void showError({
    required String title,
    required String desc,
    VoidCallback? btnOkOnPress,
  }) {
    if (Get.context != null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: title,
        desc: desc,
        btnOkOnPress: btnOkOnPress ?? () {},
        btnOkText: 'Tutup',
        btnOkColor: Colors.red,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        descTextStyle: const TextStyle(fontSize: 14),
      ).show();
    }
  }
}