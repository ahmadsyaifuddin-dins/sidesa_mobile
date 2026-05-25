// Lokasi: lib/features/buat_surat/views/forms/form_ahli_waris_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/buat_surat_controller.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_file_upload.dart';
import '../widgets/custom_dropdown_field.dart';

class FormAhliWarisWidget extends StatefulWidget {
  const FormAhliWarisWidget({super.key});

  @override
  State<FormAhliWarisWidget> createState() => _FormAhliWarisWidgetState();
}

class _FormAhliWarisWidgetState extends State<FormAhliWarisWidget> {
  final controller = Get.find<BuatSuratController>();

  @override
  void initState() {
    super.initState();
    // Inisialisasi list ahli_waris jika form baru dibuka dan masih kosong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.formData['ahli_waris'] == null) {
        controller.updateForm('ahli_waris', [<String, dynamic>{}]);
      }
    });
  }

  // Helper untuk update data di dalam list ahli waris
  void _updateWaris(int index, String key, String? value) {
    List<dynamic> currentList = List.from(controller.formData['ahli_waris'] ?? [{}]);
    if (currentList.length > index) {
      currentList[index][key] = value ?? ''; // Beri nilai default string kosong jika null
      controller.updateForm('ahli_waris', currentList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tglLahirController = TextEditingController(text: controller.formData['tanggal_lahir_almarhum']?.toString());
    final tglMeninggalController = TextEditingController(text: controller.formData['tanggal_meninggal']?.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BANNER INFORMASI ---
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.indigo[50],
            border: Border.all(color: Colors.indigo[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.family_restroom_rounded, color: Colors.indigo[500], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Surat Keterangan Ahli Waris",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[900], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Isi data almarhum/almarhumah dengan benar, kemudian tambahkan daftar nama ahli waris yang sah (Maksimal 3 orang).",
                      style: TextStyle(color: Colors.indigo[800], fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- SECTION A: DATA ALMARHUM ---
        const Text("A. DATA ALMARHUM/ALMARHUMAH", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Divider(height: 20),
        
        CustomInputField(
          label: "Nama Almarhum",
          hint: "Nama lengkap sesuai KTP",
          initialValue: controller.formData['nama_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('nama_almarhum', val),
        ),
        
        CustomInputField(
          label: "NIK Almarhum",
          hint: "16 Digit NIK",
          keyboardType: TextInputType.number,
          maxLength: 16,
          showCounter: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          initialValue: controller.formData['nik_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('nik_almarhum', val),
        ),

        CustomInputField(
          label: "Tempat Lahir",
          hint: "Kota/Kabupaten Lahir",
          initialValue: controller.formData['tempat_lahir_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('tempat_lahir_almarhum', val),
        ),

        CustomInputField(
          label: "Tanggal Lahir",
          hint: "Pilih Tanggal",
          readOnly: true,
          controller: tglLahirController,
          suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context, initialDate: DateTime(1970), firstDate: DateTime(1900), lastDate: DateTime.now(),
            );
            if (picked != null) {
              String formatted = DateFormat('yyyy-MM-dd').format(picked);
              tglLahirController.text = formatted;
              controller.updateForm('tanggal_lahir_almarhum', formatted);
            }
          },
        ),

        CustomInputField(
          label: "Tanggal Meninggal",
          hint: "Pilih Tanggal",
          readOnly: true,
          controller: tglMeninggalController,
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now(),
            );
            if (picked != null) {
              String formatted = DateFormat('yyyy-MM-dd').format(picked);
              tglMeninggalController.text = formatted;
              controller.updateForm('tanggal_meninggal', formatted);
            }
          },
        ),

        CustomInputField(
          label: "Tempat Meninggal",
          hint: "Contoh: RSUD Ulin / Rumah Kediaman",
          initialValue: controller.formData['tempat_meninggal']?.toString(),
          onChanged: (val) => controller.updateForm('tempat_meninggal', val),
        ),

        CustomInputField(
          label: "Alamat Terakhir",
          hint: "Alamat lengkap terakhir almarhum...",
          isTextArea: true,
          initialValue: controller.formData['alamat_almarhum']?.toString(),
          onChanged: (val) => controller.updateForm('alamat_almarhum', val),
        ),

        const SizedBox(height: 20),

        // --- SECTION B: DAFTAR AHLI WARIS ---
        Obx(() {
          List<dynamic> listWaris = controller.formData['ahli_waris'] ?? [<String, dynamic>{}];
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("B. DAFTAR AHLI WARIS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  if (listWaris.length < 3)
                    ElevatedButton.icon(
                      onPressed: () {
                        List<dynamic> currentList = List.from(listWaris);
                        currentList.add(<String, dynamic>{});
                        controller.updateForm('ahli_waris', currentList);
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text("Tambah", style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        backgroundColor: Colors.indigo[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
              const Divider(height: 20),
              
              ...List.generate(listWaris.length, (index) {
                Map<String, dynamic> waris = listWaris[index] as Map<String, dynamic>;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ahli Waris Ke-${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[800], fontSize: 12)),
                          if (listWaris.length > 1)
                            InkWell(
                              onTap: () {
                                List<dynamic> currentList = List.from(listWaris);
                                currentList.removeAt(index);
                                controller.updateForm('ahli_waris', currentList);
                              },
                              child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomInputField(
                        label: "Nama",
                        hint: "Nama Ahli Waris",
                        initialValue: waris['nama']?.toString(),
                        onChanged: (val) => _updateWaris(index, 'nama', val),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownField(
                              label: "J.Kelamin",
                              hint: "Pilih",
                              items: const ["L", "P"],
                              value: waris['jk']?.toString(),
                              onChanged: (val) => _updateWaris(index, 'jk', val ?? ''),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomInputField(
                              label: "Umur (Thn)",
                              hint: "0",
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              initialValue: waris['umur']?.toString(),
                              onChanged: (val) => _updateWaris(index, 'umur', val),
                            ),
                          ),
                        ],
                      ),
                      CustomInputField(
                        label: "Hubungan",
                        hint: "Contoh: Anak / Istri",
                        initialValue: waris['hubungan']?.toString(),
                        onChanged: (val) => _updateWaris(index, 'hubungan', val),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }),

        const SizedBox(height: 10),
        const Text("C. BERKAS PERSYARATAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Divider(height: 20),

        const CustomFileUpload(label: "Scan/Foto KTP Pemohon", fileKey: "ktp"),
        const CustomFileUpload(label: "Scan/Foto KK", fileKey: "kk"),
        const CustomFileUpload(label: "Surat Kematian (RS/Desa)", fileKey: "surat_kematian", allowDocument: true,),
      ],
    );
  }
}