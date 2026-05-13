import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCommentCard extends StatelessWidget {
  const SkeletonCommentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skeleton Komentar Utama
        _buildSkeletonBody(isReply: false),

        // Skeleton Balasan (Simulasi ada 1 balasan)
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 4, bottom: 8),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 2,
                  color: Colors.grey.shade200, // Warna garis vertikal
                  margin: const EdgeInsets.only(right: 12),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                    child: _buildSkeletonBody(isReply: true),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const Divider(height: 16, thickness: 0.5, color: Colors.black12),
      ],
    );
  }

  // Fungsi pembantu untuk membuat bentuk dasar komentar
  Widget _buildSkeletonBody({required bool isReply}) {
    double avatarSize = isReply ? 28 : 36;
    
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder Avatar
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder Nama & Tanggal
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 14,
                      color: Colors.white,
                    ),
                    const Spacer(),
                    Container(
                      width: 60,
                      height: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Placeholder Teks Komentar (2 baris)
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 20),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 80), // Baris kedua lebih pendek
                ),
                const SizedBox(height: 8),
                
                // Placeholder Tombol Balas
                Container(
                  width: 40,
                  height: 10,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}