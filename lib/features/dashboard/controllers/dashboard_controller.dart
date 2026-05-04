import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
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
      // Panggil getProfile() yang sudah rapi melewati UserModel
      final user = await _authRepo.getProfile();

      // Gunakan baseHost untuk memanggil URL Public[cite: 4]
      userAvatar.value = user.avatar != null
          ? '${ApiConfig.baseHost}/${user.avatar}'
          : '';

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
      SnackbarHelper.info(
        title: "Informasi",
        message: "Gagal memuat profil terbaru.",
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
