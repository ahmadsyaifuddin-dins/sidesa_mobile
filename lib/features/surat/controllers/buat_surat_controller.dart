import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/surat_repository.dart';

class BuatSuratController extends GetxController {
  final SuratRepository _repo = SuratRepository();

  // State Form
  var isLoading = false.obs;
  var jenisSuratTerpilih = 'sku'.obs; // Default SKU

  // Input Controller Umum
  final keteranganC = TextEditingController();
  
  // Input Khusus SKU (Surat Keterangan Usaha)
  final namaUsahaC = TextEditingController();
  final jenisUsahaC = TextEditingController();

  // List Pilihan Surat (Nanti bisa ditambah)
  final List<Map<String, String>> pilihanSurat = [
    {'kode': 'sku', 'nama': 'Surat Keterangan Usaha'},
    {'kode': 'domisili', 'nama': 'Surat Keterangan Domisili'},
    {'kode': 'sktm', 'nama': 'Surat Keterangan Tidak Mampu'},
  ];

  void kirimSurat() async {
    if (keteranganC.text.isEmpty) {
      Get.snackbar("Error", "Keterangan keperluan harus diisi", backgroundColor: Colors.red[100]);
      return;
    }

    // Validasi Khusus SKU
    if (jenisSuratTerpilih.value == 'sku') {
      if (namaUsahaC.text.isEmpty || jenisUsahaC.text.isEmpty) {
        Get.snackbar("Error", "Detail usaha wajib diisi", backgroundColor: Colors.red[100]);
        return;
      }
    }

    isLoading.value = true;

    try {
      // Siapkan data JSON untuk kolom 'data_form'
      Map<String, dynamic> dataForm = {};
      
      if (jenisSuratTerpilih.value == 'sku') {
        dataForm = {
          "nama_usaha": namaUsahaC.text,
          "jenis_usaha": jenisUsahaC.text,
        };
      }

      // Kirim ke Backend
      await _repo.ajukanSurat(
        jenisSurat: jenisSuratTerpilih.value,
        keterangan: keteranganC.text,
        dataForm: dataForm,
      );

      Get.back(); // Tutup halaman form
      Get.snackbar("Sukses", "Surat berhasil diajukan!", backgroundColor: Colors.green, colorText: Colors.white);
      
      // TODO: Refresh halaman dashboard/riwayat biar muncul status terbaru

    } catch (e) {
      Get.snackbar("Gagal", e.toString().replaceAll("Exception:", ""), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}