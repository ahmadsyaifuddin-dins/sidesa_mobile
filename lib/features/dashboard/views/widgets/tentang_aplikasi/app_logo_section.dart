import 'package:flutter/material.dart';

class AppLogoSection extends StatelessWidget {
  const AppLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: theme.cardColor, // Mengikuti warna Card tema
            shape: BoxShape.circle,
            // Border outline agar terlihat rapi di Dark Mode
            border: Border.all(color: theme.colorScheme.outlineVariant, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/SIDESA_MOBILE.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "SIDESA Mobile",
          // Warna font sengaja dikosongkan agar otomatis mengikuti mode
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Versi 1.0.0",
          style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}