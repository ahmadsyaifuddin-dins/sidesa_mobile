import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'aduan_model.dart';
import '../../../core/config/api_config.dart'; // Pastikan path ini benar

class AduanRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  
  // --- AMBIL RIWAYAT ADUAN ---
  Future<List<AduanModel>> getRiwayatAduan() async {
    try {
      String? token = await _storage.read(key: 'auth_token'); 
      
      final response = await _dio.get(
        "${ApiConfig.baseUrl}/aduan",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        List data = response.data['data'];
        return data.map((json) => AduanModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception("Gagal mengambil riwayat aduan: $e");
    }
  }

  // --- KIRIM ADUAN BARU ---
  Future<void> buatAduan({
    required String judul,
    required String kategori,
    required String deskripsi,
    required String prioritas,
    required bool isAnonymous,
    File? foto,
  }) async {
    try {
      // PERBAIKAN: Gunakan kunci 'auth_token'
      String? token = await _storage.read(key: 'auth_token'); 
      
      FormData formData = FormData.fromMap({
        "judul": judul,
        "kategori": kategori,
        "deskripsi": deskripsi,
        "prioritas": prioritas,
        "is_anonymous": isAnonymous ? "1" : "0", 
      });

      if (foto != null) {
        formData.files.add(MapEntry(
          "foto",
          await MultipartFile.fromFile(foto.path, filename: foto.path.split('/').last),
        ));
      }

      final response = await _dio.post(
        "${ApiConfig.baseUrl}/aduan",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
         throw Exception(response.data['message'] ?? "Gagal mengirim aduan");
      }
      
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
         throw Exception(e.response?.data['message'] ?? "Terjadi kesalahan server");
      }
      throw Exception("Gagal terhubung ke server");
    }
  }
}