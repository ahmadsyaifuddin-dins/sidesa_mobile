// Lokasi: lib/features/dashboard/views/edit_profile_view.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/dashboard_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller langsung di View
    final EditProfileController controller = Get.put(EditProfileController());
    final DashboardController dashC = Get.find<DashboardController>();
    
    // Ambil referensi tema aktif
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent, // Transparan agar menyatu dengan background
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bagian Avatar
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() {
                    return Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2), 
                          width: 4
                        ),
                        image: controller.selectedImage.value != null
                            // Jika ada gambar baru yang dipilih dari HP
                            ? DecorationImage(
                                image: FileImage(controller.selectedImage.value!),
                                fit: BoxFit.cover,
                              )
                            : (dashC.userAvatar.value.isNotEmpty
                                // Jika tidak ada pilihan baru, tampilkan dari Network (jika ada)
                                ? DecorationImage(
                                    image: NetworkImage(dashC.userAvatar.value),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child: controller.selectedImage.value == null &&
                              dashC.userAvatar.value.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            )
                          : null,
                    );
                  }),
                  // Tombol Kamera untuk Pick Image
                  GestureDetector(
                    onTap: () => controller.pickImage(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Ubah Foto Profil",
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 40),

            // Form Edit Nomor Telepon
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nomor Telepon (WhatsApp)",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface, // Teks mengikuti kontras tema
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.noTelpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Contoh: 081234567890",
                prefixIcon: Icon(Icons.phone_android, color: theme.colorScheme.primary),
                filled: true,
                // Menggunakan surfaceVariant agar kolom input sedikit berbeda dengan background
                fillColor: theme.colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Catatan Peringatan (Trik Opacity Warna Orange)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Data penting seperti NIK, Nama, dan Alamat hanya dapat diubah oleh Operator Desa demi validitas kependudukan.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700, // Shade lebih gelap sedikit agar terbaca di Light Mode
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.saveProfile(),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}