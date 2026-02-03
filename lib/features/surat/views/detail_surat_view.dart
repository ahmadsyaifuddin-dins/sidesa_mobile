import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/surat_model.dart';
import 'package:open_file/open_file.dart';
import '../data/surat_repository.dart';

class DetailSuratView extends StatelessWidget {
  const DetailSuratView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data yang dikirim dari halaman sebelumnya
    final SuratModel surat = Get.arguments as SuratModel;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Detail Permohonan"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                    _getIconStatus(surat.status), 
                    size: 50, 
                    color: surat.statusColor
                  ),
                  const SizedBox(height: 10),
                  Text(
                    surat.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: surat.statusColor
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Diajukan pada ${surat.tanggalFormatted}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Jika DITOLAK, Munculkan Alasannya
            if (surat.status == 'ditolak' && surat.keteranganOperator != null)
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
                    const Text("Alasan Penolakan:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    const SizedBox(height: 5),
                    Text(surat.keteranganOperator!, style: TextStyle(color: Colors.red[900])),
                  ],
                ),
              ),

            const SizedBox(height: 25),

            // 2. Informasi Surat
            const Text("Informasi Surat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  _rowDetail("Jenis Surat", surat.namaSurat),
                  const Divider(height: 20),
                  _rowDetail("Keperluan", surat.keteranganPemohon ?? "-"),
                  
                  // Tampilkan Data Form Dinamis (Nama Usaha, dll)
                  if (surat.dataForm != null) ...[
                    const Divider(height: 20),
                    ...surat.dataForm!.entries.map((entry) {
                      // Ubah key "nama_usaha" jadi "Nama Usaha" biar rapi
                      String label = entry.key.replaceAll('_', ' ').toUpperCase();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _rowDetail(label, entry.value.toString()),
                      );
                    }).toList(),
                  ]
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. Tombol Aksi (Jika Selesai)
            if (surat.status == 'selesai' && surat.fileHasil != null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      Get.snackbar("Mengunduh...", "Menyimpan ke folder Download...", 
                        backgroundColor: Colors.blue[100], duration: const Duration(seconds: 2));
                      
                      final repo = SuratRepository();
                      
                      // 1. Ambil URL & Tentukan Ekstensi (Prioritas DOCX)
                      String urlFile = surat.fileHasil!;
                      String extension = "docx"; // Default Word
                      
                      if (urlFile.endsWith(".pdf")) extension = "pdf";
                      else if (urlFile.endsWith(".doc")) extension = "doc";
                      
                      final fileName = "Surat_${surat.jenisSurat}_${surat.uuid.substring(0,5)}.$extension";

                      // 3. Download
                      final path = await repo.downloadFile(urlFile, fileName);
                      
                      if (path != null) {
                         // SUKSES!
                         Get.snackbar(
                           "Download Berhasil!", 
                           "Tersimpan di: Folder Download HP.\nMembuka file...", 
                           backgroundColor: Colors.green[100],
                           duration: const Duration(seconds: 4),
                           snackPosition: SnackPosition.BOTTOM // Biar kebaca jelas
                         );
                         
                         await Future.delayed(const Duration(seconds: 1));
                         await OpenFile.open(path);
                      } else {
                         Get.snackbar("Gagal", "File tidak dapat disimpan. Cek izin penyimpanan.", backgroundColor: Colors.red[100]);
                      }
                    } catch (e) {
                      Get.snackbar("Error", "Terjadi kesalahan: $e", backgroundColor: Colors.red[100]);
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
              
             // Tombol Batalkan (Jika masih Pending) - Optional
             if (surat.status == 'pending')
               Center(
                 child: TextButton(
                   onPressed: () {
                     Get.snackbar("Info", "Fitur pembatalan belum tersedia");
                   },
                   child: const Text("Batalkan Permohonan", style: TextStyle(color: Colors.red)),
                 ),
               )
          ],
        ),
      ),
    );
  }

  Widget _rowDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
      ],
    );
  }

  IconData _getIconStatus(String status) {
    switch (status) {
      case 'selesai': return Icons.check_circle;
      case 'ditolak': return Icons.cancel;
      case 'diproses': return Icons.sync;
      default: return Icons.hourglass_top;
    }
  }
}