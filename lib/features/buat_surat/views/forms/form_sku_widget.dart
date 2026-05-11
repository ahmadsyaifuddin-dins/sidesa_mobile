// Lokasi: lib/features/buat_surat/views/forms/form_sku_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart'; 

class FormSkuWidget extends StatelessWidget {
  const FormSkuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.storefront_rounded, color: Colors.blue[700], size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              "Lengkapi Data Usaha",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const Divider(height: 30),
       
        CustomInputField(
          label: "Nama Usaha",
          hint: "Contoh: Warung Sembako Berkah",
          initialValue: controller.formData['nama_usaha']?.toString(),
          onChanged: (val) => controller.updateForm('nama_usaha', val),
        ),
       
        CustomInputField(
          label: "Jenis Usaha",
          hint: "Contoh: Perdagangan, Jasa, Kuliner",
          initialValue: controller.formData['jenis_usaha']?.toString(),
          onChanged: (val) => controller.updateForm('jenis_usaha', val),
        ),
       
        CustomInputField(
          label: "Alamat Lokasi Usaha",
          hint: "Masukkan alamat lengkap tempat usaha...",
          isTextArea: true,
          initialValue: controller.formData['alamat_usaha']?.toString(),
          onChanged: (val) => controller.updateForm('alamat_usaha', val),
        ),

        const SizedBox(height: 10),
        const Text("Lampiran Wajib", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),

        const CustomFileUpload(
          label: "Foto Tempat Usaha/Produk",
          fileKey: "foto_usaha",
        ),
      ],
    );
  }
}