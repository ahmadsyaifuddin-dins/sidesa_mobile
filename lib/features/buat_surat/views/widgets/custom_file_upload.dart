// Lokasi: lib/features/buat_surat/views/widgets/custom_file_upload.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buat_surat_controller.dart';

class CustomFileUpload extends StatelessWidget {
  final String label;
  final String fileKey; // Contoh: 'ktp', 'kk', 'foto_usaha'

  const CustomFileUpload({
    super.key,
    required this.label,
    required this.fileKey,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 13),
          ),
          const SizedBox(height: 6),
          
          Obx(() {
            bool hasFile = controller.lampiranFiles.containsKey(fileKey);
            String fileName = hasFile ? controller.lampiranFiles[fileKey]!.name : "Belum ada file dipilih";

            return InkWell(
              onTap: () => controller.pickFile(fileKey),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: hasFile ? Colors.green[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: hasFile ? Colors.green : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      hasFile ? Icons.check_circle : Icons.upload_file,
                      color: hasFile ? Colors.green : Colors.grey[400],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: hasFile ? Colors.green[800] : Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (hasFile)
                      GestureDetector(
                        onTap: () => controller.removeFile(fileKey),
                        child: const Icon(Icons.close, color: Colors.red, size: 20),
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
}