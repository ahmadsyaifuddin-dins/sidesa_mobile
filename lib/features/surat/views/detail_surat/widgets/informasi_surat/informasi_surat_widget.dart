// Lokasi: lib/features/surat/views/detail_surat/widgets/informasi_surat/informasi_surat_widget.dart

import 'package:flutter/material.dart';
import '../../../../../../data/models/surat_model.dart';
import 'detail_baris_widget.dart';
import 'lampiran_grid_widget.dart';
import '../../../../../../core/utils/string_formatter.dart'; 

class InformasiSuratWidget extends StatelessWidget {
  final SuratModel surat;
  const InformasiSuratWidget({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. SEKSI INFORMASI TEKS ---
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text("Informasi Surat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Column(
            children: [
              DetailBarisWidget(
                icon: Icons.assignment_outlined, 
                label: "JENIS SURAT", 
                value: StringFormatter.formatJenisSurat(surat.namaSurat ?? surat.jenisSurat), 
              ),
              const Divider(height: 24),
              DetailBarisWidget(
                icon: Icons.info_outline, 
                label: "KEPERLUAN", 
                // LOGIKA CERDAS: Jika ada underscore, format jadi rapi. Jika tidak, biarkan asli.
                value: (surat.keteranganPemohon ?? '').contains('_') 
                    ? StringFormatter.formatJenisSurat(surat.keteranganPemohon)
                    : surat.keteranganPemohon
              ),
             
              // Render Data Form Dinamis
              if (surat.dataForm != null && surat.dataForm!.isNotEmpty) ...[
                const Divider(height: 24),
                ...surat.dataForm!.entries.map((entry) {
                  String label = entry.key.replaceAll('_', ' ').toUpperCase();
                  dynamic rawValue = entry.value;

                  // LOGIKA KHUSUS: BACA FORMAT AHLI WARIS
                  if (entry.key == 'ahli_waris' && rawValue is List) {
                    String formattedWaris = "";
                    for (int i = 0; i < rawValue.length; i++) {
                      var w = rawValue[i];
                      if (w is Map) {
                        // Susun rapi: "1. Alpha (L) - 9 Thn - Anak"
                        formattedWaris += "${i + 1}. ${w['nama'] ?? '-'} (${w['jk'] ?? '-'}) - ${w['umur'] ?? '0'} Thn - ${w['hubungan'] ?? '-'}";
                        // Tambahkan enter jika bukan baris terakhir
                        if (i < rawValue.length - 1) formattedWaris += "\n"; 
                      }
                    }
                    rawValue = formattedWaris; // Timpa value aslinya dengan string yang sudah rapi
                  }

                  bool isUang = entry.key.toLowerCase().contains('penghasilan') || 
                                entry.key.toLowerCase().contains('biaya') || 
                                entry.key.toLowerCase().contains('harga') ||
                                entry.key.toLowerCase().contains('gaji');

                  return DetailBarisWidget(
                    icon: Icons.arrow_right_alt_rounded, 
                    label: label, 
                    value: rawValue, // Masukkan rawValue yang sudah difilter
                    isCurrency: isUang,
                  );
                }),
              ],
            ],
          ),
        ),

        const SizedBox(height: 30),

        // --- 2. SEKSI LAMPIRAN GRID ---
        if (surat.fileSyarat != null && surat.fileSyarat!.isNotEmpty)
          LampiranGridWidget(
            lampiranUrls: surat.fileSyarat!, 
            jenisSurat: surat.jenisSurat,
          ),
      ],
    );
  }
}