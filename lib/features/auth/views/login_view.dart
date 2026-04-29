import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/login_header.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  // Inisialisasi AuthController menggunakan Get.put
  final AuthController controller = Get.put(AuthController());

  // Variabel Animasi
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Setup Animasi (Durasi 1.2 Detik agar smooth)
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    // Jalankan animasi saat halaman dimuat
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Gradient Biru Elegan
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade400, Colors.white],
            stops: const [0.0, 0.4, 0.4],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 1. HEADER (LOGO) - Modular via Widgets
                      LoginHeader(
                        onLogoLongPress: () => controller.showChangeIPDialog(),
                      ),

                      const SizedBox(height: 30),

                      // 2. CARD FORM LOGIN
                      _buildLoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bagian Form Login yang dipisah dalam method agar build() tidak terlalu panjang
  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "SIDESA Mobile",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Selamat datang! Silakan masuk.",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 30),

          // INPUT EMAIL / NIK
          CustomTextField(
            controller: controller.emailC,
            label: "Email / NIK",
            prefixIcon: Icons.person_outline,
          ),

          const SizedBox(height: 20),

          // INPUT PASSWORD (Reaktif menggunakan Obx)
          Obx(
            () => CustomTextField(
              controller: controller.passwordC,
              label: "Password",
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              isObscure: controller.isObscure.value,
              onToggleVisibility: () => controller.toggleObscure(),
            ),
          ),

          const SizedBox(height: 30),

          // TOMBOL LOGIN (Reaktif menggunakan Obx untuk Loading State)
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.login(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blue.withOpacity(0.5),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "MASUK SEKARANG",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
