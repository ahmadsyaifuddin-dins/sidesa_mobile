import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/buat_surat_controller.dart';
import 'dart:io';

class BuatSuratView extends StatelessWidget {
  const BuatSuratView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuatSuratController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Permohonan"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Pilihan Jenis Surat
            const Text("Jenis Surat", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.jenisSuratTerpilih.value,
                  items: controller.pilihanSurat.map((item) {
                    return DropdownMenuItem(
                      value: item['kode'],
                      child: Text(item['nama']!),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.jenisSuratTerpilih.value = val;
                  },
                ),
              )),
            ),

            const SizedBox(height: 20),

            // 2. Form Dinamis (Muncul sesuai jenis surat)
            // Saat ini khusus SKU dulu
            Obx(() {
              if (controller.jenisSuratTerpilih.value == 'sku') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[100]!)
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 10),
                          Expanded(child: Text("Mohon lengkapi data usaha anda untuk keperluan verifikasi.", style: TextStyle(fontSize: 12))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: controller.namaUsahaC,
                      decoration: const InputDecoration(
                        labelText: "Nama Usaha",
                        hintText: "Contoh: Warung Sejahtera",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: controller.jenisUsahaC,
                      decoration: const InputDecoration(
                        labelText: "Bidang Usaha",
                        hintText: "Contoh: Kelontong / Kuliner",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink(); // Kosong kalau bukan SKU
            }),

            const SizedBox(height: 20),

            // 3. Keterangan Keperluan
            const Text("Keperluan / Keterangan", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.keteranganC,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Jelaskan keperluan pembuatan surat ini...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 4. UPLOAD LAMPIRAN (BARU)
            const Text("Lampiran (Foto KTP/Syarat)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            Obx(() {
              if (controller.selectedImage.value == null) {
                // KONDISI: BELUM ADA FOTO
                return InkWell(
                  onTap: () => _showPickerBottomSheet(context, controller),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey[400]!, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Tap untuk ambil foto", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              } else {
                // KONDISI: SUDAH ADA FOTO (PREVIEW)
                return Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(File(controller.selectedImage.value!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Tombol Hapus/Ganti
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.selectedImage.value = null; // Hapus
                          },
                        ),
                      ),
                    )
                  ],
                );
              }
            }),

            const SizedBox(height: 30),

            // 4. Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.kirimSurat(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("AJUKAN SURAT SEKARANG"),
              )),
            ),
          ],
        ),
      ),
    );
  }
  // Fungsi Bottom Sheet Pilihan
  void _showPickerBottomSheet(BuildContext context, BuatSuratController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Ambil dari Galeri'),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
