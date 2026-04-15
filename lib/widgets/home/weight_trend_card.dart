import 'package:flutter/material.dart';

class WeightTrendCard extends StatelessWidget {
  const WeightTrendCard({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tren Berat Badan',
                    style: TextStyle(
                      color: Color(0xFF172720),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '6 bulan terakhir',
                    style: TextStyle(
                      color: Color(0xFF6B8F80),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: Color(0xFF3FAD78),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '+1.7 kg',
                      style: TextStyle(
                        color: Color(0xFF3FAD78),
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
            child: CustomPaint(painter: _AreaChartPainter()),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sep',
                style: TextStyle(color: Color(0xFF6B8F80), fontSize: 9),
              ),
              Text(
                'Okt',
                style: TextStyle(color: Color(0xFF6B8F80), fontSize: 9),
              ),
              Text(
                'Nov',
                style: TextStyle(color: Color(0xFF6B8F80), fontSize: 9),
              ),
              Text(
                'Des',
                style: TextStyle(color: Color(0xFF6B8F80), fontSize: 9),
              ),
              Text(
                'Jan',
                style: TextStyle(color: Color(0xFF6B8F80), fontSize: 9),
              ),
              Text(
                'Feb',
                style: TextStyle(color: Color(0xFF6B8F80), fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    // Sample curve points for the area chart
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.15),
    ];

    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      path.cubicTo(
        p0.dx + (p1.dx - p0.dx) / 2,
        p0.dy,
        p0.dx + (p1.dx - p0.dx) / 2,
        p1.dy,
        p1.dx,
        p1.dy,
      );
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Rect boundingBox = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF4CAF82).withValues(alpha: 0.3),
        const Color(0xFF4CAF82).withValues(alpha: 0.0),
      ],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(boundingBox)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotStrokePaint = Paint()
      ..color = const Color(0xFF4CAF82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 4, dotStrokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
