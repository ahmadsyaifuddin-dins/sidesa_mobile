import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../data/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../core/config/api_config.dart';
import '../../../core/utils/snackbar_helper.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;
  var isObscure = true.obs;
  void toggleObscure() => isObscure.toggle();

  Future<void> login() async {
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
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

      SnackbarHelper.success(
        title: "Berhasil",
        message: "Halo, ${user.name}!",
      );
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      String msg = e.toString().replaceAll("Exception: ", "");
      SnackbarHelper.error(
        title: "Gagal Masuk",
        message: msg,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showChangeIPDialog() {
    final currentIP = Hive.box('settings').get('server_ip', defaultValue: "192.168.0.28");
    final TextEditingController ipController = TextEditingController(text: currentIP);

    if (Get.context != null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: "⚙️ Developer Mode",
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const Text(
                "Masukkan IP Laptop Server SIDESA:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
        ),
        btnCancelText: "BATAL",
        btnOkText: "SIMPAN",
        btnOkColor: Colors.blue.shade700,
        btnCancelColor: Colors.grey[600],
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          if (ipController.text.isNotEmpty) {
            await ApiConfig.setIP(ipController.text);

            SnackbarHelper.info(
              title: "Config Updated",
              message: "IP Server berhasil diubah ke: ${ipController.text}. Lakukan Hot Restart agar efeknya maksimal.",
              duration: 4.0,
            );
          }
        },
      ).show();
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}