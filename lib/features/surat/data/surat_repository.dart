import 'dart:convert'; // Wajib import ini buat jsonEncode
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/config/api_config.dart';
import '../../../data/models/surat_model.dart';

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
      
      // Gunakan jsonEncode agar formatnya valid JSON: {"key": "value"}
      // Kalau pakai .toString() hasilnya {key: value} -> Laravel Gagal Baca
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
        _endpoint, // URL: /api/surat
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Debugging: Cek isi data di terminal
        // print("Data API: ${response.data}"); 
        
        List data = response.data['data'];
        return data.map((json) => SuratModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Return list kosong kalau error
      print("Error ambil surat: $e");
      return [];
    }
  }
}