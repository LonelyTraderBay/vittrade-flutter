part of '../../phone/pages/analytics/copy_performance_page.dart';

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.points});

  final List<TradeCopyEquityPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 58.0;
    const right = 10.0;
    const top = 4.0;
    const bottom = 42.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - right,
      size.height - top - bottom,
    );
    _drawGrid(canvas, chart, verticalCount: 15, horizontalCount: 4);

    final values = [
      for (final point in points) ...[point.you, point.provider],
    ];
    final min = values.reduce((a, b) => a < b ? a : b) - 80;
    final max = values.reduce((a, b) => a > b ? a : b) + 80;

    Offset project(TradeCopyEquityPoint point, double value) {
      final x = chart.left + (point.day - 1) / 29 * chart.width;
      final y = chart.bottom - (value - min) / (max - min) * chart.height;
      return Offset(x, y);
    }

    canvas.drawLine(
      Offset(chart.left, chart.top),
      Offset(chart.left, chart.bottom),
      _axisPaint,
    );
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      _axisPaint,
    );

    _drawText(
      canvas,
      max.round().toString(),
      Offset(0, chart.top + 2),
      AppColors.text3,
    );
    _drawText(
      canvas,
      ((min + max) / 2).round().toString(),
      Offset(0, chart.center.dy - 4),
      AppColors.text3,
    );
    _drawText(
      canvas,
      min.round().toString(),
      Offset(0, chart.bottom - 2),
      AppColors.text3,
    );

    for (var day = 2; day <= 30; day += 2) {
      final x = chart.left + (day - 1) / 29 * chart.width;
      _drawText(
        canvas,
        '$day',
        Offset(x - 4, chart.bottom + 8),
        AppColors.text3,
      );
    }
    _drawText(
      canvas,
      'Ngày',
      Offset(chart.center.dx - 10, chart.bottom + 27),
      AppColors.text3,
    );

    _drawLine(
      canvas,
      [for (final point in points) project(point, point.you)],
      _performancePrimary,
      dashed: false,
    );
    _drawLine(
      canvas,
      [for (final point in points) project(point, point.provider)],
      _performancePurple,
      dashed: true,
    );

    final legendY = size.height - 16;
    _drawLegend(
      canvas,
      Offset(chart.left + 48, legendY),
      'Bạn',
      _performancePrimary,
    );
    _drawLegend(
      canvas,
      Offset(chart.left + 98, legendY),
      'Provider (lý thuyết)',
      _performancePurple,
    );
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({required this.buckets});

  final List<TradeCopySlippageBucket> buckets;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 58.0;
    const right = 10.0;
    const top = 8.0;
    const bottom = 44.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - right,
      size.height - top - bottom,
    );
    _drawGrid(canvas, chart, verticalCount: 4, horizontalCount: 3);
    canvas.drawLine(
      Offset(chart.left, chart.top),
      Offset(chart.left, chart.bottom),
      _axisPaint,
    );
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      _axisPaint,
    );
    _drawText(canvas, '60', Offset(34, chart.top), AppColors.text3);
    _drawText(canvas, '30', Offset(34, chart.center.dy - 4), AppColors.text3);
    _drawText(canvas, '15', Offset(34, chart.center.dy + 30), AppColors.text3);
    _drawText(canvas, '0', Offset(42, chart.bottom - 6), AppColors.text3);
    _drawRotatedText(canvas, '% Trades', Offset(6, chart.center.dy + 20));

    final groupWidth = chart.width / buckets.length;
    const barWidth = 32.0;
    for (var i = 0; i < buckets.length; i++) {
      final bucket = buckets[i];
      final center = chart.left + groupWidth * i + groupWidth / 2;
      final youHeight = bucket.youPct / 60 * chart.height;
      final providerHeight = bucket.providerPct / 60 * chart.height;
      canvas.drawRect(
        Rect.fromLTWH(
          center - barWidth,
          chart.bottom - youHeight,
          barWidth,
          youHeight,
        ),
        Paint()..color = _performancePrimary,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          center + 3,
          chart.bottom - providerHeight,
          barWidth,
          providerHeight,
        ),
        Paint()..color = _performancePurple,
      );
      _drawText(
        canvas,
        bucket.range,
        Offset(center - 24, chart.bottom + 8),
        AppColors.text3,
      );
    }
    _drawLegend(
      canvas,
      Offset(chart.left + 78, size.height - 16),
      'Bạn',
      _performancePrimary,
    );
    _drawLegend(
      canvas,
      Offset(chart.left + 128, size.height - 16),
      'Provider',
      _performancePurple,
    );
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.buckets != buckets;
  }
}

