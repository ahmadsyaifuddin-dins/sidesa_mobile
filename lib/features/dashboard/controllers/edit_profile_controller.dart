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

  String _sanitizePhoneNumber(String number) {
    if (number.isEmpty) return '';

    // 1. Hapus semua karakter yang BUKAN angka (termasuk +, -, spasi, kurung)
    String cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.isEmpty) return '';

    // 2. Cek awalan nomor untuk standarisasi ke 62
    if (cleanNumber.startsWith('0')) {
      cleanNumber = '62${cleanNumber.substring(1)}';
    } else if (cleanNumber.startsWith('8')) {
      cleanNumber = '62$cleanNumber';
    }

    return cleanNumber;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      // Terapkan sanitasi pada inputan teks sebelum dikirim
      String sanitizedNumber = _sanitizePhoneNumber(
        noTelpController.text.trim(),
      );

      await _authRepo.updateProfile(
        noTelp: sanitizedNumber, // Kirim nomor yang sudah disanitasi
        avatar: selectedImage.value,
      );

      // Refresh data profil di dashboard
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
