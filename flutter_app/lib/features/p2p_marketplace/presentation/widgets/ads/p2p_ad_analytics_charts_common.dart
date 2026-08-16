part of '../../phone/pages/ads/p2p_ad_analytics_page.dart';

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          child: const SizedBox(
            width: _p2pAdAnalyticsLegendDotExtent,
            height: _p2pAdAnalyticsLegendDotExtent,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _HeatLegendCell extends StatelessWidget {
  const _HeatLegendCell({required this.alpha});

  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buy.withValues(alpha: alpha),
      borderRadius: AppRadii.smRadius,
      child: const SizedBox(
        width: _p2pAdAnalyticsLegendDotExtent,
        height: _p2pAdAnalyticsLegendDotExtent,
      ),
    );
  }
}

class _PerformanceLinePainter extends CustomPainter {
  const _PerformanceLinePainter(this.points);

  final List<P2PAdDailyPerformanceDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final chart = Rect.fromLTRB(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width,
      size.height - AppSpacing.x5,
    );
    _paintGrid(canvas, chart);
    _paintLine(
      canvas,
      chart,
      values: points.map((point) => point.impressions.toDouble()).toList(),
      color: AppColors.accent,
      fill: true,
    );
    _paintLine(
      canvas,
      chart,
      values: points.map((point) => point.orders.toDouble()).toList(),
      color: AppColors.buy,
      maxOverride: 24,
    );
    for (var i = 0; i < points.length; i += 2) {
      final x = chart.left + chart.width * i / (points.length - 1);
      _paintTinyText(
        canvas,
        points[i].date,
        Offset(x - AppSpacing.x4, chart.bottom + AppSpacing.x2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformanceLinePainter oldDelegate) =>
      oldDelegate.points != points;
}

class _VolumeBarPainter extends CustomPainter {
  const _VolumeBarPainter(this.points);

  final List<P2PAdDailyPerformanceDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final chart = Rect.fromLTRB(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width,
      size.height - AppSpacing.x5,
    );
    _paintGrid(canvas, chart);
    final maxVolume = points
        .map((point) => point.volume)
        .reduce(math.max)
        .toDouble();
    final slot = chart.width / points.length;
    final paint = Paint()..color = AppColors.primary;
    for (var i = 0; i < points.length; i++) {
      final barHeight = chart.height * points[i].volume / maxVolume;
      final left = chart.left + slot * i + slot * .24;
      final right = chart.left + slot * (i + 1) - slot * .24;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, chart.bottom - barHeight, right, chart.bottom),
        AppRadii.chartBarCorner,
      );
      canvas.drawRRect(rect, paint);
    }
    for (var i = 0; i < points.length; i += 2) {
      final x = chart.left + slot * i + slot * .1;
      _paintTinyText(
        canvas,
        points[i].date,
        Offset(x, chart.bottom + AppSpacing.x2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VolumeBarPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RadarComparisonPainter extends CustomPainter {
  const _RadarComparisonPainter(this.rows);

  final List<P2PAdCompetitorComparisonDraft> rows;

  @override
  void paint(Canvas canvas, Size size) {
    if (rows.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2 + AppSpacing.x2);
    final radius = math.min(size.width, size.height) * .32;
    final grid = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var level = 1; level <= 4; level++) {
      final path = Path();
      for (var i = 0; i < rows.length; i++) {
        final point = _radarPoint(center, radius * level / 4, i, rows.length);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, grid);
    }

    for (var i = 0; i < rows.length; i++) {
      final end = _radarPoint(center, radius, i, rows.length);
      canvas.drawLine(center, end, grid);
      final label = _radarPoint(center, radius + AppSpacing.x5, i, rows.length);
      _paintTinyText(
        canvas,
        rows[i].metric,
        label.translate(-AppSpacing.x5, -AppSpacing.x2),
      );
    }

    _paintRadarSeries(
      canvas,
      center,
      radius,
      _normalizedRadarValues(rows, (row) => row.average),
      AppColors.text3,
      .10,
    );
    _paintRadarSeries(
      canvas,
      center,
      radius,
      _normalizedRadarValues(rows, (row) => row.top),
      AppColors.buy,
      .12,
    );
    _paintRadarSeries(
      canvas,
      center,
      radius,
      _normalizedRadarValues(rows, (row) => row.yours),
      AppColors.accent,
      .24,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarComparisonPainter oldDelegate) =>
      oldDelegate.rows != rows;
}

void _paintGrid(Canvas canvas, Rect chart) {
  final paint = Paint()
    ..color = AppColors.divider
    ..strokeWidth = 1;
  for (var i = 0; i <= 4; i++) {
    final y = chart.bottom - chart.height * i / 4;
    canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), paint);
  }
}

void _paintLine(
  Canvas canvas,
  Rect chart, {
  required List<double> values,
  required Color color,
  bool fill = false,
  double? maxOverride,
}) {
  if (values.length < 2) return;
  final maxValue = maxOverride ?? values.reduce(math.max);
  final minValue = maxOverride == null ? values.reduce(math.min) : 0;
  final span = math.max(maxValue - minValue, 1);
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = chart.left + chart.width * i / (values.length - 1);
    final y = chart.bottom - chart.height * (values[i] - minValue) / span;
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = color.withValues(alpha: .10));
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round,
  );
}

