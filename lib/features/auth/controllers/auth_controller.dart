// Lokasi: lib/features/auth/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../data/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../core/config/api_config.dart';
import '../../../core/utils/snackbar_helper.dart'; // Import helper SIDESA

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;
  var isObscure = true.obs;
  void toggleObscure() => isObscure.toggle();

  Future<void> login() async {
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      // Menggunakan tipe Warning untuk validasi input
      SnackbarHelper.warning(
        title: "Peringatan",
        message: "Email dan Password harus diisi",
      );
      return;
    }

    isLoading.value = true;

    try {
      final user = await _repo.login(emailC.text, passwordC.text);

      try {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          print("🔥 FCM Token berhasil didapat: $fcmToken");
          await _repo.sendFcmToken(fcmToken);
        }
      } catch (e) {
        print("❌ Gagal mendapatkan FCM Token: $e");
      }

      // Menggunakan tipe Success saat berhasil login
      SnackbarHelper.success(
        title: "Berhasil",
        message: "Halo, ${user.name}!",
      );
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      String msg = e.toString().replaceAll("Exception: ", "");
      // Menggunakan tipe Error saat login ditolak/salah
      SnackbarHelper.error(
        title: "Gagal Masuk",
        message: msg,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showChangeIPDialog() {
    // Ambil IP saat ini dari Hive (atau default jika kosong)
    final currentIP = Hive.box(
      'settings',
    ).get('server_ip', defaultValue: "192.168.0.28");
    
    final TextEditingController ipController = TextEditingController(
      text: currentIP,
    );

    Get.defaultDialog(
      title: "⚙️ Developer Mode",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      content: Column(
        children: [
          const Text(
            "Masukkan IP Laptop Server SIDESA:",
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ipController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Contoh: 192.168.1.10",
              prefixIcon: const Icon(Icons.wifi, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ],
      ),
      textConfirm: "SIMPAN",
      textCancel: "BATAL",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue.shade700,
      cancelTextColor: Colors.blue.shade700,
      onConfirm: () async {
        if (ipController.text.isNotEmpty) {
          await ApiConfig.setIP(ipController.text); // Simpan ke Hive via ApiConfig
          Get.back(); // Tutup dialog
          
          // Menggunakan tipe Info untuk pemberitahuan update sistem
          SnackbarHelper.info(
            title: "Config Updated",
            message: "IP Server berhasil diubah ke: ${ipController.text}. Lakukan Hot Restart agar efeknya maksimal.",
            duration: 4.0, // Durasi agak lama agar user sempat baca
          );
        }
      },
    );
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}