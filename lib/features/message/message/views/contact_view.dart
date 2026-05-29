// Lokasi: lib/features/message/views/contact_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../controllers/contact_controller.dart';
import '../../../../core/config/api_config.dart';
import 'widgets/skeleton_contact_item.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  // Fungsi Role Format sekarang membutuhkan parameter "isDark" agar warna kontrasnya pas
  Map<String, dynamic> _getRoleFormat(String role, bool isDark) {
    switch (role.toLowerCase()) {
      case 'pimpinan':
        return {
          'text': 'Kepala Desa',
          'color': isDark ? Colors.purple.shade300 : Colors.purple.shade700
        };
      case 'operator':
        return {
          'text': 'Operator Desa',
          'color': isDark ? Colors.teal.shade300 : Colors.teal.shade700
        };
      case 'rt':
        return {
          'text': 'Ketua RT',
          'color': isDark ? Colors.orange.shade300 : Colors.orange.shade700
        };
      case 'warga':
      default:
        return {
          'text': 'Warga',
          'color': isDark ? Colors.blue.shade300 : Colors.blue.shade600
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Background utama ngikut tema
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface, // Menyatu dengan tema
        foregroundColor: theme.colorScheme.onSurface, // Teks dan icon ngikut tema
        titleSpacing: 0,
        elevation: 0,
        shadowColor: theme.shadowColor.withOpacity(0.2), // Sedikit bayangan
        title: const Text("Pilih Kontak", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: controller.searchC,
              onChanged: controller.searchContact,
              style: TextStyle(color: theme.colorScheme.onSurface), // Teks inputan
              decoration: InputDecoration(
                hintText: "Cari nama warga atau perangkat...",
                hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7)),
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                filled: true,
                // Di mode gelap jadi abu-abu elegan, di mode terang abu-abu sangat muda
                fillColor: theme.colorScheme.surfaceVariant, 
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            itemCount: 8, // Tampilkan 8 item bayangan
            itemBuilder: (context, index) {
              return const SkeletonContactItem();
            },
          );
        }

        if (controller.filteredContacts.isEmpty) {
          return Center(
            child: Text(
              "Kontak tidak ditemukan",
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.filteredContacts.length,
          itemBuilder: (context, index) {
            final user = controller.filteredContacts[index];
            
            // Panggil fungsi format role dengan melempar status isDark
            final roleFormat = _getRoleFormat(user.role, isDark);

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              onTap: () {
                Get.toNamed(Routes.CHAT_ROOM, arguments: user);
              },
              leading: ClipOval(
                child: (user.avatar != null && user.avatar!.isNotEmpty)
                    ? Image.network(
                        user.avatar!.startsWith('http')
                            ? user.avatar!
                            : "${ApiConfig.baseHost}/${user.avatar}",
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _fallbackAvatar(context),
                      )
                    : _fallbackAvatar(context),
              ),
              title: Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: theme.colorScheme.onSurface, // Nama dinamis
                ),
              ),
              subtitle: Text(
                roleFormat['text'],
                style: TextStyle(
                  color: roleFormat['color'], // Warna dari _getRoleFormat
                  fontSize: 13,
                  fontWeight: user.role == 'warga' ? FontWeight.normal : FontWeight.w600,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Fallback Avatar disesuaikan agar tidak silau di Dark Mode
  Widget _fallbackAvatar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 45,
      height: 45,
      color: theme.colorScheme.surfaceVariant, // Background abu-abu dinamis
      child: Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant),
    );
  }
}