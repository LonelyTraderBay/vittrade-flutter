part of '../../phone/pages/tools/launchpad_risk_analytics_page.dart';

class _RadarLabel extends StatelessWidget {
  const _RadarLabel({
    required this.index,
    required this.count,
    required this.metrics,
  });

  final int index;
  final int count;
  final List<LaunchpadRiskMetricDraft> metrics;

  @override
  Widget build(BuildContext context) {
    final angle = -math.pi / 2 + (math.pi * 2 * index / count);
    final x = .5 + math.cos(angle) * .42;
    final y = .5 + math.sin(angle) * .42;
    return Align(
      alignment: Alignment((x * 2) - 1, (y * 2) - 1),
      child: Text(
        metrics[index].label,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  _RadarChartPainter(this.metrics);

  final List<LaunchpadRiskMetricDraft> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .34;
    final axisPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final polygonFill = Paint()
      ..color = AppColors.primary.withValues(alpha: .24)
      ..style = PaintingStyle.fill;
    final polygonStroke = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (var ring = 1; ring <= 4; ring++) {
      final path = Path();
      for (var i = 0; i < metrics.length; i++) {
        final point = _point(center, radius * ring / 4, i, metrics.length);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, axisPaint);
    }

    for (var i = 0; i < metrics.length; i++) {
      canvas.drawLine(
        center,
        _point(center, radius, i, metrics.length),
        axisPaint,
      );
    }

    final scorePath = Path();
    for (var i = 0; i < metrics.length; i++) {
      final valueRadius = radius * metrics[i].value / 100;
      final point = _point(center, valueRadius, i, metrics.length);
      if (i == 0) {
        scorePath.moveTo(point.dx, point.dy);
      } else {
        scorePath.lineTo(point.dx, point.dy);
      }
    }
    scorePath.close();
    canvas.drawPath(scorePath, polygonFill);
    canvas.drawPath(scorePath, polygonStroke);
  }

  Offset _point(Offset center, double radius, int index, int count) {
    final angle = -math.pi / 2 + (math.pi * 2 * index / count);
    return Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.metrics != metrics;
  }
}
