import 'package:flutter/material.dart';

class AduanHeaderWidget extends StatelessWidget {
  const AduanHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
            style: TextStyle(
              fontSize: 14, 
              color: theme.colorScheme.onSurfaceVariant, // Warna teks abu-abu dinamis
              height: 1.5
            ),
          ),
          const SizedBox(height: 24),

          // Accordion Panduan
          Container(
            decoration: BoxDecoration(
              // Background dinamis
              color: isDark ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.blue[50],
              border: Border.all(
                color: isDark ? theme.colorScheme.primary.withValues(alpha: 0.3) : Colors.blue[100]!
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: theme.colorScheme.primary,
                collapsedIconColor: theme.colorScheme.onSurfaceVariant,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.menu_book_rounded, size: 18, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Baca Panduan & Etika", 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 14, 
                              color: isDark ? theme.colorScheme.primary : Colors.blue[900]
                            )
                          ),
                          Text(
                            "Penting: Agar laporan cepat diproses.", 
                            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.transparent : Colors.white.withValues(alpha: 0.5),
                      border: Border(
                        top: BorderSide(
                          color: isDark ? theme.colorScheme.outlineVariant : Colors.blue[100]!
                        )
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGuideItem(theme, isDark, "1", "Tulis Laporan dengan Jelas (5W + 1H)", "Sebutkan Lokasi spesifik, Waktu kejadian, dan Kronologi singkat. Hindari kata kasar."),
                        const SizedBox(height: 12),
                        _buildGuideItem(theme, isDark, "2", "Pilih Prioritas yang Tepat", "Tinggi (Darurat/Bahaya), Sedang (Mengganggu kenyamanan), Rendah (Usulan/Tidak bahaya)."),
                        const SizedBox(height: 12),
                        _buildGuideItem(theme, isDark, "3", "Fitur Anonim", "Gunakan jika laporan bersifat sensitif. Identitas dirahasiakan sistem."),
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

  // Helper dengan parsing theme
  Widget _buildGuideItem(ThemeData theme, bool isDark, String number, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.blue[100], 
            shape: BoxShape.circle
          ),
          child: Text(
            number, 
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}