// Lokasi: lib/features/surat/data/surat_repository.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/config/api_config.dart';
import '../../../data/models/surat_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SuratRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  // URL API: /api/surat (sesuai route laravel)
  final String _endpoint = "${ApiConfig.baseUrl}/surat";

  // FUNGSI 1: KIRIM SURAT BARU (MULTIPART)
  Future<bool> ajukanSurat({
    required String jenisSurat,
    required String keterangan,
    required Map<String, dynamic> dataForm,
    required List<XFile> lampiranList, 
  }) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      FormData formData = FormData.fromMap({
          "jenis_surat": jenisSurat,
          "keterangan": keterangan,
          "data_form": jsonEncode(dataForm),
      });

      if (lampiranList.isNotEmpty) {
        for (var file in lampiranList) {
          formData.files.add(MapEntry(
            "lampiran[]", 
            await MultipartFile.fromFile(
              file.path,
              filename: "upload_${DateTime.now().millisecondsSinceEpoch}_${file.name}",
            ),
          ));
        }
      }
      
      final response = await _dio.post(
        _endpoint,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          sendTimeout: const Duration(seconds: 60), 
        ),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? "Gagal mengirim surat.");
      }
      throw Exception("Gangguan koneksi ke server SIDESA");
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }

  // --- FUNGSI BARU: EDIT SURAT (MULTIPART POST) ---
  Future<bool> editSurat({
    required int idSurat,
    required String jenisSurat,
    required String keterangan,
    required Map<String, dynamic> dataForm,
    required List<XFile> lampiranBaruList,
    required List<String> fileLamaDipertahankan,
  }) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      
      FormData formData = FormData.fromMap({
          "jenis_surat": jenisSurat,
          "keterangan": keterangan,
          "data_form": jsonEncode(dataForm),
      });

      // 1. Kirim daftar nama file lama yang tidak dihapus oleh user
      // Harus di-loop sebagai MapEntry agar terbaca sebagai array oleh Laravel
      if (fileLamaDipertahankan.isNotEmpty) {
        for (String namaFileLama in fileLamaDipertahankan) {
          formData.fields.add(MapEntry("file_lama_yang_dipertahankan[]", namaFileLama));
        }
      }

      // 2. Tambahkan file fisik yang baru diunggah (jika ada)
      if (lampiranBaruList.isNotEmpty) {
        for (var file in lampiranBaruList) {
          formData.files.add(MapEntry(
            "lampiran[]", 
            await MultipartFile.fromFile(
              file.path,
              filename: "upload_${DateTime.now().millisecondsSinceEpoch}_${file.name}",
            ),
          ));
        }
      }
      
      // Menggunakan POST untuk mengedit data yang berisi file (Sesuai rute Laravel kita)
      final response = await _dio.post(
        "$_endpoint/$idSurat", 
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          sendTimeout: const Duration(seconds: 60), 
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? "Gagal memperbarui surat.");
      }
      throw Exception("Gangguan koneksi ke server SIDESA");
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }

  // FUNGSI 2: AMBIL RIWAYAT (GET)
  Future<List<SuratModel>> getRiwayatSurat() async {
    try {
      String? token = await _storage.read(key: 'auth_token');
     
      final response = await _dio.get(
        _endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        List data = response.data['data'];
        return data.map((json) => SuratModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error ambil surat: $e"); 
      return [];
    }
  }

  // FUNGSI DOWNLOAD FILE
  Future<String?> downloadFile(String url, String fileName) async {
    try {
      String savePath;

      if (Platform.isAndroid) {
        savePath = "/storage/emulated/0/Download/$fileName";
      } else {
        final dir = await getApplicationDocumentsDirectory();
        savePath = "${dir.path}/$fileName";
      }

      await _dio.download(url, savePath);

      return savePath;
    } catch (e) {
      return null;
    }
  }

  // FUNGSI BATALKAN SURAT
  Future<bool> batalkanSurat(int id) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
     
      final response = await _dio.delete(
        "$_endpoint/$id", 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? "Gagal membatalkan surat");
      }
      throw Exception("Gangguan koneksi ke server SIDESA");
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }
}