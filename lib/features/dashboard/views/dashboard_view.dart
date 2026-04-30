import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

// Import Tabs
import 'tabs/home_tab.dart';
import 'tabs/riwayat_tab.dart';
import 'tabs/profile_tab.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final controller = Get.put(DashboardController());

    return Scaffold(
      // BODY BERUBAH SESUAI TAB
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: const [
            HomeTab(), // Index 0
            RiwayatTab(), // Index 1
            ProfileTab(), // Index 2 (Sudah bersih, hanya 3 children)
          ],
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[800],
          unselectedItemColor: Colors.grey,
          currentIndex: controller.tabIndex.value,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            controller.changeTab(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: "Riwayat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}
