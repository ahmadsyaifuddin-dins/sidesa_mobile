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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Menentukan apakah user adalah Perangkat Desa (untuk Icon Verified)
    final bool isPerangkatDesa = ['pimpinan', 'operator', 'rt', 'admin', 'developer'].contains(user.role.toLowerCase());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Background ngikut tema
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        title: const Text('Info Pengguna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          // KOTAK PROFIL ATAS
          Container(
            width: double.infinity,
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                ClipOval(
                  child: (user.avatar != null && user.avatar!.isNotEmpty)
                      ? Image.network(
                          user.avatar!.startsWith('http') ? user.avatar! : "${ApiConfig.baseHost}/${user.avatar}",
                          width: 120, height: 120, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _fallbackAvatar(120, bg: theme.colorScheme.surfaceContainerHighest),
                        )
                      : _fallbackAvatar(120, bg: theme.colorScheme.surfaceContainerHighest),
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
                      Icon(Icons.verified, color: theme.colorScheme.primary, size: 22),
                    ]
                  ],
                ),
                const SizedBox(height: 8),

                // BADGE LABEL ROLE
                Builder(
                  builder: (context) {
                    String roleName = 'Warga';
                    Color roleColor = isDark ? Colors.blue.shade300 : Colors.blue.shade600;
                    Color bgColor = isDark ? Colors.blue.shade900.withValues(alpha: 0.35) : Colors.blue.shade100;

                    switch (user.role.toLowerCase()) {
                      case 'pimpinan':
                        roleName = 'Kepala Desa';
                        roleColor = isDark ? Colors.purple.shade300 : Colors.purple.shade700;
                        bgColor = isDark ? Colors.purple.shade900.withValues(alpha: 0.35) : Colors.purple.shade50;
                        break;
                      case 'operator':
                        roleName = 'Operator Desa';
                        roleColor = isDark ? Colors.teal.shade300 : Colors.teal.shade700;
                        bgColor = isDark ? Colors.teal.shade900.withValues(alpha: 0.35) : Colors.teal.shade50;
                        break;
                      case 'rt':
                        roleName = 'Ketua RT';
                        roleColor = isDark ? Colors.orange.shade300 : Colors.orange.shade700;
                        bgColor = isDark ? Colors.orange.shade900.withValues(alpha: 0.35) : Colors.orange.shade50;
                        break;
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: roleColor.withValues(alpha: 0.3)),
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
                            Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: theme.colorScheme.onSurfaceVariant)),
                            const SizedBox(width: 6),
                            Text("Sedang Offline", style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Terakhir dilihat: ${controller.getLastSeen()}",
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8), fontStyle: FontStyle.italic)
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
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_month_rounded, color: theme.colorScheme.primary),
                  title: Text("Bergabung sejak", style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                  subtitle: Text(controller.getJoinedDate(), style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface)),
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

  Widget _fallbackAvatar(double size, {Color? bg}) {
    return Container(
      width: size, height: size, color: bg ?? Colors.grey.shade200,
      child: Icon(Icons.person, color: Colors.grey, size: size * 0.6),
    );
  }
}