import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_ahli_waris_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_beda_nama_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_belum_menikah_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_kelahiran_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_kematian_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_pengantar_ktp_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_penghasilan_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_skck_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_sktm_widget.dart';
import '../controllers/buat_surat_controller.dart';
import 'forms/form_sku_widget.dart';

class BuatSuratView extends StatelessWidget {
  const BuatSuratView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final controller = Get.put(BuatSuratController());
    
    // Deteksi mode gelap/terang
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditMode.value ? "Edit Pengajuan Surat" : "Pengajuan Surat Baru",
          style: const TextStyle(fontWeight: FontWeight.w600)
        )),
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Jenis Surat",
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            
            // 1. GRID PILIHAN SURAT
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 2.5,
              children: [
                _buildSuratOption(context, controller, id: 'sku', title: "Keterangan Usaha", icon: Icons.storefront_rounded, color: Colors.blue),
                _buildSuratOption(context, controller, id: 'sktm', title: "Ket. Tidak Mampu", icon: Icons.health_and_safety_rounded, color: Colors.green),
                _buildSuratOption(context, controller, id: 'kelahiran', title: "Ket. Kelahiran", icon: Icons.child_friendly_rounded, color: Colors.pink),
                _buildSuratOption(context, controller, id: 'kematian', title: "Ket. Kematian", icon: Icons.event_busy_rounded, color: Colors.purple),
                _buildSuratOption(context, controller, id: 'pengantar_skck', title: "Pengantar SKCK", icon: Icons.local_police_rounded, color: Colors.amber),
                _buildSuratOption(context, controller, id: 'keterangan_penghasilan', title: "Ket. Penghasilan", icon: Icons.payments_rounded, color: Colors.green),
                _buildSuratOption(context, controller, id: 'belum_pernah_menikah', title: "Ket. Belum Menikah", icon: Icons.favorite_border_rounded, color: Colors.pink),
                _buildSuratOption(context, controller, id: 'keterangan_beda_nama', title: "Ket. Beda Nama", icon: Icons.badge_rounded, color: Colors.orange),
                _buildSuratOption(context, controller, id: 'pengantar_ktp', title: "Pengantar KTP", icon: Icons.badge_rounded, color: Colors.blue),
                _buildSuratOption(context, controller, id: 'keterangan_ahli_waris', title: "Ahli Waris", icon: Icons.family_restroom_rounded, color: Colors.indigo),
              ],
            ),
            
            const SizedBox(height: 30),

            // 2. FORM DINAMIS (Muncul berdasarkan pilihan)
            Obx(() {
              if (controller.selectedJenisSurat.value.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Silakan pilih jenis surat di atas untuk mulai mengisi form.", 
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey, 
                        fontStyle: FontStyle.italic
                      )
                    ),
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MENGAMBIL WIDGET SESUAI ID SURAT
                    if (controller.selectedJenisSurat.value == 'sku') const FormSkuWidget(),
                    if (controller.selectedJenisSurat.value == 'sktm') const FormSktmWidget(),
                    if (controller.selectedJenisSurat.value == 'kelahiran') const FormKelahiranWidget(),
                    if (controller.selectedJenisSurat.value == 'kematian') const FormKematianWidget(),
                    if (controller.selectedJenisSurat.value == 'pengantar_skck') const FormSkckWidget(),
                    if (controller.selectedJenisSurat.value == 'keterangan_penghasilan') const FormPenghasilanWidget(),
                    if (controller.selectedJenisSurat.value == 'belum_pernah_menikah') const FormBelumMenikahWidget(),
                    if (controller.selectedJenisSurat.value == 'keterangan_beda_nama') const FormBedaNamaWidget(),
                    if (controller.selectedJenisSurat.value == 'pengantar_ktp') const FormPengantarKtpWidget(),
                    if (controller.selectedJenisSurat.value == 'keterangan_ahli_waris') const FormAhliWarisWidget(),
                    const SizedBox(height: 30),
                    
                    // TOMBOL KIRIM
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: controller.isLoading.value ? null : () => controller.submitSurat(),
                        icon: controller.isLoading.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send_rounded),
                        label: Obx(() => Text(
                          controller.isLoading.value
                              ? "Menyimpan..."
                              : (controller.isEditMode.value ? "Simpan Perubahan" : "Kirim Pengajuan")
                        )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // WIDGET CARD PILIHAN SURAT (Diperbarui untuk Dark Mode)
  Widget _buildSuratOption(BuildContext context, BuatSuratController controller, {required String id, required String title, required IconData icon, required MaterialColor color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      bool isSelected = controller.selectedJenisSurat.value == id;
      
      // Mengatur warna latar belakang berdasarkan mode dan seleksi
      Color bgColor;
      if (isSelected) {
        bgColor = isDark ? color.withValues(alpha: 0.2) : color[50]!;
      } else {
        bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
      }

      // Mengatur warna border
      Color borderColor = isSelected 
          ? color[400]! 
          : (isDark ? Colors.grey[800]! : Colors.grey[200]!);

      // Mengatur warna teks dan ikon
      Color iconAndTextColor = isSelected 
          ? (isDark ? color[300]! : color[700]!)
          : (isDark ? Colors.grey[400]! : Colors.grey[700]!);

      return InkWell(
        onTap: () => controller.changeSuratType(id),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, color: iconAndTextColor, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                    color: iconAndTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}