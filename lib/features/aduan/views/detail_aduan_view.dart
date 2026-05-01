// Lokasi: lib/features/aduan/views/detail_aduan_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/aduan_controller.dart';
import '../data/aduan_model.dart';
import 'edit_aduan_view.dart';

class DetailAduanView extends StatelessWidget {
  // 1. Jadikan parameter aduan opsional (nullable) dengan menghapus 'required'
  final AduanModel? aduan;
  const DetailAduanView({super.key, this.aduan});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AduanController>();

    // --- LOGIC NAVIGASI PINTAR ---
    AduanModel? currentAduan = aduan;

    // Jika 'aduan' kosong tapi ada Get.arguments, berarti dibuka via Notifikasi FCM
    if (currentAduan == null && Get.arguments != null) {
      final String argId = Get.arguments.toString();
      try {
        // Cari data aduan di memori controller berdasarkan ID dari Notifikasi
        currentAduan = controller.listAduan.firstWhere(
          (item) => item.id.toString() == argId,
        );
      } catch (e) {
        currentAduan = null; // Jika ID tidak ditemukan
      }
    }

    // Handle jika data benar-benar tidak ditemukan / kosong
    if (currentAduan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detail Aduan")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              const Text(
                "Data aduan tidak ditemukan.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("Kembali"),
              ),
            ],
          ),
        ),
      );
    }
    // -----------------------------

    // Penentuan Warna Status (Menggunakan currentAduan)
    Color statusColor = Colors.grey;
    if (currentAduan.status == 'menunggu') statusColor = Colors.orange;
    if (currentAduan.status == 'diproses') statusColor = Colors.blue;
    if (currentAduan.status == 'selesai') statusColor = Colors.green;
    if (currentAduan.status == 'ditolak') statusColor = Colors.red;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Aduan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
                Text(
                  currentAduan.kodeAduan,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    currentAduan.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Judul & Meta Info
            Text(
              currentAduan.judul,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 15,
              runSpacing: 10,
              children: [
                _buildMetaIcon(
                  Icons.calendar_today,
                  currentAduan.createdAt.substring(0, 10),
                ),
                _buildMetaIcon(Icons.category, currentAduan.kategori),
                _buildMetaIcon(
                  Icons.flag,
                  "Prioritas ${currentAduan.prioritas}",
                ),
                if (currentAduan.isAnonymous == 1)
                  _buildMetaIcon(Icons.visibility_off, "Anonim"),
              ],
            ),
            const Divider(height: 40),

            // TANGGAPAN PETUGAS
            if (currentAduan.tanggapan != null &&
                currentAduan.tanggapan!.isNotEmpty) ...[
              const Text(
                "Tanggapan Petugas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(
                  currentAduan.tanggapan!,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Divider(height: 40),
            ],

            // Deskripsi Warga
            const Text(
              "Deskripsi Aduan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              currentAduan.deskripsi,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Foto Lampiran
            if (currentAduan.fotoUrl != null) ...[
              const Text(
                "Lampiran Foto",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  currentAduan.fotoUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: currentAduan.status == 'menunggu'
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Hapus Aduan",
                          middleText:
                              "Yakin ingin membatalkan dan menghapus aduan ini?",
                          textConfirm: "Ya, Hapus",
                          textCancel: "Kembali",
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.red,
                          cancelTextColor: Colors.black,
                          onConfirm: () => controller.hapusAduan(
                            currentAduan!.id,
                          ), // Menggunakan currentAduan!
                        );
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.setupEditForm(
                          currentAduan!,
                        ); // Menggunakan currentAduan!
                        Get.to(() => EditAduanView(aduanId: currentAduan!.id));
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

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
