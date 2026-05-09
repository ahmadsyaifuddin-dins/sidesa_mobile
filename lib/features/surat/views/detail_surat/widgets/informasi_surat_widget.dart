// Lokasi: lib/features/surat/views/detail_surat/widgets/informasi_surat_widget.dart

import 'package:flutter/material.dart';
import '../../../../../data/models/surat_model.dart'; 

class InformasiSuratWidget extends StatelessWidget {
  final SuratModel surat;
  const InformasiSuratWidget({super.key, required this.surat});

  // Helper untuk menentukan apakah data dianggap "kosong"
  bool _isEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) {
      return value.toLowerCase() == 'null' || value.trim().isEmpty;
    }
    if (value is List) return value.isEmpty;
    return false;
  }

  Widget _rowDetail({required IconData icon, required String label, dynamic value}) {
    bool isDataEmpty = _isEmpty(value);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon di sebelah kiri label
          Icon(icon, size: 18, color: Colors.blueGrey[400]),
          const SizedBox(width: 10),
          
          // Bagian Label
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600], 
                fontSize: 12,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          
          // Bagian Value
          Expanded(
            child: Text(
              isDataEmpty ? "Tidak ada data" : value.toString(),
              style: TextStyle(
                fontWeight: isDataEmpty ? FontWeight.normal : FontWeight.bold,
                fontSize: 14,
                fontStyle: isDataEmpty ? FontStyle.italic : FontStyle.normal,
                color: isDataEmpty ? Colors.grey[400] : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            "Informasi Surat",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Column(
            children: [
              _rowDetail(
                icon: Icons.assignment_outlined,
                label: "JENIS SURAT",
                value: surat.namaSurat,
              ),
              const Divider(height: 24),
              _rowDetail(
                icon: Icons.info_outline,
                label: "KEPERLUAN",
                value: surat.keteranganPemohon,
              ),
              
              // Render Data Form Dinamis
              if (surat.dataForm != null && surat.dataForm!.isNotEmpty) ...[
                const Divider(height: 24),
                ...surat.dataForm!.entries.map((entry) {
                  String label = entry.key.replaceAll('_', ' ').toUpperCase();
                  return _rowDetail(
                    icon: Icons.arrow_right_alt_rounded,
                    label: label,
                    value: entry.value,
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}