// Lokasi: lib/features/auth/views/login_view.dart

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
  final AuthController controller = Get.put(AuthController());

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

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

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dinamis
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Gradasi Dinamis: Biru Elegan (Light) vs Deep Space Blue (Dark)
            colors: isDark
                ? [
                    const Color(0xFF0A1931), // Biru sangat gelap
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor,
                  ]
                : [
                    Colors.blue.shade800,
                    Colors.blue.shade400,
                    theme.scaffoldBackgroundColor, // Transisi ke background default
                  ],
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
                      // 1. HEADER (LOGO)
                      LoginHeader(
                        onLogoLongPress: () => controller.showChangeIPDialog(),
                      ),

                      const SizedBox(height: 30),

                      // 2. CARD FORM LOGIN (Lempar context ke helper)
                      _buildLoginForm(context),
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

  // Helper Widget dengan parameter context
  Widget _buildLoginForm(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor, // Background card dinamis
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)), // Tambahan border halus
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05), // Shadow dinamis
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "SIDESA Mobile",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface, // Teks judul dinamis
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Selamat datang! Silakan masuk.",
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant), // Teks sub dinamis
          ),
          const SizedBox(height: 30),

          // INPUT EMAIL / NIK
          // Pastikan CustomTextField milikmu juga sudah adaptif terhadap tema ya!
          CustomTextField(
            controller: controller.emailC,
            label: "Email / NIK",
            prefixIcon: Icons.person_outline,
          ),

          const SizedBox(height: 20),

          // INPUT PASSWORD
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

          // TOMBOL LOGIN
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.login(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary, // Dinamis
                  foregroundColor: theme.colorScheme.onPrimary, // Dinamis
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  shadowColor: theme.colorScheme.primary.withOpacity(0.5),
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
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