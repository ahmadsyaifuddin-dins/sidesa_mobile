// Lokasi: lib/features/surat/views/detail_surat_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart'; // Pastikan path helper ini benar
import '../../../data/models/surat_model.dart';
import '../data/surat_repository.dart';
import '../controllers/surat_controller.dart';

class DetailSuratView extends StatelessWidget {
  const DetailSuratView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Detail Permohonan"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      // BUNGKUS SELURUH BODY DENGAN Obx AGAR REAKTIF
      body: Obx(() {
        // --- LOGIC REAKTIF & DEEP LINKING ---
        SuratModel? currentSurat;
        final suratC = Get.find<SuratController>();

        if (Get.arguments is SuratModel) {
          // 1. Jika dibuka normal dari List Surat, kita tetap cari di memori agar Reaktif
          final SuratModel argSurat = Get.arguments as SuratModel;
          try {
            currentSurat = suratC.historySurat.firstWhere(
              (item) => item.id == argSurat.id,
            );
          } catch (e) {
            currentSurat = argSurat; // Fallback jika tidak ketemu di memori
          }
        } else if (Get.arguments != null) {
          // 2. Jika dibuka via Notifikasi FCM (arguments berupa String ID)
          final String argId = Get.arguments.toString();
          try {
            currentSurat = suratC.historySurat.firstWhere(
              (item) => item.id.toString() == argId,
            );
          } catch (e) {
            currentSurat = null;
          }
        }

        // --- FALLBACK UI JIKA DATA KOSONG ---
        if (currentSurat == null) {
          return const Center(
            child: Text(
              "Data surat tidak ditemukan / sedang memuat...",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // --- RENDER UI UTAMA ---
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Status
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getIconStatus(currentSurat.status),
                      size: 50,
                      color: currentSurat.statusColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentSurat.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: currentSurat.statusColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Diajukan pada ${currentSurat.tanggalFormatted}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Jika DITOLAK, Munculkan Alasannya
              if (currentSurat.status == 'ditolak' &&
                  currentSurat.keteranganOperator != null)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Alasan Penolakan:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        currentSurat.keteranganOperator!,
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 25),

              // 2. Informasi Surat
              const Text(
                "Informasi Surat",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _rowDetail("Jenis Surat", currentSurat.namaSurat),
                    const Divider(height: 20),
                    _rowDetail(
                      "Keperluan",
                      currentSurat.keteranganPemohon ?? "-",
                    ),

                    // Tampilkan Data Form Dinamis
                    if (currentSurat.dataForm != null) ...[
                      const Divider(height: 20),
                      ...currentSurat.dataForm!.entries.map((entry) {
                        String label = entry.key
                            .replaceAll('_', ' ')
                            .toUpperCase();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _rowDetail(label, entry.value.toString()),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. Tombol Aksi (Jika Selesai)
              if (currentSurat.status == 'selesai' &&
                  currentSurat.fileHasil != null)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        // UPDATE: Snackbar Info Download
                        SnackbarHelper.info(
                          title: "Mengunduh...",
                          message: "Menyimpan ke folder Download...",
                          duration: 2.0,
                        );

                        final repo = SuratRepository();

                        String urlFile = currentSurat!.fileHasil!;
                        String extension = "docx";

                        if (urlFile.endsWith(".pdf")) {
                          extension = "pdf";
                        } else if (urlFile.endsWith(".doc")) {
                          extension = "doc";
                        }

                        final fileName =
                            "Surat_${currentSurat!.jenisSurat}_${currentSurat!.uuid.substring(0, 5)}.$extension";

                        final path = await repo.downloadFile(urlFile, fileName);

                        if (path != null) {
                          // UPDATE: Snackbar Berhasil Download
                          SnackbarHelper.success(
                            title: "Download Berhasil!",
                            message: "Tersimpan di: Folder Download HP.\nMembuka file...",
                            duration: 4.0,
                          );

                          await Future.delayed(const Duration(seconds: 1));
                          await OpenFile.open(path);
                        } else {
                          // UPDATE: Snackbar Gagal Simpan File
                          SnackbarHelper.error(
                            title: "Gagal",
                            message: "File tidak dapat disimpan. Cek izin penyimpanan.",
                          );
                        }
                      } catch (e) {
                        // UPDATE: Snackbar Tangkap Error
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
                ),

              // Tombol Batalkan (Jika masih Pending)
              if (currentSurat.status == 'pending')
                Center(
                  child: TextButton(
                    onPressed: () {
                      // UPDATE: Snackbar Info Fitur Belum Tersedia
                      SnackbarHelper.info(
                        title: "Info",
                        message: "Fitur pembatalan belum tersedia",
                      );
                    },
                    child: const Text(
                      "Batalkan Permohonan",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _rowDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }

  IconData _getIconStatus(String status) {
    switch (status) {
      case 'selesai':
        return Icons.check_circle;
      case 'ditolak':
        return Icons.cancel;
      case 'diproses':
        return Icons.sync;
      default:
        return Icons.hourglass_top;
    }
  }
}