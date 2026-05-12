import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/features/aduan/views/aduan_view.dart';
import 'package:sidesa_mobile/features/chat/views/chat_view.dart';
import 'package:sidesa_mobile/features/dashboard/views/widgets/home/service_menu/service_menu_item.dart';
import 'package:sidesa_mobile/features/dashboard/views/widgets/home/service_menu/surat_dialog_helper.dart';
import 'package:sidesa_mobile/core/services/activity_logger_service.dart';

class ServiceMenu extends StatelessWidget {
  const ServiceMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Layanan Desa",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BUAT SURAT (Memanggil Helper Dialog)
              ServiceMenuItem(
                icon: Icons.mark_email_unread_outlined,
                label: "Buat Surat",
                color: Colors.orange,
                onTap: () {
                  ActivityLoggerService.log('Menu Layanan: Buat Surat');
                  SuratDialogHelper.showPengajuanSurat();
                },
              ),

              // 2. ADUAN WARGA
              ServiceMenuItem(
                icon: Icons.campaign_outlined,
                label: "Aduan",
                color: Colors.red,
                onTap: () {
                  ActivityLoggerService.log('Menu Layanan: Aduan Warga');
                  Get.to(() => const AduanView());
                },
              ),

              // 3. SIDESA AI
              ServiceMenuItem(
                icon: Icons.support_agent_outlined,
                label: "SiDesa AI",
                color: Colors.teal,
                onTap: () {
                  ActivityLoggerService.log('Menu Layanan: SiDesa AI Chatbot');
                  Get.to(() => const ChatView());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}