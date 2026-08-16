part of 'dca_multi_asset_page.dart';

class _SuccessCallout extends StatelessWidget {
  const _SuccessCallout({
    required this.icon,
    required this.title,
    required this.text,
    required this.score,
  });

  final IconData icon;
  final String title;
  final String text;
  final String score;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.buy20,
      padding: DcaSpacingTokens.dcaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.buy, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      text,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: AppTextStyles.amountMd.copyWith(
                  color: AppColors.buy,
                  height: DcaSpacingTokens.dcaMultiTightLineHeight,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Padding(
                padding: DcaSpacingTokens.dcaBottomPaddingX2,
                child: Text(
                  '/ 10',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricText extends StatelessWidget {
  const _MetricText({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.large = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (large ? AppTextStyles.sectionTitle : AppTextStyles.baseMedium)
              .copyWith(color: color, fontWeight: AppTextStyles.bold),
        ),
      ],
    );
  }
}

class _PercentBar extends StatelessWidget {
  const _PercentBar({
    required this.label,
    required this.valueLabel,
    required this.percent,
    required this.color,
  });

  final String label;
  final String valueLabel;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              valueLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: DcaSpacingTokens.dcaMultiProgressHeight,
            value: (percent / 100).clamp(0.0, 1.0),
            backgroundColor: AppColors.surface3,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _AllocationDonutPainter extends CustomPainter {
  const _AllocationDonutPainter({required this.allocations});

  final List<DcaMultiAssetAllocation> allocations;

  @override
  void paint(Canvas canvas, Size size) {
    if (allocations.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;
    for (var i = 0; i < allocations.length; i++) {
      final sweep = allocations[i].currentPercent / 100 * math.pi * 2;
      final paint = Paint()
        ..color = _assetColor(i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, start, sweep - 0.04, false, paint);
      _drawDonutLabel(
        canvas,
        center,
        radius + 26,
        start + sweep / 2,
        allocations[i].symbol,
      );
      start += sweep;
    }
    final innerPaint = Paint()
      ..color = AppColors.cardBg
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 22, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _AllocationDonutPainter oldDelegate) {
    return oldDelegate.allocations != allocations;
  }
}

class _StackedBarsPainter extends CustomPainter {
  const _StackedBarsPainter({required this.points});

  final List<DcaMultiAssetPerformancePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const bottomLabelHeight = 20.0;
    final chartHeight = size.height - bottomLabelHeight;
    final maxTotal = points.map((point) => point.totalUsd).reduce(math.max);
    final gap = size.width / (points.length * 3 + 1);
    final barWidth = gap * 1.6;
    final baseY = chartHeight;
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (var i = 0; i <= 3; i++) {
      final y = chartHeight - chartHeight * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = gap + i * gap * 3 + gap * 0.7;
      var top = baseY;
      final segments = [
        (point.btcUsd, AppColors.primary),
        (point.ethUsd, AppColors.buy),
        (point.bnbUsd, AppColors.warn),
        (point.solUsd, AppColors.accent),
      ];
      for (final segment in segments) {
        final height = chartHeight * segment.$1 / maxTotal;
        final rect = RRect.fromRectXY(
          Rect.fromLTWH(x, top - height, barWidth, height),
          AppRadii.xs,
          AppRadii.xs,
        );
        canvas.drawRRect(rect, Paint()..color = segment.$2);
        top -= height;
      }
      _drawBottomLabel(
        canvas,
        point.month,
        Offset(x + barWidth / 2, baseY + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StackedBarsPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

void _drawDonutLabel(
  Canvas canvas,
  Offset center,
  double radius,
  double angle,
  String label,
) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final offset = Offset(
    center.dx + math.cos(angle) * radius - textPainter.width / 2,
    center.dy + math.sin(angle) * radius - textPainter.height / 2,
  );
  textPainter.paint(canvas, offset);
}

void _drawBottomLabel(Canvas canvas, String label, Offset center) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(
    canvas,
    Offset(center.dx - textPainter.width / 2, center.dy),
  );
}

Color _assetColor(int index) {
  switch (index % 4) {
    case 0:
      return AppColors.primary;
    case 1:
      return AppColors.buy;
    case 2:
      return AppColors.warn;
    default:
      return AppColors.accent;
  }
}

// Delegates to the shared formatters in dca_currency_formatters.dart (see
// that file's doc comment for the formatUsd duplicate and the divergent
// per-screen _formatPercent implementations it consolidates).
String _formatUsd(num value) => formatUsd(value);

String _formatPercent(double value) => formatPercentTrimmed(value);
