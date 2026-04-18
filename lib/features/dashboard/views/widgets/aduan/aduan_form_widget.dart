import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sidesa_mobile/features/aduan/controllers/aduan_controller.dart';

class AduanFormWidget extends StatelessWidget {
  const AduanFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.find() karena controller sudah di-inisialisasi di halaman utama
    final controller = Get.find<AduanController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- JUDUL ---
        _buildLabel("Judul Laporan"),
        TextField(
          controller: controller.judulC,
          decoration: _inputDeco("Contoh: Jalan berlubang di RT 05"),
        ),
        const SizedBox(height: 20),

        // --- KATEGORI & PRIORITAS (Dibuat sebaris agar hemat tempat) ---
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Kategori"),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: controller.kategori.value,
                          items: controller.listKategori
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) => controller.kategori.value = val!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Prioritas"),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: controller.prioritas.value,
                          items: ['rendah', 'sedang', 'tinggi']
                              .map(
                                (val) => DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val.capitalizeFirst!,
                                    style: TextStyle(
                                      color: val == 'tinggi'
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => controller.prioritas.value = val!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- DESKRIPSI ---
        _buildLabel("Detail Laporan"),
        TextField(
          controller: controller.deskripsiC,
          maxLines: 4,
          decoration: _inputDeco(
            "Jelaskan secara detail masalah yang terjadi...",
          ),
        ),
        const SizedBox(height: 20),

        // --- OPSI ANONIM ---
        Obx(
          () => SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Kirim sebagai Anonim",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: const Text(
              "Identitas Anda disembunyikan (Batas 1x sebulan)",
              style: TextStyle(fontSize: 12),
            ),
            value: controller.isAnonymous.value,
            activeColor: Colors.blue,
            onChanged: (val) => controller.isAnonymous.value = val,
          ),
        ),
        const SizedBox(height: 20),

        // --- UPLOAD FOTO ---
        _buildLabel("Lampiran Foto (Opsional)"),
        Obx(
          () => GestureDetector(
            onTap: () => _showImagePicker(context, controller),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              child: controller.foto.value != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        controller.foto.value!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 40,
                          color: Colors.blue[300],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Tap untuk tambah/ganti foto",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET HELPERS ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  void _showImagePicker(BuildContext context, AduanController controller) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text("Ambil dari Kamera"),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text("Pilih dari Galeri"),
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
