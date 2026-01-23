import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/api_config.dart';
import '../../../data/models/surat_model.dart';

class SuratRepository {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  // URL API: /api/surat (sesuai route laravel)
  final String _endpoint = "${ApiConfig.baseUrl}/surat";

  Future<bool> ajukanSurat({
    required String jenisSurat,
    required String keterangan,
    required Map<String, dynamic> dataForm,
  }) async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      
      final response = await _dio.post(
        _endpoint,
        data: {
          "jenis_surat": jenisSurat,
          "keterangan": keterangan,
          "data_form": dataForm, // Data spesifik (Nama Usaha, dll)
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal mengirim surat: $e");
    }
  }

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
        List data = response.data['data'];
        return data.map((json) => SuratModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Return list kosong kalau error, atau lempar exception
      print("Error ambil surat: $e");
      return [];
    }
  }
}