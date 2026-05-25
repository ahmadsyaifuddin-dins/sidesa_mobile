// Lokasi: lib/features/buat_surat/controllers/buat_surat_controller.dart

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../surat/data/surat_repository.dart';
import '../../surat/controllers/surat_controller.dart';
import '../../../core/utils/buat_surat_validator.dart';
import '../../../data/models/surat_model.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/utils/string_formatter.dart';

class BuatSuratController extends GetxController {
  final SuratRepository _repo = SuratRepository();

  // Mode Edit Identifier
  var isEditMode = false.obs;
  int? editSuratId;

  var selectedJenisSurat = ''.obs;
  var isLoading = false.obs;
 
  var formData = <String, dynamic>{}.obs;
  var lampiranFiles = <String, XFile>{}.obs; 
  var lampiranLamaUrls = <String, String>{}.obs; 

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

      // 4. Mapping File Lama Berdasarkan Urutan Pasti (Sequential Mapping)
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
          case 'pengantar_ktp': 
            // Cek alasan untuk menentukan jumlah kotak lampiran yang ada
            String alasan = suratLama.dataForm?['jenis_permohonan'] ?? '';
            if (alasan.contains('Baru')) {
              expectedKeys = ['kk', 'akta_kelahiran'];
            } else if (alasan.contains('Hilang')) {
              expectedKeys = ['kk', 'surat_kehilangan'];
            } else if (alasan.contains('Rusak')) {
              expectedKeys = ['kk', 'ktp_rusak'];
            } else if (alasan.contains('Perubahan')) {
              expectedKeys = ['kk', 'ktp_lama', 'bukti_pendukung'];
            } else {
              expectedKeys = ['kk'];
            }
            break;

            case 'keterangan_ahli_waris': expectedKeys = ['ktp', 'kk', 'surat_kematian']; break;
        }

        // Pasangkan URL dari database ke masing-masing slot secara berurutan
        for (int i = 0; i < urls.length; i++) {
          if (i < expectedKeys.length) {
            lampiranLamaUrls[expectedKeys[i]] = urls[i];
          } else {
            lampiranLamaUrls['extra_$i'] = urls[i];
          }
        }
      }
    }
  }

  void changeSuratType(String type) {
    if (isEditMode.value) {
      SnackbarHelper.warning(title: "Perhatian", message: "Anda tidak bisa mengubah jenis surat saat mengedit.");
      return; 
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
      lampiranLamaUrls.remove(key); // Hapus preview lama agar diganti yang baru
    }
  }

  // Untuk memilih Gambar ATAU Dokumen (PDF/Word)
  Future<void> pickDocumentOrImage(String key) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        // Konversi hasil FilePicker menjadi XFile agar kompatibel dengan sistem kita
        lampiranFiles[key] = XFile(result.files.single.path!);
        lampiranLamaUrls.remove(key); // Hapus preview lama agar diganti yang baru
      }
    } catch (e) {
      SnackbarHelper.error(title: "Batal", message: "Pemilihan file dibatalkan atau error.");
    }
  }
  
  void removeFile(String key) {
    lampiranFiles.remove(key);
    lampiranLamaUrls.remove(key); 
  }

  Future<void> submitSurat() async {
    // Gabungkan file lama dan file baru untuk dikirim ke Validator
    Map<String, dynamic> gabunganLampiran = {};
    gabunganLampiran.addAll(lampiranFiles);
    gabunganLampiran.addAll(lampiranLamaUrls);

    String? errorMessage = BuatSuratValidator.validate(
      jenisSurat: selectedJenisSurat.value,
      formData: formData,
      lampiranFiles: gabunganLampiran, 
    );

    if (errorMessage != null) {
      SnackbarHelper.error(title: "Validasi Gagal", message: errorMessage);
      return;
    }

    isLoading.value = true;
    try {
      List<XFile> filesToSend = lampiranFiles.values.toList();

      // Ambil string nama file asli dari akhir URL Laravel
      List<String> fileLamaYangDipertahankan = lampiranLamaUrls.values.map((url) {
        return url.split('/').last; 
      }).toList();

      bool isSuccess;

      if (isEditMode.value && editSuratId != null) {
        isSuccess = await _repo.editSurat(
          idSurat: editSuratId!,
          jenisSurat: selectedJenisSurat.value,
          keterangan: formData['keperluan'] ?? "Pengajuan Surat ${StringFormatter.formatJenisSurat(selectedJenisSurat.value)}",
          dataForm: formData,
          lampiranBaruList: filesToSend,
          fileLamaDipertahankan: fileLamaYangDipertahankan,
        );
      } else {
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
            message: isEditMode.value ? "Permohonan berhasil diperbarui." : "Pengajuan surat berhasil dikirim ke Desa."
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