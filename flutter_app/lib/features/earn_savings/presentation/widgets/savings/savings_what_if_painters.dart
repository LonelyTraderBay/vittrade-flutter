part of '../../phone/pages/savings/savings_what_if_page.dart';

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.points});

  final List<_MonthlyPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final values = [
      for (final point in points) point.baseline,
      for (final point in points) point.scenario,
    ];
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(1, maxValue - minValue);

    Path pathFor(double Function(_MonthlyPoint point) selector) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = points.length == 1
            ? 0.0
            : size.width * i / (points.length - 1);
        final value = selector(points[i]);
        final y = size.height - ((value - minValue) / span * size.height);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final baselinePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final scenarioPaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(pathFor((point) => point.baseline), baselinePaint);
    canvas.drawPath(pathFor((point) => point.scenario), scenarioPaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    final base = Paint()
      ..color = AppColors.surface3
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final progress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, base);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * score / 100,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.color != color;
}
