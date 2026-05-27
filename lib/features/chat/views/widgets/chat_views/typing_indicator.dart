import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import package spinkit-nya

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // 1. Warna Background (Biru Transparan)
          color: theme.colorScheme.primary.withOpacity(isDark ? 0.15 : 0.08),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          // 2. Border Tipis biar lebih stand-out di Dark Mode
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(isDark ? 0.4 : 0.2),
            width: 1,
          ),
        ),
        // Gunakan Row + mainAxisSize.min agar kotaknya membungkus pas sesuai panjang teks
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "SiDesa AI sedang membalas",
              style: TextStyle(
                // 3. Warna teks menggunakan Primary agar kontras dan terbaca jelas
                color: theme.colorScheme.primary,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600, // Sedikit ditebalkan
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            // 4. Animasi Titik Membal dari flutter_spinkit
            SpinKitThreeBounce(
              color: theme.colorScheme.primary,
              size: 15.0, // Ukuran titik disesuaikan dengan besar font
            ),
          ],
        ),
      ),
    );
  }
}