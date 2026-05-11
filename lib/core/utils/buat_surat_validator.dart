// Lokasi: lib/features/buat_surat/utils/buat_surat_validator.dart

import 'package:get/get.dart';

class BuatSuratValidator {
  /// Mengembalikan [String] berisi pesan error jika tidak valid.
  /// Mengembalikan [null] jika semua data valid.
  static String? validate({
    required String jenisSurat,
    required Map<String, dynamic> formData,
    required Map<String, dynamic> lampiranFiles,
  }) {
    if (jenisSurat.isEmpty) {
      return "Pilih jenis surat terlebih dahulu!";
    }

    switch (jenisSurat) {
      case 'sku':
        String? err = _checkTexts(formData, ['nama_usaha', 'jenis_usaha', 'alamat_usaha']);
        if (err != null) return err;
        if (!lampiranFiles.containsKey('foto_usaha')) return "Foto Tempat Usaha/Produk wajib diupload!";
        break;

      case 'sktm':
        if (_isEmpty(formData['keperluan'])) return "Keperluan Surat wajib diisi!";
        String? errFile = _checkFiles(lampiranFiles, ['foto_rumah_depan', 'foto_rumah_dalam', 'surat_pernyataan', 'ktp', 'kk']);
        if (errFile != null) return errFile;
        break;

      case 'kelahiran':
        String? errLahir = _checkTexts(formData, [
          'nama_bayi', 'jenis_kelamin_bayi', 'tanggal_lahir', 'jam_lahir',
          'tempat_lahir', 'anak_ke', 'penolong_kelahiran', 'nama_ayah', 'nama_ibu'
        ]);
        if (errLahir != null) return errLahir;
        break;

      case 'kematian':
        String? errMati = _checkTexts(formData, [
          'nama_almarhum', 'nik_almarhum', 'jenis_kelamin_almarhum',
          'tanggal_lahir_almarhum', 'agama_almarhum', 'alamat_almarhum',
          'tanggal_meninggal', 'jam_meninggal', 'tempat_meninggal',
          'penyebab_kematian', 'tempat_pemakaman'
        ]);
        if (errMati != null) return errMati;
        String? errFileMati = _checkFiles(lampiranFiles, ['ktp_almarhum', 'kk_almarhum']);
        if (errFileMati != null) return errFileMati;
        break;

      case 'skck':
        String? errSkck = _checkTexts(formData, ['tujuan_instansi', 'keperluan']);
        if (errSkck != null) return errSkck;
        String? errFileSkck = _checkFiles(lampiranFiles, ['ktp', 'kk']);
        if (errFileSkck != null) return errFileSkck;
        break;

      case 'penghasilan':
        String? errGaji = _checkTexts(formData, ['sumber_penghasilan', 'jumlah_penghasilan', 'keperluan']);
        if (errGaji != null) return errGaji;
        String? errFileGaji = _checkFiles(lampiranFiles, ['ktp', 'kk']);
        if (errFileGaji != null) return errFileGaji;
        break;

      case 'belum_menikah':
        if (_isEmpty(formData['keperluan'])) return "Keperluan Surat wajib diisi!";
        String? errFileNikah = _checkFiles(lampiranFiles, ['ktp', 'kk', 'surat_pernyataan']);
        if (errFileNikah != null) return errFileNikah;
        break;

      case 'beda_nama':
        String? errBeda = _checkTexts(formData, ['dokumen_satu', 'nama_satu', 'dokumen_dua', 'nama_dua', 'keperluan']);
        if (errBeda != null) return errBeda;
        String? errFileBeda = _checkFiles(lampiranFiles, ['ktp', 'kk', 'bukti_satu', 'bukti_dua']);
        if (errFileBeda != null) return errFileBeda;
        break;
    }

    // Pengecekan global: Harus ada minimal 1 file (kecuali untuk form yang memang tidak ada lampirannya)
    if (lampiranFiles.isEmpty && jenisSurat != 'kelahiran') {
      return "Harap lengkapi dokumen lampiran yang diminta!";
    }

    return null; // Semua validasi lolos!
  }

  // --- HELPER FUNCTIONS (DRY Principle) ---

  // Mengecek apakah value null atau kosong
  static bool _isEmpty(dynamic value) {
    return value == null || value.toString().trim().isEmpty;
  }

  // Mengecek List Text Form
  static String? _checkTexts(Map<String, dynamic> formData, List<String> keys) {
    for (String key in keys) {
      if (_isEmpty(formData[key])) {
        String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
        return "Data $labelName wajib diisi!";
      }
    }
    return null;
  }

  // Mengecek List File
  static String? _checkFiles(Map<String, dynamic> lampiranFiles, List<String> keys) {
    for (String key in keys) {
      if (!lampiranFiles.containsKey(key)) {
        String labelName = key.replaceAll('_', ' ').capitalizeFirst ?? key;
        
        // Sedikit penyesuaian khusus agar terbaca rapi
        if (key == 'ktp') labelName = 'KTP';
        if (key == 'kk') labelName = 'Kartu Keluarga (KK)';
        if (key == 'ktp_almarhum') labelName = 'KTP Almarhum';
        if (key == 'kk_almarhum') labelName = 'KK Almarhum';

        return "Lampiran $labelName wajib diunggah!";
      }
    }
    return null;
  }
}