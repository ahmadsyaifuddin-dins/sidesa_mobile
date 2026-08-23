// Lokasi: lib/features/buat_surat/views/forms/form_sktm_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart';

class FormSktmWidget extends StatelessWidget {
  const FormSktmWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: isDark ? Colors.green.withValues(alpha: 0.15) : Colors.green[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.health_and_safety_rounded, color: isDark ? Colors.green[300] : Colors.green[700], size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              "Data SKTM",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const Divider(height: 30),
       
        CustomInputField(
          label: "Keperluan Surat",
          hint: "Contoh: Persyaratan Beasiswa Sekolah",
          isTextArea: true,
          initialValue: controller.formData['keperluan']?.toString(),
          onChanged: (val) => controller.updateForm('keperluan', val),
        ),
       
        const SizedBox(height: 10),
        const Text("Lampiran Wajib", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),

        const CustomFileUpload(
          label: "Foto Rumah (Depan)",
          fileKey: "foto_rumah_depan",
        ),
        const CustomFileUpload(
          label: "Foto Rumah (Dalam)",
          fileKey: "foto_rumah_dalam",
        ),
        const CustomFileUpload(
          label: "Surat Pernyataan Bermaterai",
          fileKey: "surat_pernyataan",
        ),
        const CustomFileUpload(
          label: "Scan/Foto KTP",
          fileKey: "ktp",
        ),
        const CustomFileUpload(
          label: "Scan/Foto KK",
          fileKey: "kk",
        ),
      ],
    );
  }
}