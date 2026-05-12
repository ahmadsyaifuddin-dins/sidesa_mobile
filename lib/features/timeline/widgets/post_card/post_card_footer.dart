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
    return Row(
      children: [
        InkWell(
          onTap: onCommentTap,
          child: Row(children: [
            Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey.shade600), 
            const SizedBox(width: 6), 
            Text("${post.commentsCount} Komentar", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500))
          ]),
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
    );
  }
}