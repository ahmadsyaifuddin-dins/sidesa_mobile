// Lokasi: lib/features/timeline/widgets/post_card.dart

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool isPinned = post.isPinned;
    final bool isOfficial = post.type == 'pengumuman';
    final bool isMine = post.user?.id == currentUserId;
    final bool isPerangkatDesa = post.user != null &&
        ['pimpinan', 'operator', 'rt', 'admin', 'developer'].contains(post.user!.role.toLowerCase());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Background Dinamis: Jika pengumuman resmi, gunakan warna primer pudar
        color: isOfficial 
            ? (isDark ? theme.colorScheme.primary.withOpacity(0.15) : Colors.blue.shade50) 
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Border Dinamis menyesuaikan status pin/pengumuman dan mode gelap/terang
          color: isPinned 
              ? theme.colorScheme.primary 
              : (isOfficial ? theme.colorScheme.primary.withOpacity(0.5) : theme.colorScheme.outlineVariant),
          width: isPinned ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05), // Shadow Dinamis
            blurRadius: 8, 
            offset: const Offset(0, 2)
          ),
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
          Divider(height: 1, thickness: 1, color: theme.colorScheme.outlineVariant), // Divider Dinamis
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
    final theme = Theme.of(context);
    final postDate = DateTime.parse(post.createdAt).toLocal();
    final difference = DateTime.now().difference(postDate).inMinutes;
    final bool canEdit = difference <= 15;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor, // Background sheet dinamis
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Drag Indicator
            Container(
              width: 40, 
              height: 4, 
              margin: const EdgeInsets.only(bottom: 16), 
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant, // Dinamis
                borderRadius: BorderRadius.circular(10)
              )
            ),
            
            ListTile(
              leading: Icon(
                Icons.edit_rounded, 
                color: canEdit ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withOpacity(0.5)
              ),
              title: Text(
                "Edit Postingan", 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: canEdit ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant.withOpacity(0.5)
                )
              ),
              subtitle: canEdit
                  ? Text("Tersisa ${15 - difference} menit lagi", style: TextStyle(color: theme.colorScheme.onSurfaceVariant))
                  : Text("Waktu edit telah habis (Maks 15 menit)", style: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5), fontSize: 12)),
              onTap: canEdit ? () {
                Get.back();
                onEdit();  
              } : null,
            ),
            
            ListTile(
              leading: Icon(Icons.delete_rounded, color: theme.colorScheme.error), // Merah dinamis
              title: Text("Hapus Postingan", style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.error)),
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