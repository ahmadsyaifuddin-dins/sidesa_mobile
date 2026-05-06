// Lokasi: lib/features/timeline/widgets/post_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../../data/models/post_model.dart';
import '../../../core/config/api_config.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final int currentUserId; 
  final VoidCallback onCommentTap;
  final VoidCallback onEdit;   
  final VoidCallback onDelete; 

  const PostCard({
    super.key, 
    required this.post, 
    required this.currentUserId,
    required this.onCommentTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOfficial = post.type == 'pengumuman' || post.isPinned;
    final bool isMine = post.user?.id == currentUserId; 

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
          // --- HEADER: Avatar, Nama, & TOMBOL 3 TITIK ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BUNGKUS FOTO DENGAN GESTURE DETECTOR
              GestureDetector(
                onTap: () {
                  if (post.user != null) {
                    Get.toNamed(Routes.USER_PROFILE, arguments: post.user);
                  }
                },
                child: ClipOval(
                  child: (post.user?.avatar != null && post.user!.avatar!.isNotEmpty)
                      ? Image.network(
                          post.user!.avatar!.startsWith('http')
                              ? post.user!.avatar!
                              : "${ApiConfig.baseHost}/${post.user!.avatar}", 
                          width: 40, height: 40, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(width: 40, height: 40, color: Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey)),
                        )
                      : Container(width: 40, height: 40, color: Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. BUNGKUS NAMA DENGAN GESTURE DETECTOR
                    GestureDetector(
                      onTap: () {
                        if (post.user != null) {
                          Get.toNamed(Routes.USER_PROFILE, arguments: post.user);
                        }
                      },
                      child: Row(
                        children: [
                          Text(post.user?.name ?? 'Warga Desa', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          if (isOfficial) ...[const SizedBox(width: 4), const Icon(Icons.verified, color: Colors.blue, size: 16)]
                        ],
                      ),
                    ),
                    Text(_formatDate(post.createdAt), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
             
              // TOMBOL 3 TITIK (HANYA MUNCUL JIKA POSTINGAN MILIKNYA)
              if (isMine)
                InkWell(
                  onTap: () => _showPostMenu(context),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.more_horiz, color: Colors.grey),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // --- BODY: Isi Postingan ---
          Text(post.content, style: const TextStyle(fontSize: 14, height: 1.4)),
          
          // --- ATTACHMENT: Gambar ---
          if (post.attachment != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _showFullScreenImage(context, "${ApiConfig.baseHost}/${post.attachment}"),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "${ApiConfig.baseHost}/${post.attachment}", 
                  width: double.infinity, fit: BoxFit.cover, 
                  errorBuilder: (context, error, stackTrace) => Container(height: 150, color: Colors.grey.shade200, child: const Icon(Icons.broken_image))
                ),
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
                child: Row(children: [Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey.shade600), const SizedBox(width: 6), Text("${post.commentsCount} Komentar", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500))]),
              ),
              const Spacer(),
              if (post.user != null && post.user?.role == 'warga')
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.CHAT_ROOM, arguments: post.user);
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

  // --- MENU BOTTOM Color.fromARGB(255, 19, 22, 24)KA 15 MENIT) ---
  void _showPostMenu(BuildContext context) {
    final postDate = DateTime.parse(post.createdAt).toLocal();
    final difference = DateTime.now().difference(postDate).inMinutes;
    final bool canEdit = difference <= 15; // Cek apakah masih dalam batas 15 menit

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            
            // TOMBOL EDIT (DISABLED JIKA WAKTU HABIS)
            ListTile(
              leading: Icon(Icons.edit_rounded, color: canEdit ? Colors.blue.shade700 : Colors.grey.shade400),
              title: Text("Edit Postingan", style: TextStyle(fontWeight: FontWeight.bold, color: canEdit ? Colors.black87 : Colors.grey.shade400)),
              subtitle: canEdit 
                  ? Text("Tersisa ${15 - difference} menit lagi") 
                  : Text("Waktu edit telah habis (Maks 15 menit)", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              onTap: canEdit ? () {
                Get.back(); // Tutup menu
                onEdit();   // Panggil fungsi edit
              } : null,
            ),
            
            // TOMBOL HAPUS (SELALU BISA)
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text("Hapus Postingan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                Get.back(); // Tutup menu
                onDelete(); // Panggil fungsi hapus
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Baru saja';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black, // Latar belakang hitam khas galeri
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: Center(
          child: InteractiveViewer(
            panEnabled: true, // Bisa digeser-geser saat di-zoom
            minScale: 0.5,
            maxScale: 4.0, // Batas maksimal zoom
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
      fullscreenDialog: true,
      transition: Transition.fadeIn, // Animasi elegan ala galeri foto
    );
  }
}