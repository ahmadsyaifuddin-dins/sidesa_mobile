// Lokasi: lib/features/chat/views/widgets/chat_views/chat_bubble_item.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';

class ChatBubbleItem extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubbleItem({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Sedikit dilebarkan (0.85) agar rendering TABEL tidak terlalu sesak
        constraints: BoxConstraints(maxWidth: Get.width * 0.85), 
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: MarkdownBody(
          data: text,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            // 1. Teks Paragraf Biasa
            p: TextStyle(
              color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              fontSize: 14,
              height: 1.5,
            ),
            // 2. Teks Link / Tautan
            a: TextStyle(
              color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            // 3. Teks Tebal (Bold)
            strong: TextStyle(
              color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            // 4. List Bullet (Titik/Angka pada list)
            listBullet: TextStyle(
              color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              fontSize: 14,
            ),
            // 5. Tabel (Merapikan border dan kontras teks dalam kotak tabel)
            tableBorder: TableBorder.all(
              color: isUser 
                  ? Colors.white.withValues(alpha: 0.4) 
                  : theme.colorScheme.outlineVariant,
              width: 1,
            ),
            tableHead: TextStyle(
              color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            tableBody: TextStyle(
              color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
            // 6. Blockquote (Ini yang bikin kotak biru di screenshot-mu!)
            blockquoteDecoration: BoxDecoration(
              // Trik Opacity: Mode Dark jadi biru gelap, Mode Light jadi biru super muda
              color: isUser 
                  ? Colors.white.withValues(alpha: 0.15) 
                  : (isDark ? theme.colorScheme.primary.withValues(alpha: 0.15) : Colors.blue.shade50),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: isUser ? Colors.white : theme.colorScheme.primary,
                  width: 4,
                ),
              ),
            ),
            blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            blockquote: TextStyle(
              // Teks di dalam kotak catatan dipaksa hitam/putih tegas agar tidak silau
              color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              fontStyle: FontStyle.italic,
              fontSize: 13,
              height: 1.5,
            ),
            // 7. Code Block (Jika sewaktu-waktu AI mengirim format kode snippet)
            codeblockDecoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            code: TextStyle(
              color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.error, 
              backgroundColor: Colors.transparent,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
          onTapLink: (text, href, title) async {
            if (href != null) {
              final Uri url = Uri.parse(href);
              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                SnackbarHelper.error(title: "Gagal", message: "Tidak dapat membuka tautan");
              }
            }
          },
        ),
      ),
    );
  }
}