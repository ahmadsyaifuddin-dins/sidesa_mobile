// Lokasi: lib/features/buat_surat/views/forms/form_belum_menikah_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart';
import '../../../../core/utils/snackbar_helper.dart';

class FormBelumMenikahWidget extends StatelessWidget {
  const FormBelumMenikahWidget({super.key});

  // FUNGSI DOWNLOAD TEMPLATE
  Future<void> _downloadTemplate() async {
    final box = Hive.box('settings');
    final String dynamicIP = box.get('server_ip', defaultValue: '192.168.0.28');
    final Uri url = Uri.parse('http://$dynamicIP:8000/template_download/format_pernyataan_belum_menikah.docx');
   
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        SnackbarHelper.error(title: "Gagal", message: "Tidak dapat membuka browser untuk mengunduh.");
      }
    } catch (e) {
      SnackbarHelper.error(title: "Error", message: "Gagal mengunduh file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BANNER INFORMASI (BOX PINK) ---
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.pink.withOpacity(0.1) : Colors.pink[50],
            border: Border.all(color: isDark ? Colors.pink[800]! : Colors.pink[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.favorite_border_rounded, color: isDark ? Colors.pink[400] : Colors.pink[500], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Surat Keterangan Belum Pernah Menikah",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: isDark ? Colors.pink[300] : Colors.pink[900], 
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Surat ini menerangkan status perkawinan Anda saat ini (Jejaka/Perawan) dan belum pernah terikat pernikahan resmi maupun siri.",
                      style: TextStyle(
                        color: isDark ? Colors.pink[100] : Colors.pink[800], 
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

        // --- FORM INPUT ---
        CustomInputField(
          label: "Keperluan Surat",
          hint: "Contoh: Persyaratan pendaftaran TNI/Polri, Persyaratan nikah, dll",
          isTextArea: true,
          initialValue: controller.formData['keperluan']?.toString(),
          onChanged: (val) => controller.updateForm('keperluan', val),
        ),

        const SizedBox(height: 10),
        Text(
          "Berkas Persyaratan", 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Divider(height: 20, color: isDark ? Colors.grey[800] : Colors.grey[300]),

        // --- LAMPIRAN WAJIB UMUM ---
        const CustomFileUpload(
          label: "Scan/Foto KTP",
          fileKey: "ktp",
        ),
        const CustomFileUpload(
          label: "Scan/Foto Kartu Keluarga",
          fileKey: "kk",
        ),

        const SizedBox(height: 10),

        // --- LAMPIRAN KHUSUS + TOMBOL DOWNLOAD ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "Surat Pernyataan Belum Menikah",
                style: TextStyle(
                  fontWeight: FontWeight.w600, 
                  color: isDark ? Colors.grey[300] : Colors.grey[700], 
                  fontSize: 13,
                ),
              ),
            ),
            InkWell(
              onTap: _downloadTemplate,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.download_rounded, size: 14, color: isDark ? Colors.blue[400] : Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text(
                      "Download Format",
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.bold, 
                        color: isDark ? Colors.blue[400] : Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
       
        // Slot Upload
        const CustomFileUpload(
          label: "", // Dikosongkan karena labelnya sudah ditaruh di Row atas
          fileKey: "surat_pernyataan",
        ),
       
        // Warning Teks
        Text.rich(
          TextSpan(
            text: "* Wajib: ",
            style: TextStyle(
              color: isDark ? Colors.pink[400] : Colors.pink[600], 
              fontSize: 11, 
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: "Silakan download format di atas, isi data diri, tempel ",
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600], 
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: "Materai Rp 10.000", 
                style: TextStyle(
                  color: isDark ? Colors.grey[200] : Colors.grey[800], 
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ", tanda tangani, lalu foto/scan dan upload di atas.",
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600], 
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}