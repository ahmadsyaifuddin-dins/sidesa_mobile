// Lokasi: lib/features/aduan/views/aduan_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/dashboard/views/widgets/aduan/aduan_card.dart';
import '../controllers/aduan_controller.dart';
import 'buat_aduan_view.dart';

class AduanView extends StatelessWidget {
  const AduanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AduanController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Aduan Warga",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent, // Menyatu dengan tema
        foregroundColor: theme.colorScheme.onSurface, // Teks ikut tema
        elevation: 0,
      ),
      
      // --- IMPLEMENTASI DYNAMIC FAB (AnimatedSwitcher) ---
      floatingActionButton: Obx(() {
        // Logika kapan tombol disembunyikan
        final isHidden = controller.isFetching.value && controller.listAduan.isEmpty;
        
        return AnimatedScale(
          scale: isHidden ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 500), // Durasi dipanjangin biar kerasa
          curve: Curves.easeOutBack, 
          child: AnimatedOpacity(
            opacity: isHidden ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: FloatingActionButton.extended(
              heroTag: 'fab_sidesa',
              onPressed: () {
                controller.resetForm();
                Get.to(() => const BuatAduanView());
              },
              backgroundColor: theme.colorScheme.primary,
              icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
              label: Text(
                "Buat Laporan",
                style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }),

      body: Obx(() {
        if (controller.isFetching.value && controller.listAduan.isEmpty) {
          return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
        }

        if (controller.listAduan.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(
                  "Belum ada aduan yang Anda kirim.",
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchRiwayatAduan(),
          color: theme.colorScheme.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.listAduan.length,
            itemBuilder: (context, index) {
              final aduan = controller.listAduan[index];
              return AduanCard(aduan: aduan);
            },
          ),
        );
      }),
    );
  }
}