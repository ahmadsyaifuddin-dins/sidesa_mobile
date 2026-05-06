// Lokasi: lib/features/timeline/controllers/comment_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/auth/data/auth_repository.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/repositories/social_repository.dart';
import '../../../core/utils/snackbar_helper.dart';

class CommentController extends GetxController {
  final SocialRepository _repo = SocialRepository();
  final AuthRepository _authRepo = AuthRepository();
  
  // Data Postingan yang sedang dilihat
  late PostModel post;
  
  var comments = <CommentModel>[].obs;
  var isLoading = true.obs;
  var isSending = false.obs;
  
  // ID user yang sedang login (untuk fitur hapus)
  var currentUserId = 0.obs;

  // Controller untuk Input Text & Keyboard Focus
  final TextEditingController commentC = TextEditingController();
  final FocusNode focusNode = FocusNode();

  // State untuk menampung komentar siapa yang sedang dibalas
  var replyingTo = Rxn<CommentModel>(); 

  @override
  void onInit() {
    super.onInit();
    // Tangkap argumen post dari halaman sebelumnya
    post = Get.arguments as PostModel; 
    _fetchCurrentUser();
    fetchComments();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await _authRepo.getProfile();
      currentUserId.value = user.id;
    } catch (e) {
      print("Gagal mengambil data user");
    }
  }

  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      final data = await _repo.getComments(post.id);
      final List dynamicList = data['data']['data']; // Ambil array datanya
      
      comments.value = dynamicList.map((e) => CommentModel.fromJson(e)).toList();
    } catch (e) {
      SnackbarHelper.error(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk menset status "Sedang Membalas..."
  void setReplyTo(CommentModel comment) {
    replyingTo.value = comment;
    
    // UX MAGIC: Jika kita membalas sebuah balasan, otomatis tambahkan @namawarga di kolom ketik!
    if (comment.parentId != null) {
      commentC.text = "@${comment.user?.name} ";
    } else {
      commentC.clear();
    }
    
    focusNode.requestFocus(); 
  }

  // Fungsi batal membalas
  void cancelReply() {
    replyingTo.value = null;
    focusNode.unfocus(); // Sembunyikan keyboard
  }

  // Fungsi kirim komentar / balasan
  Future<void> submitComment() async {
    if (commentC.text.trim().isEmpty) return;

    try {
      isSending.value = true;
      
      // UX MAGIC 2: Pastikan parentId yang dikirim ke Laravel selalu ID Komentar Utama
      final target = replyingTo.value;
      final parentId = target?.parentId ?? target?.id; 
      
      final newCommentData = await _repo.sendComment(post.id, commentC.text.trim(), parentId: parentId);
      final newComment = CommentModel.fromJson(newCommentData);

      if (parentId != null) {
        int parentIndex = comments.indexWhere((c) => c.id == parentId);
        if (parentIndex != -1) {
          var updatedReplies = List<CommentModel>.from(comments[parentIndex].replies)..add(newComment);
          comments[parentIndex] = CommentModel(
            id: comments[parentIndex].id, postId: comments[parentIndex].postId, userId: comments[parentIndex].userId,
            content: comments[parentIndex].content, createdAt: comments[parentIndex].createdAt, user: comments[parentIndex].user,
            replies: updatedReplies,
          );
        }
      } else {
        comments.add(newComment);
      }

      commentC.clear();
      cancelReply();
      
    } catch (e) {
      SnackbarHelper.error(title: "Gagal Kirim", message: e.toString());
    } finally {
      isSending.value = false;
    }
  }

  // Fungsi mengedit komentar
  Future<void> editCommentData(int commentId, String newContent, {int? parentId}) async {
    if (newContent.isEmpty) return;
    
    try {
      final updatedData = await _repo.updateComment(commentId, newContent);
      final updatedComment = CommentModel.fromJson(updatedData);

      if (parentId != null) {
        // Jika yang diedit adalah sebuah balasan (child)
        int parentIndex = comments.indexWhere((c) => c.id == parentId);
        if (parentIndex != -1) {
          var updatedReplies = List<CommentModel>.from(comments[parentIndex].replies);
          int replyIndex = updatedReplies.indexWhere((r) => r.id == commentId);
          if (replyIndex != -1) {
            updatedReplies[replyIndex] = updatedComment; // Ganti dengan data baru
            
            // Perbarui array utama
            comments[parentIndex] = CommentModel(
              id: comments[parentIndex].id, postId: comments[parentIndex].postId, userId: comments[parentIndex].userId,
              content: comments[parentIndex].content, createdAt: comments[parentIndex].createdAt, user: comments[parentIndex].user,
              replies: updatedReplies, 
            );
          }
        }
      } else {
        // Jika yang diedit adalah komentar utama
        int index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          // Tetap pertahankan replies yang lama
          final oldReplies = comments[index].replies; 
          comments[index] = CommentModel(
            id: updatedComment.id, postId: updatedComment.postId, userId: updatedComment.userId,
            content: updatedComment.content, createdAt: updatedComment.createdAt, user: updatedComment.user,
            replies: oldReplies, 
          );
        }
      }
      SnackbarHelper.success(title: "Berhasil", message: "Komentar diperbarui");
    } catch (e) {
      SnackbarHelper.error(title: "Gagal Edit", message: e.toString());
    }
  }

  Future<void> deleteCommentData(int commentId, {int? parentId}) async {
    try {
      await _repo.deleteComment(commentId);
      
      if (parentId != null) {
        // Jika yang dihapus adalah balasan (child)
        int parentIndex = comments.indexWhere((c) => c.id == parentId);
        if (parentIndex != -1) {
          var updatedReplies = List<CommentModel>.from(comments[parentIndex].replies)
            ..removeWhere((r) => r.id == commentId);
            
          comments[parentIndex] = CommentModel(
            id: comments[parentIndex].id,
            postId: comments[parentIndex].postId,
            userId: comments[parentIndex].userId,
            content: comments[parentIndex].content,
            createdAt: comments[parentIndex].createdAt,
            user: comments[parentIndex].user,
            replies: updatedReplies,
          );
        }
      } else {
        // Jika yang dihapus adalah komentar utama
        comments.removeWhere((c) => c.id == commentId);
      }
      
      SnackbarHelper.success(title: "Terhapus", message: "Komentar telah dihapus.");
    } catch (e) {
      SnackbarHelper.error(title: "Gagal", message: e.toString());
    }
  }

  @override
  void onClose() {
    commentC.dispose();
    focusNode.dispose();
    super.onClose();
  }
}