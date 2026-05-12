// Lokasi: lib/features/dashboard/views/widgets/home/history_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/dashboard/views/widgets/home/skeleton_history_item.dart';
import 'package:sidesa_mobile/features/surat/views/detail_surat_view.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../../../data/models/surat_model.dart';
import '../../../../surat/controllers/surat_controller.dart';
import '../../../../../core/utils/string_formatter.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller surat
    final suratC = Get.find<SuratController>();

    return Column(
      children: [
        // Header Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Aktivitas Terkini",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            TextButton(
              onPressed: () {
                // Pindah ke Tab Riwayat (Index 1)
                Get.find<DashboardController>().changeTab(1);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text("Lihat Semua", style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Body List (Obx)
        Obx(() {
          // UBAH BAGIAN INI: Menggunakan Skeleton Loading
          if (suratC.isLoadingHistory.value) {
            return Column(
              // Generate 3 skeleton agar terlihat penuh sambil menunggu data
              children: List.generate(
                3,
                (index) => const SkeletonHistoryItem(),
              ),
            );
          }

          if (suratC.historySurat.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: suratC.historySurat.take(3).map((surat) {
              return _buildHistoryItem(surat);
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: const [
          Icon(Icons.inbox_outlined, color: Colors.grey, size: 40),
          SizedBox(height: 8),
          Text(
            "Belum ada pengajuan surat",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(SuratModel surat) {
    return InkWell(
      onTap: () => Get.to(() => const DetailSuratView(), arguments: surat),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_outlined,
                color: Colors.blue[800],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringFormatter.formatJenisSurat(surat.namaSurat), 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Diajukan ${surat.tanggalFormatted}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: surat.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                surat.status.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: surat.statusColor,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}