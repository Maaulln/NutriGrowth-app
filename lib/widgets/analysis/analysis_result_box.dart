import 'package:flutter/material.dart';

class AnalysisResultBox extends StatelessWidget {
  final String status;
  final String recommendation;
  final Color color;

  final VoidCallback? onSeeFood;

  const AnalysisResultBox({
    super.key,
    required this.status,
    required this.recommendation,
    required this.color,
    this.onSeeFood,
  });

  /// Menentukan ikon berdasarkan nilai [status] dari API.
  IconData _resolveStatusIcon() {
    final normalized = status.toLowerCase();
    if (normalized.contains('normal') || normalized.contains('tinggi')) {
      return Icons.check_circle_outline;
    }
    if (normalized.contains('severely') || normalized.contains('sangat')) {
      return Icons.error_outline;
    }
    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _resolveStatusIcon(),
                  color: color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Recommendation:',
              style: TextStyle(
                color: Color(0xFF1A2E2A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              recommendation,
              style: TextStyle(
                color: const Color(0xFF1A2E2A).withValues(alpha: 0.7),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            if (onSeeFood != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSeeFood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF82),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('See Food Recommendations'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
