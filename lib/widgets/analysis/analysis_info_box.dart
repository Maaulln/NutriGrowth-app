import 'package:flutter/material.dart';

class AnalysisInfoBox extends StatelessWidget {
  const AnalysisInfoBox({super.key, this.childName});

  /// Nama anak aktif; jika ada, form diisi otomatis dari profilnya.
  final String? childName;

  @override
  Widget build(BuildContext context) {
    final message = childName != null && childName!.trim().isNotEmpty
        ? 'Data from $childName\'s profile was filled automatically. Review and adjust if needed, then tap Analyze Now.'
        : 'Select a child profile in the Children tab first. Measurement fields will then auto-fill for you to verify.';

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
