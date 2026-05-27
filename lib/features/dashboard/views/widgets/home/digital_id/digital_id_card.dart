// Lokasi: lib/features/dashboard/views/widgets/home/digital_id/digital_id_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sidesa_mobile/core/config/api_config.dart';
import 'package:sidesa_mobile/features/dashboard/controllers/dashboard_controller.dart';
// Import fungsi bottom sheet yang sudah kita pisahkan
import 'qr_bottom_sheet.dart';

class DigitalIdCard extends StatelessWidget {
  const DigitalIdCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // --- RACIKAN WARNA "NENDANG" & GLOWING ---
          colors: isDark
              ? const [
                  Color(0xFF0A1931), // Deep Space Blue (Sangat Gelap)
                  Color(0xFF00E5FF), // Neon Cyan (Garis Cahaya / Shine di tengah)
                  Color(0xFF0D47A1), // Royal Blue (Biru Elegan)
                ]
              : [
                  Colors.blue.shade800, // Light mode asli
                  Colors.blue.shade600, // Light mode asli
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // Mengatur titik persebaran cahaya agar presisi menyilang di tengah
          stops: isDark ? const [0.1, 0.6, 1.0] : null,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          isDark
              ? BoxShadow(
                  // Efek Glow berpendar warna Cyan di Dark Mode
                  color: const Color(0xFF00E5FF).withOpacity(0.25), 
                  blurRadius: 25, 
                  spreadRadius: 2,
                  offset: const Offset(0, 10), 
                )
              : BoxShadow(
                  color: Colors.blue.withOpacity(0.4), 
                  blurRadius: 15, 
                  offset: const Offset(0, 8), 
                ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              bottom: -20,
              child: Opacity(
                opacity: isDark ? 0.25 : 0.15, // Peta NKRI sedikit diterangkan di mode gelap
                child: Image.asset(
                  'assets/map_nkri.png',
                  width: 350,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER KARTU (SIDESA & KARTU WARGA DIGITAL) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Flexible(
                        flex: 2,
                        child: Text(
                          "SIDESA Mobile",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.verified_user_rounded, color: Colors.white.withOpacity(0.8), size: 14),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "KARTU WARGA DIGITAL",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // --- DATA WARGA ---
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Obx(() => Text(
                      controller.userName.value.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white, // Nama tetap putih solid agar pop-out
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  const SizedBox(height: 5),
                  Obx(() => Text(
                    controller.userNik.value,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFE0F7FA) : Colors.blue.shade100, // Cyan pudar di Dark Mode
                      fontSize: 16,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  )),
                  const SizedBox(height: 25),
                  
                  // --- FOOTER KARTU & QR CODE ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Desa Anjir Muara Kota Tengah",
                              style: TextStyle(
                                color: isDark ? Colors.white.withOpacity(0.9) : Colors.blue.shade100,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Dokumen Digital Sah",
                              style: TextStyle(
                                color: isDark ? const Color(0xFF00E5FF) : Colors.white70, // Neon Cyan di Dark Mode
                                fontSize: 10, 
                                fontStyle: FontStyle.italic, 
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => showQrBottomSheet(context, controller),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white, // KUNCI: Wajib putih untuk mesin scanner
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              isDark
                                  ? BoxShadow(
                                      color: const Color(0xFF00E5FF).withOpacity(0.3), // Glow kecil di bawah QR
                                      blurRadius: 8, 
                                      offset: const Offset(0, 2), 
                                    )
                                  : const BoxShadow(
                                      color: Colors.black26, 
                                      blurRadius: 4, 
                                      offset: Offset(0, 2), 
                                    ),
                            ],
                          ),
                          child: Obx(() {
                            final nik = controller.userNik.value;
                            final webUrl = nik.isNotEmpty ? "${ApiConfig.webUrl}/identitas-warga/$nik" : "SIDESA_GUEST";
                            
                            return QrImageView(
                              data: webUrl,
                              version: QrVersions.auto,
                              size: 55.0,
                              backgroundColor: Colors.transparent,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.black87,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.black87,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}