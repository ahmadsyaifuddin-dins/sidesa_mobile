import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600, 
              color: isDark ? Colors.grey[300] : Colors.grey[700], 
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white, // Agar menu popup mengikuti mode gelap
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black, // Mengatur warna teks yang dipilih
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[400], 
                fontSize: 14,
              ),
              filled: true,
              fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? Colors.blue[300]! : Colors.blue,
                ),
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}