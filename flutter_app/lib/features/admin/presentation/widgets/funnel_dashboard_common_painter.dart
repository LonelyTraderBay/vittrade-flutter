part of '../phone/pages/funnel_dashboard_page.dart';

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.text1,
          size: AdminSpacingTokens.adminIconLg,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepNumber extends StatelessWidget {
  const _StepNumber({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AdminSpacingTokens.adminBox24,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.accent30,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(
          child: Text(
            '$index',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _DropoutChartPainter extends CustomPainter {
  const _DropoutChartPainter({required this.steps});

  final List<AdminFunnelStep> steps;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 28.0;
    const bottomPad = 64.0;
    const topPad = 8.0;
    const rightPad = 6.0;
    final chartWidth = math.max(1.0, size.width - leftPad - rightPad);
    final chartHeight = math.max(1.0, size.height - topPad - bottomPad);
    final chartLeft = leftPad;
    final chartTop = topPad;
    final chartBottom = topPad + chartHeight;

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1.2;

    for (var i = 0; i <= 4; i++) {
      final y = chartTop + chartHeight * i / 4;
      canvas.drawLine(Offset(chartLeft, y), Offset(size.width, y), gridPaint);
      _drawText(
        canvas,
        '${4 - i}',
        Offset(2, y - 7),
        style: AppTextStyles.numericMicro.copyWith(
          color: AppColors.text3,
          height: AdminSpacingTokens.adminLineHeightTight,
        ),
      );
    }

    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartLeft + chartWidth, chartBottom),
      axisPaint,
    );

    final count = math.max(1, steps.length);
    for (var i = 0; i < steps.length; i++) {
      final x = chartLeft + chartWidth * (i + .5) / count;
      canvas.drawLine(Offset(x, chartTop), Offset(x, chartBottom), gridPaint);
      _drawRotatedText(canvas, steps[i].label, Offset(x - 4, chartBottom + 44));
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    required TextStyle style,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: AdminSpacingTokens.adminPainterLabelMaxWidth);
    painter.paint(canvas, offset);
  }

  void _drawRotatedText(Canvas canvas, String text, Offset offset) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(-math.pi / 4);
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.chartLabelXs.copyWith(
          color: AppColors.text3,
          height: AdminSpacingTokens.adminLineHeightTight,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: AdminSpacingTokens.adminPainterWideLabelMaxWidth);
    painter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DropoutChartPainter oldDelegate) {
    return oldDelegate.steps != steps;
  }
}
