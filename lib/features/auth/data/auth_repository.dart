import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/api_config.dart';
import '../../../data/models/user_model.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  // 1. Login
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
        options: Options(
          headers: {'Accept': 'application/json'},
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final user = UserModel.fromJson(response.data);
        if (user.token != null) {
          await _storage.write(key: 'auth_token', value: user.token);
          await _storage.write(key: 'user_name', value: user.name);
          if (user.nik != null) {
            await _storage.write(key: 'user_nik', value: user.nik);
            await _storage.write(key: 'user_email', value: user.email);
          }
        }
        return user;
      } else {
        throw Exception(response.data['message'] ?? 'Login Gagal');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Server Error');
      } else {
        throw Exception("Koneksi bermasalah. Cek internet/server.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 2. Get Profile (Model)
  Future<UserModel> getProfile() async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final response = await _dio.get(
        ApiConfig.user,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // PERBAIKAN: Menyamakan struktur JSON agar cocok dengan UserModel.fromJson
      // Jika API Laravel tidak membungkusnya dengan 'data', kita bungkus secara manual di sini.
      Map<String, dynamic> jsonData = response.data;
      if (!jsonData.containsKey('data')) {
        jsonData = {'data': response.data};
      }

      return UserModel.fromJson(jsonData);
    } catch (e) {
      throw Exception("Gagal memuat profil: $e");
    }
  }

  // 3. Update Profile (No. Telp & Avatar via FormData)
  Future<void> updateProfile({String? noTelp, File? avatar}) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null) throw Exception("Sesi habis, silakan login ulang.");

      Map<String, dynamic> dataMap = {};
      if (noTelp != null && noTelp.isNotEmpty) {
        dataMap['nomor_telepon'] = noTelp;
      }
      if (avatar != null) {
        dataMap['avatar'] = await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        );
      }

      var formData = FormData.fromMap(dataMap);

      final response = await _dio.post(
        ApiConfig.updateProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Gagal update profil');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Koneksi bermasalah');
    }
  }

  // 4. Send FCM Token
  Future<void> sendFcmToken(String fcmToken) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null) return;
      await _dio.post(
        ApiConfig.updateFcm,
        data: {'fcm_token': fcmToken},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print("Gagal kirim FCM: $e");
    }
  }

  // 5. Change Password
  Future<void> changePassword(
    String current,
    String newPass,
    String confirmPass,
  ) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null) throw Exception("Sesi telah habis.");

      final response = await _dio.post(
        ApiConfig.changePassword,
        data: {
          'current_password': current,
          'new_password': newPass,
          'new_password_confirmation': confirmPass,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Gagal mengubah password');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Koneksi bermasalah');
    }
  }

  // 6. Logout
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_name');
  }
}