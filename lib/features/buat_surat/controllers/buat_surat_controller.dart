// Lokasi: lib/features/buat_surat/controllers/buat_surat_controller.dart

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../surat/data/surat_repository.dart';
import '../../surat/controllers/surat_controller.dart';

class BuatSuratController extends GetxController {
  final SuratRepository _repo = SuratRepository();

  var selectedJenisSurat = ''.obs;
  var isLoading = false.obs;
  
  var formData = <String, dynamic>{}.obs;
  // Menyimpan file berdasarkan "key" (misal: 'ktp', 'kk', 'foto_usaha')
  var lampiranFiles = <String, XFile>{}.obs; 

  void changeSuratType(String type) {
    selectedJenisSurat.value = type;
    formData.clear();
    lampiranFiles.clear(); // Reset file saat ganti jenis surat
  }

  void updateForm(String key, dynamic value) {
    formData[key] = value;
  }

  // Fungsi untuk Pick Image per slot
  Future<void> pickFile(String key) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Kompres sedikit agar tidak memberatkan server
    );
    
    if (image != null) {
      lampiranFiles[key] = image;
    }
  }

  // Hapus file di slot tertentu
  void removeFile(String key) {
    lampiranFiles.remove(key);
  }

  Future<void> submitSurat() async {
    if (selectedJenisSurat.isEmpty) {
      SnackbarHelper.warning(title: "Perhatian", message: "Pilih jenis surat terlebih dahulu!");
      return;
    }

    // --- VALIDASI SKU ---
    if (selectedJenisSurat.value == 'sku') {
      if (formData['nama_usaha'] == null || formData['nama_usaha'].toString().isEmpty) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Nama Usaha wajib diisi!");
        return;
      }
      if (formData['jenis_usaha'] == null || formData['jenis_usaha'].toString().isEmpty) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Jenis Usaha wajib diisi!");
        return;
      }
      if (formData['alamat_usaha'] == null || formData['alamat_usaha'].toString().isEmpty) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Alamat Usaha wajib diisi!");
        return;
      }
      if (!lampiranFiles.containsKey('foto_usaha')) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Foto Tempat Usaha/Produk wajib diupload!");
        return;
      }
    }

    // --- VALIDASI SKTM ---
    if (selectedJenisSurat.value == 'sktm') {
      if (formData['keperluan'] == null || formData['keperluan'].toString().isEmpty) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Keperluan Surat wajib diisi!");
        return;
      }
      // Cek apakah ke-5 file sudah diupload semua
      List<String> requiredFiles = ['foto_rumah_depan', 'foto_rumah_dalam', 'surat_pernyataan', 'ktp', 'kk'];
      for (String key in requiredFiles) {
        if (!lampiranFiles.containsKey(key)) {
          // Buat format pesan yang rapi (cth: 'foto_rumah_depan' jadi 'Foto Rumah Depan')
          String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
          SnackbarHelper.error(title: "Validasi Gagal", message: "Lampiran $labelName wajib diupload!");
          return;
        }
      }
    }

    // --- VALIDASI KELAHIRAN ---
    if (selectedJenisSurat.value == 'kelahiran') {
      List<String> wajibIsi = [
        'nama_bayi', 'jenis_kelamin_bayi', 'tanggal_lahir', 'jam_lahir',
        'tempat_lahir', 'anak_ke', 'penolong_kelahiran', 'nama_ayah', 'nama_ibu'
      ];
      
      for (String key in wajibIsi) {
        if (formData[key] == null || formData[key].toString().isEmpty) {
          String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
          SnackbarHelper.error(title: "Validasi Gagal", message: "Data $labelName wajib diisi!");
          return;
        }
      }
    }

    // --- VALIDASI KEMATIAN ---
    if (selectedJenisSurat.value == 'kematian') {
      List<String> wajibIsi = [
        'nama_almarhum', 'nik_almarhum', 'jenis_kelamin_almarhum', 
        'tanggal_lahir_almarhum', 'agama_almarhum', 'alamat_almarhum',
        'tanggal_meninggal', 'jam_meninggal', 'tempat_meninggal', 
        'penyebab_kematian', 'tempat_pemakaman'
      ];
      
      for (String key in wajibIsi) {
        if (formData[key] == null || formData[key].toString().isEmpty) {
          String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
          SnackbarHelper.error(title: "Validasi Gagal", message: "Data $labelName wajib diisi!");
          return;
        }
      }

      // Validasi 2 File Lampiran Wajib
      if (!lampiranFiles.containsKey('ktp_almarhum')) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "KTP Almarhum wajib diunggah!");
        return;
      }
      if (!lampiranFiles.containsKey('kk_almarhum')) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "KK Almarhum wajib diunggah!");
        return;
      }
    }

    // --- VALIDASI SKCK ---
    if (selectedJenisSurat.value == 'skck') {
      if (formData['tujuan_instansi'] == null || formData['tujuan_instansi'].toString().isEmpty) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Tujuan Instansi wajib diisi!");
        return;
      }
      if (formData['keperluan'] == null || formData['keperluan'].toString().isEmpty) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Keperluan Membuat SKCK wajib diisi!");
        return;
      }

      // Validasi 2 File Lampiran Wajib
      if (!lampiranFiles.containsKey('ktp')) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Scan/Foto KTP wajib diunggah!");
        return;
      }
      if (!lampiranFiles.containsKey('kk')) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Scan/Foto KK wajib diunggah!");
        return;
      }
    }

    // --- VALIDASI PENGHASILAN ---
    if (selectedJenisSurat.value == 'penghasilan') {
      List<String> wajibIsi = ['sumber_penghasilan', 'jumlah_penghasilan', 'keperluan'];
      
      for (String key in wajibIsi) {
        if (formData[key] == null || formData[key].toString().isEmpty) {
          String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
          SnackbarHelper.error(title: "Validasi Gagal", message: "Data $labelName wajib diisi!");
          return;
        }
      }

      if (!lampiranFiles.containsKey('ktp') || !lampiranFiles.containsKey('kk')) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "KTP dan KK wajib diunggah!");
        return;
      }
    }

    // --- VALIDASI BELUM PERNAH MENIKAH ---
    if (selectedJenisSurat.value == 'belum_menikah') {
      if (formData['keperluan'] == null || formData['keperluan'].toString().isEmpty) {
        SnackbarHelper.error(title: "Validasi Gagal", message: "Keperluan Surat wajib diisi!");
        return;
      }

      List<String> requiredFiles = ['ktp', 'kk', 'surat_pernyataan'];
      for (String key in requiredFiles) {
        if (!lampiranFiles.containsKey(key)) {
          String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
          SnackbarHelper.error(title: "Validasi Gagal", message: "Lampiran $labelName wajib diunggah!");
          return;
        }
      }
    }

    // --- VALIDASI BEDA NAMA ---
    if (selectedJenisSurat.value == 'beda_nama') {
      List<String> wajibIsi = ['dokumen_satu', 'nama_satu', 'dokumen_dua', 'nama_dua', 'keperluan'];
      
      for (String key in wajibIsi) {
        if (formData[key] == null || formData[key].toString().isEmpty) {
          String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
          SnackbarHelper.error(title: "Validasi Gagal", message: "Data $labelName wajib diisi!");
          return;
        }
      }

      List<String> requiredFiles = ['ktp', 'kk', 'bukti_satu', 'bukti_dua'];
      for (String key in requiredFiles) {
        if (!lampiranFiles.containsKey(key)) {
          String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
          SnackbarHelper.error(title: "Validasi Gagal", message: "Lampiran $labelName wajib diunggah!");
          return;
        }
      }
    }
    // TODO: Validasi SKTM, Kelahiran, Kematian nanti ditaruh di sini...

    // Pastikan minimal ada 1 file yang dilampirkan (Berdasarkan backend yang nullable, tapi secara bisnis diwajibkan)
    if (lampiranFiles.isEmpty) {
      SnackbarHelper.warning(title: "Perhatian", message: "Harap lengkapi dokumen lampiran yang diminta!");
      return;
    }

    isLoading.value = true;
    try {
      // Ubah Map lampiranFiles menjadi List<XFile> untuk dikirim ke Repo
      List<XFile> filesToSend = lampiranFiles.values.toList();

      bool isSuccess = await _repo.ajukanSurat(
        jenisSurat: selectedJenisSurat.value,
        keterangan: formData['keperluan'] ?? "Pengajuan Surat ${selectedJenisSurat.value.toUpperCase()}",
        dataForm: formData,
        lampiranList: filesToSend,
      );

      if (isSuccess) {
        Get.back(); // Tutup form
        Future.delayed(const Duration(milliseconds: 300), () {
          SnackbarHelper.success(title: "Berhasil!", message: "Pengajuan surat berhasil dikirim ke Desa.");
        });
        if (Get.isRegistered<SuratController>()) {
          Get.find<SuratController>().fetchHistory();
        }
      }
    } catch (e) {
      String errorMsg = e.toString().replaceAll("Exception: ", "");
      SnackbarHelper.error(title: "Gagal Mengirim", message: errorMsg);
    } finally {
      isLoading.value = false;
    }
  }
}