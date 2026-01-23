import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan sudah 'flutter pub add intl'

class SuratModel {
  final String uuid;
  final String jenisSurat;
  final String status;
  final String createdAt;

  SuratModel({
    required this.uuid,
    required this.jenisSurat,
    required this.status,
    required this.createdAt,
  });

  factory SuratModel.fromJson(Map<String, dynamic> json) {
    return SuratModel(
      uuid: json['uuid'],
      jenisSurat: json['jenis_surat'],
      status: json['status'],
      createdAt: json['created_at'], // Laravel format: 2026-01-23T11:36:23.000000Z
    );
  }

  // Helper: Ubah kode 'sku' jadi 'Surat Keterangan Usaha'
  String get namaSurat {
    switch (jenisSurat) {
      case 'sku': return 'Surat Keterangan Usaha';
      case 'domisili': return 'Surat Domisili';
      case 'sktm': return 'Surat Ket. Tidak Mampu';
      default: return jenisSurat.toUpperCase();
    }
  }

  // Helper: Format Tanggal (Contoh: 23 Jan 2026)
  String get tanggalFormatted {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('d MMM yyyy').format(date);
    } catch (e) {
      return "-";
    }
  }

  // Helper: Warna Badge Status
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