import 'package:flutter/material.dart';
import '../../../data/aduan_model.dart';

class DetailFotoWidget extends StatelessWidget {
  final AduanModel aduan;
  const DetailFotoWidget({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    if (aduan.fotoUrl == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image_outlined, size: 20, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            const Text(
              "Lampiran Foto",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              aduan.fotoUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: theme.colorScheme.onSurfaceVariant, size: 40),
                      const SizedBox(height: 8),
                      Text("Gagal memuat foto", style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}