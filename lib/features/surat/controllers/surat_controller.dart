import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Sesuaikan import path ini dengan struktur folder Mas Dins
import '../data/surat_repository.dart';
import '../../../data/models/surat_model.dart';

class SuratController extends GetxController {
  final SuratRepository _suratRepo = SuratRepository();

  // STATE VARIABEL
  var historySurat = <SuratModel>[].obs;
  var isLoadingHistory = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory(); // Otomatis load data saat controller dipanggil
  }

  // FUNGSI AMBIL RIWAYAT
  Future<void> fetchHistory() async {
    isLoadingHistory.value = true;
    try {
      var list = await _suratRepo.getRiwayatSurat();
      historySurat.assignAll(list);
    } catch (e) {
      Get.snackbar(
        "Informasi",
        "Gagal memuat riwayat surat. Periksa koneksi internet Anda.",
        backgroundColor: Colors.orange[100],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }
}
