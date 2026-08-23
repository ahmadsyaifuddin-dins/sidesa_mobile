import 'package:flutter/material.dart';
import '../../../data/aduan_model.dart';

class DetailMetaWidget extends StatelessWidget {
  final AduanModel aduan;
  const DetailMetaWidget({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          aduan.judul,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, height: 1.3),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _buildChip(context, Icons.calendar_today, aduan.createdAt.substring(0, 10), Colors.grey),
            _buildChip(context, Icons.category, aduan.kategori, Colors.blue),
            _buildChip(
              context,
              Icons.flag, 
              "Prioritas ${aduan.prioritas}", 
              aduan.prioritas == 'tinggi' ? Colors.red : (aduan.prioritas == 'sedang' ? Colors.orange : Colors.green),
            ),
            if (aduan.isAnonymous == 1)
              _buildChip(context, Icons.visibility_off, "Anonim", Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label, MaterialColor color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? color.shade300 : color.shade700;
    final Color bgColor = isDark ? color.shade900.withValues(alpha: 0.35) : color.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}