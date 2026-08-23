// Lokasi: lib/features/message/views/chat_room_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../controllers/chat_room_controller.dart';
import '../../../../core/config/api_config.dart';

class ChatRoomView extends StatelessWidget {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatRoomController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, 
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            Get.toNamed(Routes.USER_PROFILE, arguments: controller.opponent);
          },
          child: Row(
            children: [
              ClipOval(
                child: (controller.opponent.avatar != null && controller.opponent.avatar!.isNotEmpty)
                    ? Image.network(
                        controller.opponent.avatar!.startsWith('http') ? controller.opponent.avatar! : "${ApiConfig.baseHost}/${controller.opponent.avatar}",
                        width: 36, height: 36, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _fallbackAvatar(bg: theme.colorScheme.surfaceContainerHighest),
                      )
                    : _fallbackAvatar(bg: theme.colorScheme.surfaceContainerHighest),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.opponent.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Obx(() {
                      if (controller.isOpponentTyping.value) {
                        final namaPanggilan = controller.opponent.name.split(' ')[0];
                        return Text(
                          "$namaPanggilan sedang mengetik...",
                          style: const TextStyle(fontSize: 11, color: Colors.greenAccent, fontStyle: FontStyle.italic)
                        );
                      }
                      return Text(
                        controller.isOpponentOnline.value ? "Online" : "Offline",
                        style: TextStyle(
                          fontSize: 11,
                          color: controller.isOpponentOnline.value ? Colors.greenAccent : Colors.white70
                        )
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // AREA OBROLAN
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return _buildSkeletonChat(isDark);
              }
              
              if (controller.messages.isEmpty) {
                return Center(child: Text("Mulai obrolan sekarang", style: TextStyle(color: theme.colorScheme.onSurfaceVariant)));
              }
              
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.senderId == controller.currentUserId.value;
                  return _buildChatBubble(theme, msg, isMe, isDark);
                },
              );
            }),
          ),

          // PREVIEW GAMBAR
          Obx(() {
            if (controller.selectedImage.value != null) {
              return Container(
                padding: const EdgeInsets.all(12),
                color: theme.colorScheme.surface,
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(controller.selectedImage.value!, width: 80, height: 80, fit: BoxFit.cover),
                        ),
                        InkWell(
                          onTap: controller.cancelImage,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // AREA INPUT BAWAH
          _buildInputBar(context, controller),
        ],
      ),
    );
  }

  // --- WIDGET SKELETON CHAT BUBBLES ---
  Widget _buildSkeletonChat(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: 6,
      itemBuilder: (context, index) {
        final isMe = index % 2 != 0; // Selang-seling Kiri dan Kanan
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Shimmer.fromColors(
            baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 45,
              width: isMe ? 180 : 220, // Lebar gelembung palsu
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET GELEMBUNG CHAT (ASLI) ---
  Widget _buildChatBubble(ThemeData theme, msg, bool isMe, bool isDark) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          color: isMe
              ? theme.colorScheme.primaryContainer
              : (isDark ? const Color(0xFF2C2C2C) : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
          ),
          boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (msg.attachment != null)
                GestureDetector(
                  onTap: () => _showImageZoom(msg.attachment!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      msg.attachment!.startsWith('http') ? msg.attachment! : "${ApiConfig.baseHost}/${msg.attachment}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (msg.message != null && msg.message!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: msg.attachment != null ? 8 : 4, bottom: 2),
                  child: Text(msg.message!, style: TextStyle(fontSize: 15, color: isMe ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface)),
                ),
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 4, left: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_formatTime(msg.createdAt), style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        msg.status == 'read' ? Icons.done_all : (msg.status == 'delivered' ? Icons.done_all : Icons.check),
                        color: msg.status == 'read' ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                        size: 16,
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET INPUT BAR ---
  Widget _buildInputBar(BuildContext context, ChatRoomController controller) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.image_outlined, color: theme.colorScheme.primary),
              onPressed: controller.pickImage,
            ),
            Expanded(
              child: TextField(
                controller: controller.messageC,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: "Ketik pesan...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => CircleAvatar(
              backgroundColor: controller.isSending.value ? Colors.grey : Colors.blue.shade700,
              child: IconButton(
                icon: controller.isSending.value
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: controller.isSending.value ? null : controller.sendMessage,
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showImageZoom(String imageUrl) {
    Get.to(() => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white, elevation: 0),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            imageUrl.startsWith('http') ? imageUrl : "${ApiConfig.baseHost}/$imageUrl",
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ));
  }

  Widget _fallbackAvatar({Color? bg}) {
    return Container(width: 36, height: 36, color: bg ?? Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey, size: 20));
  }

  String _formatTime(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) { return ''; }
  }
}