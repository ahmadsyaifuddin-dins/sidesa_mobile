// Lokasi: lib/features/timeline/widgets/comment_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../../data/models/comment_model.dart';
import '../../../core/config/api_config.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final int currentUserId;
  final Function(CommentModel) onReply;
  final Function(int commentId, {int? parentId}) onDelete;
  final Function(CommentModel, {int? parentId}) onEdit;

  const CommentCard({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.onReply,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. KOMENTAR UTAMA
        _buildCommentBody(context, comment, isReply: false),

        // 2. BALASAN (NESTED REPLIES)
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 4, bottom: 8),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(width: 2, color: Colors.grey.shade300, margin: const EdgeInsets.only(right: 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: comment.replies.map((reply) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                          child: _buildCommentBody(context, reply, isReply: true, parentId: comment.id),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        const Divider(height: 16, thickness: 0.5, color: Colors.black12),
      ],
    );
  }

  Widget _buildCommentBody(BuildContext context, CommentModel item, {required bool isReply, int? parentId}) {
    final bool isMine = item.userId == currentUserId;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (item.user != null) Get.toNamed(Routes.USER_PROFILE, arguments: item.user);
          },
          child: ClipOval(
            child: (item.user?.avatar != null && item.user!.avatar!.isNotEmpty)
                ? Image.network(
                    item.user!.avatar!.startsWith('http') ? item.user!.avatar! : "${ApiConfig.baseHost}/${item.user!.avatar}",
                    width: isReply ? 28 : 36, height: isReply ? 28 : 36, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _fallbackAvatar(isReply),
                  )
                : _fallbackAvatar(isReply),
          ),
        ),
        const SizedBox(width: 10),
       
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    // 👇 BUNGKUS JUGA NAMANYA DENGAN GESTURE
                    child: GestureDetector(
                      onTap: () {
                        if (item.user != null) Get.toNamed(Routes.USER_PROFILE, arguments: item.user);
                      },
                      child: Row(
                        children: [
                          Text(item.user?.name ?? 'Warga Desa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isReply ? 13 : 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (item.user?.role == 'admin') ...[const SizedBox(width: 4), const Icon(Icons.verified, color: Colors.blue, size: 14)],
                        ],
                      ),
                    ),
                  ),
                  Text(_formatDate(item.createdAt), style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                 
                  if (isMine) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _showCommentMenu(context, item, parentId),
                      child: const Icon(Icons.more_horiz, size: 16, color: Colors.grey),
                    )
                  ]
                ],
              ),
              const SizedBox(height: 4),
             
              Text(item.content, style: TextStyle(fontSize: isReply ? 13 : 14, height: 1.3)),
              const SizedBox(height: 6),
             
              InkWell(
                onTap: () => onReply(item),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4, right: 16),
                  child: Text("Balas", style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- MENU BOTTOM SHEET UNTUK KOMENTAR (LOGIKA 15 MENIT) ---
  void _showCommentMenu(BuildContext context, CommentModel item, int? parentId) {
    final postDate = DateTime.parse(item.createdAt).toLocal();
    final difference = DateTime.now().difference(postDate).inMinutes;
    final bool canEdit = difference <= 15;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            ListTile(
              leading: Icon(Icons.edit_rounded, color: canEdit ? Colors.blue.shade700 : Colors.grey.shade400),
              title: Text("Edit Komentar", style: TextStyle(fontWeight: FontWeight.bold, color: canEdit ? Colors.black87 : Colors.grey.shade400)),
              subtitle: canEdit ? Text("Tersisa ${15 - difference} menit lagi") : Text("Waktu edit telah habis", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              onTap: canEdit ? () {
                Get.back();
                onEdit(item, parentId: parentId);
              } : null,
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text("Hapus Komentar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                Get.back();
                onDelete(item.id, parentId: parentId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackAvatar(bool isReply) {
    double size = isReply ? 28 : 36;
    return Container(width: size, height: size, color: Colors.grey.shade200, child: Icon(Icons.person, color: Colors.grey, size: size * 0.7));
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) { return ''; }
  }
}