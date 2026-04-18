// Lokasi: lib/features/aduan/views/detail_aduan_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/aduan_controller.dart';
import '../data/aduan_model.dart';
import 'edit_aduan_view.dart';

class DetailAduanView extends StatelessWidget {
  final AduanModel aduan;
  const DetailAduanView({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AduanController>();

    // Penentuan Warna Status
    Color statusColor = Colors.grey;
    if (aduan.status == 'menunggu') statusColor = Colors.orange;
    if (aduan.status == 'diproses') statusColor = Colors.blue;
    if (aduan.status == 'selesai') statusColor = Colors.green;
    if (aduan.status == 'ditolak') statusColor = Colors.red;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Aduan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info (Kode & Status)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(aduan.kodeAduan, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text(aduan.status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Judul & Meta Info
            Text(aduan.judul, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Wrap(
              spacing: 15,
              runSpacing: 10,
              children: [
                _buildMetaIcon(Icons.calendar_today, aduan.createdAt.substring(0, 10)),
                _buildMetaIcon(Icons.category, aduan.kategori),
                _buildMetaIcon(Icons.flag, "Prioritas ${aduan.prioritas}"),
                if (aduan.isAnonymous == 1) _buildMetaIcon(Icons.visibility_off, "Anonim"),
              ],
            ),
            const Divider(height: 40),
            
            // TANGGAPAN PETUGAS (Muncul jika ada isinya)
            if (aduan.tanggapan != null && aduan.tanggapan!.isNotEmpty) ...[
              const Text("Tanggapan Petugas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(aduan.tanggapan!, style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87)),
              ),
              const Divider(height: 40),
            ],

            // Deskripsi Warga
            const Text("Deskripsi Aduan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Text(aduan.deskripsi, style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 20),

            // Foto Lampiran
            if (aduan.fotoUrl != null) ...[
              const Text("Lampiran Foto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  aduan.fotoUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150, color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ],
        ),
      ),
      
      // Bottom Navigation Bar untuk Edit & Hapus (Hanya muncul jika "menunggu")
      bottomNavigationBar: aduan.status == 'menunggu' ? Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Hapus Aduan",
                    middleText: "Yakin ingin membatalkan dan menghapus aduan ini?",
                    textConfirm: "Ya, Hapus",
                    textCancel: "Kembali",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    cancelTextColor: Colors.black,
                    onConfirm: () => controller.hapusAduan(aduan.id),
                  );
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text("Hapus", style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.setupEditForm(aduan);
                  Get.to(() => EditAduanView(aduanId: aduan.id));
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text("Edit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
              ),
            ),
          ],
        ),
      ) : null,
    );
  }

  // Widget helper untuk merapikan baris ikon meta data
  Widget _buildMetaIcon(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}