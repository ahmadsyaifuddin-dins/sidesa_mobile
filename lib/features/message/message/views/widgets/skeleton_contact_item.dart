// Lokasi: lib/features/message/views/widgets/skeleton_contact_item.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonContactItem extends StatelessWidget {
  const SkeletonContactItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      // Warna efek kilap dinamis
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 45, // Disamakan dengan ukuran avatar aslimu
          height: 45,
          decoration: const BoxDecoration(
            color: Colors.white, // Hanya cetakan/masking
            shape: BoxShape.circle,
          ),
        ),
        title: Container(
          height: 14,
          width: double.infinity,
          color: Colors.white, // Hanya cetakan/masking
          margin: const EdgeInsets.only(bottom: 8, right: 100),
        ),
        subtitle: Container(
          height: 12,
          width: double.infinity,
          color: Colors.white, // Hanya cetakan/masking
          margin: const EdgeInsets.only(right: 40),
        ),
      ),
    );
  }
}