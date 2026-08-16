part of '../../phone/pages/event/prediction_advanced_chart_page.dart';

class _OrderFlowCard extends StatelessWidget {
  const _OrderFlowCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: VitPageContent(
        rhythm: VitPageRhythm.flush,
        padding: VitContentPadding.none,
        fullBleed: true,
        gap: VitContentGap.tight,
        children: [
          Text(
            'Order Flow (Buy vs Sell Pressure)',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: AppSpacing.x7 * 4,
                child: CustomPaint(
                  painter: _OrderFlowPainter(points: snapshot.orderFlow),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Expanded(
                child: _LegendItem(label: 'Buy Volume', color: AppColors.buy),
              ),
              Expanded(
                child: _LegendItem(label: 'Sell Volume', color: AppColors.sell),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportResistanceSection extends StatelessWidget {
  const _SupportResistanceSection({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Support & Resistance',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        _LevelCard(
          label: 'Resistance',
          value: snapshot.resistanceLevel,
          helper:
              '${((snapshot.currentProbability - snapshot.resistanceLevel) * 100).toStringAsFixed(1)}% to reach',
          color: AppColors.sell,
        ),
        _LevelCard(
          label: 'Support',
          value: snapshot.supportLevel,
          helper:
              '${((snapshot.currentProbability - snapshot.supportLevel) * 100).toStringAsFixed(1)}% above support',
          color: AppColors.buy,
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
  });

  final String label;
  final double value;
  final String helper;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .18),
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${(value * 100).toStringAsFixed(1)}%',
                  style: AppTextStyles.sectionTitle.copyWith(color: color),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  helper,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Icon(
            Icons.track_changes_rounded,
            color: color,
            size: PredictionsSpacingTokens.predictionAdvancedLevelIcon,
          ),
        ],
      ),
    );
  }
}

class _PatternRecognitionCard extends StatelessWidget {
  const _PatternRecognitionCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: VitPageContent(
        rhythm: VitPageRhythm.flush,
        padding: VitContentPadding.none,
        fullBleed: true,
        gap: VitContentGap.tight,
        children: [
          Text(
            'Pattern Recognition',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          for (final pattern in snapshot.patterns)
            _PatternRow(pattern: pattern),
        ],
      ),
    );
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({required this.pattern});

  final PredictionPatternDraft pattern;

  @override
  Widget build(BuildContext context) {
    final color = pattern.bullish ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    pattern.name,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(
                    width: PredictionsSpacingTokens
                        .predictionAdvancedPatternIconGap,
                  ),
                  Icon(
                    Icons.trending_up_rounded,
                    color: color,
                    size:
                        PredictionsSpacingTokens.predictionAdvancedPatternIcon,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x1),
              ClipRRect(
                borderRadius: AppRadii.xsRadius,
                child: SizedBox(
                  height: AppSpacing.x1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: pattern.confidence / 100,
                      child: ColoredBox(color: color),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width:
              PredictionsSpacingTokens.predictionAdvancedPatternConfidenceGap,
        ),
        Text(
          '${pattern.confidence}%',
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _AnalysisDisclaimer extends StatelessWidget {
  const _AnalysisDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn.withValues(alpha: .20),
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: PredictionsSpacingTokens.predictionAdvancedDisclaimerIcon,
          ),
          const SizedBox(
            width: PredictionsSpacingTokens.predictionAdvancedDisclaimerGap,
          ),
          Expanded(
            child: Text(
              'Phan tich ky thuat chi mang tinh tham khao. Khong dam bao ket qua tuong lai. Ket hop voi nghien cuu co ban de quyet dinh.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: color,
          borderRadius: AppRadii.hairlineRadius,
          child: const SizedBox.square(
            dimension: PredictionsSpacingTokens.predictionAdvancedLegendSwatch,
          ),
        ),
        const SizedBox(
          width: PredictionsSpacingTokens.predictionAdvancedLegendGap,
        ),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _OrderFlowPainter extends CustomPainter {
  const _OrderFlowPainter({required this.points});

  final List<PredictionOrderFlowDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(36, 6, size.width - 42, size.height - 18);
    final maxValue = points
        .map((point) => point.buyVolume + point.sellVolume)
        .reduce(math.max)
        .toDouble();
    final rowHeight = chart.height / points.length;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < points.length; i += 1) {
      final point = points[i];
      final y = chart.top + i * rowHeight + 7;
      textPainter.text = TextSpan(
        text: point.price.toStringAsFixed(2),
        style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y + 5));
      final buyWidth = chart.width * point.buyVolume / maxValue;
      final sellWidth = chart.width * point.sellVolume / maxValue;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(chart.left, y, buyWidth, 11),
          AppRadii.xsCorner,
        ),
        Paint()..color = AppColors.buy,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(chart.left + buyWidth, y, sellWidth, 11),
          AppRadii.xsCorner,
        ),
        Paint()..color = AppColors.sell,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrderFlowPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
