import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart'; // IMPORT HIVE
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import '../../../core/config/api_config.dart';
import '../../auth/data/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/greeting_util.dart';
import '../../surat/controllers/surat_controller.dart';
import '../../aduan/controllers/aduan_controller.dart';
import 'package:sidesa_mobile/core/services/activity_logger_service.dart';

class DashboardController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final _storage = const FlutterSecureStorage();

  var greetingText = "".obs;

  // STATE USER DATA
  var userName = ''.obs;
  var userNik = ''.obs;
  var userEmail = ''.obs;
  var userJenisKelamin = ''.obs;
  var userTanggalLahir = ''.obs;
  var userNoTelp = ''.obs;
  var userAlamat = ''.obs;
  var userAvatar = ''.obs;

  var isDataHidden = true.obs;
  var tabIndex = 0.obs;
  
  // --- STATE BARU UNTUK HIDE NIK VIA HIVE ---
  var isNikHidden = true.obs; 

  void toggleDataVisibility() => isDataHidden.value = !isDataHidden.value;
  
  // --- FUNGSI TOGGLE NIK + SIMPAN KE HIVE ---
  void toggleNikVisibility() async {
    isNikHidden.value = !isNikHidden.value;
    var box = await Hive.openBox('app_settings');
    await box.put('is_nik_hidden', isNikHidden.value);
  }

  void changeTab(int index) {
    tabIndex.value = index;
    switch (index) {
      case 0: ActivityLoggerService.log('Tab: Home Dashboard'); break;
      case 1: ActivityLoggerService.log('Tab: Riwayat Pengajuan'); break;
      case 2: ActivityLoggerService.log('Tab: Forum Komunitas (SIDESA Timeline)'); break;
      case 3: ActivityLoggerService.log('Tab: Inbox / Pesan Masuk'); break;
      case 4: ActivityLoggerService.log('Tab: Profil Pengguna'); break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    Get.put(SuratController());
    Get.put(AduanController());
    greetingText.value = GreetingUtil.getRandomGreeting();
    loadUserData();
    fetchUserProfile();
    
    // Load status unhide NIK terakhir dari Hive
    initNikVisibility();
  }

  // --- AMBIL DATA KONDISI HIDE NIK TERAKHIR ---
  void initNikVisibility() async {
    var box = await Hive.openBox('app_settings');
    // Default awal adalah TRUE (tersembunyi) jika user belum pernah mencet tombol mata
    isNikHidden.value = box.get('is_nik_hidden', defaultValue: true);
  }

  void loadUserData() async {
    String? name = await _storage.read(key: 'user_name');
    String? nik = await _storage.read(key: 'user_nik');
    String? email = await _storage.read(key: 'user_email');

    if (name != null) userName.value = name;
    if (nik != null) userNik.value = nik;
    if (email != null) userEmail.value = email;
  }

  Future<void> fetchUserProfile() async {
    try {
      final user = await _authRepo.getProfile();
      userAvatar.value = user.avatar != null ? '${ApiConfig.baseHost}/${user.avatar}' : '';
      userJenisKelamin.value = user.jenisKelamin ?? '-';
      userNoTelp.value = user.nomorTelepon ?? '-';
      userAlamat.value = user.alamat ?? '-';

      if (user.tanggalLahir != null) {
        DateTime parsedDate = DateTime.parse(user.tanggalLahir!);
        userTanggalLahir.value = DateFormat('dd-MM-yyyy').format(parsedDate);
      } else {
        userTanggalLahir.value = '-';
      }
    } catch (e) {
      SnackbarHelper.info(title: "Informasi", message: "Gagal memuat profil terbaru.");
    }
  }

  void logout() async {
    await _authRepo.logout();
    Get.delete<SuratController>();
    Get.delete<AduanController>();
    Get.offAllNamed(Routes.LOGIN);
  }
}