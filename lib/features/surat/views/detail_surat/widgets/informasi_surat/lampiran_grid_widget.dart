// Lokasi: lib/features/surat/views/detail_surat/widgets/informasi_surat/lampiran_grid_widget.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/utils/snackbar_helper.dart';

class LampiranGridWidget extends StatelessWidget {
  final List<String> lampiranUrls;
  final String jenisSurat;

  const LampiranGridWidget({
    super.key,
    required this.lampiranUrls,
    required this.jenisSurat,
  });

  List<String> _getLampiranLabels(String jenis) {
    switch (jenis) {
      case 'sku': return ['Foto Usaha/Produk'];
      case 'sktm': return ['Foto Rumah Depan', 'Foto Rumah Dalam', 'Surat Pernyataan', 'KTP', 'KK'];
      case 'kelahiran': return ['Surat Keterangan Lahir (Bidan)'];
      case 'kematian': return ['KTP Almarhum', 'KK Almarhum'];
      case 'skck': return ['KTP', 'KK'];
      case 'penghasilan': return ['KTP', 'KK'];
      case 'belum_menikah': return ['KTP', 'KK', 'Surat Pernyataan'];
      case 'beda_nama': return ['KTP', 'KK', 'Dokumen 1', 'Dokumen 2'];
      default: return [];
    }
  }

  void _showFullScreenImage(BuildContext context, String url, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black87,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                },
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (lampiranUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text("Lampiran Persyaratan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 12),
        
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.85,
          ),
          itemCount: lampiranUrls.length,
          itemBuilder: (context, index) {
            String url = lampiranUrls[index];
            bool isPdf = url.toLowerCase().endsWith('.pdf');
            List<String> labels = _getLampiranLabels(jenisSurat);
            String title = index < labels.length ? labels[index] : "Lampiran Tambahan";

            return InkWell(
              onTap: () async {
                if (isPdf) {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    SnackbarHelper.error(title: "Gagal", message: "Tidak dapat membuka dokumen PDF");
                  }
                } else {
                  _showFullScreenImage(context, url, title);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[50],
                        child: isPdf
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 40),
                                  const SizedBox(height: 8),
                                  Text("Lihat PDF", style: TextStyle(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.bold))
                                ],
                              )
                            : Image.network(
                                url,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isPdf ? Icons.open_in_browser : Icons.zoom_in, size: 14, color: Colors.blue[700]),
                          const SizedBox(width: 4),
                          Text(isPdf ? "Buka File" : "Lihat Gambar", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}