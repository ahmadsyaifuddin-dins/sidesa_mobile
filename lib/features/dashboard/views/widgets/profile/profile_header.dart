// Lokasi: lib/features/dashboard/views/widgets/profile/profile_header.dart (Sesuaikan jika path berbeda)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dashboard_controller.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    // Deklarasikan theme di sini agar mudah dipanggil
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        // 1. Background putih diubah jadi cardColor
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            // 2. Bayangan disesuaikan dengan shadowColor tema
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() {
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  // 3. Garis border avatar mengikuti warna primary tema
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                // 4. Background avatar memakai primary dengan transparansi
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                backgroundImage: controller.userAvatar.value.isNotEmpty
                    ? NetworkImage(controller.userAvatar.value)
                    : null,
                child: controller.userAvatar.value.isEmpty
                    // 5. Icon avatar mengikuti warna primary tema
                    ? Icon(Icons.person, size: 50, color: theme.colorScheme.primary)
                    : null,
              ),
            );
          }),

          const SizedBox(height: 15),

          // Nama User
          Obx(
            () => Text(
              controller.userName.value.toUpperCase(),
              // Teks dibiarkan tanpa 'color' agar otomatis hitam/putih
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 5),

          // Label Warga
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              // 6. Label semantic (hijau) menggunakan trik opacity agar cocok di Dark Mode
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Text(
              "Warga Terverifikasi",
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}