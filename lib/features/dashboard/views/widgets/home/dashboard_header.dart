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
              // Sapaan & Pantun / Quotes
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
              const SizedBox(height: 6),
              
              // --- PENGGANTI NAMA: STATUS AKUN (WARGA TERVERIFIKASI) ---
              Row(
                children: [
                  Icon(
                    Icons.verified_rounded, 
                    // Cyan menyala di Dark Mode, Biru Tua di Light Mode
                    color: isDark ? const Color(0xFF00E5FF) : Colors.blue[700], 
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Warga Terverifikasi",
                    style: TextStyle(
                      fontSize: 14, // Dikecilkan sedikit dari 16 agar proporsional
                      fontWeight: FontWeight.bold,
                      // Warna teks dan Glow yang senada dengan icon
                      color: isDark ? const Color(0xFF81D4FA) : Colors.blue[900],
                      shadows: isDark
                          ? [
                              Shadow(
                                color: const Color(0xFF00E5FF).withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Notification Button
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