import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/snackbar_helper.dart';

class DeveloperInfoCard extends StatelessWidget {
  const DeveloperInfoCard({super.key});

  // Fungsi helper dipindah ke sini agar tidak mengotori file utama
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      SnackbarHelper.error(
        title: "Gagal",
        message: "Tidak dapat membuka tautan",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pengembang Utama",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant, // Warna teks subtitle
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary, // Warna lingkar avatar dinamis
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "AS",
                    style: TextStyle(
                      color: Colors.white, // Inisial tetap putih agar kontras dengan primary
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ahmad Syaifuddin",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Fullstack & Mobile Developer",
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Founder of Karyantara Solution",
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: 16),

          // Tombol Sosial Media
          Text(
            "Terhubung Bersama Saya:",
            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchURL('https://github.com/ahmadsyaifuddin-dins'),
                  icon: const Icon(Icons.code, size: 18),
                  label: const Text(
                    "GitHub",
                    style: TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    // onSurface memastikan warnanya hitam di Light Mode, dan putih di Dark Mode
                    foregroundColor: theme.colorScheme.onSurface, 
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchURL('https://www.instagram.com/dinsss_ai'),
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: const Text(
                    "Instagram",
                    style: TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.pink, // Tetap pink khas Instagram
                    // Trik opacity agar border pink-nya elegan di Dark Mode
                    side: BorderSide(color: Colors.pink.withValues(alpha: 0.3)), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}