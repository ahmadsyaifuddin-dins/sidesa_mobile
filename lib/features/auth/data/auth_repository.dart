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
        data: {'email': email, 'password': password},
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

  // Tambahkan fungsi ini untuk mengambil raw data profile/fungsi login
  Future<Map<String, dynamic>> getRawProfile() async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null)
        throw Exception("Token tidak ditemukan, silakan login ulang.");

      final response = await _dio.get(
        ApiConfig.user, // Endpoint /me di Laravel
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.data; // Langsung kembalikan JSON mentah
    } catch (e) {
      throw Exception("Gagal memuat detail profil: $e");
    }
  }

  // Fungsi untuk mengirim FCM Token ke Laravel
  Future<void> sendFcmToken(String fcmToken) async {
    try {
      // Ambil token Sanctum (perhatikan key-nya 'auth_token' sesuai kodemu)
      String? token = await _storage.read(key: 'auth_token');

      // Jika tidak ada token (belum login), hentikan proses
      if (token == null) return;

      // Tembak ke API Laravel
      await _dio.post(
        ApiConfig.updateFcm, // Pastikan ini sudah ada di api_config.dart
        data: {'fcm_token': fcmToken},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          // Timeout cepat saja, karena ini proses background
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      print("Berhasil mengirim FCM Token ke server!");
    } catch (e) {
      // Kita print saja, jangan di-throw (throw Exception)
      // agar kalau gagal ngirim token, proses login warga tetap berhasil masuk ke Dashboard.
      print("Gagal kirim token FCM ke server: $e");
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_name');
  }

  // Fungsi Ganti Password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null)
        throw Exception("Sesi telah habis, silakan login ulang.");

      final response = await _dio.post(
        ApiConfig.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
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
}
