// Lokasi: lib/features/buat_surat/views/forms/form_kematian_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart';
import '../widgets/custom_dropdown_field.dart';

class FormKematianWidget extends StatelessWidget {
  const FormKematianWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Controller untuk field tanggal/jam (Inisialisasi dengan data lama jika ada)
    final tglLahirController = TextEditingController(text: controller.formData['tanggal_lahir_almarhum']?.toString());
    final tglMeninggalController = TextEditingController(text: controller.formData['tanggal_meninggal']?.toString());
    final jamMeninggalController = TextEditingController(text: controller.formData['jam_meninggal']?.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SECTION 1: DATA ALMARHUM ---
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: isDark ? Colors.purple.withValues(alpha: 0.15) : Colors.purple[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.person_off_rounded, color: isDark ? Colors.purple[300] : Colors.purple[700], size: 20),
            ),
            const SizedBox(width: 10),
            const Text("Data Almarhum/Almarhumah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const Divider(height: 30),

        CustomInputField(
          label: "Nama Lengkap Almarhum",
          hint: "Sesuai KTP/KK",
          initialValue: controller.formData['nama_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('nama_almarhum', val),
        ),

        CustomInputField(
          label: "NIK Almarhum",
          hint: "Masukkan 16 digit NIK",
          keyboardType: TextInputType.number,
          maxLength: 16,
          showCounter: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          initialValue: controller.formData['nik_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('nik_almarhum', val),
        ),

        CustomDropdownField(
          label: "Jenis Kelamin",
          hint: "-- Pilih --",
          items: const ["LAKI-LAKI", "PEREMPUAN"],
          value: controller.formData['jenis_kelamin_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('jenis_kelamin_almarhum', val),
        ),

        CustomInputField(
          label: "Tempat Lahir",
          hint: "Nama Kota/Kabupaten",
          initialValue: controller.formData['tempat_lahir_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('tempat_lahir_almarhum', val),
        ),

        CustomInputField(
          label: "Tanggal Lahir",
          hint: "Pilih Tanggal",
          readOnly: true,
          controller: tglLahirController,
          suffixIcon: Icon(Icons.calendar_month, color: isDark ? Colors.grey[500] : Colors.grey),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime(1970),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              String formatted = DateFormat('yyyy-MM-dd').format(picked);
              tglLahirController.text = formatted;
              controller.updateForm('tanggal_lahir_almarhum', formatted);
            }
          },
        ),

        CustomDropdownField(
          label: "Agama",
          hint: "-- Pilih --",
          items: const ["ISLAM", "KRISTEN", "KATOLIK", "HINDU", "BUDDHA", "KONGHUCU"],
          value: controller.formData['agama_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('agama_almarhum', val),
        ),

        CustomInputField(
          label: "Alamat Terakhir",
          hint: "Masukkan alamat lengkap...",
          isTextArea: true,
          initialValue: controller.formData['alamat_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('alamat_almarhum', val),
        ),

        const SizedBox(height: 20),

        // --- SECTION 2: KETERANGAN MENINGGAL ---
        const Text("Keterangan Meninggal Dunia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(height: 30),

        CustomInputField(
          label: "Tanggal Meninggal",
          hint: "Pilih Tanggal",
          readOnly: true,
          controller: tglMeninggalController,
          suffixIcon: Icon(Icons.calendar_today, color: isDark ? Colors.grey[500] : Colors.grey),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              String formatted = DateFormat('yyyy-MM-dd').format(picked);
              tglMeninggalController.text = formatted;
              controller.updateForm('tanggal_meninggal', formatted);
            }
          },
        ),

        CustomInputField(
          label: "Jam Meninggal",
          hint: "Pilih Jam",
          readOnly: true,
          controller: jamMeninggalController,
          suffixIcon: Icon(Icons.access_time_filled, color: isDark ? Colors.grey[500] : Colors.grey),
          onTap: () async {
            TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if (picked != null) {
              String formatted = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
              jamMeninggalController.text = formatted;
              controller.updateForm('jam_meninggal', formatted);
            }
          },
        ),

        CustomInputField(
          label: "Tempat Meninggal",
          hint: "Contoh: RSUD Ulin / Rumah",
          initialValue: controller.formData['tempat_meninggal']?.toString(),
          onChanged: (val) => controller.updateForm('tempat_meninggal', val),
        ),

        CustomInputField(
          label: "Penyebab Kematian",
          hint: "Contoh: Sakit / Kecelakaan",
          initialValue: controller.formData['penyebab_kematian']?.toString(),
          onChanged: (val) => controller.updateForm('penyebab_kematian', val),
        ),

        CustomInputField(
          label: "Dimakamkan Di",
          hint: "Nama Tempat Pemakaman",
          initialValue: controller.formData['tempat_pemakaman']?.toString(),
          onChanged: (val) => controller.updateForm('tempat_pemakaman', val),
        ),

        const SizedBox(height: 10),
        const Text("Lampiran Wajib", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),

        const CustomFileUpload(label: "Scan/Foto KTP Almarhum", fileKey: "ktp_almarhum"),
        const CustomFileUpload(label: "Scan/Foto KK Almarhum", fileKey: "kk_almarhum"),
      ],
    );
  }
}