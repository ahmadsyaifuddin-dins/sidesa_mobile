// Lokasi: lib/features/timeline/views/post_detail_view.dart

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/awesome_dialog_helper.dart';
import '../controllers/comment_controller.dart';
import '../widgets/post_card.dart';
import '../widgets/comment_card.dart';

class PostDetailView extends StatelessWidget {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        title: const Text("Komentar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Column(
        children: [
          // BAGIAN ATAS: Postingan dan Daftar Komentar
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.blue));
              }

              return ListView(
                children: [
                  // 1. HEADER: Postingan Asli
                  PostCard(
                    post: controller.post,
                    currentUserId: controller.currentUserId.value,
                    onCommentTap: () {}, // Kosongkan karena sudah di halaman komentar
                    onEdit: () => Get.snackbar("Info", "Edit postingan dari halaman timeline ya!"),
                    onDelete: () => Get.snackbar("Info", "Hapus postingan dari halaman timeline ya!"),
                  ),
                  
                  const Divider(thickness: 4, color: Color(0xFFF5F5F5)),
                  
                  // 2. LIST KOMENTAR
                  if (controller.comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text("Jadilah yang pertama berkomentar!", style: TextStyle(color: Colors.grey)),
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
                        title: "Edit Komentar",
                        body: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: editC,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(12),
                            ),
                          ),
                        ),
                        btnCancelText: "Batal",
                        btnOkText: "Simpan",
                        btnOkColor: Colors.blue.shade700,
                        btnCancelColor: Colors.grey[600],
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
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
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Membalas @${controller.replyingTo.value!.user?.name}",
                          style: TextStyle(color: Colors.blue.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: controller.cancelReply,
                        child: const Icon(Icons.close, size: 16, color: Colors.blue),
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
                      decoration: InputDecoration(
                        hintText: "Tulis komentar...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: Colors.grey.shade100,
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
                      backgroundColor: controller.isSending.value ? Colors.grey : Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                    icon: controller.isSending.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
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