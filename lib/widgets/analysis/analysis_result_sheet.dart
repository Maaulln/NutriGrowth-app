import 'package:flutter/material.dart';
import '../../core/models/nutrition_analysis_model.dart';
import 'food_recommendations_section.dart';

class AnalysisResultSheet extends StatelessWidget {
  const AnalysisResultSheet({
    super.key,
    required this.status,
    required this.recommendation,
    required this.color,
    required this.riskLevel,
    required this.riskScore,
    required this.summary,
    required this.analysis,
    required this.warningFlags,
    required this.foodSummary,
    required this.foodItems,
  });

  final String status;
  final String recommendation;
  final Color color;
  final String riskLevel;
  final int riskScore;
  final String summary;
  final List<String> analysis;
  final List<String> warningFlags;
  final String foodSummary;
  final List<FoodRecommendationItem> foodItems;

  static void show(
    BuildContext context, {
    required String status,
    required String recommendation,
    required Color color,
    required String riskLevel,
    required int riskScore,
    required String summary,
    required List<String> analysis,
    required List<String> warningFlags,
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
        riskLevel: riskLevel,
        riskScore: riskScore,
        summary: summary,
        analysis: analysis,
        warningFlags: warningFlags,
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

  Color _riskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orange;
      default:
        return const Color(0xFF4CAF82);
    }
  }

  String _riskLabel() {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return 'High Risk';
      case 'medium':
        return 'Medium Risk';
      default:
        return 'Low Risk';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
                      'Analysis Results',
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
                    // Status + Risk box
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
                              // Risk level badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _riskColor().withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _riskColor().withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  _riskLabel(),
                                  style: TextStyle(
                                    color: _riskColor(),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Risk score bar
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'Risk Score: $riskScore / 100',
                                style: TextStyle(
                                  color: const Color(0xFF1A2E2A).withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: riskScore / 100,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFE0EDE8),
                              valueColor: AlwaysStoppedAnimation<Color>(_riskColor()),
                            ),
                          ),
                          // Summary
                          if (summary.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            Text(
                              summary,
                              style: TextStyle(
                                color: const Color(0xFF1A2E2A).withValues(alpha: 0.75),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Warning flags
                    if (warningFlags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.orange.withValues(alpha: 0.35)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Clinical Attention',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...warningFlags.map(
                              (flag) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(color: Colors.orange, fontSize: 13)),
                                    Expanded(
                                      child: Text(
                                        flag,
                                        style: TextStyle(
                                          color: const Color(0xFF1A2E2A).withValues(alpha: 0.75),
                                          fontSize: 12,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Analysis detail points
                    if (analysis.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE0EDE8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.analytics_outlined, color: Color(0xFF4CAF82), size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Analysis Details',
                                  style: TextStyle(
                                    color: Color(0xFF1A2E2A),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...analysis.map(
                              (point) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(color: Color(0xFF4CAF82), fontSize: 13)),
                                    Expanded(
                                      child: Text(
                                        point,
                                        style: TextStyle(
                                          color: const Color(0xFF1A2E2A).withValues(alpha: 0.72),
                                          fontSize: 12,
                                          height: 1.45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Treatment recommendations
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0EDE8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.medical_services_outlined, color: Color(0xFF4CAF82), size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Treatment Recommendations',
                                style: TextStyle(
                                  color: Color(0xFF1A2E2A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
