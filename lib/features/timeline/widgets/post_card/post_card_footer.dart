// Lokasi: lib/features/timeline/widgets/post_card/post_card_footer.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../../../data/models/post_model.dart';

class PostCardFooter extends StatelessWidget {
  final PostModel post;
  final VoidCallback onCommentTap;

  const PostCardFooter({
    super.key,
    required this.post,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 1. Ambil referensi tema

    return Row(
      children: [
        InkWell(
          onTap: onCommentTap,
          child: Row(children: [
            Icon(Icons.chat_bubble_outline, size: 20, color: theme.colorScheme.onSurfaceVariant), // Warna ikon dinamis
            const SizedBox(width: 6),
            Text(
              "${post.commentsCount} Komentar", 
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant, // Warna teks dinamis
                fontWeight: FontWeight.w500,
              )
            )
          ]),
        ),
        const Spacer(),
        if (post.user != null && post.user?.role == 'warga')
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.CHAT_ROOM, arguments: post.user);
            },
            icon: Icon(Icons.send_rounded, size: 20, color: theme.colorScheme.primary), // Warna ikon DM dinamis
            visualDensity: VisualDensity.compact,
            tooltip: "Kirim Pesan Privat",
          )
      ],
    );
  }
}