part of 'dca_dynamic_amount_page.dart';

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.block = false,
  });

  final Color color;
  final String label;
  final bool block;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: block ? AppSpacing.x3 : AppSpacing.x4,
          height: block ? AppSpacing.x3 : AppSpacing.x1,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.deviceRadius,
              ),
            ),
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

class _VolatilityChartPainter extends CustomPainter {
  const _VolatilityChartPainter({required this.points});

  final List<DcaVolatilitySnapshot> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final chartRect = Rect.fromLTWH(
      AppSpacing.x6,
      AppSpacing.x3,
      size.width - AppSpacing.x7 - AppSpacing.x3,
      size.height - AppSpacing.x7,
    );
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .42)
      ..strokeWidth = 1;
    final labelStyle = AppTextStyles.micro.copyWith(color: AppColors.text3);

    for (var i = 0; i <= 4; i++) {
      final y = chartRect.top + chartRect.height * i / 4;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
      _paintText(
        canvas,
        (60 - i * 15).toString(),
        Offset(AppSpacing.x2, y - AppSpacing.x3),
        labelStyle,
      );
    }
    for (var i = 0; i <= 5; i++) {
      final x = chartRect.left + chartRect.width * i / 5;
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }

    _drawDashedHorizontal(canvas, chartRect, 25 / 60, AppColors.sell);
    _drawDashedHorizontal(canvas, chartRect, 12 / 60, AppColors.primary);
    _drawLine(
      canvas,
      chartRect,
      points.map((point) => point.volatilityPercent / 60).toList(),
      AppColors.accent,
      fill: true,
    );
    _drawLine(
      canvas,
      chartRect,
      points.map((point) => point.multiplier / 2).toList(),
      AppColors.buy,
      dashed: true,
    );

    for (var i = 1; i < points.length; i += 2) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      _paintText(
        canvas,
        points[i].date,
        Offset(x - AppSpacing.x4, chartRect.bottom + AppSpacing.x3),
        labelStyle,
      );
    }
    _paintText(
      canvas,
      '2',
      Offset(chartRect.right + AppSpacing.x3, chartRect.top - AppSpacing.x2),
      labelStyle,
    );
    _paintText(
      canvas,
      '0',
      Offset(chartRect.right + AppSpacing.x3, chartRect.bottom - AppSpacing.x2),
      labelStyle,
    );
  }

  @override
  bool shouldRepaint(covariant _VolatilityChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
