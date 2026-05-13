import 'package:flutter/material.dart';
import '../../../data/aduan_model.dart';

class DetailDeskripsiWidget extends StatelessWidget {
  final AduanModel aduan;
  const DetailDeskripsiWidget({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description_outlined, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            const Text(
              "Deskripsi Laporan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          aduan.deskripsi,
          style: TextStyle(fontSize: 14, height: 1.6, color: Colors.grey[800]),
        ),
      ],
    );
  }
}