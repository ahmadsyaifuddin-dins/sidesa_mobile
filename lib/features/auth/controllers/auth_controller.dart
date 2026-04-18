// Lokasi: lib/features/auth/controllers/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Tambahkan import Hive
import '../data/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../core/config/api_config.dart'; // Tambahkan import ApiConfig (pastikan path-nya sesuai)

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;

  Future<void> login() async {
    // ... (Kode login yang sudah ada tidak perlu diubah)
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      Get.snackbar("Error", "Email dan Password harus diisi", 
        backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final user = await _repo.login(emailC.text, passwordC.text);
      Get.snackbar("Berhasil", "Halo, ${user.name}!",
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      String msg = e.toString().replaceAll("Exception: ", "");
      Get.snackbar("Gagal Masuk", msg,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void showChangeIPDialog() {
    // Ambil IP saat ini dari Hive (atau default jika kosong)
    final currentIP = Hive.box('settings').get('server_ip', defaultValue: "192.168.0.28");
    final TextEditingController ipController = TextEditingController(text: currentIP);

    Get.defaultDialog(
      title: "⚙️ Developer Mode",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      content: Column(
        children: [
          const Text("Masukkan IP Laptop Server SIDESA:", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          TextField(
            controller: ipController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Contoh: 192.168.1.10",
              prefixIcon: const Icon(Icons.wifi, color: Colors.blue),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          Get.snackbar(
            "Config Updated", 
            "IP Server berhasil diubah ke: ${ipController.text}. Lakukan Hot Restart agar efeknya maksimal.",
            backgroundColor: Colors.blue.shade900,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
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