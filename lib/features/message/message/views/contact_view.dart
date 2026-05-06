// Lokasi: lib/features/message/views/contact_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';
import '../../controllers/contact_controller.dart';
import '../../../../core/config/api_config.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

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
                hintText: "Cari nama warga...",
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
                user.role == 'admin' ? 'Perangkat Desa' : 'Warga', 
                style: TextStyle(color: user.role == 'admin' ? Colors.blue.shade700 : Colors.grey.shade600, fontSize: 13)
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