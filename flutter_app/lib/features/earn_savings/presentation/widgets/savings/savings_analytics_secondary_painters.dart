part of '../../phone/pages/savings/savings_analytics_page.dart';

class _SecondaryTabContent extends StatelessWidget {
  const _SecondaryTabContent({required this.tab, required this.summary});

  final String tab;
  final SavingsAnalyticsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    final icon = switch (tab) {
      'Compound' => Icons.auto_awesome_outlined,
      'APY' => Icons.percent_rounded,
      _ => Icons.pie_chart_outline_rounded,
    };
    final title = switch (tab) {
      'Compound' => 'Hiệu quả lãi kép',
      'APY' => 'Xu hướng APY',
      _ => 'Phân bổ tài sản',
    };
    final value = switch (tab) {
      'Compound' => '+\$121.48',
      'APY' => '${summary.weightedApy.toStringAsFixed(2)}%',
      _ => EarnFormatters.usd(summary.totalInvested),
    };
    final description = switch (tab) {
      'Compound' =>
        'Mô phỏng compound hằng ngày so với lãi đơn trong 12 tháng.',
      'APY' => 'Theo dõi APY bình quân gia quyền và độ ổn định theo thời gian.',
      _ => 'Tổng hợp flexible/locked và tỷ trọng từng tài sản trong danh mục.',
    };

    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPaddingHero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: AppSpacing.iconLg),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            style: AppTextStyles.pageTitle.copyWith(
              color: AppColors.buy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: EarnSpacingTokens.savingsConsumerBodyLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _YieldChart extends StatelessWidget {
  const _YieldChart({required this.points});

  final List<SavingsYieldPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labels = [180, 135, 90, 45, 0];
        final chartTop = 12.0;
        final chartHeight = constraints.maxHeight - 42;
        final xLabels = [
          points[1].date,
          points[3].date,
          points[5].date,
          points.last.date,
        ];
        const labelWidth = 56.0;
        final chartLeft = 38.0;
        final chartRight = constraints.maxWidth - 22;
        final labelStep = (chartRight - chartLeft) / (xLabels.length - 1);

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _YieldChartPainter(points: points)),
            ),
            for (final label in labels)
              Positioned(
                left: 0,
                top: chartTop + chartHeight * (1 - label / 180) - 6,
                child: _AxisText('\$$label'),
              ),
            for (var i = 0; i < xLabels.length; i++)
              Positioned(
                left: (chartLeft + labelStep * i - labelWidth / 2).clamp(
                  0.0,
                  constraints.maxWidth - labelWidth,
                ),
                bottom: 0,
                width: labelWidth,
                child: _AxisText(xLabels[i], align: TextAlign.center),
              ),
          ],
        );
      },
    );
  }
}

class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({required this.points});

  final List<SavingsMonthlyEarningsPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labels = [60, 45, 30, 15, 0];
        final chartTop = 8.0;
        final chartHeight = constraints.maxHeight - 28;
        final step = (constraints.maxWidth - 42) / points.length;

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _MonthlyBarsPainter(points: points)),
            ),
            for (final label in labels)
              Positioned(
                left: 0,
                top: chartTop + chartHeight * (1 - label / 60) - 6,
                child: _AxisText('\$$label'),
              ),
            for (var i = 0; i < points.length; i++)
              Positioned(
                left: 34 + step * i,
                bottom: 0,
                width: step,
                child: _AxisText(points[i].month, align: TextAlign.center),
              ),
          ],
        );
      },
    );
  }
}

class _AxisText extends StatelessWidget {
  const _AxisText(this.text, {this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: 1,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        height: EarnSpacingTokens.savingsConsumerChartLabelLineHeight,
        fontWeight: AppTextStyles.bold,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _YieldChartPainter extends CustomPainter {
  const _YieldChartPainter({required this.points});

  final List<SavingsYieldPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(38, 12, size.width - 60, size.height - 42);
    _drawGrid(canvas, chart, const [0, 45, 90, 135, 180], maxY: 180);
    _drawLine(
      canvas,
      chart,
      [for (final point in points) point.usdt],
      AppColors.buy,
      maxY: 180,
    );
    _drawLine(
      canvas,
      chart,
      [for (final point in points) point.btc],
      AppColors.warn,
      maxY: 180,
    );
    _drawLine(
      canvas,
      chart,
      [for (final point in points) point.sol],
      AppColors.accent,
      maxY: 180,
    );
    _drawLine(
      canvas,
      chart,
      [for (final point in points) point.total],
      AppColors.primary,
      maxY: 180,
    );
  }

  @override
  bool shouldRepaint(_YieldChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _MonthlyBarsPainter extends CustomPainter {
  const _MonthlyBarsPainter({required this.points});

  final List<SavingsMonthlyEarningsPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(34, 8, size.width - 42, size.height - 28);
    _drawGrid(canvas, chart, const [0, 15, 30, 45, 60], maxY: 60);

    final barWidth = chart.width / (points.length * 1.7);
    final step = chart.width / points.length;
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.buy, AppColors.buy20],
      ).createShader(chart);

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = chart.left + step * i + (step - barWidth) / 2;
      final height = chart.height * (point.earned / 60).clamp(0, 1);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chart.bottom - height, barWidth, height),
        AppRadii.xsCorner,
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_MonthlyBarsPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

void _drawGrid(
  Canvas canvas,
  Rect chart,
  List<int> labels, {
  required double maxY,
}) {
  final gridPaint = Paint()
    ..color = AppColors.divider
    ..strokeWidth = 1;
  for (final label in labels.reversed) {
    final y = chart.bottom - chart.height * (label / maxY);
    canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
  }
}

void _drawLine(
  Canvas canvas,
  Rect chart,
  List<double> values,
  Color color, {
  required double maxY,
}) {
  if (values.isEmpty) return;
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = chart.left + (chart.width / (values.length - 1)) * i;
    final y = chart.bottom - chart.height * (values[i] / maxY).clamp(0, 1);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke,
  );
}
