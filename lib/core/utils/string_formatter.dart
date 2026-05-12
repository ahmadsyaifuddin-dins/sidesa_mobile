// Lokasi: lib/core/utils/string_formatter.dart

class StringFormatter {
  /// Mengubah format snake_case (keterangan_penghasilan) atau UPPER_CASE
  /// menjadi Title Case (Keterangan Penghasilan) yang rapi.
  static String formatJenisSurat(String? rawText) {
    if (rawText == null || rawText.isEmpty) return "-";

    // 1. Ganti underscore jadi spasi, dan jadikan huruf kecil semua dulu
    String text = rawText.replaceAll('_', ' ').toLowerCase();

    // 2. Pisahkan per kata, lalu jadikan huruf pertama kapital
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        // Logika Pintar: Jika kata tersebut adalah singkatan, jadikan KAPITAL SEMUA
        if (['skck', 'sktm', 'sku', 'ktp', 'kk'].contains(words[i])) {
          words[i] = words[i].toUpperCase();
        } else {
          // Normal Title Case (Contoh: "penghasilan" -> "Penghasilan")
          words[i] = words[i][0].toUpperCase() + words[i].substring(1);
        }
      }
    }

    // 3. Gabungkan kembali dengan spasi
    return words.join(' ');
  }
}