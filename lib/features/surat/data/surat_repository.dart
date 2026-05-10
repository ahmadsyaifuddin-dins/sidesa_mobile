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

  // FUNGSI 1: KIRIM SURAT (MULTIPART)
  Future<bool> ajukanSurat({
    required String jenisSurat,
    required String keterangan,
    required Map<String, dynamic> dataForm,
    required List<XFile> lampiranList, // UBAH: Menerima banyak file
  }) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      FormData formData = FormData.fromMap({
          "jenis_surat": jenisSurat,
          "keterangan": keterangan,
          "data_form": jsonEncode(dataForm),
      });

      // UBAH: Looping untuk setiap file yang dipilih warga
      if (lampiranList.isNotEmpty) {
        for (var file in lampiranList) {
          formData.files.add(MapEntry(
            "lampiran[]", // WAJIB pakai [] agar dibaca array oleh Laravel
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
          sendTimeout: const Duration(seconds: 60), // Diperpanjang karena upload banyak file
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
      print("Error ambil surat: $e"); // Print error API umum saja (misal koneksi putus)
      return [];
    }
  }

  Future<String?> downloadFile(String url, String fileName) async {
    try {
      String savePath;

      // 1. TENTUKAN LOKASI PENYIMPANAN
      if (Platform.isAndroid) {
        // Khusus Android: Simpan ke folder "Download" agar muncul di File Manager
        savePath = "/storage/emulated/0/Download/$fileName";
      } else {
        // Fallback untuk iOS (karena iOS tidak punya akses folder bebas)
        final dir = await getApplicationDocumentsDirectory();
        savePath = "${dir.path}/$fileName";
      }

      // 2. EKSEKUSI DOWNLOAD
      // File akan otomatis menimpa jika nama file sama
      await _dio.download(url, savePath);

      return savePath;
    } catch (e) {
      // Jika gagal (misal izin ditolak atau koneksi putus), kembalikan null
      return null;
    }
  }

  Future<bool> batalkanSurat(int id) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      
      final response = await _dio.delete(
        "$_endpoint/$id", // Menembak /api/surat/{id}
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      // Menangkap pesan error dari backend jika status bukan pending
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? "Gagal membatalkan surat");
      }
      throw Exception("Gangguan koneksi ke server SIDESA");
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }
}