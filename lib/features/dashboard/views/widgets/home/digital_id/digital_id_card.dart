import 'package:flutter/material.dart';

// Import Partials
import 'partials/card_header.dart';
import 'partials/card_user_info.dart';
import 'partials/card_footer_qr.dart';

class DigitalIdCard extends StatelessWidget {
  const DigitalIdCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  Color(0xFF0A1931), // Deep Space Blue
                  Color(0xFF00E5FF), // Neon Cyan (Shine line)
                  Color(0xFF0D47A1), // Royal Blue
                ]
              : [
                  Colors.blue.shade800, // Light mode asli
                  Colors.blue.shade600,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: isDark ? const [0.1, 0.6, 1.0] : null,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          isDark
              ? BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.25), 
                  blurRadius: 25, 
                  spreadRadius: 2,
                  offset: const Offset(0, 10), 
                )
              : BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.4), 
                  blurRadius: 15, 
                  offset: const Offset(0, 8), 
                ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Peta NKRI
            Positioned(
              right: -50,
              bottom: -20,
              child: Opacity(
                opacity: isDark ? 0.25 : 0.15, 
                child: Image.asset(
                  'assets/map_nkri.png',
                  width: 350,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ),
            
            // Susunan Komponen (Modular)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeader(),
                  SizedBox(height: 25),
                  CardUserInfo(),
                  SizedBox(height: 25),
                  CardFooterQr(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}