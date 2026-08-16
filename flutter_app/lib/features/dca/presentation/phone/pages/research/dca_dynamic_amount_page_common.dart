part of 'dca_dynamic_amount_page.dart';

class _AmountHistoryPainter extends CustomPainter {
  const _AmountHistoryPainter({required this.entries});

  final List<DcaAmountHistoryEntry> entries;

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final data = entries.take(8).toList().reversed.toList();
    final chartRect = Rect.fromLTWH(
      AppSpacing.x7,
      AppSpacing.x3,
      size.width - AppSpacing.x7 - AppSpacing.x3,
      size.height - AppSpacing.x7,
    );
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .42)
      ..strokeWidth = 1;
    final labelStyle = AppTextStyles.micro.copyWith(color: AppColors.text3);
    final maxAmount = data
        .map((entry) => math.max(entry.baseAmountVnd, entry.adjustedAmountVnd))
        .reduce(math.max)
        .toDouble();

    for (var i = 0; i <= 4; i++) {
      final y = chartRect.top + chartRect.height * i / 4;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
      final value = maxAmount * (1 - i / 4);
      _paintText(
        canvas,
        _formatVnd(value.round()),
        Offset(AppSpacing.x2, y - AppSpacing.x3),
        labelStyle,
      );
    }

    final groupWidth = chartRect.width / data.length;
    final barWidth = math.min(AppSpacing.x4, groupWidth / 4);
    for (var i = 0; i < data.length; i++) {
      final entry = data[i];
      final center = chartRect.left + groupWidth * i + groupWidth / 2;
      _drawBar(
        canvas,
        chartRect,
        center - barWidth,
        barWidth,
        entry.baseAmountVnd / maxAmount,
        AppColors.surface3,
      );
      _drawBar(
        canvas,
        chartRect,
        center + AppSpacing.x1,
        barWidth,
        entry.adjustedAmountVnd / maxAmount,
        AppColors.primary,
      );
      if (i.isOdd) {
        _paintText(
          canvas,
          entry.date.substring(0, 5),
          Offset(center - AppSpacing.x4, chartRect.bottom + AppSpacing.x3),
          labelStyle,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AmountHistoryPainter oldDelegate) {
    return oldDelegate.entries != entries;
  }
}

void _drawLine(
  Canvas canvas,
  Rect rect,
  List<double> values,
  Color color, {
  bool dashed = false,
  bool fill = false,
}) {
  if (values.isEmpty) return;

  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = rect.left + rect.width * i / (values.length - 1);
    final y = rect.bottom - rect.height * values[i].clamp(0, 1);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: .10)
        ..style = PaintingStyle.fill,
    );
  }

  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 2;
  if (!dashed) {
    canvas.drawPath(path, paint);
    return;
  }

  for (final metric in path.computeMetrics()) {
    var distance = 0.0;
    while (distance < metric.length) {
      final segment = metric.extractPath(distance, distance + AppSpacing.x3);
      canvas.drawPath(segment, paint);
      distance += AppSpacing.x4;
    }
  }
}

void _drawDashedHorizontal(
  Canvas canvas,
  Rect rect,
  double ratio,
  Color color,
) {
  final y = rect.bottom - rect.height * ratio.clamp(0, 1);
  final paint = Paint()
    ..color = color.withValues(alpha: .58)
    ..strokeWidth = 1;
  var x = rect.left;
  while (x < rect.right) {
    canvas.drawLine(Offset(x, y), Offset(x + AppSpacing.x3, y), paint);
    x += AppSpacing.x4;
  }
}

