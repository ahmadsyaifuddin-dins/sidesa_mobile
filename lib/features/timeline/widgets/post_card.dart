import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/post_model.dart';

import 'post_card/post_card_header.dart';
import 'post_card/post_card_content.dart';
import 'post_card/post_card_attachment.dart';
import 'post_card/post_card_footer.dart';

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
    final bool isPinned = post.isPinned;
    final bool isOfficial = post.type == 'pengumuman';
    final bool isMine = post.user?.id == currentUserId;
    final bool isPerangkatDesa = post.user != null && 
        ['pimpinan', 'operator', 'rt', 'admin', 'developer'].contains(post.user!.role.toLowerCase());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOfficial ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPinned ? Colors.blue.shade400 : (isOfficial ? Colors.blue.shade200 : Colors.grey.shade200),
          width: isPinned ? 1.5 : 1, 
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER
          PostCardHeader(
            post: post,
            isOfficial: isOfficial,
            isPinned: isPinned,
            isPerangkatDesa: isPerangkatDesa,
            isMine: isMine,
            onMoreTap: () => _showPostMenu(context),
          ),
          const SizedBox(height: 12),

          // 2. CONTENT TEXT
          PostCardContent(content: post.content),
         
          // 3. ATTACHMENT GAMBAR
          if (post.attachment != null) ...[
            const SizedBox(height: 12),
            PostCardAttachment(attachmentPath: post.attachment!),
          ],
         
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),
         
          // 4. FOOTER AKSI
          PostCardFooter(
            post: post,
            onCommentTap: onCommentTap,
          ),
        ],
      ),
    );
  }

  // --- MENU BOTTOM SHEET (HAPUS/EDIT) ---
  void _showPostMenu(BuildContext context) {
    final postDate = DateTime.parse(post.createdAt).toLocal();
    final difference = DateTime.now().difference(postDate).inMinutes;
    final bool canEdit = difference <= 15; 

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
           
            ListTile(
              leading: Icon(Icons.edit_rounded, color: canEdit ? Colors.blue.shade700 : Colors.grey.shade400),
              title: Text("Edit Postingan", style: TextStyle(fontWeight: FontWeight.bold, color: canEdit ? Colors.black87 : Colors.grey.shade400)),
              subtitle: canEdit
                  ? Text("Tersisa ${15 - difference} menit lagi")
                  : Text("Waktu edit telah habis (Maks 15 menit)", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              onTap: canEdit ? () {
                Get.back(); 
                onEdit();   
              } : null,
            ),
           
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text("Hapus Postingan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                Get.back(); 
                onDelete(); 
              },
            ),
          ],
        ),
      ),
    );
  }
}