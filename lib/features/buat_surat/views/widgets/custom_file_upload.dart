// Lokasi: lib/features/buat_surat/views/widgets/custom_file_upload.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buat_surat_controller.dart';

class CustomFileUpload extends StatelessWidget {
  final String label;
  final String fileKey;
  final bool allowDocument;

  const CustomFileUpload({
    super.key,
    required this.label,
    required this.fileKey,
    this.allowDocument = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jika label kosong, jangan render Text (Berguna untuk form Belum Menikah)
          if (label.isNotEmpty) ...[
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 13),
            ),
            const SizedBox(height: 6),
          ],
         
          Obx(() {
            bool hasNewFile = controller.lampiranFiles.containsKey(fileKey);
            bool hasOldUrl = controller.lampiranLamaUrls.containsKey(fileKey);
           
            bool isFileAttached = hasNewFile || hasOldUrl;

            // --- LOGIKA TEKS DINAMIS ---
            String fileName = "";
            if (hasNewFile) {
              fileName = controller.lampiranFiles[fileKey]!.name;
            } else if (hasOldUrl) {
              fileName = "Berkas Lama (Tersimpan)";
            } else {
              // Jika kosong, bedakan teks petunjuknya!
              fileName = allowDocument ? "Pilih Dokumen / Foto" : "Pilih Foto dari Galeri";
            }

            // --- LOGIKA IKON DINAMIS ---
            IconData defaultIcon = allowDocument ? Icons.upload_file_rounded : Icons.add_photo_alternate_rounded;

            return InkWell(
              onTap: () => allowDocument 
                  ? controller.pickDocumentOrImage(fileKey) 
                  : controller.pickFile(fileKey),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: isFileAttached ? Colors.green[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isFileAttached ? Colors.green : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // --- PREVIEW GAMBAR / ICON ---
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _buildPreviewBox(hasNewFile, hasOldUrl, fileKey, controller, defaultIcon),
                      ),
                    ),
                    const SizedBox(width: 12),
                   
                    // --- NAMA FILE ---
                    Expanded(
                      child: Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isFileAttached ? Colors.green[800] : Colors.grey[500],
                          fontSize: 13,
                          fontWeight: isFileAttached ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                   
                    // --- TOMBOL SILANG (X) ---
                    if (isFileAttached)
                      GestureDetector(
                        onTap: () => controller.removeFile(fileKey),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.close, color: Colors.red, size: 20),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- LOGIKA MENGGAMBAR KOTAK PREVIEW KECIL ---
  Widget _buildPreviewBox(bool hasNewFile, bool hasOldUrl, String key, BuatSuratController c, IconData defaultIcon) {
    if (hasNewFile) {
      // 1. Jika file baru (Lokal File Path)
      String path = c.lampiranFiles[key]!.path.toLowerCase();
      if (path.endsWith('.pdf') || path.endsWith('.doc') || path.endsWith('.docx')) {
        return const Icon(Icons.description_rounded, color: Colors.red, size: 24);
      } else {
        return Image.file(File(c.lampiranFiles[key]!.path), fit: BoxFit.cover); // Render gambar lokal
      }
    } else if (hasOldUrl) {
      // 2. Jika file lama (URL dari Server Backend Laravel)
      String url = c.lampiranLamaUrls[key]!.toLowerCase();
      if (url.endsWith('.pdf') || url.endsWith('.doc') || url.endsWith('.docx')) {
        return const Icon(Icons.description_rounded, color: Colors.red, size: 24);
      } else {
        // Render gambar URL
        return Image.network(
          c.lampiranLamaUrls[key]!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey),
        );
      }
    }
    // 3. Jika kosong
    return Icon(defaultIcon, color: Colors.grey[400], size: 22);
  }
}