// Lokasi: lib/features/auth/controllers/auth_controller.dart

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
      final context = Get.context!;
      final theme = Theme.of(context); // Ambil referensi tema

      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        dialogBackgroundColor: theme.cardColor, // Background dinamis
        title: "⚙️ Developer Mode",
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onSurface, // Warna teks judul dinamis
          fontWeight: FontWeight.bold, 
          fontSize: 18
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Text(
                "Masukkan IP Lokal Wifi / URL Server SIDESA:",
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold, 
                  color: theme.colorScheme.onSurface // Teks label dinamis
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ipController,
                keyboardType: TextInputType.url,
                style: TextStyle(color: theme.colorScheme.onSurface), // Teks input dinamis
                decoration: InputDecoration(
                  hintText: "Cth: 192.168.0.28 atau https://ngrok...",
                  hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                  prefixIcon: Icon(Icons.link, color: theme.colorScheme.primary), // Icon dinamis
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest, // Warna field dinamis
                ),
              ),
            ],
          ),
        ),
        btnCancelText: "BATAL",
        btnOkText: "SIMPAN",
        btnOkColor: theme.colorScheme.primary, // Warna OK dinamis
        btnCancelColor: theme.colorScheme.surfaceContainerHighest, // Warna Batal dinamis
        buttonsTextStyle: TextStyle(
          color: theme.colorScheme.onSurface, // Teks tombol dinamis
          fontWeight: FontWeight.bold
        ),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          if (ipController.text.isNotEmpty) {
            String finalInput = ipController.text.trim();
            await ApiConfig.setIP(finalInput);

            SnackbarHelper.info(
              title: "Config Updated",
              message: "Server berhasil diubah ke: $finalInput. Lakukan Hot Restart agar efeknya maksimal.",
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