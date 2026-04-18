// Lokasi: lib/features/aduan/controllers/aduan_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/aduan_model.dart';
import '../data/aduan_repository.dart';

class AduanController extends GetxController {
  final AduanRepository _repo = AduanRepository();
  final ImagePicker _picker = ImagePicker();

  // --- STATE VARIABEL ---
  var isLoading = false.obs;
  var isFetching = false.obs;
  var listAduan = <AduanModel>[].obs;

  // --- FORM INPUT ---
  final judulC = TextEditingController();
  final deskripsiC = TextEditingController();
  
  var kategori = 'Infrastruktur'.obs;
  var prioritas = 'sedang'.obs;
  var isAnonymous = false.obs;
  var foto = Rxn<File>(); // File gambar (bisa null)

  // Opsi Kategori
  final List<String> listKategori = [
    'Infrastruktur', 'Kebersihan', 'Keamanan', 'Pelayanan', 'Sosial', 'Lainnya'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchRiwayatAduan();
  }

  @override
  void onClose() {
    judulC.dispose();
    deskripsiC.dispose();
    super.onClose();
  }

  // --- FUNGSI AMBIL RIWAYAT ---
  Future<void> fetchRiwayatAduan() async {
    isFetching.value = true;
    try {
      final data = await _repo.getRiwayatAduan();
      listAduan.value = data;
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""), 
          backgroundColor: Colors.red[100]);
    } finally {
      isFetching.value = false;
    }
  }

  // --- FUNGSI AMBIL FOTO ---
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Kompres ukuran biar upload cepat
      );
      if (pickedFile != null) {
        foto.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil foto", backgroundColor: Colors.red[100]);
    }
  }

  // --- FUNGSI KIRIM ADUAN BARU ---
  Future<void> kirimAduan() async {
    if (judulC.text.isEmpty || deskripsiC.text.isEmpty) {
      Get.snackbar("Peringatan", "Judul dan Deskripsi wajib diisi!", 
          backgroundColor: Colors.orange[100]);
      return;
    }

    isLoading.value = true;
    try {
      await _repo.buatAduan(
        judul: judulC.text,
        kategori: kategori.value,
        deskripsi: deskripsiC.text,
        prioritas: prioritas.value,
        isAnonymous: isAnonymous.value,
        foto: foto.value,
      );

      Get.back(); // Tutup halaman form
      Get.snackbar("Berhasil", "Aduan Anda berhasil dikirim", 
          backgroundColor: Colors.green[100]);
      
      _resetForm();
      fetchRiwayatAduan();
      
    } catch (e) {
      Get.snackbar("Gagal", e.toString().replaceAll("Exception: ", ""), 
          backgroundColor: Colors.red[100], duration: const Duration(seconds: 4));
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI SETUP FORM EDIT ---
  void setupEditForm(AduanModel aduan) {
    judulC.text = aduan.judul;
    deskripsiC.text = aduan.deskripsi;
    kategori.value = aduan.kategori;
    prioritas.value = aduan.prioritas; 
    isAnonymous.value = aduan.isAnonymous == 1; // Konversi dari int ke bool
    foto.value = null; // Kosongkan file local agar aman
  }

  // --- FUNGSI SIMPAN EDIT ADUAN ---
  Future<void> simpanEditAduan(int id) async {
    if (judulC.text.isEmpty || deskripsiC.text.isEmpty) {
      Get.snackbar("Peringatan", "Judul dan Deskripsi wajib diisi!", backgroundColor: Colors.orange[100]);
      return;
    }

    isLoading.value = true;
    try {
      await _repo.updateAduan(
        id: id,
        judul: judulC.text,
        kategori: kategori.value,
        deskripsi: deskripsiC.text,
        prioritas: prioritas.value,
        isAnonymous: isAnonymous.value,
        fotoBaru: foto.value,
      );

      Get.back(); // Tutup halaman form edit
      Get.back(); // Tutup halaman detail (kembali ke list)
      Get.snackbar("Berhasil", "Aduan berhasil diperbarui", backgroundColor: Colors.green[100]);
      
      _resetForm();
      fetchRiwayatAduan(); // Refresh list terbaru
    } catch (e) {
      Get.snackbar("Gagal", e.toString().replaceAll("Exception: ", ""), backgroundColor: Colors.red[100]);
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI HAPUS ADUAN ---
  Future<void> hapusAduan(int aduanId) async {
    try {
      // Tampilkan loading dialog
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      await _repo.hapusAduan(aduanId);
      
      Get.back(); // Tutup loading
      Get.back(); // Tutup halaman detail 
      
      Get.snackbar("Berhasil", "Aduan berhasil dihapus.", backgroundColor: Colors.green[100]);
      fetchRiwayatAduan(); // Refresh list aduan
    } catch (e) {
      Get.back(); // Tutup loading
      Get.snackbar("Gagal", e.toString().replaceAll("Exception: ", ""), backgroundColor: Colors.red[100]);
    }
  }

  // --- FUNGSI RESET FORM ---
  void _resetForm() {
    judulC.clear();
    deskripsiC.clear();
    kategori.value = 'Infrastruktur';
    prioritas.value = 'sedang';
    isAnonymous.value = false;
    foto.value = null;
  }
}