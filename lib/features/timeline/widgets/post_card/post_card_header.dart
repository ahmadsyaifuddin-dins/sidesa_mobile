import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../../../data/models/post_model.dart';
import '../../../../core/config/api_config.dart';

class PostCardHeader extends StatelessWidget {
  final PostModel post;
  final bool isOfficial;
  final bool isPinned;
  final bool isPerangkatDesa;
  final bool isMine;
  final VoidCallback onMoreTap;

  const PostCardHeader({
    super.key,
    required this.post,
    required this.isOfficial,
    required this.isPinned,
    required this.isPerangkatDesa,
    required this.isMine,
    required this.onMoreTap,
  });

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Baru saja';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. AVATAR
        GestureDetector(
          onTap: () {
            if (post.user != null) Get.toNamed(Routes.USER_PROFILE, arguments: post.user);
          },
          child: ClipOval(
            child: (post.user?.avatar != null && post.user!.avatar!.isNotEmpty)
                ? Image.network(
                    post.user!.avatar!.startsWith('http') ? post.user!.avatar! : "${ApiConfig.baseHost}/${post.user!.avatar}",
                    width: 40, height: 40, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(width: 40, height: 40, color: Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey)),
                  )
                : Container(width: 40, height: 40, color: Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey)),
          ),
        ),
        const SizedBox(width: 12),
        
        // 2. NAMA, ROLE, TANGGAL
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (post.user != null) Get.toNamed(Routes.USER_PROFILE, arguments: post.user);
                },
                child: Row(
                  children: [
                    Flexible(
                      child: Text(post.user?.name ?? 'Warga Desa', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                    if (isPerangkatDesa) ...[
                      const SizedBox(width: 4), 
                      const Icon(Icons.verified, color: Colors.blue, size: 16)
                    ]
                  ],
                ),
              ),
              Row(
                children: [
                  Text(_formatDate(post.createdAt), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  Text(" • ", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  Text(post.type == 'pengumuman' ? 'Pengumuman' : 'Aspirasi', 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: post.type == 'pengumuman' ? FontWeight.w600 : FontWeight.normal)
                  ),
                ],
              ),
            ],
          ),
        ),
       
        // 3. ICON PIN & MORE
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPinned)
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 2.0),
                child: Icon(Icons.push_pin, color: Colors.blue.shade700, size: 18),
              ),
            if (isMine)
              InkWell(
                onTap: onMoreTap,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.more_horiz, color: Colors.grey),
                ),
              ),
          ],
        ),
      ],
    );
  }
}