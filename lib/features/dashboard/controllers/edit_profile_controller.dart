import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/data/auth_repository.dart';
import 'dashboard_controller.dart';

class EditProfileController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final DashboardController _dashboardC = Get.find<DashboardController>();

  final noTelpController = TextEditingController();
  var selectedImage = Rxn<File>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Isi otomatis textfield dengan data nomor telepon saat ini
    noTelpController.text = _dashboardC.userNoTelp.value == '-'
        ? ''
        : _dashboardC.userNoTelp.value;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Kompres sedikit agar tidak terlalu besar
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      await _authRepo.updateProfile(
        noTelp: noTelpController.text.trim(),
        avatar: selectedImage.value,
      );

      // Refresh data profil di dashboard agar avatar & no telp langsung berubah
      await _dashboardC.fetchUserProfile();

      Get.back(); // Tutup halaman edit
      Get.snackbar(
        "Berhasil",
        "Profil Anda berhasil diperbarui!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Gagal",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
