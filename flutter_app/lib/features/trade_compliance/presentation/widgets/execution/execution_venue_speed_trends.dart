part of '../../phone/pages/execution/execution_venue_analysis_page.dart';

class _SpeedTab extends StatelessWidget {
  const _SpeedTab({required this.venues});

  final List<TradeExecutionVenueAnalysisMetric> venues;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Speed Metrics',
      density: VitDensity.tool,
      children: [
        for (final venue in venues)
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            borderColor: _venueBorder.withValues(alpha: .72),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        venue.venue,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.bolt_rounded,
                      color: venue.avgFillTime < .4 ? _venueGreen : _venueAmber,
                      size: TradeSpacingTokens.executionVenueBodyIcon,
                    ),
                    const SizedBox(
                      width: TradeSpacingTokens.executionVenueSortLabelGap,
                    ),
                    Text(
                      '${_formatSpeed(venue.avgFillTime)}s',
                      style: AppTextStyles.caption.copyWith(
                        color: venue.avgFillTime < .4
                            ? _venueGreen
                            : _venueAmber,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: _MetricBox(
                        label: 'Latency',
                        value: '${venue.avgLatency}ms',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _MetricBox(
                        label: 'Reliability',
                        value: '${venue.reliability.toStringAsFixed(2)}%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TrendsTab extends StatelessWidget {
  const _TrendsTab({required this.trends});

  final List<TradeExecutionVenueCostTrend> trends;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Cost Trends (Last 3 Months)',
      density: VitDensity.tool,
      children: [
        VitCard(
          density: VitDensity.tool,
          radius: VitCardRadius.tight,
          borderColor: _venueBorder.withValues(alpha: .72),
          child: Column(
            children: [
              for (final trend in trends) ...[
                Row(
                  children: [
                    SizedBox(
                      width: SharedSpacingTokens.homeHeroActionHeight,
                      child: Text(
                        trend.month,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _TrendBar(
                        value: trend.binance,
                        color: _venueAmber,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Text(
                      '${trend.binance.toStringAsFixed(2)} bps',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                if (trend != trends.last)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              VitCard(
                variant: VitCardVariant.inner,
                density: VitDensity.tool,
                radius: VitCardRadius.tight,
                borderColor: _venueGreen.withValues(alpha: .28),
                child: Text(
                  'Overall costs trending down 5% over last 3 months',
                  style: AppTextStyles.caption.copyWith(
                    color: _venueGreen,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendBar extends StatelessWidget {
  const _TrendBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.pillRadius,
      child: SizedBox(
        height: AppSpacing.pageRhythmCompactInnerGap,
        child: Stack(
          children: [
            const ColoredBox(color: _venuePanel2),
            FractionallySizedBox(
              widthFactor: (value / 5).clamp(0, 1).toDouble(),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.factor,
    required this.color,
  });

  final String label;
  final String value;
  final double factor;
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
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: SizedBox(
            height: AppSpacing.pageRhythmCompactInnerGap,
            child: Stack(
              children: [
                const ColoredBox(color: _venuePanel2),
                FractionallySizedBox(
                  widthFactor: factor.clamp(0, 1).toDouble(),
                  child: ColoredBox(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
