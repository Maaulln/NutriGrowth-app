import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/navigation_provider.dart';

class FoodHeader extends ConsumerWidget {
  const FoodHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                ref.read(navigationIndexProvider.notifier).state = 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF4CAF82).withValues(alpha: 0.15),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1A2E2A),
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Food Recommendations',
                style: TextStyle(
                  color: Color(0xFF1A2E2A),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Personalized for Aisha, 18 months',
                style: TextStyle(color: Color(0xFF6B8F80), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
