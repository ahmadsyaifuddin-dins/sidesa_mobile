import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/dashboard_controller.dart';

class CardUserInfo extends StatelessWidget {
  const CardUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Obx(() => Text(
            controller.userName.value.toUpperCase(),
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              final rawNik = controller.userNik.value;
              final displayedNik = controller.isNikHidden.value
                  ? (rawNik.length >= 6 ? "${rawNik.substring(0, 6)}••••••••••" : "••••••••••••••••")
                  : rawNik;

              return Text(
                displayedNik,
                style: TextStyle(
                  color: isDark ? const Color(0xFFE0F7FA) : Colors.blue.shade100, 
                  fontSize: 16,
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              );
            }),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => controller.toggleNikVisibility(),
              child: Obx(() => Icon(
                controller.isNikHidden.value
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              )),
            ),
          ],
        ),
      ],
    );
  }
}