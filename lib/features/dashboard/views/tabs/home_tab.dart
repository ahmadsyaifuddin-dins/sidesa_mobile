import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/digital_id_card.dart';
import '../widgets/history_section.dart';
import '../widgets/service_menu.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita pakai controller yang sudah ada
    final controller = Get.find<DashboardController>(); 

    return RefreshIndicator(
      onRefresh: () async {
        controller.loadUserData();
        await controller.fetchHistory();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              DashboardHeader(),
              SizedBox(height: 20),
              DigitalIdCard(),
              SizedBox(height: 25),
              ServiceMenu(),
              SizedBox(height: 20),
              HistorySection(), // HistorySection perlu diedit sedikit biar cuma nampilin 3
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}