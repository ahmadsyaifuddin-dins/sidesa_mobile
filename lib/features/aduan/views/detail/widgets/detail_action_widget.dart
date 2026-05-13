import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/awesome_dialog_helper.dart';
import '../../../controllers/aduan_controller.dart';
import '../../../data/aduan_model.dart';
import '../../edit_aduan_view.dart';

class DetailActionWidget extends StatelessWidget {
  final AduanModel aduan;
  const DetailActionWidget({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    // Kalau status bukan menunggu, hilangkan tombolnya
    if (aduan.status != 'menunggu') return const SizedBox.shrink();

    final aduanC = Get.find<AduanController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea( // SafeArea agar tidak tabrakan dengan indikator home HP iPhone/Android modern
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: () {
                  AwesomeDialogHelper.showConfirm(
                    title: "Hapus Aduan",
                    desc: "Yakin ingin membatalkan dan menghapus aduan ini?",
                    dialogType: DialogType.error,
                    btnOkText: "Ya, Hapus",
                    btnCancelText: "Kembali",
                    btnOkOnPress: () => aduanC.hapusAduan(aduan.id),
                  );
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                label: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: ElevatedButton.icon(
                onPressed: () {
                  aduanC.setupEditForm(aduan);
                  Get.to(() => EditAduanView(aduanId: aduan.id));
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                label: const Text("Edit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}