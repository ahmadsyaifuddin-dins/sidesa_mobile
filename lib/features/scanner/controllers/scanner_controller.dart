// Lokasi: lib/features/scanner/controllers/scanner_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/scanner_repository.dart';

class ScannerController extends GetxController {
  final ScannerRepository _repo = ScannerRepository();

  // Controller bawaan mobile_scanner
  late MobileScannerController cameraController;

  // State untuk mencegah kamera scan berkali-kali saat sedang loading
  var isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  // Fungsi utama saat QR Code terdeteksi
  Future<void> onDetect(BarcodeCapture capture) async {
    if (isProcessing.value) return; // Abaikan jika sedang memproses

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? rawValue = barcodes.first.rawValue;

      // Pastikan QR Code yang discan adalah QR SIDESA
      if (rawValue != null && rawValue.contains('/identitas-warga/')) {
        isProcessing.value = true;

        // Jeda kamera sementara agar tidak pusing
        cameraController.stop();

        // Ekstrak NIK dari URL (mengambil bagian paling akhir dari URL)
        Uri uri = Uri.parse(rawValue);
        String nik = uri.pathSegments.last;

        await _prosesVerifikasi(nik);
      } else {
        Get.snackbar(
          "QR Tidak Valid",
          "Mohon scan QR Code dari Kartu Warga Digital SIDESA.",
          backgroundColor: Colors.orange[100],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> _prosesVerifikasi(String nik) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final dataWarga = await _repo.cekIdentitasWarga(nik);
      Get.back(); // Tutup loading dialog

      // Tampilkan hasil di BottomSheet
      _showResultBottomSheet(dataWarga);
    } catch (e) {
      Get.back(); // Tutup loading dialog
      Get.snackbar(
        "Verifikasi Gagal",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );

      // Nyalakan kamera lagi jika gagal
      isProcessing.value = false;
      cameraController.start();
    }
  }

  void _showResultBottomSheet(Map<String, dynamic> data) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            const Text(
              "TERVERIFIKASI",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow("NIK", data['nik']),
            const Divider(),
            _buildInfoRow("Nama Lengkap", data['nama_lengkap']),
            const Divider(),
            _buildInfoRow("Alamat", data['alamat']),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Tutup bottom sheet
                  // Mulai kamera lagi untuk scan berikutnya
                  isProcessing.value = false;
                  cameraController.start();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Tutup & Scan Lagi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
