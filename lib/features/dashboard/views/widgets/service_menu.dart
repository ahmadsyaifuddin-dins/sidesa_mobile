import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/surat/views/buat_surat_view.dart';

class ServiceMenu extends StatelessWidget {
  const ServiceMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Layanan Desa",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildItem(Icons.mail_outline, "Buat Surat", Colors.orange, () {
                Get.to(() => const BuatSuratView());
              }),
              _buildItem(Icons.campaign_outlined, "Laporan", Colors.red, () {}),
              _buildItem(Icons.storefront_outlined, "UMKM", Colors.green, () {}),
              _buildItem(Icons.newspaper_outlined, "Berita", Colors.blue, () {}),
              _buildItem(Icons.map_outlined, "Peta", Colors.purple, () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}