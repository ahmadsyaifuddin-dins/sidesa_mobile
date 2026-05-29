// Lokasi: lib/features/buat_surat/views/forms/form_beda_nama_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart';

class FormBedaNamaWidget extends StatelessWidget {
  const FormBedaNamaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BANNER INFORMASI (BOX AMBER) ---
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.amber.withOpacity(0.1) : Colors.amber[50],
            border: Border.all(color: isDark ? Colors.amber[800]! : Colors.amber[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.difference_rounded, color: isDark ? Colors.amber[400] : Colors.amber[600], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Surat Keterangan Beda Nama",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: isDark ? Colors.amber[300] : Colors.amber[900], 
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Surat ini menerangkan bahwa nama yang tercantum pada dua dokumen yang berbeda adalah milik satu orang yang sama.",
                      style: TextStyle(
                        color: isDark ? Colors.amber[100] : Colors.amber[800], 
                        fontSize: 12, 
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- KOTAK DATA DOKUMEN 1 ---
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[50],
            border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DATA PADA DOKUMEN PERTAMA", 
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold, 
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              Divider(height: 20, color: isDark ? Colors.grey[700] : Colors.grey[300]),
              CustomInputField(
                label: "Jenis Dokumen 1",
                hint: "Contoh: KARTU TANDA PENDUDUK (KTP)",
                initialValue: controller.formData['dokumen_satu']?.toString(), // TAMBAHAN
                onChanged: (val) => controller.updateForm('dokumen_satu', val),
              ),
              CustomInputField(
                label: "Nama Tertulis di Dokumen 1",
                hint: "Nama sesuai dokumen di atas",
                initialValue: controller.formData['nama_satu']?.toString(), // TAMBAHAN
                onChanged: (val) => controller.updateForm('nama_satu', val),
              ),
            ],
          ),
        ),

        // --- KOTAK DATA DOKUMEN 2 ---
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[50],
            border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DATA PADA DOKUMEN KEDUA", 
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold, 
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              Divider(height: 20, color: isDark ? Colors.grey[700] : Colors.grey[300]),
              CustomInputField(
                label: "Jenis Dokumen 2",
                hint: "Contoh: IJAZAH SMA / SERTIFIKAT TANAH",
                initialValue: controller.formData['dokumen_dua']?.toString(), // TAMBAHAN
                onChanged: (val) => controller.updateForm('dokumen_dua', val),
              ),
              CustomInputField(
                label: "Nama Tertulis di Dokumen 2",
                hint: "Nama sesuai dokumen di atas",
                initialValue: controller.formData['nama_dua']?.toString(), // TAMBAHAN
                onChanged: (val) => controller.updateForm('nama_dua', val),
              ),
            ],
          ),
        ),

        // --- KEPERLUAN ---
        CustomInputField(
          label: "Keperluan Surat",
          hint: "Contoh: Perbaikan data Perbankan / Revisi Ijazah",
          isTextArea: true,
          initialValue: controller.formData['keperluan']?.toString(), // TAMBAHAN
          onChanged: (val) => controller.updateForm('keperluan', val),
        ),

        const SizedBox(height: 10),
        Text(
          "Berkas Pembuktian", 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Divider(height: 20, color: isDark ? Colors.grey[800] : Colors.grey[300]),

        // --- LAMPIRAN WAJIB ---
        const CustomFileUpload(label: "Scan/Foto KTP Asli", fileKey: "ktp"),
        const CustomFileUpload(label: "Scan/Foto Kartu Keluarga", fileKey: "kk"),
       
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Bukti Beda Nama", 
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.bold, 
              color: isDark ? Colors.amber[400] : Colors.amber[800],
            ),
          ),
        ),
       
        const CustomFileUpload(label: "Foto Dokumen 1 (Yg disebut di atas)", fileKey: "bukti_satu"),
        const CustomFileUpload(label: "Foto Dokumen 2 (Yg disebut di atas)", fileKey: "bukti_dua"),
      ],
    );
  }
}