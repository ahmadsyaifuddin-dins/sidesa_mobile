import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/awesome_dialog_helper.dart';

import '../controllers/chat_controller.dart';
import 'widgets/skeleton_chat_bubble.dart';

// --- IMPORT MODULES BARU ---
import 'widgets/chat_views/chat_bubble_item.dart';
import 'widgets/chat_views/typing_indicator.dart';
import 'widgets/chat_views/chat_input_area.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              radius: 18,
              child: Icon(Icons.support_agent, color: theme.colorScheme.onPrimary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SiDesa AI",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface),
                ),
                Text(
                  "Asisten Virtual Online",
                  style: TextStyle(fontSize: 11, color: Colors.green.shade600),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        elevation: 1,
        shadowColor: theme.shadowColor.withValues(alpha: 0.2),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            tooltip: "Bersihkan Riwayat",
            onPressed: () {
              AwesomeDialogHelper.showConfirm(
                title: "Hapus Obrolan?",
                desc: "Riwayat chat ini akan dihapus dari layar Anda.",
                dialogType: DialogType.error,
                btnOkText: "Hapus",
                btnCancelText: "Batal",
                btnOkOnPress: () {
                  controller.clearChat();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- AREA LIST PESAN CHAT ---
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHistory.value) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    SkeletonChatBubble(isUser: true),
                    SkeletonChatBubble(isUser: false),
                    SkeletonChatBubble(isUser: true),
                    SkeletonChatBubble(isUser: false),
                  ],
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  // Indikator Typing di urutan paling bawah
                  if (index == controller.messages.length && controller.isTyping.value) {
                    return const TypingIndicator();
                  }

                  final msg = controller.messages[index];
                  return ChatBubbleItem(text: msg.text, isUser: msg.isUser);
                },
              );
            }),
          ),

          // --- AREA INPUT (MODULAR) ---
          const ChatInputArea(),
        ],
      ),
    );
  }
}