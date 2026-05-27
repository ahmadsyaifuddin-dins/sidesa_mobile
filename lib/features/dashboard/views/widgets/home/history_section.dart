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
    // Ambil referensi tema
    final theme = Theme.of(context);

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
                foregroundColor: theme.colorScheme.primary, // Warna efek klik mengikuti tema
              ),
              child: const Text("Lihat Semua", style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Body List (Obx)
        Obx(() {
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
            // Lempar context ke helper Empty State
            return _buildEmptyState(context);
          }

          return Column(
            children: suratC.historySurat.take(3).map((surat) {
              // Lempar context ke helper Item History
              return _buildHistoryItem(context, surat);
            }).toList(),
          );
        }),
      ],
    );
  }

  // --- HELPER 1: EMPTY STATE ---
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant, // Background dinamis
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant), // Border dinamis
      ),
      child: Column(
        // 'const' dihapus karena ada properti warna dinamis di dalam children
        children: [
          Icon(Icons.inbox_outlined, color: theme.colorScheme.onSurfaceVariant, size: 40),
          const SizedBox(height: 8),
          Text(
            "Belum ada pengajuan surat",
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // --- HELPER 2: HISTORY ITEM ---
  Widget _buildHistoryItem(BuildContext context, SuratModel surat) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Get.to(() => const DetailSuratView(), arguments: surat),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor, // Background dinamis card
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05), // Shadow dinamis
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
                // Ikon bulat dengan warna primary transparan
                color: theme.colorScheme.primary.withOpacity(0.1), 
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_outlined,
                color: theme.colorScheme.primary, // Warna ikon
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
                    // Warna subtitle dinamis
                    style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant), 
                  ),
                ],
              ),
            ),
            // Status Tag (Trik Opacity sudah pas diterapkan dari kode aslimu)
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}