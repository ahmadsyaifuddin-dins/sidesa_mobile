// Lokasi: lib/features/surat/views/detail_surat/widgets/tombol_aksi_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import 'package:sidesa_mobile/features/surat/controllers/surat_controller.dart'; 
import '../../../../../data/models/surat_model.dart'; 
import '../../../data/surat_repository.dart'; 

class TombolAksiWidget extends StatelessWidget {
  final SuratModel surat;
  const TombolAksiWidget({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    // --- 1. KONDISI SELESAI (TOMBOL DOWNLOAD) ---
    if (surat.status == 'selesai' && surat.fileHasil != null) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              SnackbarHelper.info(title: "Mengunduh...", message: "Menyimpan ke folder Download...", duration: 2.0);

              final repo = SuratRepository();
              String urlFile = surat.fileHasil!;
              String extension = "docx";

              if (urlFile.endsWith(".pdf")) {
                extension = "pdf";
              } else if (urlFile.endsWith(".doc")) {
                extension = "doc";
              }

              final fileName = "Surat_${surat.jenisSurat}_${surat.uuid.substring(0, 5)}.$extension";
              final path = await repo.downloadFile(urlFile, fileName);

              if (path != null) {
                SnackbarHelper.success(
                  title: "Download Berhasil!",
                  message: "Tersimpan di: Folder Download HP.\nMembuka file...",
                  duration: 4.0,
                );
                await Future.delayed(const Duration(seconds: 1));
                await OpenFile.open(path);
              } else {
                SnackbarHelper.error(title: "Gagal", message: "File tidak dapat disimpan. Cek izin penyimpanan.");
              }
            } catch (e) {
              SnackbarHelper.error(title: "Error", message: "Terjadi kesalahan: $e");
            }
          },
          icon: const Icon(Icons.description_rounded),
          label: const Text("UNDUH DOKUMEN (WORD)", style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }

    // --- 2. KONDISI PENDING (TOMBOL EDIT & BATAL BERSEBELAHAN) ---
    if (surat.status == 'pending') {
      return Row(
        children: [
          // TOMBOL EDIT
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Arahkan ke halaman Buat Surat, tapi bawa data surat lama!
                  // Nanti di controller ditangkap untuk masuk mode Edit
                  Get.toNamed('/buat-surat', arguments: surat);
                },
                icon: Icon(Icons.edit_rounded, color: Colors.blue[700], size: 20),
                label: Text(
                  "Edit Data",
                  style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue[700]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 15),

          // TOMBOL BATALKAN
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  final suratC = Get.find<SuratController>();
                  suratC.batalkanPermohonan(surat.id);
                },
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                label: const Text("Batalkan", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red[700],
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}