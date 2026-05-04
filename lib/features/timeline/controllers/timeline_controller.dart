import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/social_repository.dart';
import '../../../core/services/pusher_service.dart';
import '../../../core/utils/snackbar_helper.dart'; // Gunakan helper andalan kita

class TimelineController extends GetxController {
  final SocialRepository _repo = SocialRepository();
  // Mengambil instance Pusher yang sudah berjalan di background
  final PusherService _pusher = Get.find<PusherService>(); 
  final ScrollController scrollController = ScrollController();

  var posts = <PostModel>[].obs;
  var isLoading = true.obs;
  var isPaginating = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    setupScrollListener();
    listenToNewPosts();
  }

  // Mendengarkan saat user men-scroll ke paling bawah
  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMorePosts();
      }
    });
  }

  // Memuat data pertama kali
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

  // Memuat halaman selanjutnya (Infinite Scroll)
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

  // Pull to refresh
  Future<void> refreshTimeline() async {
    await fetchPosts();
  }

  // TELINGA WEBSOCKET: Menangkap postingan baru secara Real-time
  void listenToNewPosts() {
    _pusher.subscribeToPrivateChannel(
      channelName: 'timeline',
      eventName: 'post.created',
      onEvent: (data) {
        if (data['post'] != null) {
          final newPost = PostModel.fromJson(data['post']);
          // Menyelipkan postingan baru di urutan teratas secara otomatis!
          posts.insert(0, newPost);
        }
      }
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    _pusher.unsubscribe('timeline'); // Putus koneksi agar hemat RAM
    super.onClose();
  }
}