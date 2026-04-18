import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/aduan/data/aduan_model.dart';
import 'package:sidesa_mobile/features/aduan/views/detail_aduan_view.dart';

class AduanCard extends StatelessWidget {
  final AduanModel aduan;

  const AduanCard({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    // Tentukan Warna Status
    Color statusColor = Colors.grey;
    if (aduan.status == 'menunggu') statusColor = Colors.orange;
    if (aduan.status == 'diproses') statusColor = Colors.blue;
    if (aduan.status == 'selesai') statusColor = Colors.green;
    if (aduan.status == 'ditolak') statusColor = Colors.red;

    return InkWell(
      onTap: () {
        // Arahkan ke halaman Detail saat card di-tap dan bawa data aduannya
        Get.to(() => DetailAduanView(aduan: aduan));
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    aduan.kodeAduan,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      aduan.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                aduan.judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                aduan.deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.category, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    aduan.kategori,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  // Memotong string createdAt untuk mengambil tanggalnya saja (YYYY-MM-DD)
                  Text(
                    aduan.createdAt.substring(0, 10),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
