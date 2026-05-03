import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
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
            ProfileTab(), // Index 2
          ],
        ),
      ),

      // BOTTOM NAV BAR BARU DENGAN WATER DROP EFFECT
      bottomNavigationBar: Obx(
        () => WaterDropNavBar(
          backgroundColor: Colors.blue[50]!,
          waterDropColor: Colors.blue[800]!, // Warna tetesan air (sesuaikan dengan tema SIDESA)
          selectedIndex: controller.tabIndex.value,
          onItemSelected: (index) {
            controller.changeTab(index);
          },
          barItems: [
            BarItem(
              filledIcon: Icons.home_rounded,
              outlinedIcon: Icons.home_outlined,
            ),
            BarItem(
              filledIcon: Icons.history_rounded,
              outlinedIcon: Icons.history, 
            ),
            BarItem(
              filledIcon: Icons.person_rounded,
              outlinedIcon: Icons.person_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}