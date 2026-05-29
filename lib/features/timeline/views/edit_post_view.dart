// Lokasi: lib/features/timeline/views/edit_post_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import '../controllers/timeline_controller.dart';
import '../../../data/models/post_model.dart';
import '../../../core/config/api_config.dart';

class EditPostView extends StatefulWidget {
  final PostModel post;
  const EditPostView({super.key, required this.post});

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  late TextEditingController contentC;
  final TimelineController controller = Get.find<TimelineController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi otomatis dengan teks postingan sebelumnya
    contentC = TextEditingController(text: widget.post.content);
  }

  @override
  void dispose() {
    contentC.dispose();
    super.dispose();
  }

  Future<void> _submitEdit() async {
    if (contentC.text.trim().isEmpty) return;
    
    setState(() => isLoading = true);
    
    // Tunggu hasil update dari server (true / false)
    bool isSuccess = await controller.updatePostData(widget.post.id, contentC.text.trim());
    
    if (!mounted) return;
    setState(() => isLoading = false);
    
    // Jika berhasil, atur urutan penutupannya agar mulus
    if (isSuccess) {
      Get.back(); // 1. Tutup layar Edit terlebih dahulu
      
      // 2. Beri jeda sangat sebentar agar animasi layar tertutup tidak bertabrakan
      Future.delayed(const Duration(milliseconds: 300), () {
        // 3. Munculkan Snackbar di layar Timeline
        SnackbarHelper.success(
          title: "Berhasil",
          message: "Aspirasi Anda telah diperbarui."
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 1. Ambil referensi tema

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Background utama dinamis
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface, // Background appbar dinamis
        surfaceTintColor: Colors.transparent, // Hindari efek kusam Material 3
        elevation: 0.5,
        shadowColor: theme.shadowColor.withOpacity(0.3), // Bayangan halus
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: theme.colorScheme.onSurface), // Ikon close dinamis
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Edit Aspirasi", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: isLoading ? null : _submitEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary, // Warna tombol dinamis
                foregroundColor: theme.colorScheme.onPrimary, // Warna teks tombol dinamis
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: isLoading
                  ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 2))
                  : const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: contentC,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface), // Teks inputan dinamis
                  decoration: InputDecoration(
                    hintText: "Ubah isi aspirasi Anda...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7), // Teks placeholder dinamis
                      fontSize: 18
                    ),
                  ),
                  autofocus: true, // Keyboard otomatis muncul
                ),
              ),
              
              // Jika postingan ini memiliki gambar, tampilkan tapi buat agak transparan
              // sebagai penanda bahwa gambar aslinya akan tetap dipertahankan
              if (widget.post.attachment != null) ...[
                Divider(color: theme.colorScheme.outlineVariant), // Divider dinamis
                Text(
                  "Gambar terlampir (Tidak dapat diubah pada mode edit)",
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12) // Teks instruksi dinamis
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: 0.6, // Dibuat transparan sebagai indikasi tak bisa diedit
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "${ApiConfig.baseHost}/${widget.post.attachment}",
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}