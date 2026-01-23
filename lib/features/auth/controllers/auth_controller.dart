import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  // Text Controller untuk Form
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  // Variable Reaktif (Obs)
  var isLoading = false.obs;

  Future<void> login() async {
    // Validasi sederhana
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      Get.snackbar("Error", "Email dan Password harus diisi", 
        backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true; // Mulai Loading

    try {
      final user = await _repo.login(emailC.text, passwordC.text);
      
      // Sukses!
      Get.snackbar("Berhasil", "Halo, ${user.name}!",
          backgroundColor: Colors.green, colorText: Colors.white);
      
      // TODO: Arahkan ke Dashboard
      // Get.offAllNamed(Routes.DASHBOARD); 
      
    } catch (e) {
      // Gagal
      String msg = e.toString().replaceAll("Exception: ", "");
      Get.snackbar("Gagal Masuk", msg,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false; // Stop Loading
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}