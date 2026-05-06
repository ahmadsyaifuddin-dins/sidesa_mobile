// Lokasi: lib/features/message/views/inbox_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sidesa_mobile/features/message/controllers/inbox_controller.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../../../core/config/api_config.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InboxController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pesan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.CONTACT),
            icon: const Icon(Icons.add_comment_rounded, color: Colors.blue),
            tooltip: 'Kontak Baru',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.inboxList.isEmpty) {
          return _buildSkeletonInbox();
        }

        if (controller.inboxList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text("Belum ada obrolan", style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchInbox,
          color: Colors.blue,
          child: ListView.separated(
            itemCount: controller.inboxList.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final msg = controller.inboxList[index];
              final opponent = controller.getOpponent(msg);
              final isMe = msg.senderId == controller.currentUserId.value;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                onTap: () {
                  Get.toNamed(Routes.CHAT_ROOM, arguments: opponent);
                },
                leading: GestureDetector(
                  onTap: () {
                    if (opponent != null) {
                      Get.toNamed(Routes.USER_PROFILE, arguments: opponent);
                    }
                  },
                  child: ClipOval(
                    child: (opponent?.avatar != null && opponent!.avatar!.isNotEmpty)
                        ? Image.network(
                            opponent.avatar!.startsWith('http') ? opponent.avatar! : "${ApiConfig.baseHost}/${opponent.avatar}",
                            width: 50, height: 50, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _fallbackAvatar(),
                          )
                        : _fallbackAvatar(),
                  ),
                ),
                title: Text(
                  opponent?.name ?? 'Pengguna',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Row(
                  children: [
                    if (isMe) ...[
                      Icon(
                        (msg.status == 'read' || msg.status == 'delivered') ? Icons.done_all : Icons.check,
                        size: 14,
                        color: msg.status == 'read' ? Colors.blue : Colors.grey
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        msg.attachment != null ? "📷 Mengirim foto" : (msg.message ?? ''),
                        style: TextStyle(
                          color: (msg.status != 'read' && !isMe) ? Colors.black87 : Colors.grey.shade600,
                          fontWeight: (msg.status != 'read' && !isMe) ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // --- WIDGET SKELETON INBOX ---
  Widget _buildSkeletonInbox() {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(width: 50, height: 50, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            title: Container(height: 14, width: double.infinity, color: Colors.white, margin: const EdgeInsets.only(bottom: 8, right: 80)),
            subtitle: Container(height: 12, width: double.infinity, color: Colors.white, margin: const EdgeInsets.only(right: 20)),
          ),
        );
      },
    );
  }

  Widget _fallbackAvatar() {
    return Container(width: 50, height: 50, color: Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey));
  }

  String _formatTime(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return '';
    }
  }
}