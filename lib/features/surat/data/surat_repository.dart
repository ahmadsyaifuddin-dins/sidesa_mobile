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
    XFile? lampiran, 
  }) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      FormData formData = FormData.fromMap({
          "jenis_surat": jenisSurat,
          "keterangan": keterangan,
          "data_form": jsonEncode(dataForm), 
      });

      // Jika ada file, masukkan ke FormData
      if (lampiran != null) {
        formData.files.add(MapEntry(
          "lampiran", // Key harus sama dengan di Controller Laravel ($request->file('lampiran'))
          await MultipartFile.fromFile(
            lampiran.path, 
            filename: "upload_${DateTime.now().millisecondsSinceEpoch}.jpg" // Nama file unik
          ),
        ));
      }
      
      final response = await _dio.post(
        _endpoint,
        data: formData, // Kirim FormData
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            // 'Content-Type': 'multipart/form-data', // Dio otomatis set ini
          },
          // Tambah timeout biar gak error kalau upload agak lama (misal sinyal lemot)
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal mengirim surat: $e");
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
}