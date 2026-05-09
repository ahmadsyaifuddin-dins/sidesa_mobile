// Lokasi: lib/features/surat/views/detail_surat/widgets/alasan_penolakan_widget.dart

import 'package:flutter/material.dart';

class AlasanPenolakanWidget extends StatelessWidget {
  final String alasan;
  const AlasanPenolakanWidget({super.key, required this.alasan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alasan Penolakan:",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 5),
          Text(
            alasan,
            style: TextStyle(color: Colors.red[900]),
          ),
        ],
      ),
    );
  }
}