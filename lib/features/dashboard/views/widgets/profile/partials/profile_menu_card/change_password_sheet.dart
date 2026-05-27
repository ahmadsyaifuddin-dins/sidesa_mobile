// Lokasi: lib/features/dashboard/views/widgets/profile/change_password_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import 'package:sidesa_mobile/features/auth/data/auth_repository.dart';

class ChangePasswordSheet extends StatelessWidget {
  ChangePasswordSheet({super.key});

  final currentPassC = TextEditingController();
  final newPassC = TextEditingController();
  final confirmPassC = TextEditingController();
  final isLoading = false.obs;
  final AuthRepository authRepo = AuthRepository();

  @override
  Widget build(BuildContext context) {
    // Ambil warna dinamis untuk garis outline textfield
    final outlineColor = Theme.of(context).colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Background ikut tema
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ganti Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Pastikan password baru Anda kuat dan mudah diingat.",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _buildTextField("Password Saat Ini", Icons.lock_clock, currentPassC, outlineColor),
            const SizedBox(height: 15),
            _buildTextField("Password Baru", Icons.lock_outline, newPassC, outlineColor),
            const SizedBox(height: 15),
            _buildTextField("Konfirmasi Password Baru", Icons.check_circle_outline, confirmPassC, outlineColor),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading.value ? null : () => _submitPassword(),
                  child: isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Simpan Password", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper agar UI TextField tidak berulang
  Widget _buildTextField(String label, IconData icon, TextEditingController controller, Color outlineColor) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Future<void> _submitPassword() async {
    if (currentPassC.text.isEmpty || newPassC.text.isEmpty || confirmPassC.text.isEmpty) {
      SnackbarHelper.warning(title: "Peringatan", message: "Semua kolom harus diisi!");
      return;
    }

    isLoading.value = true;
    try {
      await authRepo.changePassword(currentPassC.text, newPassC.text, confirmPassC.text);
      Get.back(); // Tutup sheet
      SnackbarHelper.success(title: "Berhasil", message: "Password berhasil diperbarui.");
    } catch (e) {
      SnackbarHelper.error(title: "Gagal", message: e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }
}