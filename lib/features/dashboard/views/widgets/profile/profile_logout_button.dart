// Lokasi: lib/features/dashboard/views/widgets/profile/profile_logout_button.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sidesa_mobile/core/utils/awesome_dialog_helper.dart';
import '../../../controllers/dashboard_controller.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          // Tidak perlu lagi melempar 'context' karena helper sudah pakai Get.context!
          onPressed: () => _showLogoutDialog(controller),
          style: ElevatedButton.styleFrom(
            // Trik Opacity: Nyaman di Light Mode, Kontras dan Elegan di Dark Mode
            backgroundColor: Colors.red.withValues(alpha: 0.15),
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 15),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Keluar Aplikasi",
            style: TextStyle(fontWeight: FontWeight.bold), // Aku tambahkan bold biar lebih tegas
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(DashboardController controller) {
    // Panggil helper yang sudah dimodularisasi
    AwesomeDialogHelper.showConfirm(
      title: "Konfirmasi",
      desc: "Apakah Anda yakin ingin keluar dari aplikasi?",
      dialogType: DialogType.warning, // Tipe warning akan memberi icon kuning dan tombol merah
      btnOkText: "Ya, Keluar",
      btnCancelText: "Batal",
      btnOkOnPress: () {
        controller.logout();
      },
    );
  }
}