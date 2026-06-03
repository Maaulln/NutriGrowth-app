import 'package:flutter/material.dart';
import '../../core/models/stunting_assessment_model.dart';

class WeeklyNutritionCard extends StatelessWidget {
  const WeeklyNutritionCard({super.key, required this.assessments});

  final List<StuntingAssessmentSummary> assessments;

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
      child: assessments.length < 2 ? _buildEmptyState() : _buildChart(),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stunting Risk Trend',
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
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5EE),
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
                'Data not available yet',
                style: TextStyle(
                  color: Color(0xFF172720),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Run at least 2 nutrition analyses to\nsee your child\'s stunting risk trend.',
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
    );
  }

  Widget _buildChart() {
    final scores = assessments.map((a) => a.riskScore.toDouble()).toList();
    final first = scores.first;
    final last = scores.last;
    final diff = last - first;
    final sign = diff >= 0 ? '+' : '';
    final trendColor = diff <= 0
        ? const Color(0xFF3FAD78)   // membaik
        : const Color(0xFFE76F6F);  // memburuk
    final trendLabel = '$sign${diff.toStringAsFixed(0)} pts';

    final labels = assessments.map((a) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[a.createdAt.month - 1]} ${a.createdAt.day}';
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stunting Risk Trend',
                  style: TextStyle(
                    color: Color(0xFF172720),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Risk score 0–100 per analysis',
                  style: TextStyle(
                    color: Color(0xFF6B8F80),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: trendColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    diff <= 0 ? Icons.trending_down : Icons.trending_up,
                    size: 14,
                    color: trendColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trendLabel,
                    style: TextStyle(
                      color: trendColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Legenda skor terakhir
        Row(
          children: [
            _buildScoreBadge(assessments.last),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          width: double.infinity,
          child: CustomPaint(painter: _RiskScoreChartPainter(scores)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map((l) => Text(
                    l,
                    style: const TextStyle(
                      color: Color(0xFF6B8F80),
                      fontSize: 9,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildScoreBadge(StuntingAssessmentSummary assessment) {
    Color color;
    String label;
    switch (assessment.riskLevel) {
      case 'high':
        color = const Color(0xFFE76F6F);
        label = 'High Risk';
        break;
      case 'medium':
        color = Colors.orange;
        label = 'Medium Risk';
        break;
      default:
        color = const Color(0xFF3FAD78);
        label = 'Low Risk';
    }
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          'Latest score: ${assessment.riskScore} — $label',
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _RiskScoreChartPainter extends CustomPainter {
  final List<double> scores;

  _RiskScoreChartPainter(this.scores);

  Color _colorForScore(double score) {
    if (score >= 70) return const Color(0xFFE76F6F);
    if (score >= 40) return Colors.orange;
    return const Color(0xFF4CAF82);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.length < 2) return;

    const minVal = 0.0;
    const maxVal = 100.0;

    List<Offset> points = [];
    for (int i = 0; i < scores.length; i++) {
      final x = size.width * i / (scores.length - 1);
      final normalized = (scores[i] - minVal) / (maxVal - minVal);
      // Invert Y: skor tinggi = atas (buruk) tapi kita tampilkan skor rendah di atas (baik)
      final y = size.height * (1.0 - normalized * 0.8 - 0.1);
      points.add(Offset(x, y));
    }

    final lastScore = scores.last;
    final lineColor = _colorForScore(lastScore);

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      path.cubicTo(
        p0.dx + (p1.dx - p0.dx) / 2, p0.dy,
        p0.dx + (p1.dx - p0.dx) / 2, p1.dy,
        p1.dx, p1.dy,
      );
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        lineColor.withValues(alpha: 0.25),
        lineColor.withValues(alpha: 0.0),
      ],
    );

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    for (int i = 0; i < points.length; i++) {
      final dotColor = _colorForScore(scores[i]);
      canvas.drawCircle(points[i], 4,
          Paint()..color = Colors.white..style = PaintingStyle.fill);
      canvas.drawCircle(points[i], 4,
          Paint()..color = dotColor..style = PaintingStyle.stroke..strokeWidth = 2.0);
    }
  }

  @override
  bool shouldRepaint(covariant _RiskScoreChartPainter old) =>
      old.scores != scores;
}
