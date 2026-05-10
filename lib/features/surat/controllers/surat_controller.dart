import 'package:get/get.dart';
    import 'package:flutter/material.dart';
    import 'package:awesome_dialog/awesome_dialog.dart'; 

    import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
    // PASTIKAN PATH INI SESUAI DENGAN LOKASI HELPER MU
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

      Future<void> batalkanPermohonan(int suratId) async {
        AwesomeDialogHelper.showConfirm(
          title: "Batalkan Permohonan?",
          desc: "Permohonan surat yang belum diproses akan dihapus secara permanen.",
          dialogType: DialogType.error,
          btnOkText: "Ya, Batalkan",
          btnCancelText: "Tutup",
          btnOkOnPress: () async {
            SnackbarHelper.info(
              title: "Memproses...",
              message: "Sedang membatalkan permohonan surat.",
              duration: 2.0,
            );

            try {
              bool isSuccess = await _suratRepo.batalkanSurat(suratId);

              if (isSuccess) {
                Get.back(); 

                SnackbarHelper.success(
                  title: "Berhasil",
                  message: "Permohonan surat telah dibatalkan.",
                );
                
                fetchHistory(); 
              }
            } catch (e) {
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