// Lokasi: lib/features/dashboard/views/widgets/home/skeleton_history_item.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonHistoryItem extends StatelessWidget {
  const SkeletonHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor, // Background dinamis
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant), // Border dinamis
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05), // Shadow dinamis
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Shimmer effect menyesuaikan Light / Dark Mode
      child: Shimmer.fromColors(
        // Jika dark mode pakai abu-abu gelap, jika light mode pakai abu-abu terang
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
        child: Row(
          children: [
            // 1. Placeholder Icon (Lingkaran)
            // Warna Colors.white di dalam Shimmer hanya sebagai "cetakan" bentuk, aman tidak diubah
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),

            // 2. Placeholder Text (Judul & Tanggal)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 100, // Lebih pendek untuk mensimulasikan tanggal
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // 3. Placeholder Status Badge
            Container(
              width: 60,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}