part of '../../phone/pages/event/prediction_advanced_chart_page.dart';

class _TimeframeSelector extends StatelessWidget {
  const _TimeframeSelector({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const timeframes = ['1H', '4H', '1D', '1W'];
    return Row(
      children: [
        for (var index = 0; index < timeframes.length; index += 1) ...[
          Expanded(
            child: _TimeframeButton(
              key: timeframes[index] == '4H'
                  ? PredictionAdvancedChartPage.timeframe4hKey
                  : null,
              label: timeframes[index],
              active: active == timeframes[index],
              onTap: () => onChanged(timeframes[index]),
            ),
          ),
          if (index != timeframes.length - 1)
            const SizedBox(
              width: PredictionsSpacingTokens.predictionAdvancedTimeframeGap,
            ),
        ],
      ],
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  const _TimeframeButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: _predictionPrimary,
      fullWidth: true,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x2),
    );
  }
}

class _ProbabilitySummaryCard extends StatelessWidget {
  const _ProbabilitySummaryCard({required this.snapshot});

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
            'Current Probability',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(snapshot.currentProbability * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.amountMd,
              ),
              const SizedBox(
                width:
                    PredictionsSpacingTokens.predictionAdvancedSummaryValueGap,
              ),
              Padding(
                padding: PredictionsSpacingTokens
                    .predictionAdvancedSummaryChangePadding,
                child: Row(
                  children: [
                    const Icon(
                      Icons.north_east_rounded,
                      color: AppColors.buy,
                      size:
                          PredictionsSpacingTokens.predictionAdvancedTrendIcon,
                    ),
                    const SizedBox(
                      width: PredictionsSpacingTokens
                          .predictionAdvancedTrendIconGap,
                    ),
                    Text(
                      '+${snapshot.priceChangePercent.toStringAsFixed(2)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProbabilityChartCard extends StatelessWidget {
  const _ProbabilityChartCard({
    required this.snapshot,
    required this.showMA7,
    required this.showMA25,
    required this.showBB,
  });

  final PredictionAdvancedChartSnapshot snapshot;
  final bool showMA7;
  final bool showMA25;
  final bool showBB;

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
            'Probability Chart',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: AppSpacing.x7 * 6,
                // PERF-HN5: isolate the heavy chart painter into its own
                // compositor layer.
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _ProbabilityPainter(
                      points: snapshot.priceHistory,
                      support: snapshot.supportLevel,
                      resistance: snapshot.resistanceLevel,
                      showMA7: showMA7,
                      showMA25: showMA25,
                      showBB: showBB,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VolumeChartCard extends StatelessWidget {
  const _VolumeChartCard({required this.snapshot});

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
            'Trading Volume',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: AppSpacing.x7 * 3,
                // PERF-HN5: isolate the heavy chart painter into its own
                // compositor layer.
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _VolumePainter(points: snapshot.priceHistory),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartLayerControls extends StatelessWidget {
  const _ChartLayerControls({
    required this.showMA7,
    required this.showMA25,
    required this.showBB,
    required this.showVolume,
    required this.onMA7,
    required this.onMA25,
    required this.onBB,
    required this.onVolume,
  });

  final bool showMA7;
  final bool showMA25;
  final bool showBB;
  final bool showVolume;
  final VoidCallback onMA7;
  final VoidCallback onMA25;
  final VoidCallback onBB;
  final VoidCallback onVolume;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Lop hien thi',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        GridView.count(
          crossAxisCount:
              PredictionsSpacingTokens.predictionAdvancedLayerColumns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: PredictionsSpacingTokens.predictionAdvancedLayerGap,
          crossAxisSpacing: PredictionsSpacingTokens.predictionAdvancedLayerGap,
          childAspectRatio:
              PredictionsSpacingTokens.predictionAdvancedLayerAspect,
          children: [
            _LayerButton(
              key: PredictionAdvancedChartPage.ma7ToggleKey,
              label: 'MA(7)',
              color: AppColors.buy,
              active: showMA7,
              onTap: onMA7,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.ma25ToggleKey,
              label: 'MA(25)',
              color: _purple,
              active: showMA25,
              onTap: onMA25,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.bbToggleKey,
              label: 'Bollinger Bands',
              color: AppColors.warn,
              active: showBB,
              onTap: onBB,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.volumeToggleKey,
              label: 'Volume',
              color: _predictionPrimary,
              active: showVolume,
              onTap: onVolume,
            ),
          ],
        ),
      ],
    );
  }
}

class _LayerButton extends StatelessWidget {
  const _LayerButton({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: active ? color : AppColors.border,
      background: active
          ? ColoredBox(color: color.withValues(alpha: .08))
          : null,
      clip: active,
      padding: PredictionsSpacingTokens.predictionAdvancedLayerPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: active ? color : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Icon(
            active ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: PredictionsSpacingTokens.predictionAdvancedLayerIcon,
            color: active ? color : AppColors.text3,
          ),
        ],
      ),
    );
  }
}
