import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeService extends GetxService {
  // Kita pakai box 'settings' yang sama dengan api_config.dart
  final _box = Hive.box('settings');
  final _key = 'theme_mode';

  // Reactive state agar UI (seperti radio button) bisa langsung update
  final RxString currentTheme = 'system'.obs;

  @override
  void onInit() {
    super.onInit();
    // Set nilai awal dari Hive saat service dijalankan
    currentTheme.value = _box.get(_key, defaultValue: 'system');
  }

  // Getter untuk inisialisasi di GetMaterialApp
  ThemeMode get theme {
    String themeString = currentTheme.value;
    if (themeString == 'light') return ThemeMode.light;
    if (themeString == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  // Fungsi untuk mengubah dan menyimpan tema
  void changeTheme(String mode) {
    currentTheme.value = mode; // Update state Rx
    _box.put(_key, mode);      // Simpan permanen ke Hive

    // Eksekusi perubahan UI GetX
    if (mode == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    } else if (mode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }
}