part of '../../phone/pages/portfolio/dca_performance_compare_page.dart';

class _PerformanceLinePainter extends CustomPainter {
  const _PerformanceLinePainter(this.points);

  final List<DcaPerformancePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const left = 36.0;
    const bottom = 24.0;
    final chart = Rect.fromLTWH(0, 0, size.width, size.height - bottom);
    final maxValue = points
        .map((point) => math.max(point.dcaValueUsd, point.lumpSumValueUsd))
        .reduce(math.max)
        .toDouble();
    _drawGrid(canvas, chart, maxValue, left);
    _drawLine(
      canvas,
      chart,
      values: points.map((point) => point.dcaValueUsd / maxValue).toList(),
      color: AppColors.buy,
      leftInset: left,
      fill: true,
    );
    _drawLine(
      canvas,
      chart,
      values: points.map((point) => point.lumpSumValueUsd / maxValue).toList(),
      color: AppColors.primary,
      leftInset: left,
    );
    for (var i = 1; i < points.length; i += 2) {
      _drawAxisLabel(
        canvas,
        points[i].month,
        Offset(
          left + (chart.width - left) * i / (points.length - 1),
          chart.bottom + 4,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformanceLinePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter(this.metrics);

  final List<DcaRadarMetric> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    if (metrics.length < 3) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    final grid = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var step = 1; step <= 4; step++) {
      final path = _radarPath(
        center,
        radius * step / 4,
        List<double>.filled(metrics.length, 1),
      );
      canvas.drawPath(path, grid);
    }
    for (var i = 0; i < metrics.length; i++) {
      final angle = -math.pi / 2 + math.pi * 2 * i / metrics.length;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(center, point, grid);
      _drawRadarLabel(canvas, metrics[i].metric, center, radius + 20, angle);
    }
    _drawRadarSeries(
      canvas,
      center,
      radius,
      metrics.map((metric) => metric.dcaScore / 200).toList(),
      AppColors.buy,
    );
    _drawRadarSeries(
      canvas,
      center,
      radius,
      metrics.map((metric) => metric.lumpSumScore / 200).toList(),
      AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.metrics != metrics;
  }
}

void _drawGrid(Canvas canvas, Rect chart, double maxValue, double leftInset) {
  final grid = Paint()
    ..color = AppColors.border
    ..strokeWidth = 1;
  for (var i = 0; i <= 4; i++) {
    final y = chart.bottom - chart.height * i / 4;
    canvas.drawLine(Offset(leftInset, y), Offset(chart.right, y), grid);
    _drawAxisLabel(canvas, '${(maxValue * i / 4).round()}', Offset(0, y - 7));
  }
}

void _drawLine(
  Canvas canvas,
  Rect chart, {
  required List<double> values,
  required Color color,
  required double leftInset,
  bool fill = false,
}) {
  if (values.isEmpty) return;
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = leftInset + (chart.width - leftInset) * i / (values.length - 1);
    final y = chart.bottom - chart.height * values[i];
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(leftInset, chart.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke,
  );
}

Path _radarPath(Offset center, double radius, List<double> values) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final angle = -math.pi / 2 + math.pi * 2 * i / values.length;
    final point = Offset(
      center.dx + math.cos(angle) * radius * values[i],
      center.dy + math.sin(angle) * radius * values[i],
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  return path;
}

void _drawRadarSeries(
  Canvas canvas,
  Offset center,
  double radius,
  List<double> values,
  Color color,
) {
  final path = _radarPath(center, radius, values);
  canvas.drawPath(
    path,
    Paint()
      ..color = color.withValues(alpha: 0.24)
      ..style = PaintingStyle.fill,
  );
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke,
  );
}

void _drawRadarLabel(
  Canvas canvas,
  String label,
  Offset center,
  double radius,
  double angle,
) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text2),
    ),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: DcaSpacingTokens.dcaPerformanceCompareRadarLabelMaxWidth);
  final offset = Offset(
    center.dx + math.cos(angle) * radius - textPainter.width / 2,
    center.dy + math.sin(angle) * radius - textPainter.height / 2,
  );
  textPainter.paint(canvas, offset);
}

void _drawAxisLabel(Canvas canvas, String label, Offset offset) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(canvas, offset);
}
