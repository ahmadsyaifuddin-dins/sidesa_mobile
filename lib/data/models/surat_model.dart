import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; // Tambahkan ini buat jsonDecode

class SuratModel {
  final String uuid;
  final String jenisSurat;
  final String status;
  final String createdAt;
  
  // Field Tambahan
  final String? keteranganPemohon;
  final String? keteranganOperator;
  final Map<String, dynamic>? dataForm;
  final List<String>? fileSyarat; // Tambahan: List Foto
  final String? fileHasil;

  SuratModel({
    required this.uuid,
    required this.jenisSurat,
    required this.status,
    required this.createdAt,
    this.keteranganPemohon,
    this.keteranganOperator,
    this.dataForm,
    this.fileSyarat,
    this.fileHasil,
  });

  factory SuratModel.fromJson(Map<String, dynamic> json) {
    // 1. LOGIC PINTAR: Parsing 'data_form'
    // Cek apakah dia String (JSON Text) atau sudah Map (Object)
    Map<String, dynamic>? parsedDataForm;
    if (json['data_form'] != null) {
      if (json['data_form'] is String) {
        try {
          parsedDataForm = jsonDecode(json['data_form']);
        } catch (_) { parsedDataForm = {}; }
      } else if (json['data_form'] is Map) {
        parsedDataForm = Map<String, dynamic>.from(json['data_form']);
      }
    }

    // 2. LOGIC PINTAR: Parsing 'file_syarat'
    List<String>? parsedFileSyarat;
    if (json['file_syarat'] != null) {
      if (json['file_syarat'] is List) {
        parsedFileSyarat = List<String>.from(json['file_syarat']);
      } else if (json['file_syarat'] is String) {
         try {
           parsedFileSyarat = List<String>.from(jsonDecode(json['file_syarat']));
         } catch (_) {}
      }
    }

    return SuratModel(
      uuid: json['uuid'] ?? '',
      jenisSurat: json['jenis_surat'] ?? '?',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
      keteranganPemohon: json['keterangan_pemohon'],
      keteranganOperator: json['keterangan_operator'],
      
      dataForm: parsedDataForm, // Pakai hasil olahan
      fileSyarat: parsedFileSyarat, // Pakai hasil olahan
      
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
      final localDate = date.toLocal(); 
      return DateFormat('d MMM yyyy, HH:mm').format(localDate);
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