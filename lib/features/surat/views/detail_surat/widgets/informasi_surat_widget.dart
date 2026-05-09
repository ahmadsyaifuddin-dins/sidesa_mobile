// Lokasi: lib/features/surat/views/detail_surat/widgets/informasi_surat_widget.dart

import 'package:flutter/material.dart';
import '../../../../../data/models/surat_model.dart'; 

class InformasiSuratWidget extends StatelessWidget {
  final SuratModel surat;
  const InformasiSuratWidget({super.key, required this.surat});

  Widget _rowDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Informasi Surat",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _rowDetail("Jenis Surat", surat.namaSurat),
              const Divider(height: 20),
              _rowDetail(
                "Keperluan",
                surat.keteranganPemohon ?? "-",
              ),
              if (surat.dataForm != null) ...[
                const Divider(height: 20),
                ...surat.dataForm!.entries.map((entry) {
                  String label = entry.key.replaceAll('_', ' ').toUpperCase();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _rowDetail(label, entry.value.toString()),
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