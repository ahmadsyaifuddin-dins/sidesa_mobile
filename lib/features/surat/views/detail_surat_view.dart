// Lokasi: lib/features/surat/views/detail_surat_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/surat/views/detail_surat/widgets/workflow_status_widget.dart';

// Import Controller & Model
import '../../../data/models/surat_model.dart';
import '../controllers/surat_controller.dart';

// Import Widget Modular
import 'detail_surat/widgets/status_header_widget.dart';
import 'detail_surat/widgets/alasan_penolakan_widget.dart';
import 'detail_surat/widgets/informasi_surat/informasi_surat_widget.dart';
import 'detail_surat/widgets/tombol_aksi_widget.dart';

class DetailSuratView extends StatelessWidget {
  const DetailSuratView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 1. Ambil referensi tema

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Background utama dinamis
      appBar: AppBar(
        title: Text(
          "Detail Permohonan", 
          style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)
        ),
        backgroundColor: theme.colorScheme.surface, // Background Appbar dinamis
        foregroundColor: theme.colorScheme.onSurface, // Icon Back dinamis
        surfaceTintColor: Colors.transparent, // Hindari tint kusam dari Material 3
        elevation: 0.5,
        shadowColor: theme.shadowColor.withOpacity(0.3),
        centerTitle: true,
      ),
      body: Obx(() {
        // --- LOGIC REAKTIF & DEEP LINKING ---
        SuratModel? currentSurat;
        final suratC = Get.find<SuratController>();

        if (Get.arguments is SuratModel) {
          final SuratModel argSurat = Get.arguments as SuratModel;
          try {
            currentSurat = suratC.historySurat.firstWhere(
              (item) => item.id == argSurat.id,
            );
          } catch (e) {
            currentSurat = argSurat;
          }
        } else if (Get.arguments != null) {
          final String argId = Get.arguments.toString();
          try {
            currentSurat = suratC.historySurat.firstWhere(
              (item) => item.id.toString() == argId,
            );
          } catch (e) {
            currentSurat = null;
          }
        }

        // --- FALLBACK UI JIKA DATA KOSONG ---
        if (currentSurat == null) {
          return Center(
            child: Text(
              "Data surat tidak ditemukan / sedang memuat...",
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant), // Teks fallback dinamis
            ),
          );
        }

        // --- RENDER UI UTAMA ---
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkflowStatusWidget(surat: currentSurat),
              StatusHeaderWidget(surat: currentSurat),
              
              if (currentSurat.status == 'ditolak' && currentSurat.keteranganOperator != null)
                AlasanPenolakanWidget(alasan: currentSurat.keteranganOperator!),
                
              const SizedBox(height: 25),
              InformasiSuratWidget(surat: currentSurat),
              
              const SizedBox(height: 30),
              TombolAksiWidget(surat: currentSurat),
            ],
          ),
        );
      }),
    );
  }
}