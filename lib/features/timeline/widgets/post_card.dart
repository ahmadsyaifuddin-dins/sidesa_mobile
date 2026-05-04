// Lokasi: lib/features/timeline/widgets/post_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../core/config/api_config.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onCommentTap;

  const PostCard({super.key, required this.post, required this.onCommentTap});

  @override
  Widget build(BuildContext context) {
    // Penanda apakah ini pengumuman resmi dari kantor desa
    final bool isOfficial = post.type == 'pengumuman' || post.isPinned;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOfficial ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOfficial ? Colors.blue.shade200 : Colors.grey.shade200,
          width: isOfficial ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER: Avatar & Nama ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: (post.user?.avatar != null && post.user!.avatar!.isNotEmpty)
                    ? Image.network(
                        post.user!.avatar!.startsWith('http')
                            ? post.user!.avatar! // Jika dari Google Login (URL penuh)
                            : "${ApiConfig.baseHost}/${post.user!.avatar}", // Old school URL (tanpa /storage/)
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Jika gambar gagal diload dari server, tampilkan ikon default
                          return Container(
                            width: 40, height: 40, color: Colors.grey.shade200,
                            child: const Icon(Icons.person, color: Colors.grey),
                          );
                        },
                      )
                    : Container(
                        // Jika user memang belum punya foto profil
                        width: 40, height: 40, color: Colors.grey.shade200,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.user?.name ?? 'Warga Desa',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        if (isOfficial) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: Colors.blue, size: 16),
                        ]
                      ],
                    ),
                    Text(
                      _formatDate(post.createdAt), // Helper format waktu
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Badge Pengumuman
              if (isOfficial)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "📌 Pengumuman",
                    style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // --- BODY: Isi Postingan ---
          Text(
            post.content,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),

          // --- ATTACHMENT: Gambar (Jika Ada) ---
          if (post.attachment != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${ApiConfig.baseHost}/${post.attachment}", // Old school URL (tanpa /storage/)
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    Container(height: 150, color: Colors.grey.shade200, child: const Icon(Icons.broken_image)),
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          // --- FOOTER: Tombol Aksi ---
          Row(
            children: [
              InkWell(
                onTap: onCommentTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        "${post.commentsCount} Komentar",
                        style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Tombol DM Langsung ke pembuat postingan (Opsional)
              if (post.user?.role == 'warga')
                IconButton(
                  onPressed: () {
                    // Nanti kita arahkan ke Chat DM Room
                    Get.snackbar("Info", "Fitur DM akan segera disambungkan");
                  },
                  icon: const Icon(Icons.send_rounded, size: 20, color: Colors.blue),
                  visualDensity: VisualDensity.compact,
                  tooltip: "Kirim Pesan Privat",
                )
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi sederhana untuk memformat string tanggal dari Laravel
  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Baru saja';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }
}