// Lokasi: lib/features/timeline/views/create_post_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/create_post_controller.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreatePostController());
    final theme = Theme.of(context); // 1. Ambil referensi tema

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Background utama dinamis
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface, // Background appbar dinamis
        surfaceTintColor: Colors.transparent, // Hindari efek kusam Material 3
        elevation: 0.5,
        shadowColor: theme.shadowColor.withValues(alpha: 0.3),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: theme.colorScheme.onSurface), // Icon close dinamis
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Tulis Aspirasi", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)
        ),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => controller.submitPost(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary, // Warna tombol dinamis
                foregroundColor: theme.colorScheme.onPrimary, // Warna teks tombol dinamis
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: controller.isLoading.value
                  ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 2))
                  : const Text("Posting", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kolom Teks
                    TextField(
                      controller: controller.contentC,
                      maxLines: null, // Bisa multiline tanpa batas
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface), // Warna teks inputan
                      decoration: InputDecoration(
                        hintText: "Apa yang ingin Anda sampaikan untuk desa?",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7), // Warna placeholder dinamis
                          fontSize: 18
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Preview Gambar
                    Obx(() {
                      if (controller.selectedImage.value != null) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                controller.selectedImage.value!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: controller.removeImage,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54, // Tetap hitam transparan karena gambar bisa berwarna apa saja
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
            
            // Toolbar Bawah (Tambah Foto)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)), // Garis pemisah dinamis
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _showImageSourceDialog(context, controller),
                    icon: Icon(Icons.image_outlined, color: theme.colorScheme.primary, size: 28), // Icon warna primer dinamis
                    tooltip: "Sisipkan Gambar",
                  ),
                  IconButton(
                    onPressed: () => _showImageSourceDialog(context, controller, forceCamera: true),
                    icon: Icon(Icons.camera_alt_outlined, color: theme.colorScheme.primary, size: 28),
                    tooltip: "Ambil Foto Baru",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Dialog untuk memilih Kamera atau Galeri
  void _showImageSourceDialog(BuildContext context, CreatePostController controller, {bool forceCamera = false}) {
    if (forceCamera) {
      controller.pickImage(ImageSource.camera);
      return;
    }

    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor, // Background sheet dinamis
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Pilih Sumber Gambar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
              title: Text("Kamera", style: TextStyle(color: theme.colorScheme.onSurface)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: theme.colorScheme.primary),
              title: Text("Galeri", style: TextStyle(color: theme.colorScheme.onSurface)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}