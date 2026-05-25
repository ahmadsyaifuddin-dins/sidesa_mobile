// Lokasi: lib/features/buat_surat/views/forms/form_pengantar_ktp_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_dropdown_field.dart';
import '../widgets/custom_file_upload.dart';

class FormPengantarKtpWidget extends StatelessWidget {
  const FormPengantarKtpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();

    // Variabel statis untuk value dropdown agar tidak salah ketik
    const String baru = "Perekaman Baru (Pemula / Usia 17 Th)";
    const String hilang = "Hilang (Cetak Ulang)";
    const String rusak = "Rusak / Patah / Terkelupas";
    const String ubahData = "Perubahan Data (Status/Gelar/Alamat)";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BANNER INFORMASI ---
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border.all(color: Colors.blue[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.badge_rounded, color: Colors.blue[600], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Surat Pengantar KTP Elektronik",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Digunakan untuk pengurusan pencetakan KTP-el di Kecamatan atau Disdukcapil.",
                      style: TextStyle(color: Colors.blue[800], fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- DROPDOWN JENIS PERMOHONAN ---
        CustomDropdownField(
          label: "Jenis Permohonan KTP",
          hint: "-- Pilih Alasan --",
          items: const [baru, hilang, rusak, ubahData],
          // AUTO FILL SAAT EDIT:
          value: controller.formData['jenis_permohonan']?.toString(),
          onChanged: (val) => controller.updateForm('jenis_permohonan', val),
        ),

        // --- SEKSI LAMPIRAN DINAMIS (AJAIB) ---
        // Obx akan memantau perubahan formData dan merender ulang bagian ini saja
        Obx(() {
          String? jenis = controller.formData['jenis_permohonan']?.toString();

          // Jika warga belum memilih alasan dari dropdown, sembunyikan kotak upload
          if (jenis == null || jenis.isEmpty) {
            return const SizedBox.shrink(); 
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text("Berkas Persyaratan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Divider(height: 20),

              // 1. KK WAJIB untuk semua jenis permohonan
              const CustomFileUpload(
                label: "Scan/Foto Kartu Keluarga (Asli/Legalisir)",
                fileKey: "kk",
              ),

              // 2. KONDISI: HILANG
              if (jenis == hilang)
                const CustomFileUpload(
                  label: "Surat Ket. Hilang dari Kepolisian (Polsek)",
                  fileKey: "surat_kehilangan",
                ),

              // 3. KONDISI: RUSAK
              if (jenis == rusak)
                const CustomFileUpload(
                  label: "Foto Fisik KTP Lama yang Rusak",
                  fileKey: "ktp_rusak",
                ),

              // 4. KONDISI: UBAH DATA
              if (jenis == ubahData) ...[
                const CustomFileUpload(
                  label: "Foto KTP Lama",
                  fileKey: "ktp_lama",
                ),
                const CustomFileUpload(
                  label: "Bukti Pendukung (Ijazah/Akta Nikah/dll)",
                  fileKey: "bukti_pendukung",
                ),
              ],

              // 5. KONDISI: BARU
              if (jenis == baru)
                const CustomFileUpload(
                  label: "Scan Akta Kelahiran (Opsional)",
                  fileKey: "akta_kelahiran",
                ),
            ],
          );
        }),
      ],
    );
  }
}