part of '../../phone/pages/bridge/launchpad_bridge_compare_page.dart';

class _QuickComparisonCard extends StatelessWidget {
  const _QuickComparisonCard({required this.comparison});

  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeComparePage.quickCompareKey,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'So sánh nhanh',
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _MetricBars(
            title: 'Output (${comparison.outputToken})',
            routes: comparison.routes,
            metric: _BridgeMetric.output,
            bestRouteId: comparison.bestOutput,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _MetricBars(
            title: 'Tổng phí (USD)',
            routes: comparison.routes,
            metric: _BridgeMetric.fee,
            bestRouteId: comparison.bestFee,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _MetricBars(
            title: 'Thời gian',
            routes: comparison.routes,
            metric: _BridgeMetric.speed,
            bestRouteId: comparison.bestSpeed,
          ),
        ],
      ),
    );
  }
}

enum _BridgeMetric { output, fee, speed }

class _MetricBars extends StatelessWidget {
  const _MetricBars({
    required this.title,
    required this.routes,
    required this.metric,
    required this.bestRouteId,
  });

  final String title;
  final List<LaunchpadBridgeRouteOptionDraft> routes;
  final _BridgeMetric metric;
  final String bestRouteId;

  @override
  Widget build(BuildContext context) {
    final values = routes.map(_metricValue).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final route in routes)
          _MetricBarRow(
            route: route,
            value: _metricValue(route),
            label: _metricLabel(route),
            fraction: _fraction(_metricValue(route), minValue, maxValue),
            best: route.id == bestRouteId,
            metric: metric,
          ),
      ],
    );
  }

  double _metricValue(LaunchpadBridgeRouteOptionDraft route) {
    return switch (metric) {
      _BridgeMetric.output => route.outputAmount,
      _BridgeMetric.fee => route.totalFee,
      _BridgeMetric.speed => route.estimatedSeconds.toDouble(),
    };
  }

  String _metricLabel(LaunchpadBridgeRouteOptionDraft route) {
    return switch (metric) {
      _BridgeMetric.output => _formatNumber(route.outputAmount),
      _BridgeMetric.fee => route.totalFeeUsd,
      _BridgeMetric.speed => route.estimatedTime,
    };
  }

  double _fraction(double value, double minValue, double maxValue) {
    if (maxValue == minValue) return 1;
    if (metric == _BridgeMetric.output) {
      return (((value - minValue) / (maxValue - minValue)) * .6 + .4).clamp(
        .15,
        1,
      );
    }
    return (value / maxValue).clamp(.15, 1);
  }
}

class _MetricBarRow extends StatelessWidget {
  const _MetricBarRow({
    required this.route,
    required this.value,
    required this.label,
    required this.fraction,
    required this.best,
    required this.metric,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final double value;
  final String label;
  final double fraction;
  final bool best;
  final _BridgeMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = best
        ? AppColors.buy
        : metric == _BridgeMetric.fee
        ? AppColors.sell
        : route.accent.resolve();
    return Padding(
      padding: LaunchpadSpacingTokens.launchpadBottomPaddingX2,
      child: Row(
        children: [
          SizedBox(
            width: LaunchpadSpacingTokens.launchpadBox28,
            child: Text(
              route.providerIcon,
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadii.xlRadius,
              child: ColoredBox(
                color: AppColors.surface2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: fraction,
                    child: SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: color.withValues(alpha: best ? 1 : .58),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadii.xlRadius,
                          ),
                        ),
                        child: Padding(
                          padding:
                              LaunchpadSpacingTokens.launchpadRightPaddingX2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.onAccent,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          SizedBox(
            width: LaunchpadSpacingTokens.launchpadIconMd,
            child: best
                ? const Icon(
                    Icons.star_rounded,
                    color: AppColors.buy,
                    size: LaunchpadSpacingTokens.launchpadIconXs,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
