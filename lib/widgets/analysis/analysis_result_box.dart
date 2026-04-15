import 'package:flutter/material.dart';

class AnalysisResultBox extends StatelessWidget {
  final String status;
  final String recommendation;
  final Color color;

  const AnalysisResultBox({
    super.key,
    required this.status,
    required this.recommendation,
    required this.color,
  });

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
                  status == 'Healthy Growth'
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_rounded,
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
          ],
        ),
      ),
    );
  }
}
