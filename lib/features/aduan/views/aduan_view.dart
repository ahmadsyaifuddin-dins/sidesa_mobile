import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/aduan_controller.dart';
import 'buat_aduan_view.dart';

class AduanView extends StatelessWidget {
  const AduanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller di halaman utama aduan ini
    final controller = Get.put(AduanController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Aduan Warga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      
      // Tombol Mengambang (FAB) buat nambah aduan
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const BuatAduanView()),
        backgroundColor: Colors.blue[700],
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Buat Laporan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                Text("Belum ada aduan yang Anda kirim.", style: TextStyle(color: Colors.grey[600])),
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
              
              // Tentukan Warna Status
              Color statusColor = Colors.grey;
              if (aduan.status == 'menunggu') statusColor = Colors.orange;
              if (aduan.status == 'diproses') statusColor = Colors.blue;
              if (aduan.status == 'selesai') statusColor = Colors.green;
              if (aduan.status == 'ditolak') statusColor = Colors.red;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            aduan.kodeAduan,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text(aduan.status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(aduan.judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(aduan.deskripsi, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.category, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(aduan.kategori, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          const Spacer(),
                          Text(aduan.createdAt.substring(0, 10), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}