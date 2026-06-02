import 'package:flutter/material.dart';
import '../../core/models/nutrition_analysis_model.dart';
import 'food_recommendations_section.dart';

class AnalysisResultSheet extends StatelessWidget {
  const AnalysisResultSheet({
    super.key,
    required this.status,
    required this.recommendation,
    required this.color,
    required this.foodSummary,
    required this.foodItems,
  });

  final String status;
  final String recommendation;
  final Color color;
  final String foodSummary;
  final List<FoodRecommendationItem> foodItems;

  static void show(
    BuildContext context, {
    required String status,
    required String recommendation,
    required Color color,
    required String foodSummary,
    required List<FoodRecommendationItem> foodItems,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AnalysisResultSheet(
        status: status,
        recommendation: recommendation,
        color: color,
        foodSummary: foodSummary,
        foodItems: foodItems,
      ),
    );
  }

  IconData _resolveStatusIcon() {
    final s = status.toLowerCase();
    if (s.contains('normal') || s.contains('tinggi')) {
      return Icons.check_circle_outline;
    }
    if (s.contains('severely') || s.contains('sangat')) {
      return Icons.error_outline;
    }
    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF0F7F4),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
                child: Row(
                  children: [
                    const Text(
                      'Hasil Analisis',
                      style: TextStyle(
                        color: Color(0xFF1A2E2A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Color(0xFF1A2E2A)),
                      iconSize: 22,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE0EDE8)),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  children: [
                    // Status box
                    Container(
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
                              Icon(_resolveStatusIcon(), color: color, size: 24),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Rekomendasi Treatment:',
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
                    // Food recommendations
                    if (foodItems.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      FoodRecommendationsSection(
                        foodSummary: foodSummary,
                        foodItems: foodItems,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
