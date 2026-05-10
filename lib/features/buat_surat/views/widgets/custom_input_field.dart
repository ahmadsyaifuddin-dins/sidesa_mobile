import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isTextArea;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  
  // TAMBAHAN UNTUK DATE/TIME PICKER
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hint,
    this.onChanged,
    this.isTextArea = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 13),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            maxLines: isTextArea ? 3 : 1,
            keyboardType: keyboardType,
            readOnly: readOnly, // Jika true, keyboard HP tidak akan muncul
            onTap: onTap, // Menjalankan fungsi saat field diklik
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.grey[50],
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}