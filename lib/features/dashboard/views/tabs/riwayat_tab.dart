import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/surat/views/detail_surat_view.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../data/models/surat_model.dart';

class RiwayatTab extends StatefulWidget {
  const RiwayatTab({super.key});

  @override
  State<RiwayatTab> createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  // Filter Lokal (Semua, Pending, Selesai, Ditolak)
  String filterStatus = 'Semua'; 
  final List<String> filters = ['Semua', 'Pending', 'Selesai', 'Ditolak'];

  @override
  Widget build(BuildContext context) {
    // Kita panggil controller Dashboard yang sudah ada
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Riwayat Pengajuan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. FILTER CHIPS (Scroll Samping)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: filters.map((status) {
                bool isActive = filterStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isActive,
                    onSelected: (val) {
                      setState(() {
                        filterStatus = status;
                      });
                    },
                    selectedColor: Colors.blue[100],
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: isActive ? Colors.blue[900] : Colors.grey[700],
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),

          // 2. LIST SURAT
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHistory.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Logic Filter Data
              List<SuratModel> dataTampil = controller.historySurat.where((surat) {
                if (filterStatus == 'Semua') return true;
                return surat.status.toLowerCase() == filterStatus.toLowerCase();
              }).toList();

              if (dataTampil.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("Tidak ada riwayat $filterStatus", style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => await controller.fetchHistory(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: dataTampil.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final surat = dataTampil[index];
                    return _buildCard(surat);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(SuratModel surat) {
    return Container(
      // Margin bawah agar antar kartu ada jarak
      margin: const EdgeInsets.only(bottom: 15),
      
      // Dekorasi Luar (Khusus Shadow)
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      
      // Material digunakan agar efek 'Ripple' (gelombang klik) terlihat di atas warna putih
      child: Material(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(() => const DetailSuratView(), arguments: surat);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            // Dekorasi Dalam (Khusus Border)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Icon Surat
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.description_outlined, color: Colors.blue[700]),
                ),
                const SizedBox(width: 15),
                
                // 2. Detail Teks & Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surat.namaSurat,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Diajukan: ${surat.tanggalFormatted}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      
                      // Badge Status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: surat.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          surat.status.toUpperCase(),
                          style: TextStyle(
                            color: surat.statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}