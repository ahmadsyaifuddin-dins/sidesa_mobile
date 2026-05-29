// Lokasi: lib/features/surat/views/detail_surat/widgets/alasan_penolakan_widget.dart

import 'package:flutter/material.dart';

class AlasanPenolakanWidget extends StatelessWidget {
  final String alasan;
  const AlasanPenolakanWidget({super.key, required this.alasan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // Background dinamis: Merah transparan (Dark Mode) vs Merah sangat muda (Light Mode)
        color: isDark ? theme.colorScheme.error.withOpacity(0.15) : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        // Border dinamis
        border: Border.all(color: isDark ? theme.colorScheme.error.withOpacity(0.3) : Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Alasan Penolakan:",
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: isDark ? Colors.red.shade300 : Colors.red // Warna judul dinamis
            ),
          ),
          const SizedBox(height: 5),
          Text(
            alasan,
            style: TextStyle(
              color: isDark ? Colors.red.shade100 : Colors.red.shade900 // Teks pesan dinamis agar mudah dibaca di mode gelap
            ),
          ),
        ],
      ),
    );
  }
}