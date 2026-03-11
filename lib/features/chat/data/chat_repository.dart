import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/api_config.dart';

class ChatRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  // --- AMBIL RIWAYAT CHAT ---
  Future<List<dynamic>> getHistory() async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await _dio.get(
      "${ApiConfig.baseUrl}/chat",
      options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
    );
    if (response.statusCode == 200 && response.data['success']) {
      return response.data['data'];
    }
    return [];
  }

  // --- KIRIM PESAN KE AI ---
  Future<String> sendMessage(String message) async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await _dio.post(
      "${ApiConfig.baseUrl}/chat",
      data: {'message': message},
      options: Options(
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
        // Kasih waktu agak lama karena AI Groq butuh waktu berpikir
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30), 
      ),
    );

    if (response.statusCode == 200 && response.data['success']) {
      return response.data['data']['jawaban'] ?? "Maaf, tidak ada jawaban.";
    }
    throw Exception("Gagal mengirim pesan");
  }

  // --- BERSIHKAN RIWAYAT ---
  Future<void> clearHistory() async {
    String? token = await _storage.read(key: 'auth_token');
    await _dio.delete(
      "${ApiConfig.baseUrl}/chat/clear",
      options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
    );
  }
}