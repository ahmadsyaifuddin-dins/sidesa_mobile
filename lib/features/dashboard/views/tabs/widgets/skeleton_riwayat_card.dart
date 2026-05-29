// Lokasi: lib/features/dashboard/views/tabs/widgets/skeleton_riwayat_card.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonRiwayatCard extends StatelessWidget {
  const SkeletonRiwayatCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant), // Border dinamis
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05), // Shadow dinamis
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Efek shimmer membungkus layout card
      child: Shimmer.fromColors(
        // Warna shimmer mengikuti mode terang/gelap
        baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor, // Background kotak dinamis
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Placeholder Icon (Kotak membulat)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white, // Sebagai cetakan/masking
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 15),
             
              // 2. Placeholder Text & Badge Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder Judul Surat
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white, // Sebagai cetakan/masking
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Placeholder Tanggal
                    Container(
                      width: 120,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white, // Sebagai cetakan/masking
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Placeholder Badge Status
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white, // Sebagai cetakan/masking
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}