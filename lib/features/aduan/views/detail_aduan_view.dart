import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/aduan_controller.dart';
import '../data/aduan_model.dart';
import 'detail/widgets/detail_action_widget.dart';
import 'detail/widgets/detail_deskripsi_widget.dart';
import 'detail/widgets/detail_foto_widget.dart';
import 'detail/widgets/detail_header_widget.dart';
import 'detail/widgets/detail_meta_widget.dart';
import 'detail/widgets/detail_tanggapan_widget.dart';

class DetailAduanView extends StatelessWidget {
  final AduanModel? aduan; 
  const DetailAduanView({super.key, this.aduan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Detail Laporan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: Obx(() {
        final aduanC = Get.find<AduanController>();
        AduanModel? currentAduan = aduan;

        // --- LOGIC REAKTIF & DEEP LINKING ---
        if (currentAduan != null) {
          try {
            currentAduan = aduanC.listAduan.firstWhere((item) => item.id == currentAduan!.id);
          } catch (e) {
            // Tetap pakai data kiriman jika tidak ketemu
          }
        } else if (Get.arguments != null) {
          final String argId = Get.arguments.toString();
          try {
            currentAduan = aduanC.listAduan.firstWhere((item) => item.id.toString() == argId);
          } catch (e) {
            currentAduan = null;
          }
        }

        // --- FALLBACK UI JIKA DATA KOSONG ---
        if (currentAduan == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // --- BAGIAN ATAS (Kertas Putih) ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        boxShadow: isDark ? null : const [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailHeaderWidget(aduan: currentAduan),
                          const SizedBox(height: 20),
                          DetailMetaWidget(aduan: currentAduan),
                        ],
                      ),
                    ),
                    
                    // --- BAGIAN BAWAH (Konten Detail) ---
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailTanggapanWidget(aduan: currentAduan),
                          DetailDeskripsiWidget(aduan: currentAduan),
                          const SizedBox(height: 20),
                          DetailFotoWidget(aduan: currentAduan),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // --- TOMBOL AKSI (Akan diam di bawah) ---
            DetailActionWidget(aduan: currentAduan),
          ],
        );
      }),
    );
  }
}