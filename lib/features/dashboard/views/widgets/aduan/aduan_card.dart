import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/aduan/data/aduan_model.dart';
import 'package:sidesa_mobile/features/aduan/views/detail_aduan_view.dart';

class AduanCard extends StatelessWidget {
  final AduanModel aduan;
  const AduanCard({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    // 1. Setup Warna Status
    Color statusColor = Colors.grey;
    Color statusBgColor = Colors.grey.shade100;
    
    switch (aduan.status.toLowerCase()) {
      case 'menunggu':
        statusColor = Colors.orange.shade700;
        statusBgColor = Colors.orange.shade50;
        break;
      case 'diproses':
        statusColor = Colors.blue.shade700;
        statusBgColor = Colors.blue.shade50;
        break;
      case 'selesai':
        statusColor = Colors.green.shade700;
        statusBgColor = Colors.green.shade50;
        break;
      case 'ditolak':
        statusColor = Colors.red.shade700;
        statusBgColor = Colors.red.shade50;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigasi ke halaman detail
            Get.to(() => DetailAduanView(aduan: aduan));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BARIS 1: Kategori & Badge Status ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(aduan.kategori),
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          aduan.kategori,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        aduan.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // --- BARIS 2: Judul Aduan ---
                Text(
                  aduan.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // --- BARIS 3: Potongan Deskripsi ---
                Text(
                  aduan.deskripsi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 12),
                
                // --- BARIS 4: Meta Bawah (Tanggal, Prioritas, & Anonim) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          aduan.createdAt.substring(0, 10), // Format YYYY-MM-DD
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 12),
                        
                        // Dot Separator
                        Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle)),
                        
                        const SizedBox(width: 12),
                        Icon(
                          Icons.flag,
                          size: 14,
                          color: _getPriorityColor(aduan.prioritas),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          aduan.prioritas.capitalizeFirst!,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getPriorityColor(aduan.prioritas),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    // Ikon Anonim (Jika dikirim sebagai anonim)
                    if (aduan.isAnonymous == 1)
                      Icon(Icons.visibility_off, size: 16, color: Colors.purple.shade400)
                    else
                      Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER UNTUK IKON KATEGORI ---
  IconData _getCategoryIcon(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'infrastruktur': return Icons.construction;
      case 'keamanan': return Icons.local_police_outlined;
      case 'administrasi': return Icons.folder_copy_outlined;
      case 'kesehatan': return Icons.health_and_safety_outlined;
      case 'sosial': return Icons.people_alt_outlined;
      default: return Icons.report_problem_outlined;
    }
  }

  // --- HELPER UNTUK WARNA PRIORITAS ---
  Color _getPriorityColor(String prioritas) {
    switch (prioritas.toLowerCase()) {
      case 'tinggi': return Colors.red.shade600;
      case 'sedang': return Colors.orange.shade600;
      default: return Colors.green.shade600;
    }
  }
}