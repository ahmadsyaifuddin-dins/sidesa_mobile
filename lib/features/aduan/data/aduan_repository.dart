// Lokasi: lib/features/aduan/data/aduan_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'aduan_model.dart';
import '../../../core/config/api_config.dart';

class AduanRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  
  // AMBIL RIWAYAT ADUAN
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

  // KIRIM ADUAN BARU
  Future<void> buatAduan({
    required String judul,
    required String kategori,
    required String deskripsi,
    required String prioritas,
    required bool isAnonymous,
    File? foto,
  }) async {
    try {
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

  // UPDATE ADUAN
  Future<void> updateAduan({
    required int id,
    required String judul,
    required String kategori,
    required String deskripsi,
    required String prioritas,
    required bool isAnonymous,
    File? fotoBaru, // Hanya dikirim jika user mengganti fotonya
  }) async {
    try {
      String? token = await _storage.read(key: 'auth_token'); 
      
      FormData formData = FormData.fromMap({
        "judul": judul,
        "kategori": kategori,
        "deskripsi": deskripsi,
        "prioritas": prioritas,
        "is_anonymous": isAnonymous ? "1" : "0", 
      });

      if (fotoBaru != null) {
        formData.files.add(MapEntry(
          "foto", await MultipartFile.fromFile(fotoBaru.path, filename: fotoBaru.path.split('/').last),
        ));
      }

      // Menggunakan POST karena Form Data dengan File di Laravel lebih stabil dengan method POST
      final response = await _dio.post(
        "${ApiConfig.baseUrl}/aduan/$id",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) throw Exception("Gagal update aduan");
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Terjadi kesalahan server");
    }
  }

  // HAPUS ADUAN
  Future<void> hapusAduan(int aduanId) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      
      final response = await _dio.delete(
        "${ApiConfig.baseUrl}/aduan/$aduanId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? "Gagal menghapus aduan");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Koneksi bermasalah");
    }
  }
}