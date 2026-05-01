import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../../core/config/api_config.dart';
import '../../auth/data/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/greeting_util.dart';
import '../../surat/controllers/surat_controller.dart';
import '../../aduan/controllers/aduan_controller.dart';

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

  void toggleDataVisibility() => isDataHidden.value = !isDataHidden.value;
  void changeTab(int index) => tabIndex.value = index;

  @override
  void onInit() {
    super.onInit();

    // Agar data riwayat surat langsung di-fetch dan siap dipakai oleh tab surat
    Get.put(SuratController());
    Get.put(AduanController());
    greetingText.value = GreetingUtil.getRandomGreeting();
    loadUserData();
    fetchUserProfile();
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
      final data = await _authRepo.getRawProfile();
      final userData = data['user'];
      final wargaData = data['warga'];

      if (userData != null) {
        userAvatar.value = userData['avatar'] != null
            ? '${ApiConfig.baseHost}/${userData['avatar']}'
            : '';
      }

      if (wargaData != null) {
        userJenisKelamin.value = wargaData['jenis_kelamin'] ?? '-';
        userNoTelp.value = wargaData['nomor_telepon'] ?? '-';
        userAlamat.value = wargaData['alamat'] ?? '-';

        if (wargaData['tanggal_lahir'] != null) {
          DateTime parsedDate = DateTime.parse(wargaData['tanggal_lahir']);
          userTanggalLahir.value = DateFormat('dd-MM-yyyy').format(parsedDate);
        } else {
          userTanggalLahir.value = '-';
        }
      }
    } catch (e) {
      Get.snackbar(
        "Informasi",
        "Gagal memuat profil terbaru.",
        backgroundColor: Colors.orange[100],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void logout() async {
    await _authRepo.logout();
    // Hapus juga SuratController dari memori saat logout
    Get.delete<SuratController>();
    Get.delete<AduanController>();
    Get.offAllNamed(Routes.LOGIN);
  }
}
