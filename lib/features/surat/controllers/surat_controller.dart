// Lokasi: lib/features/surat/controllers/surat_controller.dart

import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';

// Sesuaikan import path ini dengan struktur folder kamu
import '../data/surat_repository.dart';
import '../../../data/models/surat_model.dart';

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
}