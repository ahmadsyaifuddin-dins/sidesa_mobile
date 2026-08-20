import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonChatBubble extends StatelessWidget {
  final bool isUser;
  const SkeletonChatBubble({super.key, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: Get.width * 0.5,
        height: 45,
        decoration: BoxDecoration(
          // Warna dasar skeleton: Primary pudar untuk user, Card untuk AI
          color: isUser 
              ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1) 
              : theme.cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // Efek Shimmer (Kilap) menyesuaikan tema
        child: Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Hanya sebagai cetakan/masking
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}