import 'package:flutter/material.dart';

class AnalysisInfoBox extends StatelessWidget {
  const AnalysisInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Icon(Icons.info_outline, color: Color(0xFF4CAF82), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Enter your child's measurements to get an AI-powered nutrition status analysis.",
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
