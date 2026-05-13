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
            _buildChip(Icons.calendar_today, aduan.createdAt.substring(0, 10), Colors.grey),
            _buildChip(Icons.category, aduan.kategori, Colors.blue),
            _buildChip(
              Icons.flag, 
              "Prioritas ${aduan.prioritas}", 
              aduan.prioritas == 'tinggi' ? Colors.red : (aduan.prioritas == 'sedang' ? Colors.orange : Colors.green),
            ),
            if (aduan.isAnonymous == 1)
              _buildChip(Icons.visibility_off, "Anonim", Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(IconData icon, String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color.shade700),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color.shade700, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}