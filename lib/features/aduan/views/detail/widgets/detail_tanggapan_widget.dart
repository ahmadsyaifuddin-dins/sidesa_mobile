import 'package:flutter/material.dart';
import '../../../data/aduan_model.dart';

class DetailTanggapanWidget extends StatelessWidget {
  final AduanModel aduan;
  const DetailTanggapanWidget({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    if (aduan.tanggapan == null || aduan.tanggapan!.isEmpty) {
      return const SizedBox.shrink(); // Hilang total kalau gak ada
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.green.shade900.withValues(alpha: 0.35), const Color(0xFF1E1E1E)]
                : [Colors.green.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.green.shade800.withValues(alpha: 0.5) : Colors.green.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? Colors.green.shade900.withValues(alpha: 0.45) : Colors.green.shade100,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_user_rounded, size: 18, color: isDark ? Colors.green.shade300 : Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text("Tanggapan Petugas", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.green.shade300 : Colors.green.shade800)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                aduan.tanggapan!,
                style: TextStyle(fontSize: 14, height: 1.6, color: theme.colorScheme.onSurface.withValues(alpha: 0.85)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}