import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sidesa_mobile/features/aduan/views/aduan_view.dart';
import 'package:sidesa_mobile/features/chat/views/chat_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ServiceMenu extends StatelessWidget {
  const ServiceMenu({super.key});

  // FUNGSI POP-UP & BUKA BROWSER
  Future<void> _bukaLayananSuratWeb() async {
    if (Get.context != null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.question, // Icon tanda tanya (Pilihan)
        animType: AnimType.bottomSlide,
        title: "Pilih Metode Pengajuan",
        // Menggunakan custom body agar kita bisa buat 2 tombol besar
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            children: [
              const Text(
                "Pilih platform untuk mengajukan surat Anda hari ini:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              
              // OPSI 1: VIA APLIKASI (NATIVE)
              InkWell(
                onTap: () {
                  Get.back(); // Tutup dialog
                  Get.toNamed('/buat-surat'); // Arahkan ke halaman native
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.blue[200]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
                        child: Icon(Icons.phone_android_rounded, color: Colors.blue[700], size: 28),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Via Aplikasi (Cepat)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blue[900])),
                            const SizedBox(height: 5),
                            Text.rich(
                              TextSpan(
                                text: "Sangat cocok untuk surat umum (seperti ",
                                style: TextStyle(fontSize: 12, color: Colors.blue[800], height: 1.3),
                                children: const [
                                  TextSpan(text: "SKU, SKTM, Kelahiran, dll", style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: ") karena formnya jauh lebih "),
                                  TextSpan(text: "simpel dan praktis.", style: TextStyle(fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 12),

              // OPSI 2: VIA WEBSITE (LENGKAP)
              InkWell(
                onTap: () async {
                  Get.back(); // Tutup dialog
                  
                  // Logic buka browser lama kamu
                  final box = Hive.box('settings');
                  final String dynamicIP = box.get('server_ip', defaultValue: '192.168.0.28');
                  final Uri url = Uri.parse('http://$dynamicIP:8000/layanan-surat/buat');
                  
                  try {
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      SnackbarHelper.error(title: "Gagal", message: "Tidak dapat membuka browser");
                    }
                  } catch (e) {
                    SnackbarHelper.error(title: "Error", message: "Gagal membuka link: $e");
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    border: Border.all(color: Colors.orange[200]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.orange[100], shape: BoxShape.circle),
                        child: Icon(Icons.language_rounded, color: Colors.orange[700], size: 28),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Via Website (Lengkap)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.orange[900])),
                            const SizedBox(height: 5),
                            Text.rich(
                              TextSpan(
                                text: "Pilih opsi ini jika surat yang Anda cari ",
                                style: TextStyle(fontSize: 12, color: Colors.orange[800], height: 1.3),
                                children: const [
                                  TextSpan(text: "tidak tersedia", style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: " di aplikasi, atau membutuhkan upload dokumen yang "),
                                  TextSpan(text: "sangat banyak.", style: TextStyle(fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        btnCancelText: "Batal",
        btnCancelColor: Colors.grey[400],
        btnCancelOnPress: () {}, 
      ).show();
    }
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
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Membagi jarak sama rata
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BUAT SURAT (Ke Web Laravel)
              _buildItem(
                Icons.mark_email_unread_outlined,
                "Buat Surat",
                Colors.orange,
                () {
                  _bukaLayananSuratWeb();
                },
              ),

              // 2. ADUAN WARGA
              _buildItem(Icons.campaign_outlined, "Aduan", Colors.red, () {
                Get.to(() => AduanView());
              }),

              // 3. SIDESA AI
              _buildItem(
                Icons.support_agent_outlined,
                "SiDesa AI",
                Colors.teal,
                () {
                  Get.to(() => const ChatView());
                },
              ),

              // Jika nanti menu UMKM/Berita mau diaktifkan lagi,
              // lebih baik gunakan Wrap() ketimbang Row() agar tidak sempit.
            ],
          ),
        ),
      ],
    );
  }

  // Helper Widget yang sudah diperbaiki (Tanpa Padding Kanan)
  Widget _buildItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
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
            child: Icon(
              icon,
              color: color,
              size: 26,
            ), // Ukuran icon menyesuaikan
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ), // Font dibesarkan sedikit
        ),
      ],
    );
  }
}
