// Lokasi: lib/features/timeline/views/post_detail_view.dart

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/awesome_dialog_helper.dart';
import '../controllers/comment_controller.dart';
import '../widgets/post_card.dart';
import '../widgets/comment_card.dart';
import '../widgets/skeleton_comment_card.dart';

class PostDetailView extends StatelessWidget {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dinamis
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface, // Dinamis
        surfaceTintColor: Colors.transparent, // Hindari tint kusam dari Material 3
        elevation: 0.5,
        shadowColor: theme.shadowColor.withValues(alpha: 0.3), // Bayangan halus
        foregroundColor: theme.colorScheme.onSurface, // Icon back dan Teks otomatis ngikut tema
        title: const Text("Komentar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView(
                  children: [
                    // Tetap tampilkan PostCard aslinya (karena biasanya data post dikirim lewat arguments/sudah ada)
                    PostCard(
                      post: controller.post,
                      currentUserId: controller.currentUserId.value,
                      onCommentTap: () {},
                      onEdit: () {},
                      onDelete: () {},
                    ),
                    Divider(thickness: 4, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)), // Divider dinamis
                    
                    // Tampilkan 4 Skeleton Komentar sebagai pengganti loading muter
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: List.generate(4, (index) => const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: SkeletonCommentCard(),
                        )),
                      ),
                    ),
                  ],
                );
              }

              return ListView(
                children: [
                  // 1. HEADER: Postingan Asli
                  PostCard(
                    post: controller.post,
                    currentUserId: controller.currentUserId.value,
                    onCommentTap: () {}, // Kosongkan karena sudah di halaman komentar
                    onEdit: () => Get.snackbar("Info", "Edit postingan dari halaman timeline ya!", 
                      backgroundColor: theme.colorScheme.surfaceContainerHighest, 
                      colorText: theme.colorScheme.onSurfaceVariant
                    ),
                    onDelete: () => Get.snackbar("Info", "Hapus postingan dari halaman timeline ya!",
                      backgroundColor: theme.colorScheme.surfaceContainerHighest, 
                      colorText: theme.colorScheme.onSurfaceVariant
                    ),
                  ),
                  
                  Divider(thickness: 4, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)), // Divider tebal dinamis
                  
                  // 2. LIST KOMENTAR
                  if (controller.comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text("Jadilah yang pertama berkomentar!", style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: controller.comments.map((comment) {
                          return CommentCard(
                            comment: comment,
                            currentUserId: controller.currentUserId.value,
                            onReply: (cmt) => controller.setReplyTo(cmt), // Memunculkan keyboard
                            
                            // FITUR EDIT KOMENTAR
                            onEdit: (cmt, {parentId}) {
                              TextEditingController editC = TextEditingController(text: cmt.content);
                              
                              if (Get.context != null) {
                                AwesomeDialog(
                                  context: Get.context!,
                                  dialogType: DialogType.info,
                                  animType: AnimType.bottomSlide,
                                  dialogBackgroundColor: theme.cardColor, // Background modal dialog dinamis
                                  title: "Edit Komentar",
                                  titleTextStyle: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                                  body: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: TextField(
                                      controller: editC,
                                      maxLines: 3,
                                      style: TextStyle(color: theme.colorScheme.onSurface), // Teks inputan dinamis
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        contentPadding: const EdgeInsets.all(12),
                                        fillColor: theme.colorScheme.surfaceContainerHighest,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  btnCancelText: "Batal",
                                  btnOkText: "Simpan",
                                  btnOkColor: theme.colorScheme.primary,
                                  btnCancelColor: theme.colorScheme.surfaceContainerHighest,
                                  buttonsTextStyle: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    if (editC.text.trim().isNotEmpty) {
                                      await controller.editCommentData(cmt.id, editC.text.trim(), parentId: parentId);
                                    }
                                  },
                                ).show();
                              }
                            },
                            // FITUR HAPUS KOMENTAR
                            onDelete: (id, {parentId}) {
                              AwesomeDialogHelper.showConfirm(
                                title: "Hapus Komentar",
                                desc: "Yakin ingin menghapus komentar ini secara permanen?",
                                dialogType: DialogType.error,
                                btnOkText: "Hapus",
                                btnCancelText: "Batal",
                                btnOkOnPress: () {
                                  controller.deleteCommentData(id, parentId: parentId);
                                },
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                ],
              );
            }),
          ),

          // BAGIAN BAWAH: Input Komentar
          _buildBottomInputBar(context, controller),
        ],
      ),
    );
  }

  // WIDGET INPUT BAR BAWAH
  Widget _buildBottomInputBar(BuildContext context, CommentController controller) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor, // Background dinamis
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05), 
            blurRadius: 10, 
            offset: const Offset(0, -2)
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INDIKATOR "Membalas @Nama"
            Obx(() {
              if (controller.replyingTo.value != null) {
                return Container(
                  width: double.infinity,
                  color: isDark ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.blue.shade50, // Biru pudar yang soft
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Membalas @${controller.replyingTo.value!.user?.name}",
                          style: TextStyle(
                            color: isDark ? const Color(0xFF81D4FA) : Colors.blue.shade800, // Warna teks kontras
                            fontSize: 12, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: controller.cancelReply,
                        child: Icon(
                          Icons.close, 
                          size: 16, 
                          color: isDark ? const Color(0xFF81D4FA) : Colors.blue
                        ),
                      )
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // KOLOM INPUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.commentC,
                      focusNode: controller.focusNode, // Mengatur keyboard
                      maxLines: 4,
                      minLines: 1,
                      style: TextStyle(color: theme.colorScheme.onSurface), // Warna inputan dinamis
                      decoration: InputDecoration(
                        hintText: "Tulis komentar...",
                        hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest, // Background field abu-abu
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => IconButton(
                    onPressed: controller.isSending.value ? null : () => controller.submitComment(),
                    style: IconButton.styleFrom(
                      backgroundColor: controller.isSending.value 
                          ? theme.colorScheme.surfaceContainerHighest 
                          : theme.colorScheme.primary, // Button Send Biru vs Abu
                      foregroundColor: controller.isSending.value 
                          ? theme.colorScheme.onSurfaceVariant 
                          : theme.colorScheme.onPrimary,
                    ),
                    icon: controller.isSending.value
                        ? SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(
                              strokeWidth: 2, 
                              color: theme.colorScheme.onSurfaceVariant
                            )
                          )
                        : const Icon(Icons.send_rounded, size: 20),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}