class _SidePill extends StatelessWidget {
  const _SidePill({required this.side});

  final TradeOrderSide side;

  @override
  Widget build(BuildContext context) {
    final buy = side == TradeOrderSide.buy;
    return VitAccentPill(
      label: buy ? 'BUY' : 'SELL',
      accentColor: buy ? AppColors.buy : AppColors.sell,
    );
  }
}

class _TradeColumn extends StatelessWidget {
  const _TradeColumn({
    required this.title,
    required this.color,
    required this.entry,
    required this.exit,
    required this.pnl,
  });

  final String title;
  final Color color;
  final double entry;
  final double exit;
  final double pnl;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.micro.copyWith(color: color)),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _MiniRow(label: 'Entry', value: '\$${entry.toStringAsFixed(0)}'),
          _MiniRow(label: 'Exit', value: '\$${exit.toStringAsFixed(0)}'),
          const Divider(color: AppColors.divider, height: AppSpacing.rowPy),
          _MiniRow(
            label: 'P/L',
            value: '${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(0)}',
            valueColor: pnl >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ],
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text3, size: AppSpacing.x4),
        const SizedBox(width: AppSpacing.x2),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}

class _MiniRow extends StatelessWidget {
  const _MiniRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.extraBold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

final Paint _axisPaint = Paint()
  ..color = AppColors.borderSolid
  ..strokeWidth = 1;

void _drawGrid(
  Canvas canvas,
  Rect chart, {
  required int verticalCount,
  required int horizontalCount,
}) {
  final paint = Paint()
    ..color = AppColors.borderSolid.withValues(alpha: .36)
    ..strokeWidth = 1;
  for (var i = 0; i <= verticalCount; i++) {
    final x = chart.left + chart.width * i / verticalCount;
    _drawDashedLine(
      canvas,
      Offset(x, chart.top),
      Offset(x, chart.bottom),
      paint,
    );
  }
  for (var i = 0; i <= horizontalCount; i++) {
    final y = chart.top + chart.height * i / horizontalCount;
    _drawDashedLine(
      canvas,
      Offset(chart.left, y),
      Offset(chart.right, y),
      paint,
    );
  }
}

void _drawLine(
  Canvas canvas,
  List<Offset> points,
  Color color, {
  required bool dashed,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  if (!dashed) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paint);
    return;
  }
  for (var i = 0; i < points.length - 1; i++) {
    _drawDashedLine(canvas, points[i], points[i + 1], paint, dash: 5, gap: 5);
  }
}

void _drawDashedLine(
  Canvas canvas,
  Offset start,
  Offset end,
  Paint paint, {
  double dash = 3,
  double gap = 5,
}) {
  final delta = end - start;
  final distance = delta.distance;
  if (distance == 0) return;
  final direction = delta / distance;
  var current = 0.0;
  while (current < distance) {
    final next = (current + dash).clamp(0, distance).toDouble();
    canvas.drawLine(
      start + direction * current,
      start + direction * next,
      paint,
    );
    current += dash + gap;
  }
}

void _drawText(Canvas canvas, String text, Offset offset, Color color) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

void _drawRotatedText(Canvas canvas, String text, Offset offset) {
  canvas.save();
  canvas.translate(offset.dx, offset.dy);
  canvas.rotate(-1.5708);
  _drawText(canvas, text, Offset.zero, AppColors.text3);
  canvas.restore();
}

void _drawLegend(Canvas canvas, Offset offset, String label, Color color) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2;
  canvas.drawLine(offset, offset + const Offset(14, 0), paint);
  canvas.drawCircle(offset + const Offset(7, 0), 2.5, paint);
  _drawText(canvas, label, offset + const Offset(18, -6), color);
}
