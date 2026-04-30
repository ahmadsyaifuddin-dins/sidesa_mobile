import 'dart:math';

class GreetingUtil {
  static String getRandomGreeting() {
    final hour = DateTime.now().hour;
    final random = Random();

    String sapaanWaktu = "";
    List<String> ucapanBanjar = [];

    // Penentuan rentang waktu dan ucapan Banjar
    if (hour >= 4 && hour < 11) {
      sapaanWaktu = "Selamat Pagi";
      ucapanBanjar = [
        "Pagi cerah, hancap bagawi manjari rajakian! 🌅",
        "Awali hari lawan bismillah, moga langkar sabarataan. ✨",
        "Matahari tarbit, sumangat balakas bausaha! 🕊️",
      ];
    } else if (hour >= 11 && hour < 15) {
      sapaanWaktu = "Selamat Siang";
      ucapanBanjar = [
        "Matahari manggantang, tatap sumangat walau paluh bacucuran! ☀️",
        "Amun uyuh baranai satumat, gawi bujur-bujur kaina bauntung. 💪",
        "Jangan lali makan siang, nginang banyu nang banyak. 🍛",
      ];
    } else if (hour >= 15 && hour < 18) {
      sapaanWaktu = "Selamat Sore";
      ucapanBanjar = [
        "Hari sanja wayahnya bulik, kumpul rami lawan kaluarga. 🌇",
        "Tuntung sudah gawian, alhamdulillah rasi hari ini. ☕",
        "Banyu surut hari bagamat kadap, bawa baranai di palatar. 🍃",
      ];
    } else {
      sapaanWaktu = "Selamat Malam";
      ucapanBanjar = [
        "Malam kadap wayahnya guring, rihatakan awak gasan isuk. 🌙",
        "Sudahi uyuhmu, moga isuk tabangun dalam barakat. 🌌",
        "Tutup hari lawan sukur, malam damai gasan sabarataan. 😴",
      ];
    }

    // Ambil satu kalimat Banjar secara acak
    String ucapanRandom = ucapanBanjar[random.nextInt(ucapanBanjar.length)];

    // Gabungkan sapaan waktu dan ucapan Banjar
    return "$sapaanWaktu,\n$ucapanRandom";
  }
}
