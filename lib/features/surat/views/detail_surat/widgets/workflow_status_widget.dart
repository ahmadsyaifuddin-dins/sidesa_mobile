// Lokasi: lib/features/surat/views/detail_surat/widgets/workflow_status_widget.dart

import 'package:flutter/material.dart';
import '../../../../../data/models/surat_model.dart';

class WorkflowStatusWidget extends StatelessWidget {
  final SuratModel surat;
  const WorkflowStatusWidget({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Ambil referensi tema
    final isDark = theme.brightness == Brightness.dark;

    // Tentukan index aktif berdasarkan status
    // 0: Admin (Pending), 1: Kades (Validasi), 2: Selesai
    int activeStep = 0;
    bool isRejected = surat.status == 'ditolak';

    if (surat.status == 'diproses' || surat.status == 'menunggu_validasi') {
      activeStep = 1;
    } else if (surat.status == 'selesai') {
      activeStep = 2;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.cardColor, // Background dinamis
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant), // Border dinamis
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05), // Shadow dinamis
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStep(
            theme: theme,
            isDark: isDark,
            index: 0,
            activeIndex: activeStep,
            label: "Operator",
            icon: Icons.admin_panel_settings_outlined,
            isRejected: isRejected && activeStep == 0,
          ),
          _buildArrow(theme, isDark, 0, activeStep),
          _buildStep(
            theme: theme,
            isDark: isDark,
            index: 1,
            activeIndex: activeStep,
            label: "Validasi",
            icon: Icons.rate_review_outlined,
            isRejected: isRejected && activeStep == 1,
          ),
          _buildArrow(theme, isDark, 1, activeStep),
          _buildStep(
            theme: theme,
            isDark: isDark,
            index: 2,
            activeIndex: activeStep,
            label: "Selesai",
            icon: Icons.task_alt,
            isRejected: false, // Selesai tidak mungkin ditolak
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required ThemeData theme,
    required bool isDark,
    required int index,
    required int activeIndex,
    required String label,
    required IconData icon,
    required bool isRejected,
  }) {
    bool isActive = index == activeIndex;
    bool isDone = index < activeIndex;
    
    Color color;
    if (isRejected) {
      color = theme.colorScheme.error;
    } else if (isActive) {
      // Step terakhir warna hijau, sisanya warna primary
      color = index == 2 ? Colors.green : theme.colorScheme.primary;
    } else if (isDone) {
      color = Colors.green;
    } else {
      // Warna step yang belum dilalui dinamis
      color = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    }

    return Expanded(
      child: Column(
        children: [
          // Lingkaran Icon dengan Efek Glow jika Active
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(isActive ? 10 : 8),
            decoration: BoxDecoration(
              color: isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: isActive ? 2.5 : 1.5,
              ),
              boxShadow: isActive
                ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 2)]
                : [],
            ),
            child: Icon(
              isDone ? Icons.check : icon,
              size: isActive ? 24 : 18,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          // Label Teks
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              // Warna label dinamis
              color: isActive 
                  ? theme.colorScheme.onSurface 
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow(ThemeData theme, bool isDark, int index, int activeIndex) {
    bool isPassed = index < activeIndex;
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Sejajarkan dengan posisi icon
      child: Icon(
        Icons.chevron_right_rounded,
        size: 16,
        color: isPassed 
            ? Colors.green 
            : (isDark ? Colors.grey.shade700 : Colors.grey.shade300), // Warna panah dinamis
      ),
    );
  }
}