// Lokasi: lib/features/timeline/views/timeline_view.dart

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/awesome_dialog_helper.dart';
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
    final theme = Theme.of(context); // 1. Ambil referensi tema

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Background utama ngikut tema
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forum SIDESA", 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 18,
                color: theme.colorScheme.onSurface, // Warna teks dinamis
              ),
            ),
            Text(
              "Ruang aspirasi & informasi desa", 
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.normal,
                color: theme.colorScheme.onSurfaceVariant, // Warna abu-abu dinamis
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface, // Background appbar ngikut tema
        surfaceTintColor: Colors.transparent, // Hindari tint kusam dari Material 3
        elevation: 0.5,
        shadowColor: theme.shadowColor.withOpacity(0.3), // Bayangan halus
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
          backgroundColor: theme.colorScheme.primary, // Warna FAB utama
          icon: Icon(Icons.edit, color: theme.colorScheme.onPrimary),
          label: Text(
            "Tulis", 
            style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          // Asumsi: TimelineSkeleton juga sudah disesuaikan dengan Dark Mode
          return const TimelineSkeleton(); 
        }

        if (controller.posts.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshTimeline,
            color: theme.colorScheme.primary,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Icon(
                  Icons.forum_outlined, 
                  size: 80, 
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4) // Icon kosong dinamis
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "Belum ada postingan.\nJadilah yang pertama membuka obrolan!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant), // Teks kosong dinamis
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshTimeline,
          color: theme.colorScheme.primary, // Warna loading spinner
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
                    child: SpinKitThreeBounce(
                      color: theme.colorScheme.primary.withOpacity(0.5), // Animasi loading pagination dinamis
                      size: 24.0,
                    ),
                  );
                }
                if (!controller.hasMoreData.value && controller.posts.length > 5) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        "Semua postingan telah dimuat", 
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                      ),
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
                  AwesomeDialogHelper.showConfirm(
                    title: "Hapus Postingan",
                    desc: "Yakin ingin menghapus aspirasi ini secara permanen?",
                    dialogType: DialogType.error,
                    btnOkText: "Hapus",
                    btnCancelText: "Batal",
                    btnOkOnPress: () async {
                      await controller.deletePostData(post.id);
                    },
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