void _drawBar(
  Canvas canvas,
  Rect rect,
  double x,
  double width,
  double ratio,
  Color color,
) {
  final height = rect.height * ratio.clamp(0, 1);
  final barRect = RRect.fromRectXY(
    Rect.fromLTWH(x, rect.bottom - height, width, height),
    AppSpacing.x2,
    AppSpacing.x2,
  );
  canvas.drawRRect(barRect, Paint()..color = color);
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  TextStyle style, {
  TextAlign textAlign = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: textAlign,
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

DcaDynamicStrategyOption _strategyOption(
  List<DcaDynamicStrategyOption> strategies,
  DcaDynamicStrategy strategy,
) {
  return strategies.firstWhere(
    (option) => option.strategy == strategy,
    orElse: () => strategies.first,
  );
}

DcaDynamicAdjustment _adjustmentFor(
  DcaDynamicStrategy strategy,
  DcaDynamicAdjustment base,
) {
  switch (strategy) {
    case DcaDynamicStrategy.fixed:
      return const DcaDynamicAdjustment(
        originalAmountVnd: 500000,
        adjustedAmountVnd: 500000,
        multiplier: 1,
        reason: 'Mua số tiền cố định mỗi kỳ',
        action: DcaDynamicAdjustmentAction.normal,
      );
    case DcaDynamicStrategy.performance:
      return const DcaDynamicAdjustment(
        originalAmountVnd: 500000,
        adjustedAmountVnd: 600000,
        multiplier: 1.2,
        reason: 'Portfolio lời +8.5% - tăng nhẹ lượng mua',
        action: DcaDynamicAdjustmentAction.increased,
      );
    case DcaDynamicStrategy.balance:
      return const DcaDynamicAdjustment(
        originalAmountVnd: 500000,
        adjustedAmountVnd: 500000,
        multiplier: 1,
        reason: 'Số dư đủ (5.2M)',
        action: DcaDynamicAdjustmentAction.normal,
      );
    case DcaDynamicStrategy.target:
      return const DcaDynamicAdjustment(
        originalAmountVnd: 200000,
        adjustedAmountVnd: 900000,
        multiplier: 4.5,
        reason: 'Cần khoảng 900K/tuần để đạt mục tiêu 50M',
        action: DcaDynamicAdjustmentAction.increased,
      );
    case DcaDynamicStrategy.volatility:
      return base;
  }
}

List<DcaDynamicConfigItem> _configItemsFor(DcaDynamicStrategy strategy) {
  switch (strategy) {
    case DcaDynamicStrategy.fixed:
      return const [
        DcaDynamicConfigItem(
          label: 'Số tiền mỗi kỳ',
          value: '500K',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.neutral,
        ),
        DcaDynamicConfigItem(
          label: 'Chu kỳ',
          value: 'Tuần',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.primary,
        ),
      ];
    case DcaDynamicStrategy.performance:
      return const [
        DcaDynamicConfigItem(
          label: 'Số tiền gốc',
          value: '500K',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Hệ số khi lời',
          value: 'x1.2',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.success,
        ),
        DcaDynamicConfigItem(
          label: 'Hệ số khi lỗ',
          value: 'x0.8',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Dừng khi lỗ',
          value: '-20%',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.danger,
        ),
      ];
    case DcaDynamicStrategy.balance:
      return const [
        DcaDynamicConfigItem(
          label: 'Số tiền gốc',
          value: '500K',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Giữ tối thiểu',
          value: '1.0M',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.neutral,
        ),
        DcaDynamicConfigItem(
          label: 'Ngưỡng giảm',
          value: '3.0M',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Ngưỡng dừng',
          value: '500K',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.danger,
        ),
      ];
    case DcaDynamicStrategy.target:
      return const [
        DcaDynamicConfigItem(
          label: 'Mục tiêu',
          value: '50.0M',
          icon: DcaScheduleOptionIcon.chart,
          accent: DcaDynamicConfigAccent.warning,
        ),
        DcaDynamicConfigItem(
          label: 'Hạn chót',
          value: '31/12',
          icon: DcaScheduleOptionIcon.clock,
          accent: DcaDynamicConfigAccent.primary,
        ),
        DcaDynamicConfigItem(
          label: 'Min/lần',
          value: '200K',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.neutral,
        ),
        DcaDynamicConfigItem(
          label: 'Max/lần',
          value: '2.0M',
          icon: DcaScheduleOptionIcon.bolt,
          accent: DcaDynamicConfigAccent.success,
        ),
      ];
    case DcaDynamicStrategy.volatility:
      return const [];
  }
}

IconData _iconFor(DcaScheduleOptionIcon icon) {
  switch (icon) {
    case DcaScheduleOptionIcon.clock:
      return Icons.lock_outline_rounded;
    case DcaScheduleOptionIcon.trend:
      return Icons.trending_up_rounded;
    case DcaScheduleOptionIcon.bolt:
      return Icons.show_chart_rounded;
    case DcaScheduleOptionIcon.chart:
      return Icons.bar_chart_rounded;
  }
}

IconData _actionIcon(DcaDynamicAdjustmentAction action) {
  switch (action) {
    case DcaDynamicAdjustmentAction.increased:
      return Icons.trending_up_rounded;
    case DcaDynamicAdjustmentAction.decreased:
      return Icons.trending_down_rounded;
    case DcaDynamicAdjustmentAction.skipped:
    case DcaDynamicAdjustmentAction.paused:
      return Icons.pause_rounded;
    case DcaDynamicAdjustmentAction.normal:
      return Icons.lock_outline_rounded;
  }
}

String _actionLabel(DcaDynamicAdjustmentAction action) {
  switch (action) {
    case DcaDynamicAdjustmentAction.increased:
      return 'Tăng mua';
    case DcaDynamicAdjustmentAction.decreased:
      return 'Giảm mua';
    case DcaDynamicAdjustmentAction.skipped:
      return 'Bỏ qua';
    case DcaDynamicAdjustmentAction.paused:
      return 'Tạm dừng';
    case DcaDynamicAdjustmentAction.normal:
      return 'Bình thường';
  }
}

Color _actionColor(DcaDynamicAdjustmentAction action) {
  switch (action) {
    case DcaDynamicAdjustmentAction.increased:
      return AppColors.buy;
    case DcaDynamicAdjustmentAction.decreased:
      return AppColors.warn;
    case DcaDynamicAdjustmentAction.skipped:
    case DcaDynamicAdjustmentAction.paused:
      return AppColors.sell;
    case DcaDynamicAdjustmentAction.normal:
      return AppColors.text2;
  }
}

Color _accentColor(DcaDynamicConfigAccent accent) {
  switch (accent) {
    case DcaDynamicConfigAccent.primary:
      return AppColors.primary;
    case DcaDynamicConfigAccent.success:
      return AppColors.buy;
    case DcaDynamicConfigAccent.warning:
      return AppColors.warn;
    case DcaDynamicConfigAccent.danger:
      return AppColors.sell;
    case DcaDynamicConfigAccent.accent:
      return AppColors.accent;
    case DcaDynamicConfigAccent.neutral:
      return AppColors.text2;
  }
}

Color _accentSoft(DcaDynamicConfigAccent accent) {
  switch (accent) {
    case DcaDynamicConfigAccent.primary:
      return AppColors.primary12;
    case DcaDynamicConfigAccent.success:
      return AppColors.buy10;
    case DcaDynamicConfigAccent.warning:
      return AppColors.warn10;
    case DcaDynamicConfigAccent.danger:
      return AppColors.sell10;
    case DcaDynamicConfigAccent.accent:
      return AppColors.accent12;
    case DcaDynamicConfigAccent.neutral:
      return AppColors.hoverBg;
  }
}

String _formatVnd(int value) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (abs >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}K';
  }
  return value.toString();
}
