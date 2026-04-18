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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Aduan Warga",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const BuatAduanView()),
        backgroundColor: Colors.blue[700],
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Buat Laporan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        if (controller.isFetching.value && controller.listAduan.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.listAduan.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  "Belum ada aduan yang Anda kirim.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchRiwayatAduan(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.listAduan.length,
            itemBuilder: (context, index) {
              final aduan = controller.listAduan[index];

              // Cukup panggil custom widget-nya di sini, view jadi sangat bersih!
              return AduanCard(aduan: aduan);
            },
          ),
        );
      }),
    );
  }
}
