import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/aduan_controller.dart';
import '../../../../../core/utils/snackbar_helper.dart'; // Pastikan path ini benar

class AduanDetailForm extends StatelessWidget {
  const AduanDetailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AduanController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- DESKRIPSI ---
        const Text("Deskripsi Lengkap", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.deskripsiC,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Jelaskan kronologi, lokasi spesifik, dan detail lainnya...",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.blue, width: 2)),
          ),
        ),
        const SizedBox(height: 24),

        // --- UPLOAD FOTO ---
        const Text("Bukti Foto (Opsional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Obx(() {
          bool hasNewPhoto = controller.foto.value != null;
          bool hasOldPhoto = controller.fotoUrlLama.value.isNotEmpty;
          bool isShowingPhoto = hasNewPhoto || hasOldPhoto;

          return GestureDetector(
            onTap: () => _showImagePicker(context, controller),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isShowingPhoto ? Colors.blue.withValues(alpha: 0.05) : Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isShowingPhoto ? Colors.blue : Colors.grey.shade300,
                  width: isShowingPhoto ? 2 : 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: isShowingPhoto
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: hasNewPhoto
                              ? Image.file(
                                  controller.foto.value!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  controller.fotoUrlLama.value,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
                                ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              controller.foto.value = null;
                              controller.fotoUrlLama.value = ''; // Hapus dari UI
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                          child: Icon(Icons.cloud_upload_outlined, size: 28, color: Colors.blue[600]),
                        ),
                        const SizedBox(height: 12),
                        const Text("Tap untuk upload foto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text("JPG, PNG (Maks. 2MB)", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
            ),
          );
        }),
        const SizedBox(height: 24),

        // --- FITUR ANONIM ---
        Obx(() {
          bool isQuotaEmpty = controller.sisaKuotaAnonim.value <= 0;

          return GestureDetector(
            // Deteksi klik pada seluruh area container
            onTap: () {
              if (isQuotaEmpty) {
                SnackbarHelper.warning(
                  title: "Fitur Terkunci",
                  message: "Kuota anonim bulan ini sudah habis. Kirim dengan identitas asli.",
                );
              } else {
                controller.isAnonymous.value = !controller.isAnonymous.value;
              }
            },
            child: Opacity(
              opacity: isQuotaEmpty ? 0.6 : 1.0, // Efek transparan saat disabled
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isQuotaEmpty ? Colors.grey[200] : Colors.blue[50], // Abu-abu kalau habis
                  border: Border.all(color: isQuotaEmpty ? Colors.grey.shade300 : Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: isQuotaEmpty ? false : controller.isAnonymous.value,
                        activeColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        // Set onChanged null agar logic klik diambil alih oleh GestureDetector
                        onChanged: isQuotaEmpty ? null : (val) => controller.isAnonymous.value = val ?? false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kirim Sebagai Anonim",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isQuotaEmpty ? Colors.grey[600] : Colors.black87,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isQuotaEmpty ? Colors.grey[300] : Colors.blue[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Token: ${controller.sisaKuotaAnonim.value}/${controller.maxKuotaBulanan.value}",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isQuotaEmpty ? Colors.grey[600] : Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (isQuotaEmpty)
                            const Text("Kuota bulanan habis. Anda harus melapor menggunakan identitas asli.", style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.w500))
                          else
                            Text("Identitas Anda akan disembunyikan. Kuota direset setiap awal bulan.", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showImagePicker(BuildContext context, AduanController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
                child: Icon(Icons.camera_alt, color: Colors.blue[700]),
              ),
              title: const Text("Ambil dari Kamera", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.purple[50], shape: BoxShape.circle),
                child: Icon(Icons.photo_library, color: Colors.purple[700]),
              ),
              title: const Text("Pilih dari Galeri", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}