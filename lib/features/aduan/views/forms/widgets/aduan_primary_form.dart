import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/aduan_controller.dart';

class AduanPrimaryForm extends StatelessWidget {
  const AduanPrimaryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AduanController>();

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
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(Icons.title, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.blue, width: 2)),
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
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
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
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriorityPill(controller, 'rendah', Colors.green),
              _buildPriorityPill(controller, 'sedang', Colors.orange),
              _buildPriorityPill(controller, 'tinggi', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityPill(AduanController controller, String value, Color color) {
    return Obx(() {
      final isSelected = controller.prioritas.value == value;
      return GestureDetector(
        onTap: () => controller.prioritas.value = value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
            border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: isSelected ? 2 : 1),
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
                  color: isSelected ? color : Colors.grey[700],
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