// Lokasi: lib/data/repositories/message_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import '../../core/config/api_config.dart';

class MessageRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  // Fungsi untuk mengambil header beserta token
  Future<Options> _getOptions() async {
    // Ambil token dari Secure Storage (Sesuai dengan sistem SIDESA kamu)
    final token = await _storage.read(key: 'auth_token'); 
    
    return Options(headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
  }

  // --- FITUR INBOX & KONTAK ---
  Future<List<dynamic>> getInbox() async {
    final options = await _getOptions();
    final response = await _dio.get("${ApiConfig.baseHost}/api/messages/inbox", options: options);
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data'];
    }
    throw Exception('Gagal mengambil daftar obrolan');
  }

  Future<List<dynamic>> getContacts() async {
    final options = await _getOptions();
    final response = await _dio.get("${ApiConfig.baseHost}/api/messages/contacts", options: options);
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data'];
    }
    throw Exception('Gagal mengambil daftar kontak');
  }

  // --- FITUR CHAT ROOM ---
  Future<List<dynamic>> getConversation(int contactId) async {
    final options = await _getOptions();
    final response = await _dio.get("${ApiConfig.baseHost}/api/messages/$contactId", options: options);
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data'];
    }
    throw Exception('Gagal mengambil obrolan');
  }

  Future<Map<String, dynamic>> sendMessage(int receiverId, String text, {dynamic attachmentFile}) async {
    final options = await _getOptions();
    
    FormData formData = FormData.fromMap({
      'receiver_id': receiverId,
      if (text.isNotEmpty) 'message': text,
    });

    if (attachmentFile != null) {
      String fileName = attachmentFile.path.split('/').last;
      formData.files.add(MapEntry(
        'attachment',
        await MultipartFile.fromFile(attachmentFile.path, filename: fileName),
      ));
    }

    final response = await _dio.post("${ApiConfig.baseHost}/api/messages/send", data: formData, options: options);
    if (response.statusCode == 201 && response.data['success'] == true) {
      return response.data['data'];
    }
    throw Exception('Gagal mengirim pesan');
  }

  Future<void> markAsRead(int senderId) async {
    try {
      final options = await _getOptions();
      FormData formData = FormData.fromMap({'sender_id': senderId});
      
      // Menembak API Laravel untuk menandai pesan telah dibaca
      await _dio.post(
        "${ApiConfig.baseHost}/api/messages/mark-read", 
        data: formData, 
        options: options
      );
    } catch (e) {
      // Kita silent error-nya agar tidak mengganggu UI kalau gagal
      print("Silent Error Mark As Read: $e");
    }
  }

  Future<void> markAsDelivered(int senderId) async {
    try {
      final options = await _getOptions();
      FormData formData = FormData.fromMap({'sender_id': senderId});
      await _dio.post("${ApiConfig.baseHost}/api/messages/mark-delivered", data: formData, options: options);
    } catch (e) {}
  }
}