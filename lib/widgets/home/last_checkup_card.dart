import 'package:flutter/material.dart';

class LastCheckupCard extends StatelessWidget {
  const LastCheckupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF82).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Feb 28, 2026',
                style: TextStyle(
                  color: Color(0xFF1A2E2A),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Normal',
                  style: TextStyle(
                    color: Color(0xFF2D6A4F),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const LinearProgressIndicator(
              value: 0.72,
              backgroundColor: Color(0xFFE8F5EE),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF82)),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress to goal',
                style: TextStyle(color: Color(0xFF86A796), fontSize: 12),
              ),
              Text(
                '72%',
                style: TextStyle(
                  color: Color(0xFF4CAF82),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
