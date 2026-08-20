// Lokasi: lib/features/dashboard/views/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/message/message/views/inbox_view.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true, 
     
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: const [
            HomeTab(),       // Index 0
            RiwayatTab(),    // Index 1
            TimelineView(),  // Index 2 
            InboxView(),     // Index 3
            ProfileTab(),    // Index 4
          ],
        ),
      ),

      // --- DYNAMIC FAB TENGAH ---
      floatingActionButton: Obx(() {
        final isForum = controller.tabIndex.value == 2;
        return FloatingActionButton(
          heroTag: 'fab_sidesa', // <-- KUNCI RAHASIA MORPHING / EFEK TERBANG!
          onPressed: () => controller.changeTab(2), 
          backgroundColor: isForum
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withValues(alpha: 0.8),
          elevation: isForum ? 0 : 4,
          shape: const CircleBorder(),
          // Bikin ikonnya berdenyut mulus saat di-tap
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: Icon(
              Icons.forum_rounded,
              key: ValueKey(isForum), 
              color: Colors.white,
              size: isForum ? 32 : 28, // Sedikit membesar saat aktif
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BOTTOM NAV BAR 
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          color: theme.colorScheme.surface,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(context: context, icon: Icons.home_rounded, label: "Home", index: 0, controller: controller),
                      _buildNavItem(context: context, icon: Icons.history_rounded, label: "Riwayat", index: 1, controller: controller),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(context: context, icon: Icons.chat_bubble_rounded, label: "Chat", index: 3, controller: controller),
                      _buildNavItem(context: context, icon: Icons.person_rounded, label: "Profil", index: 4, controller: controller),
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

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required DashboardController controller
  }) {
    final theme = Theme.of(context);
    final isSelected = controller.tabIndex.value == index;
   
    return InkWell(
      onTap: () => controller.changeTab(index),
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
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