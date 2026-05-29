// Lokasi: lib/features/surat/views/detail_surat/widgets/status_header_widget.dart

import 'package:flutter/material.dart';
// Sesuaikan path model jika menggunakan package absolute
import '../../../../../data/models/surat_model.dart';

class StatusHeaderWidget extends StatelessWidget {
  final SuratModel surat;
  const StatusHeaderWidget({super.key, required this.surat});

  IconData _getIconStatus(String status) {
    switch (status) {
      case 'selesai':
        return Icons.check_circle;
      case 'ditolak':
        return Icons.cancel;
      case 'menunggu_validasi':
        return Icons.fact_check;
      case 'diproses':
        return Icons.sync;
      case 'pending':
        return Icons.hourglass_top;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 1. Ambil referensi tema

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor, // Background kotak dinamis
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant), // Border dinamis
      ),
      child: Column(
        children: [
          Icon(
            _getIconStatus(surat.status),
            size: 50,
            color: surat.statusColor, // Status color biasanya sudah kontras
          ),
          const SizedBox(height: 10),
          Text(
            surat.status.replaceAll('_', ' ').toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: surat.statusColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Diajukan pada ${surat.tanggalFormatted}",
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12), // Teks tanggal dinamis
          ),
        ],
      ),
    );
  }
}