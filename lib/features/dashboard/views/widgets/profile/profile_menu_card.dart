// Lokasi: lib/features/dashboard/views/widgets/profile/profile_menu_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/services/activity_logger_service.dart';
import 'package:sidesa_mobile/features/dashboard/views/edit_profile_view.dart';
import 'package:sidesa_mobile/features/dashboard/views/tentang_aplikasi_view.dart';

// --- IMPORT DARI FOLDER PARTIALS ---
import 'partials/profile_menu_card/profile_menu_tile.dart';
import 'partials/profile_menu_card/change_password_sheet.dart';
import 'partials/profile_menu_card/theme_selection_sheet.dart';

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pengaturan",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                ProfileMenuTile(
                  icon: Icons.edit_outlined,
                  title: "Edit Profil",
                  onTap: () {
                    ActivityLoggerService.log('Menu Profil: Edit Profil');
                    Get.to(() => const EditProfileView(), transition: Transition.rightToLeft);
                  },
                ),
                const Divider(height: 1, indent: 50),
                
                ProfileMenuTile(
                  icon: Icons.lock_outline,
                  title: "Ganti Password",
                  onTap: () {
                    ActivityLoggerService.log('Menu Profil: Ganti Password');
                    // Panggil module dari partials
                    Get.bottomSheet(ChangePasswordSheet(), isScrollControlled: true);
                  },
                ),
                const Divider(height: 1, indent: 50),
                
                ProfileMenuTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Tema Aplikasi",
                  onTap: () {
                    ActivityLoggerService.log('Menu Profil: Tema Aplikasi');
                    // Panggil module dari partials
                    Get.bottomSheet(const ThemeSelectionSheet());
                  },
                ),
                const Divider(height: 1, indent: 50),
                
                ProfileMenuTile(
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                  onTap: () {
                    ActivityLoggerService.log('Menu Profil: Tentang Aplikasi');
                    Get.to(() => const TentangAplikasiView(), transition: Transition.rightToLeft);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}