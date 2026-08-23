// Lokasi: lib/features/buat_surat/views/forms/form_penghasilan_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart';

class FormPenghasilanWidget extends StatelessWidget {
  const FormPenghasilanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BANNER INFORMASI (BOX HIJAU) ---
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.green.withValues(alpha: 0.1) : Colors.green[50],
            border: Border.all(color: isDark ? Colors.green[800]! : Colors.green[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.payments_outlined, color: isDark ? Colors.green[400] : Colors.green[600], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Surat Keterangan Penghasilan",
                      style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.green[300] : Colors.green[900], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: "Surat ini biasanya digunakan untuk persyaratan ",
                        style: TextStyle(color: isDark ? Colors.green[100] : Colors.green[800], fontSize: 12, height: 1.4),
                        children: const [
                          TextSpan(text: "pendaftaran beasiswa, sekolah anak, ", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "atau pengajuan kredit bagi pekerja "),
                          TextSpan(text: "sektor informal/wiraswasta.", style: TextStyle(fontStyle: FontStyle.italic)),
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
          label: "Sumber Penghasilan / Usaha",
          hint: "Contoh: Bertani, Berdagang Sembako, dll",
          initialValue: controller.formData['sumber_penghasilan']?.toString(), 
          onChanged: (val) => controller.updateForm('sumber_penghasilan', val),
        ),

        CustomInputField(
          label: "Rata-rata Penghasilan (Per Bulan)",
          hint: "Contoh: 2500000 (Isi angka saja)",
          keyboardType: TextInputType.number,
          isCurrency: true,
          initialValue: controller.formData['jumlah_penghasilan']?.toString(), 
          suffixIcon: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text("Rp", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey[500] : Colors.grey)),
          ),
          onChanged: (val) => controller.updateForm('jumlah_penghasilan', val),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            "* Isi dengan angka saja tanpa titik/koma.",
            style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[500] : Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),

        CustomInputField(
          label: "Keperluan Pengajuan",
          hint: "Contoh: Persyaratan Beasiswa KIP Kuliah Anak",
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