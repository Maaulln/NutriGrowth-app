import 'package:flutter/material.dart';
import '../../core/models/child_model.dart';
import '../../screens/child_profile_screen.dart';
import '../metric_card.dart';

class ChildProfileCard extends StatelessWidget {
  final Child child;
  final VoidCallback? onChildUpdated;

  const ChildProfileCard({super.key, required this.child, this.onChildUpdated});

  @override
  Widget build(BuildContext context) {
    final isMale = child.isMale;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChildProfileScreen(child: child),
          ),
        );
        if (result == true) {
          onChildUpdated?.call();
        }
      },
      child: Container(
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
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isMale
                          ? [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)]
                          : [const Color(0xFFFCE4EC), const Color(0xFFF8BBD0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    isMale ? Icons.boy_rounded : Icons.girl_rounded,
                    size: 28,
                    color: isMale ? Colors.blue : Colors.pink,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name,
                        style: const TextStyle(
                          color: Color(0xFF1A2E2A),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        child.ageFormatted,
                        style: TextStyle(
                          color: Color(0xFF6B8F80),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5EE).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF4CAF82).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF82),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Normal',
                        style: TextStyle(
                          color: Color(0xFF2D6A4F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MetricCard(
                  icon: Icons.monitor_weight_outlined,
                  value: child.weightLabel,
                  label: 'kg',
                ),
                MetricCard(
                  icon: Icons.height_rounded,
                  value: child.heightLabel,
                  label: 'cm',
                ),
                MetricCard(
                  icon: Icons.accessibility_new_rounded,
                  value: child.muacLabel,
                  label: 'MUAC cm',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
