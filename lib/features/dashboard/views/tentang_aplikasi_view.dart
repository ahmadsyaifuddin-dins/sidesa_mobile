import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import Partials
import 'widgets/tentang_aplikasi/app_logo_section.dart';
import 'widgets/tentang_aplikasi/academic_journey_card.dart';
import 'widgets/tentang_aplikasi/developer_info_card.dart';

class TentangAplikasiView extends StatelessWidget {
  const TentangAplikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Background otomatis menyesuaikan tema
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Tentang Aplikasi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Hapus warna statis, biarkan transparan agar menyatu dengan background
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          // Icon otomatis menyesuaikan kontras tema
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            
            // 1. Panggil Bagian Logo
            const AppLogoSection(),
            const SizedBox(height: 30),

            // 2. Panggil Card Akademik
            const AcademicJourneyCard(),
            const SizedBox(height: 20),

            // 3. Panggil Card Developer Info
            const DeveloperInfoCard(),
            const SizedBox(height: 30),

            // Footer Text
            Text(
              "© 2026-${DateTime.now().year} Sistem Informasi Desa",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant, // Warna abu-abu dinamis
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}