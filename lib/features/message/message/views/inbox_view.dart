// Lokasi: lib/features/message/views/inbox_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sidesa_mobile/core/services/activity_logger_service.dart';
import 'package:sidesa_mobile/features/message/controllers/inbox_controller.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../../../core/config/api_config.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InboxController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dinamis
      appBar: AppBar(
        title: Text(
          'Pesan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface, // Dinamis
          ),
        ),
        backgroundColor: Colors.transparent, // Menyatu dengan scaffold
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // 1. Catat aktivitas
              ActivityLoggerService.log('Fitur: Tambah Kontak / Pesan Baru');
              
              // 2. Pindah halaman
              Get.toNamed(Routes.CONTACT);
            },
            icon: Icon(Icons.add_comment_rounded, color: theme.colorScheme.primary), // Dinamis
            tooltip: 'Kontak Baru',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.inboxList.isEmpty) {
          return _buildSkeletonInbox(context); // Lempar context
        }

        if (controller.inboxList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 80,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4), // Dinamis
                ),
                const SizedBox(height: 16),
                Text(
                  "Belum ada obrolan",
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant, // Dinamis
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchInbox,
          color: theme.colorScheme.primary, // Dinamis
          child: ListView.separated(
            itemCount: controller.inboxList.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant, // Dinamis
            ),
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
                            opponent.avatar!.startsWith('http')
                                ? opponent.avatar!
                                : "${ApiConfig.baseHost}/${opponent.avatar}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _fallbackAvatar(context),
                          )
                        : _fallbackAvatar(context), // Lempar context
                  ),
                ),
                title: Text(
                  opponent?.name ?? 'Pengguna',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: theme.colorScheme.onSurface, // Dinamis
                  ),
                ),
                subtitle: Row(
                  children: [
                    if (isMe) ...[
                      Icon(
                        (msg.status == 'read' || msg.status == 'delivered')
                            ? Icons.done_all
                            : Icons.check,
                        size: 14,
                        color: msg.status == 'read'
                            ? theme.colorScheme.primary // Biru
                            : theme.colorScheme.onSurfaceVariant, // Abu-abu
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        msg.attachment != null ? "📷 Mengirim foto" : (msg.message ?? ''),
                        style: TextStyle(
                          // Dinamis: Unread = onSurface (Terang/Gelap solid), Read = onSurfaceVariant (Pudar)
                          color: (msg.status != 'read' && !isMe)
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: (msg.status != 'read' && !isMe)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant, // Dinamis
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // --- WIDGET SKELETON INBOX ---
  Widget _buildSkeletonInbox(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: theme.colorScheme.outlineVariant,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          // Warna dinamis untuk Dark / Light mode
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white, // Hanya cetakan
                shape: BoxShape.circle,
              ),
            ),
            title: Container(
              height: 14,
              width: double.infinity,
              color: Colors.white, // Hanya cetakan
              margin: const EdgeInsets.only(bottom: 8, right: 80),
            ),
            subtitle: Container(
              height: 12,
              width: double.infinity,
              color: Colors.white, // Hanya cetakan
              margin: const EdgeInsets.only(right: 20),
            ),
          ),
        );
      },
    );
  }

  Widget _fallbackAvatar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 50,
      height: 50,
      color: theme.colorScheme.surfaceVariant, // Dinamis
      child: Icon(
        Icons.person,
        color: theme.colorScheme.onSurfaceVariant, // Dinamis
      ),
    );
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