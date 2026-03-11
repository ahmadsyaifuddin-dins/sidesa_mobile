import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 18,
              child: Icon(Icons.support_agent, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SiDesa AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Asisten Virtual Online", style: TextStyle(fontSize: 11, color: Colors.green)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            tooltip: "Bersihkan Riwayat",
            onPressed: () {
              Get.defaultDialog(
                title: "Hapus Obrolan?",
                middleText: "Riwayat chat ini akan dihapus dari layar Anda.",
                textConfirm: "Hapus",
                textCancel: "Batal",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back();
                  controller.clearChat();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- AREA LIST CHAT ---
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHistory.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  // Indikator Typing di urutan paling bawah
                  if (index == controller.messages.length && controller.isTyping.value) {
                    return _buildTypingIndicator();
                  }

                  final msg = controller.messages[index];
                  return _buildChatBubble(msg.text, msg.isUser);
                },
              );
            }),
          ),

          // --- AREA INPUT PESAN ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
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
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Ketik pesan di sini...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(() => CircleAvatar(
                    radius: 24,
                    backgroundColor: controller.isTyping.value ? Colors.grey : Colors.blue[700],
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: controller.isTyping.value ? null : () => controller.sendMessage(),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget BUBBLE CHAT
  // Widget BUBBLE CHAT (Sudah Support Link Click & Markdown)
  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: Get.width * 0.80), // Sedikit dilebarkan biar teks rapi
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[700] : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
          ],
        ),
        // GANTI Text BIASA MENJADI MarkdownBody
        child: MarkdownBody(
          data: text,
          selectable: true, // Teks bisa di-copy/block oleh warga
          styleSheet: MarkdownStyleSheet(
            // Style teks biasa
            p: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
            // Style teks kalau itu adalah Link URL
            a: TextStyle(
              color: isUser ? Colors.white : Colors.blue[800],
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            // Style untuk teks tebal (**text**)
            strong: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          // AKSI KETIKA LINK DI KLIK
          onTapLink: (text, href, title) async {
            if (href != null) {
              final Uri url = Uri.parse(href);
              try {
                // Buka di browser HP
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                Get.snackbar("Gagal", "Tidak dapat membuka tautan", 
                    backgroundColor: Colors.red[100], colorText: Colors.red[900]);
              }
            }
          },
        ),
      ),
    );
  }

  // Widget TYPING INDICATOR
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
          ],
        ),
        child: const Text("SiDesa AI sedang mengetik...", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 13)),
      ),
    );
  }
}