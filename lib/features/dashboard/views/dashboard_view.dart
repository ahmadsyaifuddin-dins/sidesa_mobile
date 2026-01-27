import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/dashboard/views/tabs/profile_tab.dart';
import '../controllers/dashboard_controller.dart';

// Import Tabs
import 'tabs/home_tab.dart';
import 'tabs/riwayat_tab.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      // BODY BERUBAH SESUAI TAB
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: [
          const HomeTab(),      // Index 0
          const RiwayatTab(),   // Index 1
          const ProfileTab(),   // Index 2
          Container(color: Colors.white, child: Center(child: TextButton(onPressed: ()=>controller.logout(), child: Text("Logout (Sementara)")))), // Index 2 (Profil)
        ],
      )),

      // BOTTOM NAV
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        currentIndex: controller.tabIndex.value, // Ikut variable controller
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          controller.changeTab(index); // Ganti Tab
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profil"),
        ],
      )),
    );
  }
}