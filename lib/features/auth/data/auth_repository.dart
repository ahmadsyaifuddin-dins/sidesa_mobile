import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/api_config.dart';
import '../../../data/models/user_model.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {'Accept': 'application/json'},
          // Timeout biar gak nunggu selamanya kalau server mati
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        // 1. Ubah JSON jadi Object
        final user = UserModel.fromJson(response.data);
        
        // 2. Simpan Token ke HP (Aman Terenkripsi)
        if (user.token != null) {
          await _storage.write(key: 'auth_token', value: user.token);
          // Simpan nama user juga buat sapaan nanti (opsional)
          await _storage.write(key: 'user_name', value: user.name);
        }

        return user;
      } else {
        throw Exception(response.data['message'] ?? 'Login Gagal');
      }
    } on DioException catch (e) {
      // Handle error koneksi
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Server Error');
      } else {
        throw Exception("Koneksi bermasalah. Cek internet/server.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_name');
  }
}