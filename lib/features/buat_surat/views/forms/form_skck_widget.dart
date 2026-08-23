// Lokasi: lib/features/buat_surat/views/forms/form_skck_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart';

class FormSkckWidget extends StatelessWidget {
  const FormSkckWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BANNER INFORMASI ---
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.amber.withValues(alpha: 0.1) : Colors.amber[50],
            border: Border.all(color: isDark ? Colors.amber[800]! : Colors.amber[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_rounded, color: isDark ? Colors.amber[400] : Colors.amber[600], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Pembuatan Surat Pengantar SKCK",
                      style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.amber[300] : Colors.amber[900], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: "Surat ini digunakan sebagai pengantar dari desa untuk pembuatan ",
                        style: TextStyle(color: isDark ? Colors.amber[200] : Colors.amber[800], fontSize: 12, height: 1.4),
                        children: const [
                          TextSpan(text: "Surat Keterangan Catatan Kepolisian (SKCK) ", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "di "),
                          TextSpan(text: "Polsek atau Polres setempat.", style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- FORM INPUT ---
        CustomInputField(
          label: "Tujuan Instansi",
          hint: "Contoh: KAPOLSEK KEC. ANJIR MUARA",
          initialValue: controller.formData['tujuan_instansi']?.toString(),
          onChanged: (val) => controller.updateForm('tujuan_instansi', val),
        ),

        CustomInputField(
          label: "Keperluan Membuat SKCK",
          hint: "Contoh: Melamar Pekerjaan, Syarat PPPK",
          isTextArea: true,
          initialValue: controller.formData['keperluan']?.toString(),
          onChanged: (val) => controller.updateForm('keperluan', val),
        ),

        const SizedBox(height: 10),
        const Text("Berkas Persyaratan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Divider(height: 20),

        // --- LAMPIRAN WAJIB ---
        const CustomFileUpload(
          label: "Scan/Foto KTP",
          fileKey: "ktp",
        ),
        const CustomFileUpload(
          label: "Scan/Foto Kartu Keluarga",
          fileKey: "kk",
        ),
      ],
    );
  }
}