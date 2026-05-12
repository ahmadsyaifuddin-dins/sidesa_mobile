// Lokasi: lib/features/buat_surat/controllers/buat_surat_controller.dart

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../surat/data/surat_repository.dart';
import '../../surat/controllers/surat_controller.dart';
import '../../../core/utils/buat_surat_validator.dart';
import '../../../data/models/surat_model.dart'; // Wajib import SuratModel

class BuatSuratController extends GetxController {
  final SuratRepository _repo = SuratRepository();

  // Mode Edit Identifier
  var isEditMode = false.obs;
  int? editSuratId;

  var selectedJenisSurat = ''.obs;
  var isLoading = false.obs;
 
  var formData = <String, dynamic>{}.obs;
  var lampiranFiles = <String, XFile>{}.obs; // Berisi file fisik baru yang dipilih
  var lampiranLamaUrls = <String, String>{}.obs; // Berisi URL gambar/file lama dari server

  @override
  void onInit() {
    super.onInit();
    _checkMode();
  }

  // --- LOGIKA CERDAS: CEK MODE (CREATE vs EDIT) ---
  void _checkMode() {
    if (Get.arguments != null && Get.arguments is SuratModel) {
      SuratModel suratLama = Get.arguments as SuratModel;
      isEditMode.value = true;
      editSuratId = suratLama.id;
      
      // 1. Kunci Jenis Surat
      selectedJenisSurat.value = suratLama.jenisSurat;
      
      // 2. Isi Ulang Data Form (Pre-filled)
      if (suratLama.dataForm != null) {
        formData.assignAll(suratLama.dataForm!);
      }
      
      // 3. Isi Keterangan Pemohon (Jika ada)
      if (suratLama.keteranganPemohon != null) {
        formData['keperluan'] = suratLama.keteranganPemohon;
      }

      // 4. PERBAIKAN: Mapping File Lama Berdasarkan Urutan Pasti (Bukan Tebakan Teks)
      if (suratLama.fileSyarat != null && suratLama.fileSyarat!.isNotEmpty) {
        List<String> urls = suratLama.fileSyarat!;
        List<String> expectedKeys = [];

        // Tentukan template urutan key berdasarkan jenis surat
        switch (suratLama.jenisSurat) {
          case 'sku': expectedKeys = ['foto_usaha']; break;
          case 'sktm': expectedKeys = ['foto_rumah_depan', 'foto_rumah_dalam', 'surat_pernyataan', 'ktp', 'kk']; break;
          case 'kelahiran': expectedKeys = ['surat_bidan']; break;
          case 'kematian': expectedKeys = ['ktp_almarhum', 'kk_almarhum']; break;
          case 'pengantar_skck': expectedKeys = ['ktp', 'kk']; break;
          case 'keterangan_penghasilan': expectedKeys = ['ktp', 'kk']; break;
          case 'belum_pernah_menikah': expectedKeys = ['ktp', 'kk', 'surat_pernyataan']; break;
          case 'keterangan_beda_nama': expectedKeys = ['ktp', 'kk', 'bukti_satu', 'bukti_dua']; break;
        }

        // Pasangkan URL dari database ke masing-masing slot secara berurutan
        for (int i = 0; i < urls.length; i++) {
          if (i < expectedKeys.length) {
            lampiranLamaUrls[expectedKeys[i]] = urls[i];
          } else {
            // Jaga-jaga jika ada file ekstra
            lampiranLamaUrls['extra_$i'] = urls[i];
          }
        }
      }
    }
  }

  void changeSuratType(String type) {
    if (isEditMode.value) {
      SnackbarHelper.warning(title: "Perhatian", message: "Anda tidak bisa mengubah jenis surat saat mengedit.");
      return; // Kunci jenis surat jika sedang diedit
    }
    selectedJenisSurat.value = type;
    formData.clear();
    lampiranFiles.clear();
  }

  void updateForm(String key, dynamic value) {
    formData[key] = value;
  }

  Future<void> pickFile(String key) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
   
    if (image != null) {
      lampiranFiles[key] = image;
      // Jika user memilih file baru, kita hapus URL lama agar preview berubah jadi file lokal
      lampiranLamaUrls.remove(key); 
    }
  }

  void removeFile(String key) {
    lampiranFiles.remove(key);
    lampiranLamaUrls.remove(key); // Hapus juga yang lama jika user menekan tombol silang (X)
  }

  Future<void> submitSurat() async {
    // Gabungkan file lama dan file baru untuk dikirim ke Validator
    // Agar validator tidak marah jika file baru kosong TAPI file lama masih ada
    Map<String, dynamic> gabunganLampiran = {};
    gabunganLampiran.addAll(lampiranFiles);
    gabunganLampiran.addAll(lampiranLamaUrls);

    String? errorMessage = BuatSuratValidator.validate(
      jenisSurat: selectedJenisSurat.value,
      formData: formData,
      lampiranFiles: gabunganLampiran, // Kirim gabungan untuk dievaluasi
    );

    if (errorMessage != null) {
      SnackbarHelper.error(title: "Validasi Gagal", message: errorMessage);
      return;
    }

    isLoading.value = true;
    try {
      List<XFile> filesToSend = lampiranFiles.values.toList();

      // Ambil HANYA NAMA FILE dari URL lama untuk dikirim ke field 'file_lama_yang_dipertahankan'
      List<String> fileLamaYangDipertahankan = lampiranLamaUrls.values.map((url) {
        return url.split('/').last; // Mengambil '170123_foto.jpg' dari 'http://.../uploads/syarat/170123_foto.jpg'
      }).toList();

      bool isSuccess;

      if (isEditMode.value && editSuratId != null) {
        isSuccess = await _repo.editSurat(
          idSurat: editSuratId!,
          jenisSurat: selectedJenisSurat.value,
          keterangan: formData['keperluan'] ?? "Pengajuan Surat ${selectedJenisSurat.value.toUpperCase()}",
          dataForm: formData,
          lampiranBaruList: filesToSend,
          fileLamaDipertahankan: fileLamaYangDipertahankan,
        );
      } else {
        // --- PROSES CREATE ---
        isSuccess = await _repo.ajukanSurat(
          jenisSurat: selectedJenisSurat.value,
          keterangan: formData['keperluan'] ?? "Pengajuan Surat ${selectedJenisSurat.value.toUpperCase()}",
          dataForm: formData,
          lampiranList: filesToSend,
        );
      }

      if (isSuccess) {
        Get.back();
        Future.delayed(const Duration(milliseconds: 300), () {
          SnackbarHelper.success(
            title: "Berhasil!", 
            message: isEditMode.value ? "Permohonan berhasil diperbarui." : "Pengajuan surat berhasil dikirim."
          );
        });
        if (Get.isRegistered<SuratController>()) {
          Get.find<SuratController>().fetchHistory();
        }
      }
    } catch (e) {
      String errorMsg = e.toString().replaceAll("Exception: ", "");
      SnackbarHelper.error(title: "Gagal Menyimpan", message: errorMsg);
    } finally {
      isLoading.value = false;
    }
  }
}