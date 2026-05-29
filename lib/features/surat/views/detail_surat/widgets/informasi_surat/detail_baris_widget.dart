// Lokasi: lib/features/surat/views/detail_surat/widgets/informasi_surat/detail_baris_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailBarisWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic value;
  final bool isCurrency;

  const DetailBarisWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isCurrency = false,
  });

  bool _isEmpty(dynamic val) {
    if (val == null) return true;
    if (val is String) return val.toLowerCase() == 'null' || val.trim().isEmpty;
    if (val is List) return val.isEmpty;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    bool isDataEmpty = _isEmpty(value);
    
    String displayValue = isDataEmpty ? "Tidak ada data" : value.toString();
    if (isCurrency && !isDataEmpty) {
      try {
        final number = int.parse(value.toString().replaceAll(RegExp(r'[^0-9]'), ''));
        displayValue = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
      } catch (e) {
        displayValue = value.toString();
      }
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant), // Ikon dinamis
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant, // Warna label (kiri) dinamis
                fontSize: 12, 
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: TextStyle(
                fontWeight: isDataEmpty ? FontWeight.normal : (isCurrency ? FontWeight.w800 : FontWeight.bold),
                fontSize: 14,
                fontStyle: isDataEmpty ? FontStyle.italic : FontStyle.normal,
                // Logika Warna Dinamis:
                // - Kosong: Abu-abu
                // - Uang: Hijau gelap (Light Mode) / Hijau terang (Dark Mode)
                // - Normal: Teks solid (Hitam di Light, Putih di Dark)
                color: isDataEmpty 
                    ? theme.colorScheme.onSurfaceVariant.withOpacity(0.6) 
                    : (isCurrency 
                        ? (isDark ? Colors.green.shade400 : Colors.green.shade700) 
                        : theme.colorScheme.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}