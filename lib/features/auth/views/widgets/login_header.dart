import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  // Kita gunakan callback agar widget ini tidak bergantung langsung pada AuthController
  // sehingga lebih reusable dan clean.
  final VoidCallback onLogoLongPress;

  const LoginHeader({super.key, required this.onLogoLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLogoLongPress,
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
          'assets/SIDESA_MOBILE.png',
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
