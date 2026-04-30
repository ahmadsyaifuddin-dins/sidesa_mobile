// Lokasi: lib/features/scanner/data/scanner_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/api_config.dart';

class ScannerRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> cekIdentitasWarga(String nik) async {
    try {
      String? token = await _storage.read(key: 'auth_token');

      final response = await _dio.get(
        ApiConfig.cekIdentitas(
          nik,
        ), // Memanggil getter dari ApiConfig yang kita buat tadi
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        return response.data['data']; // Kembalikan array data warga
      } else {
        throw Exception(response.data['message'] ?? "Verifikasi gagal");
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? "Data tidak ditemukan");
      }
      throw Exception("Gagal terhubung ke server");
    }
  }
}
