import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/aduan_controller.dart';

class AduanPrimaryForm extends StatelessWidget {
  const AduanPrimaryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AduanController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color fieldFill = isDark ? const Color(0xFF2C2C2C) : Colors.grey[50]!;
    final Color borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- JUDUL ---
        const Text("Judul Laporan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.judulC,
          decoration: InputDecoration(
            hintText: "Contoh: Lampu jalan mati di RT 05",
            hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6), fontSize: 14),
            prefixIcon: Icon(Icons.title, color: theme.colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: fieldFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.colorScheme.primary, width: 2)),
          ),
        ),
        const SizedBox(height: 20),

        // --- KATEGORI ---
        const Text("Kategori Masalah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: fieldFill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurfaceVariant),
                value: controller.kategori.value,
                items: controller.listKategori.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => controller.kategori.value = val!,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // --- URGENSI / PRIORITAS ---
        const Text("Tingkat Urgensi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: fieldFill,
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriorityPill(context, controller, 'rendah', Colors.green),
              _buildPriorityPill(context, controller, 'sedang', Colors.orange),
              _buildPriorityPill(context, controller, 'tinggi', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityPill(BuildContext context, AduanController controller, String value, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final isSelected = controller.prioritas.value == value;
      return GestureDetector(
        onTap: () => controller.prioritas.value = value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : (isDark ? const Color(0xFF3A3A3A) : Colors.white),
            border: Border.all(
              color: isSelected ? color : (isDark ? Colors.grey.shade600 : Colors.grey.shade300),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                value.capitalizeFirst!,
                style: TextStyle(
                  color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}