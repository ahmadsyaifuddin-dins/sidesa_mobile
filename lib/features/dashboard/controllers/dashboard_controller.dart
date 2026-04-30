import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../../core/config/api_config.dart';
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
  var userAvatar = ''.obs;

  var isDataHidden = true.obs;

  void toggleDataVisibility() {
    isDataHidden.value = !isDataHidden.value;
  }

  var historySurat = <SuratModel>[].obs;
  var isLoadingHistory = false.obs;
  var tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchHistory();
    fetchUserProfile();
  }

  void changeTab(int index) => tabIndex.value = index;

  void loadUserData() async {
    String? name = await _storage.read(key: 'user_name');
    String? nik = await _storage.read(key: 'user_nik');
    String? email = await _storage.read(key: 'user_email');
    if (name != null) userName.value = name;
    if (nik != null) userNik.value = nik;
    if (email != null) userEmail.value = email;
  }

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

  Future<void> fetchUserProfile() async {
    try {
      final data = await _authRepo.getRawProfile();
      final userData = data['user'];
      final wargaData = data['warga'];

      if (userData != null) {
        // Build URL Avatar menggunakan IP Dinamis
        userAvatar.value = userData['avatar'] != null
            ? '${ApiConfig.baseHost}/${userData['avatar']}'
            : '';
      }

      if (wargaData != null) {
        userJenisKelamin.value = wargaData['jenis_kelamin'] ?? '-';
        userNoTelp.value = wargaData['no_telp'] ?? '-';
        userAlamat.value = wargaData['alamat'] ?? '-';

        if (wargaData['tanggal_lahir'] != null) {
          DateTime parsedDate = DateTime.parse(wargaData['tanggal_lahir']);
          userTanggalLahir.value = DateFormat('dd-MM-yyyy').format(parsedDate);
        } else {
          userTanggalLahir.value = '-';
        }
      }
    } catch (e) {
      print("Error fetch user profile: $e");
    }
  }

  void logout() async {
    await _authRepo.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
