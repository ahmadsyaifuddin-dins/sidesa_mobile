import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

// Import Widgets yang baru kita buat
import 'widgets/dashboard_header.dart';
import 'widgets/digital_id_card.dart';
import 'widgets/service_menu.dart';
import 'widgets/history_section.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) Get.snackbar("Info", "Segera Hadir");
          if (index == 2) controller.logout();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profil"),
        ],
      ),
      body: RefreshIndicator(
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
                // 1. Header
                DashboardHeader(),
                
                SizedBox(height: 20),

                // 2. Kartu Digital
                DigitalIdCard(),

                SizedBox(height: 25),

                // 3. Menu Layanan
                ServiceMenu(),

                SizedBox(height: 20),

                // 4. Riwayat / Aktivitas
                HistorySection(),
                
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}