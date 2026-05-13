import 'package:flutter/material.dart';
import '../../../data/aduan_model.dart';

class DetailHeaderWidget extends StatelessWidget {
  final AduanModel aduan;
  const DetailHeaderWidget({super.key, required this.aduan});

  @override
  Widget build(BuildContext context) {
    // Penentuan Warna Status
    Color statusColor = Colors.grey;
    if (aduan.status == 'menunggu') statusColor = Colors.orange;
    if (aduan.status == 'diproses') statusColor = Colors.blue;
    if (aduan.status == 'selesai') statusColor = Colors.green;
    if (aduan.status == 'ditolak') statusColor = Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.tag, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              aduan.kodeAduan,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            aduan.status.toUpperCase(),
            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}