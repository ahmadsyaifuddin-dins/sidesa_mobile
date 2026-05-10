import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import '../../../core/utils/awesome_dialog_helper.dart';
import '../data/surat_repository.dart';
import '../../../data/models/surat_model.dart';

class SuratController extends GetxController {
    final SuratRepository _suratRepo = SuratRepository();
    var historySurat = <SuratModel>[].obs;
    var filteredHistorySurat = <SuratModel>[].obs;
    var isLoadingHistory = false.obs;
    var selectedFilter = 'Semua'.obs;
    @override
    void onInit() {
      super.onInit();
      fetchHistory();
    }

    Future<void> fetchHistory() async {
      isLoadingHistory.value = true;
      try {
        var list = await _suratRepo.getRiwayatSurat();
        historySurat.assignAll(list);
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
    void filterSuratByStatus(String statusUI) {
      selectedFilter.value = statusUI;
      if (statusUI == 'Semua') {
        filteredHistorySurat.assignAll(historySurat);
      } else {
        String statusDB = statusUI.toLowerCase().replaceAll(' ', '_');
        filteredHistorySurat.assignAll(
          historySurat.where((surat) => surat.status == statusDB).toList()
        );
      }
    }

    // --- FUNGSI BATALKAN PERMOHONAN ---
  Future<void> batalkanPermohonan(int suratId) async {
    // 1. Kita gunakan AwesomeDialog agar UI-nya premium dan seragam dengan Logout!
    AwesomeDialogHelper.showConfirm(
      dialogType: DialogType.warning,
      title: "Batalkan Permohonan?",
      desc: "Permohonan surat yang belum diproses akan dihapus secara permanen.",
      btnOkText: "Ya, Batalkan",
      btnOkOnPress: () async {
        // (AwesomeDialog otomatis tertutup saat tombol 'Ya' ditekan)

        // 2. Munculkan Loading Screen (Memblokir layar agar tidak bisa diklik)
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          barrierDismissible: false, // Tidak bisa ditutup walau klik luar layar
        );

        try {
          // 3. Tembak API
          bool isSuccess = await _suratRepo.batalkanSurat(suratId);

          if (isSuccess) {
            // 4. Tutup Loading Screen
            if (Get.isDialogOpen == true) {
              Get.back(); 
            }

            // 5. Tutup Halaman Detail Surat (Otomatis kembali ke Riwayat)
            Get.back();

            // 6. Kasih jeda sedikit biar animasinya mulus, lalu munculkan Snackbar Hijau
            Future.delayed(const Duration(milliseconds: 300), () {
              SnackbarHelper.success(
                title: "Berhasil",
                message: "Permohonan surat telah dibatalkan.",
              );
            });

            // 7. Refresh Data Riwayat di background
            fetchHistory();
          }
        } catch (e) {
          // Jika error, Tutup Loading Screen
          if (Get.isDialogOpen == true) {
            Get.back(); 
          }

          // Tampilkan pesan error
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