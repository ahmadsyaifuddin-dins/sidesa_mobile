// Lokasi: lib/features/dashboard/views/widgets/home/dashboard_header.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dashboard_controller.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.greetingText.value,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  controller.userName.value.isNotEmpty
                      ? controller.userName.value
                      : "Warga Desa",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // Jika Dark Mode: Warna Biru Terang + Glow, Light Mode: Biru Tua Standar
                    color: isDark ? const Color(0xFF81D4FA) : Colors.blue[900],
                    shadows: isDark
                        ? [
                            Shadow(
                              color: Colors.blue.shade400.withOpacity(0.5),
                              blurRadius: 10, // Efek berpendar lembut
                            ),
                          ]
                        : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        
        // Notification Button dengan background dinamis
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}