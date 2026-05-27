import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dashboard_controller.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Judul & Tombol Privasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Informasi Akun",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              // Tombol Mata (Hide/Show)
              Obx(
                () => GestureDetector(
                  onTap: () => controller.toggleDataVisibility(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      // Agar warna tombol dinamis di Dark Mode
                      color: controller.isDataHidden.value
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.isDataHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 16,
                          color: controller.isDataHidden.value
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          controller.isDataHidden.value
                              ? "Tampilkan"
                              : "Sembunyikan",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: controller.isDataHidden.value
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Bagian Header Card (Icon Centang Hijau)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // Menggunakan opacity agar di Dark Mode tidak mencolok
                        color: Colors.green.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        color: Colors.green,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Data Kependudukan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // Color sengaja dihapus agar otomatis hitam/putih
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Bersumber dari database desa",
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(
                  color: theme.colorScheme.outlineVariant,
                  thickness: 1.5,
                  height: 0,
                ),
                const SizedBox(height: 15),

                // Info Data - SEKARANG SUDAH DITAMBAHKAN PARAMETER 'context'
                _buildModernInfoRow(
                  context,
                  Icons.credit_card_outlined,
                  "Nomor Induk Kependudukan",
                  controller.userNik,
                  isObscurable: true,
                ),
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  context,
                  Icons.person_outline,
                  "Jenis Kelamin",
                  controller.userJenisKelamin,
                  isObscurable: false,
                ), // Jenis kelamin tidak perlu disensor
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  "Tanggal Lahir",
                  controller.userTanggalLahir,
                  isObscurable: true,
                ),
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  context,
                  Icons.phone_android_outlined,
                  "No. Telepon",
                  controller.userNoTelp,
                  isObscurable: true,
                ),
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  context,
                  Icons.location_on_outlined,
                  "Alamat Domisili",
                  controller.userAlamat,
                  isObscurable: true,
                ),
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  context,
                  Icons.alternate_email_outlined,
                  "Alamat Email",
                  controller.userEmail,
                  isObscurable: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Row dinamis yang sudah dilengkapi context
  Widget _buildModernInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    RxString value, {
    bool isObscurable = true,
  }) {
    final controller = Get.find<DashboardController>();
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() {
                // Logika Sensor Data
                String displayValue = value.value.isEmpty ? "-" : value.value;

                bool isHidden = isObscurable &&
                    displayValue != "-" &&
                    controller.isDataHidden.value;

                if (isHidden) {
                  // Ganti seluruh karakter dengan bullet/titik sensor
                  displayValue = "••••••••••••";
                }

                return Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    // Logika warna dinamis:
                    color: isHidden
                        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.5)
                        : null,
                    letterSpacing: isHidden ? 2.0 : 0.0,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}