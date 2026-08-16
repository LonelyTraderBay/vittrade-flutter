part of '../../phone/pages/tools/wallet_health_score_page.dart';

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(center, radius, stroke..color = _healthBackground);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * (score / 100),
      false,
      stroke
        ..color = color
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.color != color;
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter(this.metrics);

  final List<WalletHealthMetric> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = math.min(size.width, size.height) * .36;
    final gridPaint = Paint()
      ..color = AppColors.cardBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.onAccent.withValues(alpha: .08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final angles = List<double>.generate(
      metrics.length,
      (index) => -math.pi / 2 + (math.pi * 2 * index / metrics.length),
    );

    for (final fraction in const [.25, .5, .75, 1.0]) {
      final path = Path();
      for (var i = 0; i < metrics.length; i++) {
        final point =
            center +
            Offset(math.cos(angles[i]), math.sin(angles[i])) *
                (radius * fraction);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    for (var i = 0; i < metrics.length; i++) {
      final point =
          center + Offset(math.cos(angles[i]), math.sin(angles[i])) * radius;
      canvas.drawLine(center, point, axisPaint);
      _drawRadarLabel(canvas, size, metrics[i].category, point, angles[i]);
    }

    final shape = Path();
    for (var i = 0; i < metrics.length; i++) {
      final metric = metrics[i];
      final value = metric.score / metric.maxScore;
      final point =
          center +
          Offset(math.cos(angles[i]), math.sin(angles[i])) * (radius * value);
      if (i == 0) {
        shape.moveTo(point.dx, point.dy);
      } else {
        shape.lineTo(point.dx, point.dy);
      }
    }
    shape.close();
    canvas.drawPath(
      shape,
      Paint()
        ..color = _healthPurple.withValues(alpha: .42)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      shape,
      Paint()
        ..color = _healthPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    for (final tick in const [25, 50, 75, 100]) {
      final offset = center + Offset(4, -radius * tick / 100);
      _drawHealthChartText(
        canvas,
        '$tick',
        offset,
        AppTextStyles.chartLabelXs.copyWith(color: AppColors.text3),
        align: TextAlign.left,
      );
    }
  }

  void _drawRadarLabel(
    Canvas canvas,
    Size size,
    String label,
    Offset point,
    double angle,
  ) {
    final labelPoint = point + Offset(math.cos(angle), math.sin(angle)) * 20;
    final align = math.cos(angle) > .3
        ? TextAlign.left
        : math.cos(angle) < -.3
        ? TextAlign.right
        : TextAlign.center;
    _drawHealthChartText(
      canvas,
      label,
      labelPoint,
      AppTextStyles.micro.copyWith(color: AppColors.text2),
      align: align,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.metrics != metrics;
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter(this.history);

  final List<WalletHealthHistoryPoint> history;

  @override
  void paint(Canvas canvas, Size size) {
    final left = 56.0;
    final right = 6.0;
    final top = 10.0;
    final bottom = 28.0;
    final chart = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    final axis = Paint()
      ..color = AppColors.cardBorder
      ..strokeWidth = 1;
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axis);
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axis);

    for (final y in const [0, 50, 100]) {
      final dy = chart.bottom - (chart.height * y / 100);
      _drawHealthChartText(
        canvas,
        '$y',
        Offset(chart.left - 8, dy - 6),
        AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        align: TextAlign.right,
      );
    }

    final points = <Offset>[];
    for (var i = 0; i < history.length; i++) {
      final x = chart.left + chart.width * i / (history.length - 1);
      final y = chart.bottom - chart.height * history[i].score / 100;
      points.add(Offset(x, y));
      _drawHealthChartText(
        canvas,
        history[i].month,
        Offset(x, chart.bottom + 12),
        AppTextStyles.micro.copyWith(color: AppColors.text3),
        align: TextAlign.center,
      );
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _healthPurple
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    for (final point in points) {
      canvas.drawCircle(point, 5, Paint()..color = _healthPurple);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.history != history;
}

class _PiePainter extends CustomPainter {
  const _PiePainter(this.slices);

  final List<WalletDiversificationSlice> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .40;
    var start = -math.pi / 2;
    final total = slices.fold<int>(0, (sum, slice) => sum + slice.value);
    for (final slice in slices) {
      final sweep = math.pi * 2 * slice.value / total;
      final paint = Paint()
        ..color = Color(slice.colorHex)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
      final labelAngle = start + sweep / 2;
      final labelPoint =
          center + Offset(math.cos(labelAngle), math.sin(labelAngle)) * radius;
      _drawHealthChartText(
        canvas,
        '${slice.value}%',
        labelPoint,
        AppTextStyles.numericMicro.copyWith(color: AppColors.onAccent),
        align: TextAlign.center,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) =>
      oldDelegate.slices != slices;
}

void _drawHealthChartText(
  Canvas canvas,
  String text,
  Offset offset,
  TextStyle style, {
  TextAlign align = TextAlign.center,
}) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: align,
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout(maxWidth: 120);

  final dx = switch (align) {
    TextAlign.left => offset.dx,
    TextAlign.right => offset.dx - painter.width,
    _ => offset.dx - painter.width / 2,
  };
  painter.paint(canvas, Offset(dx, offset.dy));
}

Color _scoreColor(int score) {
  if (score >= 80) return _healthGreen;
  if (score >= 60) return _healthAmber;
  if (score >= 40) return _healthOrange;
  return _healthRed;
}

Color _statusColor(String status) {
  return switch (status) {
    'excellent' => _healthGreen,
    'good' => _healthPrimary,
    'warning' => _healthAmber,
    'critical' => _healthRed,
    _ => AppColors.text3,
  };
}

Color _impactColor(String impact) {
  return switch (impact) {
    'high' => _healthRed,
    'medium' => _healthAmber,
    'low' => _healthGreen,
    _ => AppColors.text3,
  };
}
