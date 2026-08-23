import 'package:flutter/material.dart';
import '../../../data/aduan_model.dart';

class DetailHeaderWidget extends StatelessWidget {
  final AduanModel aduan;
  const DetailHeaderWidget({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Penentuan Warna Status (diterangkan di dark mode agar kontras)
    Color statusColor = isDark ? Colors.grey.shade400 : Colors.grey;
    if (aduan.status == 'menunggu') statusColor = isDark ? Colors.orange.shade300 : Colors.orange;
    if (aduan.status == 'diproses') statusColor = isDark ? Colors.blue.shade300 : Colors.blue;
    if (aduan.status == 'selesai') statusColor = isDark ? Colors.green.shade300 : Colors.green;
    if (aduan.status == 'ditolak') statusColor = isDark ? Colors.red.shade300 : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.tag, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              aduan.kodeAduan,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            aduan.status.toUpperCase(),
            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}