import 'package:flutter/material.dart';

class WeeklyNutritionCard extends StatelessWidget {
  const WeeklyNutritionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3FAD78).withValues(alpha: 0.14),
          width: 0.65,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutrisi Minggu Ini',
            style: TextStyle(
              color: Color(0xFF172720),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    size: 32,
                    color: Color(0xFF4CAF82),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Data nutrisi belum tersedia',
                  style: TextStyle(
                    color: Color(0xFF172720),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Lakukan analisis gizi secara rutin untuk\nmemantau pemenuhan nutrisi anak.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF86A796),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