void _paintRadarSeries(
  Canvas canvas,
  Offset center,
  double radius,
  List<double> values,
  Color color,
  double fillAlpha,
) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final point = _radarPoint(center, radius * values[i], i, values.length);
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  canvas.drawPath(path, Paint()..color = color.withValues(alpha: fillAlpha));
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5,
  );
}

List<double> _normalizedRadarValues(
  List<P2PAdCompetitorComparisonDraft> rows,
  double Function(P2PAdCompetitorComparisonDraft row) selector,
) {
  return [
    for (final row in rows)
      _normalizedRadarMetric(row, selector(row)).clamp(0, 1),
  ];
}

double _normalizedRadarMetric(
  P2PAdCompetitorComparisonDraft row,
  double value,
) {
  final maxValue = math.max(row.yours, math.max(row.average, row.top));
  if (maxValue <= 0) return 0;
  if (row.metric.contains('Phản hồi')) {
    return (maxValue - value + 1) / maxValue;
  }
  return value / maxValue;
}

Offset _radarPoint(Offset center, double radius, int index, int total) {
  final angle = -math.pi / 2 + (math.pi * 2 * index / total);
  return Offset(
    center.dx + math.cos(angle) * radius,
    center.dy + math.sin(angle) * radius,
  );
}

void _paintTinyText(Canvas canvas, String text, Offset offset) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.chartLabelTiny.copyWith(color: AppColors.text3),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: AppSpacing.x7 + AppSpacing.x4);
  painter.paint(canvas, offset);
}

Color _heatColor(int orders, int maxOrders) {
  if (orders <= 0 || maxOrders <= 0) return AppColors.surface2;
  final intensity = orders / maxOrders;
  return AppColors.buy.withValues(alpha: .16 + intensity * .58);
}

Color _toneColor(String tone) {
  return switch (tone) {
    'buy' => AppColors.buy,
    'accent' => AppColors.accent,
    'warn' => AppColors.warn,
    'sell' => AppColors.sell,
    _ => AppModuleAccents.p2p,
  };
}

IconData _tipIcon(String iconKey) {
  return switch (iconKey) {
    'check' => Icons.check_circle_outline_rounded,
    'clock' => Icons.schedule_rounded,
    'trend' => Icons.trending_up_rounded,
    _ => Icons.info_outline_rounded,
  };
}

String _formatCount(int value) => VitFormat.count(value);

String _formatVnd(int value) => formatP2PVnd(value);

String _formatCompactVnd(int value) {
  if (value >= 1000000000) {
    return '₫${_trim(value / 1000000000)}B';
  }
  if (value >= 1000000) {
    return '₫${_trim(value / 1000000)}M';
  }
  return '₫${_formatVnd(value)}';
}

String _formatComparison(String metric, double value) {
  if (metric == 'Giá') return _formatCompactPlain(value);
  return _fixed(value);
}

String _formatCompactPlain(double value) {
  if (value >= 1000) return '${_trim(value / 1000)}K';
  return _fixed(value);
}

String _fixed(double value) => value.toStringAsFixed(1);

String _trim(double value) {
  final text = value.toStringAsFixed(2);
  if (text.endsWith('00')) return text.substring(0, text.length - 3);
  if (text.endsWith('0')) return text.substring(0, text.length - 1);
  return text;
}
