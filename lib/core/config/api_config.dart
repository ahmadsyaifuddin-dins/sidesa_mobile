// Lokasi: lib/core/config/api_config.dart
import 'package:hive_flutter/hive_flutter.dart';

class ApiConfig {
  // Nilai default jika Hive masih kosong (IP laptop kamu saat ini)
  static const String _defaultIP = "192.168.0.28";
  static String get changePassword => "$baseUrl/change-password";
  static String get updateFcm => "$baseUrl/user/update-fcm";
  
  static String get baseUrl {
    final box = Hive.box('settings');
    // Mengambil IP dari Hive, jika belum ada gunakan _defaultIP
    String ip = box.get('server_ip', defaultValue: _defaultIP);
    return "http://$ip:8000/api";
  }

  // Karena baseUrl sekarang dinamis (getter), route di bawah juga harus jadi getter
  static String get login => "$baseUrl/login";
  static String get user => "$baseUrl/user";
  
  // Fungsi helper untuk update IP dari UI
  static Future<void> setIP(String newIP) async {
    final box = Hive.box('settings');
    await box.put('server_ip', newIP);
  }
}