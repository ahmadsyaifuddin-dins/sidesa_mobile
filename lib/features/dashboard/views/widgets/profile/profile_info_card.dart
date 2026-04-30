import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dashboard_controller.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

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
                      color: controller.isDataHidden.value
                          ? Colors.blue[50]
                          : Colors.grey[100],
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
                              ? Colors.blue[600]
                              : Colors.grey[600],
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
                                ? Colors.blue[600]
                                : Colors.grey[600],
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Bagian Avatar Dinamis (Abaikan karena ini sudah pindah ke ProfileHeader, namun aku menyesuaikan desain lama yang ada ikon centangnya)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
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
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Bersumber dari database desa",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.grey[100], thickness: 1.5, height: 0),
                const SizedBox(height: 15),

                // Info Data - Menggunakan parameter tambahan isObscurable
                _buildModernInfoRow(
                  Icons.credit_card_outlined,
                  "Nomor Induk Kependudukan",
                  controller.userNik,
                  isObscurable: true,
                ),
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  Icons.person_outline,
                  "Jenis Kelamin",
                  controller.userJenisKelamin,
                  isObscurable: false,
                ), // Jenis kelamin tidak perlu disensor
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  Icons.calendar_today_outlined,
                  "Tanggal Lahir",
                  controller.userTanggalLahir,
                  isObscurable: true,
                ),
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  Icons.phone_android_outlined,
                  "No. Telepon",
                  controller.userNoTelp,
                  isObscurable: true,
                ),
                const SizedBox(height: 15),
                _buildModernInfoRow(
                  Icons.location_on_outlined,
                  "Alamat Domisili",
                  controller.userAlamat,
                  isObscurable: true,
                ),
                const SizedBox(height: 15),
                _buildModernInfoRow(
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

  // Tambahkan parameter opsional 'isObscurable' dengan default true
  Widget _buildModernInfoRow(
    IconData icon,
    String label,
    RxString value, {
    bool isObscurable = true,
  }) {
    final controller = Get.find<DashboardController>();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blue[600], size: 22),
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
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() {
                // Logika Sensor Data
                String displayValue = value.value.isEmpty ? "-" : value.value;

                // Jika isObscurable true, data tidak '-', dan status hidden sedang aktif
                if (isObscurable &&
                    displayValue != "-" &&
                    controller.isDataHidden.value) {
                  // Ganti seluruh karakter dengan bullet/titik sensor
                  displayValue = "••••••••••••";
                }

                return Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        controller.isDataHidden.value &&
                            isObscurable &&
                            value.value != "-"
                        ? Colors.grey[400]
                        : Colors.black87,
                    letterSpacing: controller.isDataHidden.value && isObscurable
                        ? 2.0
                        : 0.0, // Beri jarak spasi agar sensor terlihat lebih bagus
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
