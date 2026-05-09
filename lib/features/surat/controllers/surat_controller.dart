// Lokasi: lib/features/surat/controllers/surat_controller.dart

import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';

// Sesuaikan import path ini dengan struktur folder kamu
import '../data/surat_repository.dart';
import '../../../data/models/surat_model.dart';
import 'package:flutter/material.dart';

class SuratController extends GetxController {
  final SuratRepository _suratRepo = SuratRepository();

  // --- STATE VARIABEL ---
  // List utama untuk menyimpan semua data asli dari database
  var historySurat = <SuratModel>[].obs;
  
  // List bayangan untuk ditampilkan di UI (hasil saringan/filter)
  var filteredHistorySurat = <SuratModel>[].obs;
  
  // State indikator loading
  var isLoadingHistory = false.obs;
  
  // State untuk melacak tab filter mana yang sedang aktif
  var selectedFilter = 'Semua'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory(); // Otomatis load data saat controller dipanggil
  }

  // --- FUNGSI AMBIL RIWAYAT DARI API ---
  Future<void> fetchHistory() async {
    isLoadingHistory.value = true;
    try {
      var list = await _suratRepo.getRiwayatSurat();
      historySurat.assignAll(list);
      
      // Setelah data asli masuk, jalankan fungsi filter agar 'filteredHistorySurat' 
      // terisi sesuai dengan tab filter yang sedang aktif (default: 'Semua')
      filterSuratByStatus(selectedFilter.value);
      
    } catch (e) {
      SnackbarHelper.warning(
        title: "Informasi",
        message: "Gagal memuat riwayat surat. Periksa koneksi internet Anda.",
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // --- FUNGSI FILTER SURAT ---
  // Dipanggil saat warga menekan tab filter di riwayat_tab.dart
  void filterSuratByStatus(String statusUI) {
    selectedFilter.value = statusUI;

    if (statusUI == 'Semua') {
      // Jika "Semua", tampilkan seluruh data asli
      filteredHistorySurat.assignAll(historySurat);
    } else {
      // Konversi teks tab (cth: "Menunggu Validasi" -> "menunggu_validasi")
      String statusDB = statusUI.toLowerCase().replaceAll(' ', '_');
      
      // Saring data berdasarkan statusDB
      filteredHistorySurat.assignAll(
        historySurat.where((surat) => surat.status == statusDB).toList()
      );
    }
  }

  // --- FUNGSI BATALKAN PERMOHONAN ---
  Future<void> batalkanPermohonan(int suratId) async {
    // 1. Munculkan Dialog Konfirmasi menggunakan GetX
    Get.defaultDialog(
      title: "Batalkan Permohonan?",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Permohonan surat yang belum diproses akan dihapus secara permanen.",
      textConfirm: "Ya, Batalkan",
      textCancel: "Tutup",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.grey[700],
      onConfirm: () async {
        // Tutup dialog konfirmasi
        Get.back();

        // Tampilkan loading snackbar
        SnackbarHelper.info(
          title: "Memproses...",
          message: "Sedang membatalkan permohonan surat.",
          duration: 2.0,
        );

        try {
          // 2. Tembak API melalui Repository
          bool isSuccess = await _suratRepo.batalkanSurat(suratId);

          if (isSuccess) {
            SnackbarHelper.success(
              title: "Berhasil",
              message: "Permohonan surat telah dibatalkan.",
            );
            
            // 3. Refresh data riwayat dan terapkan filter yang sedang aktif
            await fetchHistory(); 
            
            // 4. Kembali ke halaman list (karena surat di detail ini sudah terhapus)
            Get.back(); 
          }
        } catch (e) {
          // Hilangkan kata "Exception: " bawaan dart
          String errorMsg = e.toString().replaceAll("Exception: ", "");
          SnackbarHelper.error(
            title: "Gagal",
            message: errorMsg,
          );
        }
      },
    );
  }
}