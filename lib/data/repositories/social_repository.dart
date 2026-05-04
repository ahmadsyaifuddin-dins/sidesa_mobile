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

  // --- 2. COMMENTS ---
  Future<Map<String, dynamic>> getComments(int postId, {int page = 1}) async {
    try {
      final options = await _getOptions();
      final response = await _dio.get("${ApiConfig.comments(postId)}?page=$page", options: options);
      if (response.statusCode == 200 && response.data['success'] == true) return response.data['data'];
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Gagal memuat komentar');
    }
  }

  Future<CommentModel> createComment(int postId, String content) async {
    try {
      final options = await _getOptions();
      final response = await _dio.post(ApiConfig.comments(postId), data: {'post_id': postId, 'content': content}, options: options);
      if (response.statusCode == 201 && response.data['success'] == true) return CommentModel.fromJson(response.data['data']);
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Gagal mengirim komentar');
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
}