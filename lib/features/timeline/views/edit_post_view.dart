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
        title: const Text("Edit Aspirasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: isLoading ? null : _submitEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: isLoading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
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
                  decoration: const InputDecoration(
                    hintText: "Ubah isi aspirasi Anda...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  style: const TextStyle(fontSize: 18),
                  autofocus: true, // Keyboard otomatis muncul
                ),
              ),
              
              // Jika postingan ini memiliki gambar, tampilkan tapi buat agak transparan
              // sebagai penanda bahwa gambar aslinya akan tetap dipertahankan
              if (widget.post.attachment != null) ...[
                const Divider(),
                const Text("Gambar terlampir (Tidak dapat diubah pada mode edit)", 
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Opacity(
                  opacity: 0.6,
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