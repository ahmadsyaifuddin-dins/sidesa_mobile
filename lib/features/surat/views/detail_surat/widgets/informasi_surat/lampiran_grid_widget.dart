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
      case 'pengantar_skck': return ['KTP', 'KK'];
      case 'keterangan_penghasilan': return ['KTP', 'KK'];
      case 'belum_pernah_menikah': return ['KTP', 'KK', 'Surat Pernyataan'];
      case 'keterangan_beda_nama': return ['KTP', 'KK', 'Dokumen 1', 'Dokumen 2'];
      case 'pengantar_ktp': return ['Kartu Keluarga (KK)', 'Dokumen 2', 'Dokumen 3']; 
      case 'keterangan_ahli_waris': return ['KTP Pemohon', 'KK', 'Surat Kematian'];
      default: return [];
    }
  }

  // Pop up gambar tetap dipertahankan warna hitam pekat agar fokus ke dokumen
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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            "Lampiran Persyaratan", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)
          ),
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
            String urlLower = url.toLowerCase();
            
            // --- LOGIKA DETEKSI FILE ---
            bool isPdf = urlLower.endsWith('.pdf');
            bool isWord = urlLower.endsWith('.doc') || urlLower.endsWith('.docx');
            bool isDocument = isPdf || isWord;

            List<String> labels = _getLampiranLabels(jenisSurat);
            String title = index < labels.length ? labels[index] : "Lampiran Tambahan";

            return InkWell(
              onTap: () async {
                if (isDocument) {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    SnackbarHelper.error(title: "Gagal", message: "Tidak dapat membuka dokumen ini");
                  }
                } else {
                  _showFullScreenImage(context, url, title);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor, // Background kotak dinamis
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outlineVariant), // Border dinamis
                  boxShadow: [
                    BoxShadow(color: theme.shadowColor.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // JUDUL LAMPIRAN
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10, 
                          fontWeight: FontWeight.bold, 
                          color: theme.colorScheme.onSurfaceVariant // Warna judul dinamis
                        ),
                      ),
                    ),
                    
                    // PREVIEW KOTAK TENGAH
                    Expanded(
                      child: Container(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5), // Background image placeholder dinamis
                        child: isPdf
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 40),
                                  const SizedBox(height: 8),
                                  Text("Dokumen PDF", style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, fontWeight: FontWeight.bold))
                                ],
                              )
                            : isWord
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.description_rounded, color: theme.colorScheme.primary, size: 40),
                                      const SizedBox(height: 8),
                                      Text("Dokumen Word", style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, fontWeight: FontWeight.bold))
                                    ],
                                  )
                                : Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: theme.colorScheme.onSurfaceVariant, size: 40),
                                  ),
                      ),
                    ),
                    
                    // TOMBOL BAWAH (BUKA/LIHAT)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        // Warna Background tombol bawah (biru pudar di Dark Mode, biru sangat muda di Light Mode)
                        color: isDark ? theme.colorScheme.primary.withValues(alpha: 0.15) : Colors.blue.shade50,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isDocument ? Icons.download_rounded : Icons.zoom_in, 
                            size: 14, 
                            color: theme.colorScheme.primary
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isDocument ? "Unduh File" : "Lihat Gambar", 
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)
                          ),
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