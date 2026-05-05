import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/auth/data/auth_repository.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/social_repository.dart';
import '../../../core/services/pusher_service.dart';
import '../../../core/utils/snackbar_helper.dart';

class TimelineController extends GetxController {
  final SocialRepository _repo = SocialRepository();
  final AuthRepository _authRepo = AuthRepository(); // Untuk ambil data user login
  final PusherService _pusher = Get.find<PusherService>(); 
  final ScrollController scrollController = ScrollController();

  var posts = <PostModel>[].obs;
  var isLoading = true.obs;
  var isPaginating = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  
  var currentUserId = 0.obs; 

  @override
  void onInit() {
    super.onInit();
    _fetchCurrentUser();
    fetchPosts();
    setupScrollListener();
    listenToNewPosts();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await _authRepo.getProfile();
      currentUserId.value = user.id;
    } catch (e) {
      print("Gagal mengambil data user login: $e");
    }
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMorePosts();
      }
    });
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasMoreData.value = true;
      
      final data = await _repo.getPosts(page: currentPage);
      final List dynamicList = data['data'];
      
      posts.value = dynamicList.map((e) => PostModel.fromJson(e)).toList();
      
      if (currentPage >= data['last_page']) {
        hasMoreData.value = false;
      }
    } catch (e) {
      SnackbarHelper.error(title: "Oops!", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMorePosts() async {
    if (isPaginating.value || !hasMoreData.value) return;

    try {
      isPaginating.value = true;
      currentPage++;
      final data = await _repo.getPosts(page: currentPage);
      final List dynamicList = data['data'];
      
      if (dynamicList.isEmpty) {
        hasMoreData.value = false;
      } else {
        posts.addAll(dynamicList.map((e) => PostModel.fromJson(e)).toList());
      }
      
      if (currentPage >= data['last_page']) {
        hasMoreData.value = false;
      }
    } catch (e) {
      SnackbarHelper.warning(title: "Perhatian", message: "Gagal memuat data lebih banyak");
    } finally {
      isPaginating.value = false;
    }
  }

  Future<void> refreshTimeline() async {
    await fetchPosts();
  }

  // --- FITUR EDIT POSTINGAN ---
  Future<bool> updatePostData(int postId, String newContent) async {
    try {
      // 1. Tembak API
      await _repo.updatePost(postId, newContent);
      
      // 2. Update UI secara lokal
      int index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        var oldPost = posts[index];
        posts[index] = PostModel(
          id: oldPost.id,
          userId: oldPost.userId,
          type: oldPost.type,
          content: newContent, 
          attachment: oldPost.attachment,
          isPinned: oldPost.isPinned,
          commentsCount: oldPost.commentsCount,
          createdAt: oldPost.createdAt,
          user: oldPost.user,
        );
      }
      return true; // Berikan sinyal BERHASIL
    } catch (e) {
      SnackbarHelper.error(title: "Gagal Edit", message: e.toString());
      return false; // Berikan sinyal GAGAL
    }
  }

  // --- FITUR HAPUS POSTINGAN ---
  Future<void> deletePostData(int postId) async {
    try {
      // 1. Tembak API
      await _repo.deletePost(postId);
      
      // 2. Hapus langsung dari list layar (Smooth UX)
      posts.removeWhere((p) => p.id == postId);
      
      SnackbarHelper.success(title: "Berhasil", message: "Aspirasi telah dihapus permanen.");
    } catch (e) {
      SnackbarHelper.error(title: "Gagal Hapus", message: e.toString());
    }
  }

  void listenToNewPosts() {
    _pusher.subscribeToPrivateChannel(
      channelName: 'timeline',
      eventName: 'post.created',
      onEvent: (data) {
        if (data['post'] != null) {
          final newPost = PostModel.fromJson(data['post']);
          posts.insert(0, newPost);
        }
      }
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    _pusher.unsubscribe('timeline'); 
    super.onClose();
  }
}