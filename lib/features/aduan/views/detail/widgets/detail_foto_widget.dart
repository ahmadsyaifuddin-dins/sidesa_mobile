import 'package:flutter/material.dart';
import '../../../data/aduan_model.dart';

class DetailFotoWidget extends StatelessWidget {
  final AduanModel aduan;
  const DetailFotoWidget({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    if (aduan.fotoUrl == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image_outlined, size: 20, color: Colors.grey[700]),
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
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              aduan.fotoUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[200],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      SizedBox(height: 8),
                      Text("Gagal memuat foto", style: TextStyle(color: Colors.grey)),
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