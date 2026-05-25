import 'package:flutter/material.dart';

class AduanHeaderWidget extends StatelessWidget {
  const AduanHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Teks Header dengan Gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
            ).createShader(bounds),
            child: const Text(
              "Sampaikan Aduan Anda",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white, // Harus putih agar gradient muncul
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Laporan Anda membantu kami membangun desa yang lebih baik. Silakan isi formulir di bawah ini dengan data yang valid.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
          ),
          const SizedBox(height: 24),

          // Accordion Panduan
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border.all(color: Colors.blue[100]!),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: Colors.blue[700],
                collapsedIconColor: Colors.grey[500],
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.menu_book_rounded, size: 18, color: Colors.blue[700]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Baca Panduan & Etika", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue[900])),
                          const Text("Penting: Agar laporan cepat diproses.", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      border: Border(top: BorderSide(color: Colors.blue[100]!)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGuideItem("1", "Tulis Laporan dengan Jelas (5W + 1H)", "Sebutkan Lokasi spesifik, Waktu kejadian, dan Kronologi singkat. Hindari kata kasar."),
                        const SizedBox(height: 12),
                        _buildGuideItem("2", "Pilih Prioritas yang Tepat", "Tinggi (Darurat/Bahaya), Sedang (Mengganggu kenyamanan), Rendah (Usulan/Tidak bahaya)."),
                        const SizedBox(height: 12),
                        _buildGuideItem("3", "Fitur Anonim", "Gunakan jika laporan bersifat sensitif. Identitas dirahasiakan sistem."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(String number, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
          child: Text(number, style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}