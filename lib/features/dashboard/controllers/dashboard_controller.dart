import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart'; // Tambahan import untuk format tanggal
import '../../auth/data/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../surat/data/surat_repository.dart';
import '../../../data/models/surat_model.dart';

class DashboardController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final SuratRepository _suratRepo = SuratRepository();
  final _storage = const FlutterSecureStorage();

  // STATE USER DATA
  var userName = ''.obs;
  var userNik = ''.obs;
  var userEmail = ''.obs;
  var userJenisKelamin = ''.obs;
  var userTanggalLahir = ''.obs;
  var userNoTelp = ''.obs;
  var userAlamat = ''.obs;

  // STATE HISTORY
  var historySurat = <SuratModel>[].obs;
  var isLoadingHistory = false.obs;

  // STATE TAB MENU (0: Beranda, 1: Riwayat, 2: Profil)
  var tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchHistory();
    fetchUserProfile(); // Memanggil data profil lengkap dari API saat dashboard dimuat
  }

  void changeTab(int index) {
    tabIndex.value = index;
  }

  // Load data dasar dari local storage agar tidak nunggu API (UX lebih responsif)
  void loadUserData() async {
    String? name = await _storage.read(key: 'user_name');
    String? nik = await _storage.read(key: 'user_nik');
    String? email = await _storage.read(key: 'user_email');
    if (name != null) userName.value = name;
    if (nik != null) userNik.value = nik;
    if (email != null) userEmail.value = email;
  }

  // Fetch riwayat surat
  Future<void> fetchHistory() async {
    isLoadingHistory.value = true;
    try {
      var list = await _suratRepo.getRiwayatSurat();
      historySurat.assignAll(list);
    } catch (e) {
      print("Error fetch history: $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // Fetch data profil lengkap (termasuk jenis kelamin, tgl lahir, dll) dari Laravel
  Future<void> fetchUserProfile() async {
    try {
      // Ambil data mentah dari API via repository
      final data = await _authRepo.getRawProfile();

      // Ambil objek 'warga' dari response JSON
      final wargaData = data['warga'];

      if (wargaData != null) {
        // Set state data tambahan
        userJenisKelamin.value = wargaData['jenis_kelamin'] ?? '-';
        userNoTelp.value = wargaData['no_telp'] ?? '-';
        userAlamat.value = wargaData['alamat'] ?? '-';

        // Formatting Tanggal Lahir menjadi DD-MM-YYYY
        if (wargaData['tanggal_lahir'] != null) {
          DateTime parsedDate = DateTime.parse(wargaData['tanggal_lahir']);
          String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
          userTanggalLahir.value = formattedDate;
        } else {
          userTanggalLahir.value = '-';
        }
      }
    } catch (e) {
      print("Error fetch user profile: $e");
      // Opsional: Bisa tambahkan Get.snackbar di sini jika ingin notif ke user saat gagal load profil
    }
  }

  // Fungsi Logout
  void logout() async {
    await _authRepo.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
