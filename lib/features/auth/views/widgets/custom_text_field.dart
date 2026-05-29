// Lokasi: lib/features/auth/views/widgets/custom_text_field.dart

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.isObscure = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 1. Ambil referensi tema
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color: theme.colorScheme.onSurface), // Warna teks inputan dinamis
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant), // Warna label dinamis
        prefixIcon: Icon(prefixIcon, color: theme.colorScheme.primary), // Warna ikon prefix dinamis
        filled: true,
        // Warna background field: Abu-abu elegan (Dark) vs Abu-abu muda (Light)
        fillColor: isDark ? theme.colorScheme.surfaceVariant.withOpacity(0.5) : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2), // Warna border aktif dinamis
        ),
        // Logika untuk memunculkan tombol mata jika ini adalah form password
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: theme.colorScheme.onSurfaceVariant, // Warna ikon mata dinamis
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}