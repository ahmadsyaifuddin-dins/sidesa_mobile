// Lokasi: lib/features/buat_surat/views/widgets/custom_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isTextArea;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  // --- KEKUATAN BARU ---
  final int? maxLength; 
  final bool isCurrency; 
  final List<TextInputFormatter>? inputFormatters; 
  final bool showCounter;
  final String? initialValue;

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
    this.maxLength,
    this.isCurrency = false,
    this.inputFormatters,
    this.showCounter = false, // Default false agar field lain tidak muncul counter
    this.initialValue,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late TextEditingController _internalController;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    // Gunakan controller dari luar jika ada, jika tidak buat baru
    String startingText = widget.initialValue ?? '';

    // Jika ini inputan uang dan ada nilai awalnya dari DB, format ke ribuan dulu
    if (widget.isCurrency && startingText.isNotEmpty) {
      try {
        final formatter = NumberFormat('#,###', 'id_ID');
        startingText = formatter.format(int.parse(startingText));
      } catch (e) {
        // Abaikan jika bukan angka
      }
    }

    _internalController = widget.controller ?? TextEditingController(text: startingText);
    _charCount = _internalController.text.length;

    // Listener untuk menghitung jumlah karakter secara realtime
    _internalController.addListener(() {
      if (mounted) {
        setState(() {
          _charCount = _internalController.text.length;
        });
      }
    });
  }

  @override
  void dispose() {
    // Hanya buang controller jika kita yang membuatnya secara internal
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logika cerdas untuk Suffix (Icon / Counter)
    Widget? buildSuffix() {
      if (widget.suffixIcon != null) return widget.suffixIcon;
      
      // Jika fitur showCounter aktif dan ada batas maxLength
      if (widget.maxLength != null && widget.showCounter) {
        bool isFull = _charCount == widget.maxLength;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: Text(
            '$_charCount/${widget.maxLength}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              // Berubah hijau jika sudah mencapai target, abu-abu jika belum
              color: isFull ? Colors.green[600] : Colors.grey[400],
            ),
          ),
        );
      }
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700], fontSize: 13),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _internalController,
            maxLines: widget.isTextArea ? 3 : 1,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            maxLength: widget.maxLength, 
            
            inputFormatters: [
              if (widget.inputFormatters != null) ...widget.inputFormatters!,
              if (widget.isCurrency) CurrencyInputFormatter(), 
            ],

            onChanged: (value) {
              if (widget.onChanged != null) {
                if (widget.isCurrency) {
                  String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                  widget.onChanged!(cleanValue);
                } else {
                  widget.onChanged!(value);
                }
              }
            },
            
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.grey[50],
              suffixIcon: buildSuffix(), // <-- Panggil custom suffix di sini
              counterText: "", // <-- Wajib kosong agar counter bawaan di bawah garis menghilang
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

// FORMATTER RUPIAH (Tetap sama seperti sebelumnya)
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return newValue.copyWith(text: '');
    final formatter = NumberFormat('#,###', 'id_ID');
    String formattedString = formatter.format(int.parse(digitsOnly));
    return newValue.copyWith(
      text: formattedString,
      selection: TextSelection.collapsed(offset: formattedString.length),
    );
  }
}