import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SuratModel {
  final String uuid;
  final String jenisSurat;
  final String status;
  final String createdAt;
  
  // Field Tambahan untuk Detail
  final String? keteranganPemohon;
  final String? keteranganOperator; // Alasan tolak/catatan admin
  final Map<String, dynamic>? dataForm; // Isi form (JSON)
  final String? fileHasil; // Link PDF (jika selesai)

  SuratModel({
    required this.uuid,
    required this.jenisSurat,
    required this.status,
    required this.createdAt,
    this.keteranganPemohon,
    this.keteranganOperator,
    this.dataForm,
    this.fileHasil,
  });

  factory SuratModel.fromJson(Map<String, dynamic> json) {
    return SuratModel(
      uuid: json['uuid'],
      jenisSurat: json['jenis_surat'],
      status: json['status'],
      createdAt: json['created_at'],
      keteranganPemohon: json['keterangan_pemohon'],
      keteranganOperator: json['keterangan_operator'],
      // Pastikan data_form di-parse sebagai Map
      dataForm: json['data_form'] is Map ? Map<String, dynamic>.from(json['data_form']) : null,
      fileHasil: json['file_hasil'],
    );
  }

  String get namaSurat {
    switch (jenisSurat) {
      case 'sku': return 'Surat Keterangan Usaha';
      case 'domisili': return 'Surat Domisili';
      case 'sktm': return 'Surat Ket. Tidak Mampu';
      default: return jenisSurat.toUpperCase();
    }
  }

  String get tanggalFormatted {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('d MMM yyyy, HH:mm').format(date); // Tambah jam biar detail
    } catch (e) {
      return "-";
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'diproses': return Colors.blue;
      case 'selesai': return Colors.green;
      case 'ditolak': return Colors.red;
      default: return Colors.grey;
    }
  }
}