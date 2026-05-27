import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sidesa_mobile/core/config/api_config.dart';
import '../../../../../controllers/dashboard_controller.dart';
import '../qr_bottom_sheet.dart';

class CardFooterQr extends StatelessWidget {
  const CardFooterQr({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
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
                  color: isDark ? const Color(0xFF00E5FF) : Colors.white70, 
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
              color: Colors.white, 
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                isDark
                    ? BoxShadow(
                        color: const Color(0xFF00E5FF).withOpacity(0.3), 
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
    );
  }
}