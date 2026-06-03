import 'package:flutter/material.dart';
import '../../core/models/growth_record_model.dart';

class WeightTrendCard extends StatelessWidget {
  final List<GrowthRecord> records;

  const WeightTrendCard({super.key, required this.records});

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
      child: records.isEmpty ? _buildEmptyState() : _buildChart(),
    );
  }

  Widget _buildEmptyState() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight Trend',
          style: TextStyle(
            color: Color(0xFF172720),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Icon(Icons.show_chart_rounded, size: 40, color: Color(0xFFB0C9BF)),
              SizedBox(height: 8),
              Text(
                'No weight trend data yet.',
                style: TextStyle(color: Color(0xFF86A796), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildChart() {
    final weights = records
        .where((r) => r.weightKg != null)
        .map((r) => r.weightKg!)
        .toList();

    if (weights.length < 2) return _buildEmptyState();

    final first = weights.first;
    final last = weights.last;
    final diff = last - first;
    final sign = diff >= 0 ? '+' : '';
    final trendLabel = '$sign${diff.toStringAsFixed(1)} kg';
    final trendColor =
        diff >= 0 ? const Color(0xFF3FAD78) : const Color(0xFFE76F6F);

    final labels = records
        .where((r) => r.weightKg != null)
        .map((r) {
          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          return months[r.recordedAt.month - 1];
        })
        .toList();

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
                  'Weight Trend',
                  style: TextStyle(
                    color: Color(0xFF172720),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Check-up history',
                  style: TextStyle(
                    color: Color(0xFF6B8F80),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
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
                    diff >= 0 ? Icons.trending_up : Icons.trending_down,
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
        const SizedBox(height: 24),
        SizedBox(
          height: 80,
          width: double.infinity,
          child: CustomPaint(painter: _AreaChartPainter(weights)),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map(
                (l) => Text(
                  l,
                  style: const TextStyle(
                    color: Color(0xFF6B8F80),
                    fontSize: 9,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  final List<double> weights;

  _AreaChartPainter(this.weights);

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.length < 2) return;

    final minW = weights.reduce((a, b) => a < b ? a : b);
    final maxW = weights.reduce((a, b) => a > b ? a : b);
    final range = (maxW - minW).abs();
    final padding = range == 0 ? 1.0 : range * 0.1;

    List<Offset> points = [];
    for (int i = 0; i < weights.length; i++) {
      final x = size.width * i / (weights.length - 1);
      final normalized = range == 0
          ? 0.5
          : (weights[i] - minW) / (maxW - minW + padding);
      final y = size.height * (1.0 - normalized * 0.8 - 0.1);
      points.add(Offset(x, y));
    }

    final paint = Paint()
      ..color = const Color(0xFF4CAF82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

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
        const Color(0xFF4CAF82).withValues(alpha: 0.3),
        const Color(0xFF4CAF82).withValues(alpha: 0.0),
      ],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotStroke = Paint()
      ..color = const Color(0xFF4CAF82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 4, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter old) => old.weights != weights;
}
