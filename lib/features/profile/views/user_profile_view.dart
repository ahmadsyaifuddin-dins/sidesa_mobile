// Lokasi: lib/features/profile/views/user_profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/profile/controllers/user_profile_controller.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../../../core/config/api_config.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserProfileController());
    final user = controller.user;

    // Menentukan apakah user adalah Perangkat Desa (untuk Icon Verified)
    final bool isPerangkatDesa = ['pimpinan', 'operator', 'rt', 'admin', 'developer'].contains(user.role.toLowerCase());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Background abu-abu muda
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Info Pengguna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          // KOTAK PROFIL ATAS
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                ClipOval(
                  child: (user.avatar != null && user.avatar!.isNotEmpty)
                      ? Image.network(
                          user.avatar!.startsWith('http') ? user.avatar! : "${ApiConfig.baseHost}/${user.avatar}",
                          width: 120, height: 120, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _fallbackAvatar(120),
                        )
                      : _fallbackAvatar(120),
                ),
                const SizedBox(height: 16),
                
                // NAMA & ICON VERIFIED
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (isPerangkatDesa) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: Colors.blue, size: 22),
                    ]
                  ],
                ),
                const SizedBox(height: 8),

                // BADGE LABEL ROLE
                Builder(
                  builder: (context) {
                    String roleName = 'Warga';
                    Color roleColor = Colors.blue.shade600;
                    Color bgColor = Colors.blue.shade100;

                    switch (user.role.toLowerCase()) {
                      case 'pimpinan':
                        roleName = 'Kepala Desa';
                        roleColor = Colors.purple.shade700;
                        bgColor = Colors.purple.shade50;
                        break;
                      case 'operator':
                        roleName = 'Operator Desa';
                        roleColor = Colors.teal.shade700;
                        bgColor = Colors.teal.shade50;
                        break;
                      case 'rt':
                        roleName = 'Ketua RT';
                        roleColor = Colors.orange.shade700;
                        bgColor = Colors.orange.shade50;
                        break;
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: roleColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        roleName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: roleColor,
                        ),
                      ),
                    );
                  }
                ),
                
                const SizedBox(height: 16),

                // STATUS ONLINE / OFFLINE
                Obx(() {
                  if (controller.isOnline.value) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green)),
                        const SizedBox(width: 6),
                        const Text("Sedang Online", style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w500)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey)),
                            const SizedBox(width: 6),
                            Text("Sedang Offline", style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Terakhir dilihat: ${controller.getLastSeen()}",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic)
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // KOTAK INFO TAMBAHAN
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_month_rounded, color: Colors.blue),
                  title: const Text("Bergabung sejak", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  subtitle: Text(controller.getJoinedDate(), style: const TextStyle(fontSize: 16, color: Colors.black87)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // TOMBOL KIRIM PESAN
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.offNamedUntil(Routes.CHAT_ROOM, (route) => route.isFirst, arguments: user);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
                label: const Text("Kirim Pesan", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _fallbackAvatar(double size) {
    return Container(
      width: size, height: size, color: Colors.grey.shade200,
      child: Icon(Icons.person, color: Colors.grey, size: size * 0.6),
    );
  }
}