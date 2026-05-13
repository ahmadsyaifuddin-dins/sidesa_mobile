import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonContactItem extends StatelessWidget {
  const SkeletonContactItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 45, // Disamakan dengan ukuran avatar aslimu
          height: 45,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        title: Container(
          height: 14,
          width: double.infinity,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 8, right: 100),
        ),
        subtitle: Container(
          height: 12,
          width: double.infinity,
          color: Colors.white,
          margin: const EdgeInsets.only(right: 40),
        ),
      ),
    );
  }
}