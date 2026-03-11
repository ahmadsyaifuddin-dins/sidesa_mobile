import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:sidesa_mobile/features/aduan/views/aduan_view.dart';
import 'package:sidesa_mobile/features/chat/views/chat_view.dart';

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
        
        // Sesuaikan IP jika di-test pakai HP asli
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
        const SizedBox(height: 16), // Jarak teks ke icon sedikit dilebarkan
        
        // MENGGUNAKAN ROW AGAR POSISI KE TENGAH
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Membagi jarak sama rata
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BUAT SURAT (Ke Web Laravel)
              _buildItem(Icons.mark_email_unread_outlined, "Buat Surat", Colors.orange, () {
                _bukaLayananSuratWeb();
              }),
              
              // 2. ADUAN WARGA 
              _buildItem(Icons.campaign_outlined, "Aduan", Colors.red, () {
                 Get.to(() => const AduanView()); 
              }),              
              
              // 3. SIDESA AI
              _buildItem(Icons.support_agent_outlined, "SiDesa AI", Colors.teal, () {
                 Get.to(() => const ChatView()); 
              }),
              
              // Jika nanti menu UMKM/Berita mau diaktifkan lagi, 
              // lebih baik gunakan Wrap() ketimbang Row() agar tidak sempit.
            ],
          ),
        ),
      ],
    );
  }

  // Helper Widget yang sudah diperbaiki (Tanpa Padding Kanan)
  Widget _buildItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Agar tidak makan tempat berlebih
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 55, // Sedikit dibesarkan dari 50 ke 55
            height: 55,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26), // Ukuran icon menyesuaikan
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500) // Font dibesarkan sedikit
        ),
      ],
    );
  }
}