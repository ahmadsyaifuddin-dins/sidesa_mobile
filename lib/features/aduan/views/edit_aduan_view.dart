import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/aduan_controller.dart';
import 'forms/widgets/aduan_primary_form.dart';
import 'forms/widgets/aduan_detail_form.dart';

class EditAduanView extends StatelessWidget {
  final int aduanId;
  const EditAduanView({super.key, required this.aduanId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AduanController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Edit Laporan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20), // Spasi atas

            // Bungkus form dalam container putih (mirip Card di Web)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  boxShadow: isDark ? null : const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Hiasan Progress Bar di atas Card (Warna Orange untuk mode Edit)
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange[400], 
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // 1. Panggil Form Utama
                          const AduanPrimaryForm(),

                          Divider(height: 40, color: isDark ? Colors.grey[800] : Colors.grey[200], thickness: 1),

                          // 2. Panggil Form Detail
                          const AduanDetailForm(),

                          const SizedBox(height: 30),

                          // 3. Tombol Aksi Khusus Edit (Kita inline di sini agar Batal & Simpan sejajar)
                          Row(
                            children: [
                              // Tombol Batal
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () {
                                    controller.resetForm();
                                    Get.back();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: Text("Batal", style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              // Tombol Simpan Perubahan
                              Expanded(
                                flex: 2,
                                child: Obx(
                                  () => ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () => controller.simpanEditAduan(aduanId),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      backgroundColor: Colors.orange[600], // Warna orange khusus update
                                      foregroundColor: Colors.white,
                                      elevation: controller.isLoading.value ? 0 : 4,
                                      shadowColor: Colors.orange.withValues(alpha: 0.5),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: controller.isLoading.value
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                          )
                                        : const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("SIMPAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                              SizedBox(width: 8),
                                              Icon(Icons.save_rounded, size: 18),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}