import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/repositories/social_repository.dart';
import '../../../core/utils/snackbar_helper.dart';

class CreatePostController extends GetxController {
  final SocialRepository _repo = SocialRepository();
  final contentC = TextEditingController();
  
  var isLoading = false.obs;
  var selectedImage = Rxn<File>();

  // Fungsi untuk memilih gambar dari Kamera atau Galeri
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 100, // Ambil kualitas penuh dulu, nanti kita kompres
      );

      if (image != null) {
        File file = File(image.path);
        // Lakukan kompresi sebelum disimpan ke state
        File? compressedFile = await _compressImage(file);
        selectedImage.value = compressedFile ?? file;
      }
    } catch (e) {
      SnackbarHelper.error(title: "Error", message: "Gagal memilih gambar: $e");
    }
  }

  // Fungsi Kompresi Gambar (Sangat Penting untuk menghemat Storage Server)
  Future<File?> _compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      // Buat nama file unik untuk hasil kompresi
      final targetPath = '${dir.absolute.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70, // Kompresi hingga 70%, cukup bagus untuk sosmed
        minWidth: 1080,
        minHeight: 1080,
      );
      
      return result != null ? File(result.path) : null;
    } catch (e) {
      print("Error kompresi: $e");
      return null;
    }
  }

  // Fungsi Hapus Gambar
  void removeImage() {
    selectedImage.value = null;
  }

  // Fungsi Kirim Postingan
  Future<void> submitPost() async {
    if (contentC.text.trim().isEmpty) {
      SnackbarHelper.warning(title: "Perhatian", message: "Aspirasi tidak boleh kosong.");
      return;
    }

    try {
      isLoading.value = true;
      // Secara default kita set type 'aspirasi'. Nanti di backend, 
      // Laravel akan ngecek jika role-nya admin, otomatis jadi 'pengumuman'.
      await _repo.createPost(
        type: 'aspirasi', 
        content: contentC.text.trim(),
        attachment: selectedImage.value,
      );

      // Tutup form dan beri notifikasi
      Get.back(result: true);
      SnackbarHelper.success(title: "Berhasil", message: "Aspirasi Anda berhasil dikirim!");
      
      // Catatan: Kita tidak perlu memanggil fetchPosts() manual ke TimelineController,
      // karena PusherService (Reverb) akan otomatis mendeteksi postingan baru dan memunculkannya!
      
    } catch (e) {
      SnackbarHelper.error(title: "Gagal", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    contentC.dispose();
    super.onClose();
  }
}