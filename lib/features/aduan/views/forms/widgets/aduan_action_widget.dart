import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/aduan_controller.dart';

class AduanActionWidget extends StatelessWidget {
  const AduanActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AduanController>();

    return Row(
      children: [
        // Tombol Batal
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () {
              // Reset form dan kembali ke halaman sebelumnya
              controller.resetForm();
              Get.back();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text("Batal", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(width: 12),
        // Tombol Kirim
        Expanded(
          flex: 2,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => controller.kirimAduan(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                elevation: controller.isLoading.value ? 0 : 4,
                shadowColor: Colors.blue.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("KIRIM LAPORAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(width: 8),
                        Icon(Icons.send_rounded, size: 18),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}