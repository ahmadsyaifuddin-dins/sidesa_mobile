// Lokasi: lib/features/auth/views/widgets/login_header.dart

import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final VoidCallback onLogoLongPress;

  const LoginHeader({super.key, required this.onLogoLongPress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onLongPress: onLogoLongPress,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor, // Background dinamis
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.black.withValues(alpha: 0.2), // Shadow dinamis
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Image.asset(
          // PASTIKAN: Jika logo aslimu warnanya hitam (sehingga tak terlihat di mode gelap), 
          // kamu mungkin perlu menyiapkan logo versi putih, misal 'assets/SIDESA_MOBILE_DARK.png'
          'assets/SIDESA_MOBILE.png', 
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}