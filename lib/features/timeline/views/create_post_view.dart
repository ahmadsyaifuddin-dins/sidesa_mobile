import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/create_post_controller.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreatePostController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
        title: const Text("Tulis Aspirasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => controller.submitPost(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
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
                      decoration: const InputDecoration(
                        hintText: "Apa yang ingin Anda sampaikan untuk desa?",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      style: const TextStyle(fontSize: 18),
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
                                    color: Colors.black54,
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
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _showImageSourceDialog(context, controller),
                    icon: const Icon(Icons.image_outlined, color: Colors.blue, size: 28),
                    tooltip: "Sisipkan Gambar",
                  ),
                  IconButton(
                    onPressed: () => _showImageSourceDialog(context, controller, forceCamera: true),
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.blue, size: 28),
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

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Pilih Sumber Gambar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text("Kamera"),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text("Galeri"),
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