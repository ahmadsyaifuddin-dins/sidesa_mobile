// Lokasi: lib/features/buat_surat/controllers/buat_surat_controller.dart

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../surat/data/surat_repository.dart';
import '../../surat/controllers/surat_controller.dart';
import '../../../core/utils/buat_surat_validator.dart';

class BuatSuratController extends GetxController {
  final SuratRepository _repo = SuratRepository();

  var selectedJenisSurat = ''.obs;
  var isLoading = false.obs;
 
  var formData = <String, dynamic>{}.obs;
  var lampiranFiles = <String, XFile>{}.obs;

  void changeSuratType(String type) {
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
    }
  }

  void removeFile(String key) {
    lampiranFiles.remove(key);
  }

  Future<void> submitSurat() async {
    // 1. PANGGIL VALIDATOR
    // Jika mengembalikan string, berarti ada error. Jika null, berarti lolos.
    String? errorMessage = BuatSuratValidator.validate(
      jenisSurat: selectedJenisSurat.value,
      formData: formData,
      lampiranFiles: lampiranFiles,
    );

    // 2. TAMPILKAN ERROR JIKA ADA
    if (errorMessage != null) {
      SnackbarHelper.error(title: "Validasi Gagal", message: errorMessage);
      return; // Hentikan proses eksekusi API
    }

    // 3. JIKA LOLOS, PROSES PENGIRIMAN KE API
    isLoading.value = true;
    try {
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