import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

// Tambahkan SingleTickerProviderStateMixin untuk animasi bawaan Flutter
class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final AuthController controller = Get.put(AuthController());

  bool _isObscure = true;

  // Variabel Animasi
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi Controller Animasi (Durasi 1.2 Detik)
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animasi Fade In (Transparansi 0 ke 1)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    // Animasi Slide Up (Dari bawah sedikit ke posisi asli)
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    // Mulai animasi saat halaman dibuka!
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose(); // Wajib dibersihkan agar tidak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient yang elegan
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade400,
              Colors.white,
            ],
            stops: const [0.0, 0.4, 0.4], // Membelah background jadi 2 warna
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
                      // 1. LOGO APLIKASI
                      // TAMBAHKAN GestureDetector DI SINI
                      GestureDetector(
                        onLongPress: () {
                          // Panggil fungsi rahasia saat logo ditekan lama
                          controller.showChangeIPDialog(); 
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/logo_pancasila.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 2. CARD FORM LOGIN
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
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

                            // INPUT EMAIL
                            TextField(
                              controller: controller.emailC,
                              decoration: InputDecoration(
                                labelText: "Email / NIK",
                                prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // INPUT PASSWORD
                            TextField(
                              controller: controller.passwordC,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                                ),
                                // Tombol Mata
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // TOMBOL LOGIN
                            Obx(() => SizedBox(
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
                                )),
                          ],
                        ),
                      ),
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
}