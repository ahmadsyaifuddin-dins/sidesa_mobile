// Lokasi: lib/features/timeline/views/timeline_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/timeline/views/edit_post_view.dart';
import '../controllers/timeline_controller.dart';
import '../widgets/timeline_skeleton.dart';
import '../widgets/post_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; 
import '../../../routes/app_routes.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimelineController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Forum SIDESA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Ruang aspirasi & informasi desa", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
      ),
      
      // Tombol Tulis Aspirasi Mengambang (Posisinya dinaikkan agar tidak ketutupan navbar)
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            // Tunggu user selesai dari form Create Post
            final result = await Get.toNamed(Routes.CREATE_POST);
            // Jika sukses (mengembalikan true), langsung refresh otomatis
            if (result == true) {
              controller.refreshTimeline();
            }
          },
          backgroundColor: Colors.blue.shade700,
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text("Tulis", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const TimelineSkeleton();
        }

        if (controller.posts.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshTimeline,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                const Icon(Icons.forum_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "Belum ada postingan.\nJadilah yang pertama membuka obrolan!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshTimeline,
          color: Colors.blue,
          child: ListView.builder(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.only(top: 8, bottom: 110), // Bottom padding ekstra
            itemCount: controller.posts.length + 1, 
            itemBuilder: (context, index) {
              
              if (index == controller.posts.length) {
                if (controller.isPaginating.value) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SpinKitThreeBounce(color: Colors.blue.shade300, size: 24.0), 
                  );
                }
                if (!controller.hasMoreData.value && controller.posts.length > 5) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text("Semua postingan telah dimuat", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final post = controller.posts[index];
              return PostCard(
                post: post,
                
                currentUserId: controller.currentUserId.value, 
                
                onCommentTap: () {
                  Get.toNamed(Routes.POST_DETAIL, arguments: post);
                },
                onEdit: () {
                  Get.to(
                    () => EditPostView(post: post),
                    fullscreenDialog: true, // Animasi muncul dari bawah ke atas
                    transition: Transition.downToUp,
                  );
                },
                onDelete: () {
                  Get.defaultDialog(
                    title: "Hapus Postingan",
                    middleText: "Yakin ingin menghapus aspirasi ini secara permanen?",
                    textConfirm: "Hapus",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () async {
                      Get.back(); // Tutup dialog
                      // Panggil fungsi delete asli
                      await controller.deletePostData(post.id); 
                    }
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}