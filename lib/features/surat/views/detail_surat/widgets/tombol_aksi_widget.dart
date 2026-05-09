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
    if (surat.status == 'selesai' && surat.fileHasil != null) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              SnackbarHelper.info(
                title: "Mengunduh...",
                message: "Menyimpan ke folder Download...",
                duration: 2.0,
              );

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
                SnackbarHelper.error(
                  title: "Gagal",
                  message: "File tidak dapat disimpan. Cek izin penyimpanan.",
                );
              }
            } catch (e) {
              SnackbarHelper.error(
                title: "Error",
                message: "Terjadi kesalahan: $e",
              );
            }
          },
          icon: const Icon(Icons.description_rounded),
          label: const Text("UNDUH DOKUMEN (WORD)"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      );
    }

    if (surat.status == 'pending') {
      if (surat.status == 'pending') {
      return Center(
        child: TextButton(
          onPressed: () {
            // Panggil Controller menggunakan Get.find
            final suratC = Get.find<SuratController>();
            // Eksekusi fungsi pembatalan dengan mengirimkan ID Surat
            suratC.batalkanPermohonan(surat.id!);
          },
          child: const Text(
            "Batalkan Permohonan",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    }

    return const SizedBox.shrink();
  }
}