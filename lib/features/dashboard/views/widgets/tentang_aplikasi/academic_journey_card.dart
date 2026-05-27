import 'package:flutter/material.dart';

class AcademicJourneyCard extends StatelessWidget {
  const AcademicJourneyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Perjalanan Akademik",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Aplikasi SIDESA Mobile ini bukan sekadar platform pelayanan desa, melainkan sebuah jejak perjalanan akademik yang terus berkembang. Berawal dari dedikasi dalam program Praktik Kerja Lapangan (PKL) / Magang di Kantor Desa Anjir Muara Kota Tengah, proyek ini diinkubasi dan terus disempurnakan hingga menjadi karya riset untuk Tugas Akhir (Skripsi). Harapannya, inovasi ini dapat memberikan dampak digitalisasi yang nyata dan berkelanjutan bagi masyarakat.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              // Gunakan onSurface agar warna font otomatis putih/hitam
              color: theme.colorScheme.onSurface, 
            ),
          ),
        ],
      ),
    );
  }
}