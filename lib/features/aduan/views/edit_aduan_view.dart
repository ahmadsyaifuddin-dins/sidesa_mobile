// Lokasi: lib/features/aduan/views/edit_aduan_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/aduan_controller.dart';

class EditAduanView extends StatelessWidget {
  final int aduanId;
  const EditAduanView({super.key, required this.aduanId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AduanController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Aduan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Judul Laporan", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.judulC,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 20),

            // Baris Kategori & Prioritas
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.kategori.value,
                            items: controller.listKategori.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                            onChanged: (val) { if (val != null) controller.kategori.value = val; },
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Prioritas", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.prioritas.value,
                            items: ['rendah', 'sedang', 'tinggi'].map((val) => DropdownMenuItem(value: val, child: Text(val.capitalizeFirst!))).toList(),
                            onChanged: (val) { if (val != null) controller.prioritas.value = val; },
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text("Deskripsi Detail", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.deskripsiC,
              maxLines: 5,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 20),

            // Opsi Anonim
            Obx(() => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Kirim sebagai Anonim", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Identitas Anda akan disembunyikan (Batas 1x sebulan)"),
              value: controller.isAnonymous.value,
              activeColor: Colors.blue,
              onChanged: (val) => controller.isAnonymous.value = val,
            )),
            const SizedBox(height: 20),

            const Text("Ganti Lampiran Foto (Opsional)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
              onTap: () => _showImagePicker(context, controller),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                ),
                child: controller.foto.value != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(controller.foto.value!, fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.blue[300]),
                          const SizedBox(height: 8),
                          Text("Tap untuk mengganti foto", style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
              ),
            )),
            const SizedBox(height: 40),

            Obx(() => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.simpanEditAduan(aduanId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Perubahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )),
          ],
        ),
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
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text("Ambil dari Kamera"), onTap: () { Get.back(); controller.pickImage(ImageSource.camera); }),
            ListTile(leading: const Icon(Icons.photo_library), title: const Text("Pilih dari Galeri"), onTap: () { Get.back(); controller.pickImage(ImageSource.gallery); }),
          ],
        ),
      ),
    );
  }
}