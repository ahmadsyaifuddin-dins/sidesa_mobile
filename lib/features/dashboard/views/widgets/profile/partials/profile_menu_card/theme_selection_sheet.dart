// Lokasi: lib/features/dashboard/views/widgets/profile/theme_selection_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/services/theme_service.dart';

class ThemeSelectionSheet extends StatelessWidget {
  const ThemeSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pilih Tema Aplikasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "Sesuaikan tampilan aplikasi dengan kenyamanan Anda.",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Obx(() => Column(
                children: [
                  _buildRadioTile(themeService, "Mode Sistem", "Mengikuti pengaturan perangkat", 'system'),
                  _buildRadioTile(themeService, "Terang (Light)", null, 'light'),
                  _buildRadioTile(themeService, "Gelap (Dark)", null, 'dark'),
                ],
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildRadioTile(ThemeService service, String title, String? subtitle, String value) {
    return RadioListTile<String>(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      groupValue: service.currentTheme.value,
      onChanged: (val) {
        if (val != null) service.changeTheme(val);
        Get.back();
      },
    );
  }
}