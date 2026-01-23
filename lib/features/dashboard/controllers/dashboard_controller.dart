import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../auth/data/auth_repository.dart';
import '../../../routes/app_routes.dart';

// PENTING: Import Repository Surat & Model Surat
// Pastikan file-file ini sudah kamu buat di langkah sebelumnya
import '../../surat/data/surat_repository.dart'; 
import '../../../data/models/surat_model.dart'; 

class DashboardController extends GetxController {
  // Repository
  final AuthRepository _authRepo = AuthRepository();
  final SuratRepository _suratRepo = SuratRepository(); 
  
  final _storage = const FlutterSecureStorage();

  // STATE USER (Profil)
  var userName = ''.obs;
  var userNik = ''.obs;
  
  // STATE HISTORY SURAT (Ini yang tadi error karena belum ada)
  var historySurat = <SuratModel>[].obs; // List kosong default
  var isLoadingHistory = false.obs;      // Status loading default false

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchHistory(); // Langsung ambil data pas aplikasi dibuka
  }

  // 1. Fungsi Baca Data User dari HP
  void loadUserData() async {
    String? name = await _storage.read(key: 'user_name');
    String? nik = await _storage.read(key: 'user_nik');
    
    if (name != null) userName.value = name;
    if (nik != null) userNik.value = nik;
  }

  // 2. Fungsi Ambil History Surat dari Server
  Future<void> fetchHistory() async {
    isLoadingHistory.value = true;
    try {
      // Panggil Repository Surat
      var list = await _suratRepo.getRiwayatSurat();
      
      // Ambil maksimal 3 data terbaru saja buat tampilan Dashboard
      historySurat.assignAll(list.take(3).toList());
    } catch (e) {
      print("Error fetch history: $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // 3. Fungsi Logout
  void logout() async {
    await _authRepo.logout();
    Get.offAllNamed(Routes.LOGIN);
    Get.snackbar("Logout", "Sampai jumpa lagi!");
  }
}