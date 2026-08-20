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
    final theme = Theme.of(context); // Ambil referensi tema
    final isDark = theme.brightness == Brightness.dark;

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
            backgroundColor: Colors.green.shade600, // Pertahankan hijau sukses tapi slightly darker
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
                icon: Icon(Icons.edit_rounded, color: theme.colorScheme.primary, size: 20), // Icon dinamis
                label: Text(
                  "Edit Data",
                  style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold), // Teks dinamis
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.primary), // Border dinamis
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
                  // Background dinamis
                  backgroundColor: isDark ? theme.colorScheme.error.withValues(alpha: 0.15) : Colors.red.shade50,
                  // Text dinamis
                  foregroundColor: isDark ? Colors.red.shade300 : Colors.red.shade700,
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