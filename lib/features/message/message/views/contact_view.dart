// Lokasi: lib/features/message/views/contact_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../controllers/contact_controller.dart';
import '../../../../core/config/api_config.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  Map<String, dynamic> _getRoleFormat(String role) {
    switch (role.toLowerCase()) {
      case 'pimpinan':
        return {'text': 'Kepala Desa', 'color': Colors.purple.shade700}; // Warna ungu elegan buat Kades
      case 'operator':
        return {'text': 'Operator Desa', 'color': Colors.teal.shade700}; // Warna teal buat Operator
      case 'rt':
        return {'text': 'Ketua RT', 'color': Colors.orange.shade700}; // Warna orange buat RT
      case 'warga':
      default:
        return {'text': 'Warga', 'color': Colors.blue.shade600}; // Biru standar buat warga
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: const Text("Pilih Kontak", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: controller.searchC,
              onChanged: controller.searchContact,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Cari nama warga atau perangkat...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
          return const Center(child: CircularProgressIndicator(color: Colors.blue));
        }

        if (controller.filteredContacts.isEmpty) {
          return Center(
            child: Text("Kontak tidak ditemukan", style: TextStyle(color: Colors.grey.shade500)),
          );
        }

        return ListView.builder(
          itemCount: controller.filteredContacts.length,
          itemBuilder: (context, index) {
            final user = controller.filteredContacts[index];
            
            // Panggil fungsi format role di sini
            final roleFormat = _getRoleFormat(user.role);

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              onTap: () {
                Get.toNamed(Routes.CHAT_ROOM, arguments: user);
              },
              leading: ClipOval(
                child: (user.avatar != null && user.avatar!.isNotEmpty)
                    ? Image.network(
                        user.avatar!.startsWith('http') ? user.avatar! : "${ApiConfig.baseHost}/${user.avatar}",
                        width: 45, height: 45, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _fallbackAvatar(),
                      )
                    : _fallbackAvatar(),
              ),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              
              subtitle: Text(
                roleFormat['text'], 
                style: TextStyle(
                  color: roleFormat['color'], 
                  fontSize: 13,
                  fontWeight: user.role == 'warga' ? FontWeight.normal : FontWeight.w600 
                )
              ),
            );
          },
        );
      }),
    );
  }

  Widget _fallbackAvatar() {
    return Container(width: 45, height: 45, color: Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey));
  }
}