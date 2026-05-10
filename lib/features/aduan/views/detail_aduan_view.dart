import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/awesome_dialog_helper.dart';
import '../controllers/aduan_controller.dart';
import '../data/aduan_model.dart';
import 'edit_aduan_view.dart';

class DetailAduanView extends StatelessWidget {
  final AduanModel? aduan; // Opsional agar bisa menerima FCM Payload
  const DetailAduanView({super.key, this.aduan});

  @override
  Widget build(BuildContext context) {
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
      // BUNGKUS SELURUH BODY DAN BOTTOM NAV DENGAN Obx AGAR REAKTIF
      body: Obx(() {
        final aduanC = Get.find<AduanController>();
        AduanModel? currentAduan = aduan;

        // --- LOGIC REAKTIF & DEEP LINKING ---
        if (currentAduan != null) {
          try {
            // Cari di memori agar reaktif jika ada perubahan
            currentAduan = aduanC.listAduan.firstWhere(
              (item) => item.id == currentAduan!.id,
            );
          } catch (e) {
            // Tetap pakai data kiriman jika tidak ketemu
          }
        } else if (Get.arguments != null) {
          final String argId = Get.arguments.toString();
          try {
            currentAduan = aduanC.listAduan.firstWhere(
              (item) => item.id.toString() == argId,
            );
          } catch (e) {
            currentAduan = null;
          }
        }

        // --- FALLBACK UI JIKA DATA KOSONG ---
        if (currentAduan == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Penentuan Warna Status
        Color statusColor = Colors.grey;
        if (currentAduan.status == 'menunggu') statusColor = Colors.orange;
        if (currentAduan.status == 'diproses') statusColor = Colors.blue;
        if (currentAduan.status == 'selesai') statusColor = Colors.green;
        if (currentAduan.status == 'ditolak') statusColor = Colors.red;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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

                    // TANGGAPAN PETUGAS (Muncul jika ada isinya)
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          currentAduan.fotoUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
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
            ),

            // Bottom Navigation Bar untuk Edit & Hapus (Hanya muncul jika "menunggu")
            if (currentAduan.status == 'menunggu')
              Container(
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
                          AwesomeDialogHelper.showConfirm(
                            title: "Hapus Aduan",
                            desc: "Yakin ingin membatalkan dan menghapus aduan ini?",
                            dialogType: DialogType.error, // Pakai error agar tombol merah (danger)
                            btnOkText: "Ya, Hapus",
                            btnCancelText: "Kembali",
                            btnOkOnPress: () => aduanC.hapusAduan(currentAduan!.id),
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
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
                          aduanC.setupEditForm(currentAduan!);
                          Get.to(
                            () => EditAduanView(aduanId: currentAduan!.id),
                          );
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
              ),
          ],
        );
      }),
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
