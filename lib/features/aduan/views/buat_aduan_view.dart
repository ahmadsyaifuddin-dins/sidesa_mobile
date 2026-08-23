import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/aduan_controller.dart';
import 'forms/widgets/aduan_header_widget.dart';
import 'forms/widgets/aduan_primary_form.dart';
import 'forms/widgets/aduan_detail_form.dart';
import 'forms/widgets/aduan_action_widget.dart';

class BuatAduanView extends StatelessWidget {
  const BuatAduanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan controller ditemukan
    Get.find<AduanController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Buat Aduan Baru",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AduanHeaderWidget(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  boxShadow: isDark ? null : const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Hiasan Progress Bar di atas Card
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // 2. Form Utama (Judul, Kategori, Urgensi)
                          AduanPrimaryForm(),
                          
                          Divider(height: 40, color: isDark ? Colors.grey[800] : Colors.grey[200], thickness: 1),
                          
                          // 3. Form Detail (Deskripsi, Foto, Anonim)
                          AduanDetailForm(),
                          
                          SizedBox(height: 30),
                          
                          // 4. Action Buttons
                          AduanActionWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer Note
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "Dengan mengirimkan laporan, Anda setuju bahwa data yang dikirimkan adalah benar dan dapat dipertanggungjawabkan.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}