// Lokasi: lib/features/dashboard/views/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

// Import Tabs
import 'tabs/home_tab.dart';
import 'tabs/riwayat_tab.dart';
import 'tabs/profile_tab.dart';

// Import View Baru Kita
import '../../timeline/views/timeline_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      extendBody: true, // PENTING: Agar body bisa memanjang sampai ke balik notch/lengkungan
      
      // BODY BERUBAH SESUAI TAB
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            const HomeTab(),       // Index 0
            const RiwayatTab(),    // Index 1
            const TimelineView(),  // Index 2 (Ini halaman Forum SIDESA kita)
            
            // Placeholder sementara untuk halaman Chat DM nanti
            Container(color: Colors.white, child: const Center(child: Text("Halaman Chat DM (Segera)"))), // Index 3
            
            const ProfileTab(),    // Index 4
          ],
        ),
      ),

      // TOMBOL TENGAH (FORUM SIDESA)
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () => controller.changeTab(2), // Arahkan ke Index 2 (Timeline)
          backgroundColor: controller.tabIndex.value == 2 ? Colors.blue.shade800 : Colors.blue.shade500,
          elevation: controller.tabIndex.value == 2 ? 0 : 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.forum_rounded, color: Colors.white, size: 28),
        ),
      ),
      // Atur posisi melayang tepat di tengah navbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BOTTOM NAV BAR DENGAN LENGKUNGAN (NOTCH)
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          color: Colors.blue[50], // Sesuaikan dengan warna bawaan kamu
          shape: const CircularNotchedRectangle(), // Efek lengkungan seperti di gambar
          notchMargin: 8.0, // Jarak lengkungan dengan tombol
          clipBehavior: Clip.antiAlias, 
          child: SizedBox(
            height: 65, // Ketinggian navbar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // KELOMPOK KIRI
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: Icons.home_rounded, 
                        label: "Home", 
                        index: 0, 
                        controller: controller
                      ),
                      _buildNavItem(
                        icon: Icons.history_rounded, 
                        label: "Riwayat", 
                        index: 1, 
                        controller: controller
                      ),
                    ],
                  ),
                ),
                
                // Jarak kosong di tengah untuk memberi ruang pada FloatingActionButton
                const SizedBox(width: 48), 
                
                // KELOMPOK KANAN
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: Icons.chat_bubble_rounded, 
                        label: "Chat", 
                        index: 3, 
                        controller: controller
                      ),
                      _buildNavItem(
                        icon: Icons.person_rounded, 
                        label: "Profil", 
                        index: 4, 
                        controller: controller
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET HELPER UNTUK IKON NAVBAR
  Widget _buildNavItem({
    required IconData icon, 
    required String label, 
    required int index, 
    required DashboardController controller
  }) {
    final isSelected = controller.tabIndex.value == index;
    
    return InkWell(
      onTap: () => controller.changeTab(index),
      borderRadius: BorderRadius.circular(50), // Efek ripple membulat saat disentuh
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue.shade800 : Colors.grey.shade500,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade800 : Colors.grey.shade500,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}