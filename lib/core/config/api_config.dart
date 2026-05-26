// Lokasi: lib/core/config/api_config.dart
import 'package:hive_flutter/hive_flutter.dart';

class ApiConfig {
  // Nilai default jika Hive masih kosong (IP laptop kamu saat ini)
  static const String _defaultIP = "192.168.0.28";
  
  static String get changePassword => "$baseUrl/change-password";
  static String get updateFcm => "$baseUrl/user/update-fcm";
  static String get updateProfile => "$baseUrl/user/update-profile";
  static String cekIdentitas(String nik) => "$baseUrl/identitas-warga/$nik";
  static String get mobileLogs => "$baseUrl/mobile-logs";
  
  // --- FITUR SOSMED & DM SIDESA ---
  static String get posts => "$baseUrl/posts";
  static String comments(int postId) => "$baseUrl/posts/$postId/comments";
  static String get messages => "$baseUrl/messages";

  // Helper untuk mengambil URL tanpa '/api' agar bisa dipakai untuk gambar public
  static String get baseHost => baseUrl.replaceAll('/api', '');

  static String get baseUrl {
    final box = Hive.box('settings');
    // Mengambil IP/URL dari Hive, jika belum ada gunakan _defaultIP
    String serverInput = box.get('server_ip', defaultValue: _defaultIP);
    
    // Cek apakah input berupa URL utuh (Ngrok/Domain publik)
    if (serverInput.startsWith('http')) {
      // Hapus garis miring di akhir jika user tidak sengaja mengetiknya
      if (serverInput.endsWith('/')) {
        serverInput = serverInput.substring(0, serverInput.length - 1);
      }
      return "$serverInput/api";
    } else {
      // Jika input hanya IP lokal (misal: 192.168.0.28)
      return "http://$serverInput:8000/api";
    }
  }

  // Getter khusus untuk Web Base URL (Tanpa /api)
  static String get webUrl {
    final box = Hive.box('settings');
    String serverInput = box.get('server_ip', defaultValue: _defaultIP);
    
    // Terapkan logika yang sama untuk kebutuhan Web URL
    if (serverInput.startsWith('http')) {
      if (serverInput.endsWith('/')) {
        serverInput = serverInput.substring(0, serverInput.length - 1);
      }
      return serverInput; // Return URL utuh tanpa tambahan /api
    } else {
      return "http://$serverInput:8000";
    }
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