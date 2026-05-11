// Lokasi: lib/features/buat_surat/views/forms/form_kelahiran_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart';
import '../widgets/custom_dropdown_field.dart';

class FormKelahiranWidget extends StatelessWidget {
  const FormKelahiranWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatSuratController>();

    // Tambahkan ?.toString() agar aman dari error null
    final tglController = TextEditingController(text: controller.formData['tanggal_lahir']?.toString());
    final jamController = TextEditingController(text: controller.formData['jam_lahir']?.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SECTION DATA BAYI ---
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.pink[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.child_friendly_rounded, color: Colors.pink[700], size: 20),
            ),
            const SizedBox(width: 10),
            const Text("Data Bayi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const Divider(height: 30),
       
        CustomInputField(
          label: "Nama Bayi",
          hint: "Nama Lengkap Bayi",
          initialValue: controller.formData['nama_bayi']?.toString(), 
          onChanged: (val) => controller.updateForm('nama_bayi', val),
        ),

        CustomDropdownField(
          label: "Jenis Kelamin",
          hint: "-- Pilih --",
          items: const ["LAKI-LAKI", "PEREMPUAN"],
          value: controller.formData['jenis_kelamin_bayi']?.toString(), 
          onChanged: (val) => controller.updateForm('jenis_kelamin_bayi', val),
        ),

        // Date Picker Field (Datanya diurus oleh tglController di atas)
        CustomInputField(
          label: "Tanggal Lahir",
          hint: "Pilih Tanggal",
          readOnly: true,
          controller: tglController, 
          suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000), 
              lastDate: DateTime.now(),  
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              tglController.text = formattedDate;
              controller.updateForm('tanggal_lahir', formattedDate);
            }
          },
        ),

        // Time Picker Field (Datanya diurus oleh jamController di atas)
        CustomInputField(
          label: "Jam Lahir",
          hint: "Pilih Jam",
          readOnly: true,
          controller: jamController,
          suffixIcon: const Icon(Icons.access_time_filled, color: Colors.grey),
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              String formattedTime = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
              jamController.text = formattedTime;
              controller.updateForm('jam_lahir', formattedTime);
            }
          },
        ),

        CustomInputField(
          label: "Tempat Lahir",
          hint: "Nama Kota/Kabupaten",
          initialValue: controller.formData['tempat_lahir']?.toString(), 
          onChanged: (val) => controller.updateForm('tempat_lahir', val),
        ),

        CustomInputField(
          label: "Anak Ke-",
          hint: "Contoh: 1",
          keyboardType: TextInputType.number,
          initialValue: controller.formData['anak_ke']?.toString(), 
          onChanged: (val) => controller.updateForm('anak_ke', val),
        ),

        CustomInputField(
          label: "Penolong Kelahiran",
          hint: "Contoh: Bidan Siti / Dokter Budi",
          initialValue: controller.formData['penolong_kelahiran']?.toString(), 
          onChanged: (val) => controller.updateForm('penolong_kelahiran', val),
        ),

        const SizedBox(height: 20),

        // --- SECTION DATA ORANG TUA ---
        const Text("Data Orang Tua Bayi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(height: 30),

        CustomInputField(
          label: "Nama Ayah Kandung Bayi",
          hint: "Nama Ayah si Bayi",
          initialValue: controller.formData['nama_ayah']?.toString(), 
          onChanged: (val) => controller.updateForm('nama_ayah', val),
        ),

        CustomInputField(
          label: "Nama Ibu Kandung Bayi",
          hint: "Nama Ibu si Bayi",
          initialValue: controller.formData['nama_ibu']?.toString(), 
          onChanged: (val) => controller.updateForm('nama_ibu', val),
        ),

        const SizedBox(height: 10),
        const Text("Lampiran Opsional", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),

        const CustomFileUpload(
          label: "Surat Ket. Lahir (Bidan/RS) - Opsional",
          fileKey: "surat_bidan",
        ),
      ],
    );
  }
}