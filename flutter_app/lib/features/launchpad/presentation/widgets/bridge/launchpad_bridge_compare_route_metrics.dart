part of '../../phone/pages/bridge/launchpad_bridge_compare_page.dart';

class _RouteTags extends StatelessWidget {
  const _RouteTags({required this.route, required this.comparison});

  final LaunchpadBridgeRouteOptionDraft route;
  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    final tags = <_RouteTag>[
      if (route.id == comparison.bestOutput)
        const _RouteTag('Best output', AppColors.buy),
      if (route.id == comparison.bestFee)
        const _RouteTag('Lowest fee', AppColors.buy),
      if (route.id == comparison.bestSpeed)
        const _RouteTag('Fastest', AppColors.warn),
      if (route.id == comparison.bestSecurity)
        const _RouteTag('Most secure', AppColors.accent),
      for (final tag in route.tags.where(
        (tag) => ![
          'Best output',
          'Lowest fee',
          'Fastest',
          'Most secure',
        ].contains(tag),
      ))
        _RouteTag(tag, AppColors.accent),
      for (final warning in route.warnings) _RouteTag(warning, AppColors.sell),
    ];

    return Wrap(
      spacing: AppSpacing.x1,
      runSpacing: AppSpacing.x1,
      children: [for (final tag in tags) _MetricTag(tag: tag)],
    );
  }
}

class _RouteTag {
  const _RouteTag(this.label, this.color);

  final String label;
  final Color color;
}

class _MetricTag extends StatelessWidget {
  const _MetricTag({required this.tag});

  final _RouteTag tag;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: tag.color.withValues(alpha: .10),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.xsRadius,
          side: BorderSide(color: tag.color.withValues(alpha: .16)),
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadMiniChipPadding,
        child: Text(
          tag.label,
          style: AppTextStyles.micro.copyWith(
            color: tag.color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RouteMetrics extends StatelessWidget {
  const _RouteMetrics({required this.route, required this.comparison});

  final LaunchpadBridgeRouteOptionDraft route;
  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    final outputDiff =
        ((route.outputAmount - _bestOutput(comparison)) /
                _bestOutput(comparison) *
                100)
            .toStringAsFixed(2);
    return Row(
      children: [
        Expanded(
          child: _RouteMetric(
            label: 'Output',
            value: _formatNumber(route.outputAmount),
            subvalue: route.id == comparison.bestOutput ? null : '$outputDiff%',
            color: route.id == comparison.bestOutput
                ? AppColors.buy
                : AppColors.text1,
            subvalueColor: AppColors.sell,
          ),
        ),
        Expanded(
          child: _RouteMetric(
            label: 'Phí',
            value: route.totalFeeUsd,
            color: route.id == comparison.bestFee
                ? AppColors.buy
                : AppColors.text1,
          ),
        ),
        Expanded(
          child: _RouteMetric(
            label: 'Thời gian',
            value: route.estimatedTime,
            color: route.id == comparison.bestSpeed
                ? AppColors.buy
                : AppColors.text1,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  _SecurityDots(score: route.securityScore),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    '${route.securityScore}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
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

  double _bestOutput(LaunchpadBridgeComparisonDraft comparison) {
    return comparison.routes
        .firstWhere((route) => route.id == comparison.bestOutput)
        .outputAmount;
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({
    required this.label,
    required this.value,
    this.subvalue,
    this.color = AppColors.text1,
    this.subvalueColor = AppColors.text3,
  });

  final String label;
  final String value;
  final String? subvalue;
  final Color color;
  final Color subvalueColor;

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
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        if (subvalue != null)
          Text(
            subvalue!,
            style: AppTextStyles.micro.copyWith(
              color: subvalueColor,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
      ],
    );
  }
}

class _SecurityDots extends StatelessWidget {
  const _SecurityDots({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final filled = ((score / 100) * 5).round();
    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Padding(
            padding: LaunchpadSpacingTokens.launchpadRightMarginXxs,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: i < filled
                    ? AppColors.buy
                    : AppColors.text3.withValues(alpha: .30),
                shape: const CircleBorder(),
              ),
              child: const SizedBox(
                width: LaunchpadSpacingTokens.launchpadDotXs,
                height: LaunchpadSpacingTokens.launchpadDotXs,
              ),
            ),
          ),
      ],
    );
  }
}
