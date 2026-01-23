import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Cari controller yang sudah di-put di DashboardView
    final controller = Get.find<DashboardController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Assalamualaikum,",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Obx(() => Text(
                    controller.userName.value.isNotEmpty
                        ? controller.userName.value
                        : "Warga Desa",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
            ],
          ),
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue[50],
          child: IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.blue, size: 20),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}