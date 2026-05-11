import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_beda_nama_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_belum_menikah_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_kelahiran_widget.dart';
import 'package:sidesa_mobile/features/buat_surat/views/forms/form_kematian_widget.dart';
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Pengajuan Surat Baru", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Jenis Surat",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                _buildSuratOption(controller, id: 'sku', title: "Keterangan Usaha", icon: Icons.storefront_rounded, color: Colors.blue),
                _buildSuratOption(controller, id: 'sktm', title: "Ket. Tidak Mampu", icon: Icons.health_and_safety_rounded, color: Colors.green),
                _buildSuratOption(controller, id: 'kelahiran', title: "Ket. Kelahiran", icon: Icons.child_friendly_rounded, color: Colors.pink),
                _buildSuratOption(controller, id: 'kematian', title: "Ket. Kematian", icon: Icons.event_busy_rounded, color: Colors.purple),
                _buildSuratOption(controller, id: 'skck', title: "Pengantar SKCK", icon: Icons.local_police_rounded, color: Colors.amber),
                _buildSuratOption(controller, id: 'penghasilan', title: "Ket. Penghasilan", icon: Icons.payments_rounded, color: Colors.green),
                _buildSuratOption(controller, id: 'belum_menikah', title: "Ket. Belum Menikah", icon: Icons.favorite_border_rounded, color: Colors.pink),
                _buildSuratOption(controller, id: 'beda_nama', title: "Ket. Beda Nama", icon: Icons.badge_rounded, color: Colors.orange),
              ],
            ),
            
            const SizedBox(height: 30),

            // 2. FORM DINAMIS (Muncul berdasarkan pilihan)
            Obx(() {
              if (controller.selectedJenisSurat.value.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text("Silakan pilih jenis surat di atas untuk mulai mengisi form.", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MENGAMBIL WIDGET SESUAI ID SURAT
                    if (controller.selectedJenisSurat.value == 'sku') const FormSkuWidget(),
                    if (controller.selectedJenisSurat.value == 'sktm') const FormSktmWidget(),
                    if (controller.selectedJenisSurat.value == 'kelahiran') const FormKelahiranWidget(),
                    if (controller.selectedJenisSurat.value == 'kematian') const FormKematianWidget(),
                    if (controller.selectedJenisSurat.value == 'skck') const FormSkckWidget(),
                    if (controller.selectedJenisSurat.value == 'penghasilan') const FormPenghasilanWidget(),
                    if (controller.selectedJenisSurat.value == 'belum_menikah') const FormBelumMenikahWidget(),
                    if (controller.selectedJenisSurat.value == 'beda_nama') const FormBedaNamaWidget(),

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
                        label: Text(controller.isLoading.value ? "Mengirim..." : "Kirim Pengajuan"),
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

  // WIDGET CARD PILIHAN SURAT
  Widget _buildSuratOption(BuatSuratController controller, {required String id, required String title, required IconData icon, required MaterialColor color}) {
    return Obx(() {
      bool isSelected = controller.selectedJenisSurat.value == id;
      return InkWell(
        onTap: () => controller.changeSuratType(id),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? color[50] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color[400]! : Colors.grey[200]!, width: isSelected ? 2 : 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? color[700] : Colors.grey[400], size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                    color: isSelected ? color[800] : Colors.grey[700],
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