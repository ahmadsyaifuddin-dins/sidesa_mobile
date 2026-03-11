import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Wajib import ini
import 'package:sidesa_mobile/features/aduan/views/aduan_view.dart';

class ServiceMenu extends StatelessWidget {
  const ServiceMenu({super.key});

  // FUNGSI POP-UP & BUKA BROWSER
  Future<void> _bukaLayananSuratWeb() async {
    Get.defaultDialog(
      title: "Login ke Web SIDESA",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          "Anda akan diarahkan ke Web SIDESA untuk mengajukan surat.\n\nSilakan login menggunakan:\n• NIK Anda\n• Password (Tanggal Lahir)",
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.5),
        ),
      ),
      textConfirm: "Lanjutkan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue[700],
      cancelTextColor: Colors.blue[700],
      onConfirm: () async {
        Get.back(); // Tutup dialog pop-up
        
        // Sesuaikan IP jika di-test pakai HP asli (misal: 192.168.43.208:8000)
        final Uri url = Uri.parse('http://192.168.43.208:8000/layanan-surat/buat');
        
        try {
          // LaunchMode.externalApplication akan memaksa buka di Chrome/Browser HP
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            Get.snackbar("Gagal", "Tidak dapat membuka browser", 
                backgroundColor: Colors.red[100], colorText: Colors.red[900]);
          }
        } catch (e) {
          Get.snackbar("Error", "Gagal membuka link: $e", 
              backgroundColor: Colors.red[100], colorText: Colors.red[900]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Layanan Desa",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // 1. BUAT SURAT (Ke Web Laravel)
              _buildItem(Icons.mark_email_unread_outlined, "Buat Surat", Colors.orange, () {
                _bukaLayananSuratWeb();
              }),
              
              // 2. ADUAN WARGA (Persiapan Fase 2)
              _buildItem(Icons.campaign_outlined, "Aduan", Colors.red, () {
                 // Ganti snackbar dengan ini:
                 Get.to(() => const AduanView()); 
              }),              
              // 3. SIDESA AI (Persiapan Fase 3)
              _buildItem(Icons.support_agent_outlined, "SiDesa AI", Colors.teal, () {
                 Get.snackbar(
                  "Segera Hadir", 
                  "Fitur Chat Assistant SiDesa AI sedang dalam tahap pengembangan.", 
                  backgroundColor: Colors.teal[100], colorText: Colors.teal[900]
                );
                // Nanti diganti jadi: Get.toNamed(Routes.CHAT_AI);
              }),
              
              // 4. MENU LAINNYA
              _buildItem(Icons.storefront_outlined, "UMKM", Colors.green, () {}),
              _buildItem(Icons.newspaper_outlined, "Berita", Colors.blue, () {}),
              _buildItem(Icons.map_outlined, "Peta", Colors.purple, () {}),
            ],
          ),
        ),
      ],
    );
  }

  // Helper Widget tetep sama persis kaya kodemu
  Widget _buildItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}