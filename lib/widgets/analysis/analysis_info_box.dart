import 'package:flutter/material.dart';

class AnalysisInfoBox extends StatelessWidget {
  const AnalysisInfoBox({super.key, this.childName});

  /// Nama anak aktif; jika ada, form diisi otomatis dari profilnya.
  final String? childName;

  @override
  Widget build(BuildContext context) {
    final message = childName != null && childName!.trim().isNotEmpty
        ? 'Data dari profil $childName sudah diisi otomatis. Periksa dan sesuaikan jika perlu, lalu ketuk Analisis Sekarang.'
        : 'Pilih profil anak di menu Anak terlebih dahulu. Setelah itu data pengukuran akan terisi otomatis untuk Anda validasi.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5EE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF4CAF82).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              childName != null ? Icons.check_circle_outline : Icons.info_outline,
              color: const Color(0xFF4CAF82),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: const Color(0xFF1A2E2A).withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
