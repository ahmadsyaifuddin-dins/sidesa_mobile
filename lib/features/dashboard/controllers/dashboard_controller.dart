import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../auth/data/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../surat/data/surat_repository.dart'; 
import '../../../data/models/surat_model.dart'; 

class DashboardController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final SuratRepository _suratRepo = SuratRepository(); 
  final _storage = const FlutterSecureStorage();

  var userName = ''.obs;
  var userNik = ''.obs;
  var userEmail = ''.obs;
  
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
  }

  void changeTab(int index) {
    tabIndex.value = index;
  }

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

  void logout() async {
    await _authRepo.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}