import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../chat/controllers/chat_controller.dart';

class ChatInputArea extends StatelessWidget {
  const ChatInputArea({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                minLines: 1,
                maxLines: 4,
                // --- 1. SETTING KEYBOARD UNTUK NEWLINE ---
                keyboardType: TextInputType.multiline, 
                textInputAction: TextInputAction.newline,
                // (onSubmitted sengaja dihapus agar tidak terkirim otomatis saat tekan enter di keyboard)
                
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: "Ketik pesan di sini...",
                  hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7)),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            
            // --- DYNAMIC FAB DENGAN HERO MORPHING ---
            SizedBox(
              width: 48,
              height: 48,
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeInBack,
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: controller.isTyping.value
                      // STATE LOADING (Hero Dimatikan)
                      ? FloatingActionButton(
                          heroTag: null, 
                          key: const ValueKey('btn_loading'), 
                          elevation: 0,
                          backgroundColor: theme.colorScheme.surfaceVariant,
                          shape: const CircleBorder(),
                          onPressed: null,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onSurfaceVariant,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      // STATE SEND (Hero Aktif)
                      : FloatingActionButton(
                          heroTag: 'fab_sidesa', // PENANGKAP TERBANG DARI DASHBOARD
                          key: const ValueKey('btn_send'),
                          elevation: 0,
                          backgroundColor: theme.colorScheme.primary,
                          shape: const CircleBorder(),
                          onPressed: () => controller.sendMessage(),
                          child: Icon(
                            Icons.send_rounded,
                            color: theme.colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}