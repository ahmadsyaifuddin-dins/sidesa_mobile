import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/aduan_controller.dart';

class BuatAduanView extends StatelessWidget {
  const BuatAduanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller sudah di-put di halaman riwayat nanti
    final controller = Get.find<AduanController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Buat Aduan Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- JUDUL ---
            _buildLabel("Judul Laporan"),
            TextField(
              controller: controller.judulC,
              decoration: _inputDeco("Contoh: Jalan berlubang di RT 05"),
            ),
            const SizedBox(height: 20),

            // --- KATEGORI ---
            _buildLabel("Kategori"),
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.kategori.value,
                  items: controller.listKategori.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => controller.kategori.value = val!,
                ),
              ),
            )),
            const SizedBox(height: 20),

            // --- DESKRIPSI ---
            _buildLabel("Detail Laporan"),
            TextField(
              controller: controller.deskripsiC,
              maxLines: 4,
              decoration: _inputDeco("Jelaskan secara detail masalah yang terjadi..."),
            ),
            const SizedBox(height: 20),

            // --- PRIORITAS & ANONIM (ROW) ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Prioritas"),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.prioritas.value,
                            items: const [
                              DropdownMenuItem(value: "rendah", child: Text("Rendah")),
                              DropdownMenuItem(value: "sedang", child: Text("Sedang")),
                              DropdownMenuItem(value: "tinggi", child: Text("Tinggi", style: TextStyle(color: Colors.red))),
                            ],
                            onChanged: (val) => controller.prioritas.value = val!,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Sembunyikan Nama?"),
                      Obx(() => SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(controller.isAnonymous.value ? "Ya (Anonim)" : "Tidak", style: const TextStyle(fontSize: 14)),
                        value: controller.isAnonymous.value,
                        activeColor: Colors.blue,
                        onChanged: (val) => controller.isAnonymous.value = val,
                      )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- UPLOAD FOTO ---
            _buildLabel("Foto Bukti (Opsional)"),
            Obx(() => GestureDetector(
              onTap: () {
                // Bottom Sheet untuk pilih Kamera / Galeri
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt, color: Colors.blue),
                          title: const Text('Ambil dari Kamera'),
                          onTap: () { Get.back(); controller.pickImage(ImageSource.camera); },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library, color: Colors.blue),
                          title: const Text('Pilih dari Galeri'),
                          onTap: () { Get.back(); controller.pickImage(ImageSource.gallery); },
                        ),
                      ],
                    ),
                  )
                );
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                ),
                child: controller.foto.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(controller.foto.value!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[400]),
                          const SizedBox(height: 10),
                          Text("Klik untuk tambah foto", style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
              ),
            )),
            
            const SizedBox(height: 40),

            // --- TOMBOL KIRIM ---
            Obx(() => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.kirimAduan(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("KIRIM LAPORAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 2)),
    );
  }
}