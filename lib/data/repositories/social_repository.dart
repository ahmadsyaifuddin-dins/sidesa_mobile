import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/api_config.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/message_model.dart';

class SocialRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  // Helper untuk mengambil token auth
  Future<String> _getToken() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception("Sesi habis, silakan login ulang.");
    return token;
  }

  // Helper untuk setup Dio Options dengan otorisasi
  Future<Options> _getOptions() async {
    String token = await _getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    );
  }

  // --- 1. TIMELINE & POSTS ---
  Future<Map<String, dynamic>> getPosts({int page = 1}) async {
    try {
      final options = await _getOptions();
      final response = await _dio.get("${ApiConfig.posts}?page=$page", options: options);
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']; // Mengembalikan objek paginasi Laravel
      }
      throw Exception(response.data['message']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Koneksi bermasalah');
    }
  }

  Future<PostModel> createPost({required String type, required String content, File? attachment}) async {
    try {
      Map<String, dynamic> dataMap = {'type': type, 'content': content};
      if (attachment != null) {
        dataMap['attachment'] = await MultipartFile.fromFile(attachment.path, filename: attachment.path.split('/').last);
      }
      
      var formData = FormData.fromMap(dataMap);
      final options = await _getOptions();
      final response = await _dio.post(ApiConfig.posts, data: formData, options: options);

      if (response.statusCode == 201 && response.data['success'] == true) {
        return PostModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal membuat postingan');
    }
  }

  // --- 3. DIRECT MESSAGES ---
  Future<Map<String, dynamic>> getMessages(int partnerId, {int page = 1}) async {
    try {
      final options = await _getOptions();
      final response = await _dio.get("${ApiConfig.messages}?user_id=$partnerId&page=$page", options: options);
      if (response.statusCode == 200 && response.data['success'] == true) return response.data['data'];
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Gagal memuat pesan');
    }
  }

  Future<MessageModel> sendMessage({required int receiverId, String? message, File? attachment}) async {
    try {
      Map<String, dynamic> dataMap = {'receiver_id': receiverId};
      if (message != null) dataMap['message'] = message;
      if (attachment != null) dataMap['attachment'] = await MultipartFile.fromFile(attachment.path, filename: attachment.path.split('/').last);

      var formData = FormData.fromMap(dataMap);
      final options = await _getOptions();
      final response = await _dio.post(ApiConfig.messages, data: formData, options: options);

      if (response.statusCode == 201 && response.data['success'] == true) return MessageModel.fromJson(response.data['data']);
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Gagal mengirim pesan');
    }
  }

  Future<void> updatePost(int postId, String newContent) async {
    try {
      final options = await _getOptions();
      final response = await _dio.put("${ApiConfig.posts}/$postId", data: {'content': newContent}, options: options);
      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengedit postingan');
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      final options = await _getOptions();
      final response = await _dio.delete("${ApiConfig.posts}/$postId", options: options);
      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal menghapus postingan');
    }
  }

  // --- FITUR KOMENTAR ---
  Future<Map<String, dynamic>> getComments(int postId, {int page = 1}) async {
    final options = await _getOptions();
    final response = await _dio.get("${ApiConfig.posts}/$postId/comments?page=$page", options: options);
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data;
    }
    throw Exception('Gagal mengambil komentar');
  }

  Future<Map<String, dynamic>> sendComment(int postId, String content, {int? parentId}) async {
    final options = await _getOptions();
    
    final data = {
      'post_id': postId, 
      'content': content,
      if (parentId != null) 'parent_id': parentId,
    };
    
    try {
      final response = await _dio.post("${ApiConfig.posts}/$postId/comments", data: data, options: options);
      
      if (response.statusCode == 201 && response.data['success'] == true) {
        return response.data['data'];
      }
      throw Exception('Gagal mengirim komentar');
      
    } catch (e) {
      // Menangkap pesan error spesifik dari Laravel jika menggunakan Dio
      if (e is DioException) {
        if (e.response != null && e.response?.data != null) {
          // Ambil pesan asli dari backend Laravel (misal: "post_id is required")
          final errorMessage = e.response?.data['message'] ?? 'Terjadi kesalahan pada server';
          throw Exception(errorMessage);
        }
      }
      // Jika error lain (seperti internet putus)
      throw Exception(e.toString());
    }
  }

  Future<void> deleteComment(int commentId) async {
    final options = await _getOptions();
    final response = await _dio.delete("${ApiConfig.baseHost}/api/comments/$commentId", options: options);
    if (response.statusCode != 200 || response.data['success'] != true) {
      throw Exception('Gagal menghapus komentar');
    }
  }

  Future<Map<String, dynamic>> updateComment(int commentId, String content) async {
    final options = await _getOptions();
    final response = await _dio.put("${ApiConfig.baseHost}/api/comments/$commentId", data: {'content': content}, options: options);
    
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data']; // Mengembalikan data komentar yang baru
    }
    throw Exception(response.data['message'] ?? 'Gagal mengedit komentar');
  }
}