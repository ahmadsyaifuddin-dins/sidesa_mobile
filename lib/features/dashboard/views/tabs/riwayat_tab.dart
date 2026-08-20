import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/dashboard/views/tabs/widgets/skeleton_riwayat_card.dart';
import 'package:sidesa_mobile/features/surat/views/detail_surat_view.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../data/models/surat_model.dart';
import '../../../surat/controllers/surat_controller.dart';
import '../../../../../core/utils/string_formatter.dart';

class RiwayatTab extends StatefulWidget {
  const RiwayatTab({super.key});

  @override
  State<RiwayatTab> createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  String filterStatus = 'Semua';
  final List<String> filters = ['Semua', 'Pending', 'Diproses', 'Menunggu Validasi', 'Selesai', 'Ditolak'];

  @override
  Widget build(BuildContext context) {
    // Panggil kedua controller agar rapi
    final dashboardC = Get.find<DashboardController>();
    final suratC = Get.find<SuratController>();
    final theme = Theme.of(context); // Ambil referensi tema

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Background otomatis tema
      appBar: AppBar(
        title: Text(
          "Riwayat Pengajuan",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18,
            color: theme.colorScheme.onSurface, // Teks mengikuti tema
          ),
        ),
        backgroundColor: Colors.transparent, // Transparan agar menyatu
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
                    // Warna saat chip aktif
                    selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                    // Warna saat chip tidak aktif
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    labelStyle: TextStyle(
                      color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 2. LIST SURAT
          Expanded(
            child: Obx(() {
              if (suratC.isLoadingHistory.value) {
                // Tampilkan 5 skeleton sebagai placeholder saat loading
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const SkeletonRiwayatCard();
                  },
                );
              }

              // Logic Filter Data
              List<SuratModel> dataTampil = suratC.historySurat.where((surat) {
                if (filterStatus == 'Semua') return true;
                return surat.status.toLowerCase() == filterStatus.toLowerCase();
              }).toList();

              if (dataTampil.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off,
                        size: 60,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Tidak ada riwayat $filterStatus",
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: theme.colorScheme.primary, // Warna loading spinner
                onRefresh: () async => await suratC.fetchHistory(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  itemCount: dataTampil.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final surat = dataTampil[index];
                    // Lempar context ke helper _buildCard
                    return _buildCard(context, surat);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Menerima 'context' agar tahu tema yang aktif
  Widget _buildCard(BuildContext context, SuratModel surat) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 15), // Margin luar untuk efek shadow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05), // Shadow dinamis
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: theme.cardColor, // Background kotak dinamis
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(() => const DetailSuratView(), arguments: surat);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outlineVariant), // Border dinamis
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringFormatter.formatJenisSurat(surat.namaSurat),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.colorScheme.onSurface, // Teks judul
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Diajukan: ${surat.tanggalFormatted}",
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant, // Teks tanggal
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: surat.statusColor.withValues(alpha: 0.1), // Background status tetap senada
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          surat.status.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: surat.statusColor,
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