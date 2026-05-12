import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sidesa_mobile/core/config/api_config.dart';

class ActivityLoggerService {
  static Future<void> log(String fitur) async {
    try {
      const storage = FlutterSecureStorage();
      
      String? token = await storage.read(key: 'auth_token'); 

      // Jika belum login / token tidak ada, batalkan pengiriman log
      if (token == null || token.isEmpty) return;

      final dio = Dio();
      await dio.post(
        ApiConfig.mobileLogs, // Mengarah ke getter di api_config.dart
        data: {
          'fitur': fitur
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          // Timeout sangat pendek (3 detik) 
          // Agar kalau internet lambat, log dibatalkan tanpa mengganggu UI warga
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Fail-safe (Senyap)
      // Sengaja tidak di-print atau di-throw agar tidak muncul error di layar
    }
  }
}