import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/aduan/data/aduan_model.dart';
import 'package:sidesa_mobile/features/aduan/views/detail_aduan_view.dart';

class AduanCard extends StatelessWidget {
  final AduanModel aduan;
  const AduanCard({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 1. Setup Warna Status Dinamis
    Color statusColor = Colors.grey;
    Color statusBgColor = Colors.grey.shade100;
    
    switch (aduan.status.toLowerCase()) {
      case 'menunggu':
        statusColor = isDark ? Colors.orange.shade400 : Colors.orange.shade700;
        statusBgColor = isDark ? Colors.orange.withOpacity(0.15) : Colors.orange.shade50;
        break;
      case 'diproses':
        statusColor = isDark ? Colors.blue.shade400 : Colors.blue.shade700;
        statusBgColor = isDark ? Colors.blue.withOpacity(0.15) : Colors.blue.shade50;
        break;
      case 'selesai':
        statusColor = isDark ? Colors.green.shade400 : Colors.green.shade700;
        statusBgColor = isDark ? Colors.green.withOpacity(0.15) : Colors.green.shade50;
        break;
      case 'ditolak':
        statusColor = isDark ? Colors.red.shade400 : Colors.red.shade700;
        statusBgColor = isDark ? Colors.red.withOpacity(0.15) : Colors.red.shade50;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor, // Background dinamis
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04), // Shadow dinamis
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.colorScheme.outlineVariant), // Border dinamis
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
                            color: isDark ? theme.colorScheme.primary.withOpacity(0.15) : Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(aduan.kategori),
                            size: 16,
                            color: theme.colorScheme.primary, // Icon kategori dinamis
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          aduan.kategori,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? theme.colorScheme.primary : Colors.blue.shade800, // Warna kategori
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: theme.colorScheme.onSurface, // Teks judul dinamis
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
                    color: theme.colorScheme.onSurfaceVariant, // Teks deskripsi dinamis
                  ),
                ),
                
                const SizedBox(height: 16),
                Divider(color: theme.colorScheme.outlineVariant, height: 1), // Divider dinamis
                const SizedBox(height: 12),
                
                // --- BARIS 4: Meta Bawah (Tanggal, Prioritas, & Anonim) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          aduan.createdAt.substring(0, 10), // Format YYYY-MM-DD
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(width: 12),
                        
                        // Dot Separator
                        Container(
                          width: 4, 
                          height: 4, 
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5), 
                            shape: BoxShape.circle
                          )
                        ),
                        
                        const SizedBox(width: 12),
                        Icon(
                          Icons.flag,
                          size: 14,
                          color: _getPriorityColor(aduan.prioritas, isDark),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          aduan.prioritas.capitalizeFirst!,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getPriorityColor(aduan.prioritas, isDark),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    // Ikon Anonim (Jika dikirim sebagai anonim)
                    if (aduan.isAnonymous == 1)
                      Icon(Icons.visibility_off, size: 16, color: isDark ? Colors.purple.shade300 : Colors.purple.shade400)
                    else
                      Icon(Icons.chevron_right, size: 20, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
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
  Color _getPriorityColor(String prioritas, bool isDark) {
    switch (prioritas.toLowerCase()) {
      case 'tinggi': return isDark ? Colors.red.shade400 : Colors.red.shade600;
      case 'sedang': return isDark ? Colors.orange.shade400 : Colors.orange.shade600;
      default: return isDark ? Colors.green.shade400 : Colors.green.shade600;
    }
  }
}