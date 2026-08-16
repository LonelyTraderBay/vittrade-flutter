part of '../../phone/pages/event/prediction_advanced_chart_page.dart';

class _RsiCard extends StatelessWidget {
  const _RsiCard({required this.snapshot});

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
          Row(
            children: [
              Expanded(
                child: Text(
                  'RSI (Relative Strength Index)',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${snapshot.currentRsi}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: AppSpacing.x7 * 3,
                child: CustomPaint(
                  painter: _RsiPainter(points: snapshot.priceHistory),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: PredictionsSpacingTokens.predictionAdvancedRsiInfoIcon,
                color: AppColors.text3,
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionAdvancedRsiInfoGap,
              ),
              Expanded(
                child: Text(
                  'RSI > 70: Overbought - RSI < 30: Oversold',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IndicatorSummarySection extends StatelessWidget {
  const _IndicatorSummarySection({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Technical Indicators',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        for (final indicator in snapshot.indicators)
          _IndicatorCard(indicator: indicator),
      ],
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({required this.indicator});

  final PredictionIndicatorSignalDraft indicator;

  @override
  Widget build(BuildContext context) {
    final widthFactor = switch (indicator.strength) {
      'Strong' => .80,
      'Moderate' => .50,
      _ => .25,
    };
    final color = indicator.tone.resolve();
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      indicator.name,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      indicator.description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SignalBadge(label: indicator.signal, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.xsRadius,
                  child: SizedBox(
                    height: AppSpacing.x1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: widthFactor,
                        child: ColoredBox(color: color),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionAdvancedStrengthGap,
              ),
              Text(
                indicator.strength,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverallSignalCard extends StatelessWidget {
  const _OverallSignalCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Overall Signal',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.buy,
                size: PredictionsSpacingTokens.predictionAdvancedOverallIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'BULLISH',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.buy),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '3/4 indicators show buy signal. Momentum is positive.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _SignalBadge extends StatelessWidget {
  const _SignalBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .15),
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionAdvancedSignalBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RsiPainter extends CustomPainter {
  const _RsiPainter({required this.points});

  final List<PredictionChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(38, 4, size.width - 44, size.height - 26);
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
    _drawDashedHorizontal(
      canvas,
      chart,
      chart.bottom - chart.height * .70,
      AppColors.sell,
    );
    _drawDashedHorizontal(
      canvas,
      chart,
      chart.bottom - chart.height * .30,
      AppColors.buy,
    );
    _drawSeries(
      canvas,
      chart,
      points.map((point) => point.rsi / 100).toList(),
      0,
      1,
      _purple,
      width: 2.2,
    );
  }

  @override
  bool shouldRepaint(covariant _RsiPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
