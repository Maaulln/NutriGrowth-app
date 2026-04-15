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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nutrisi Minggu Ini',
                style: TextStyle(
                  color: Color(0xFF172720),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Lihat semua',
                    style: TextStyle(
                      color: Color(0xFF3FAD78),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: Color(0xFF3FAD78),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildNutritionItem(
            'Protein',
            '68%',
            0.68,
            Icons.egg_alt_outlined,
            const Color(0xFF4CAF82),
          ),
          const SizedBox(height: 12),
          _buildNutritionItem(
            'Kalori',
            '82%',
            0.82,
            Icons.local_fire_department_outlined,
            const Color(0xFFE6912E),
          ),
          const SizedBox(height: 12),
          _buildNutritionItem(
            'Zat Besi',
            '45%',
            0.45,
            Icons.water_drop_outlined,
            const Color(0xFFE76F6F),
          ),
          const SizedBox(height: 12),
          _buildNutritionItem(
            'Kalsium',
            '74%',
            0.74,
            Icons.settings_suggest_outlined,
            const Color(0xFF7E57C2),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(
    String label,
    String percentageText,
    double percentage,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Icon(icon, color: color, size: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF172720),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    percentageText,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: const Color(0xFFF0F7F4),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
