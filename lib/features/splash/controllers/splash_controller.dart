import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    // Jalankan pengecekan saat controller dibuat
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    // 1. Kasih jeda sedikit (misal 2 detik) biar Logonya sempat kelihat
    // Biar gak kayak aplikasi nge-glitch tiba-tiba pindah
    await Future.delayed(const Duration(seconds: 2));

    // 2. Cek apakah ada token tersimpan
    String? token = await _storage.read(key: 'auth_token');

    // 3. Logika Percabangan
    if (token != null && token.isNotEmpty) {
      // Kalau ada token, berarti user sudah pernah login -> Ke Dashboard
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      // Kalau gak ada token -> Ke Login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}