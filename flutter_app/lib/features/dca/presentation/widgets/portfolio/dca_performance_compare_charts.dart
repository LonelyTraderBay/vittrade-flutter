part of '../../phone/pages/portfolio/dca_performance_compare_page.dart';

class _ComparisonChartCard extends StatelessWidget {
  const _ComparisonChartCard({required this.points});

  final List<DcaPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Portfolio Value Over Time'),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: DcaSpacingTokens.dcaPerformanceCompareChartHeight,
            width: double.infinity,
            child: CustomPaint(painter: _PerformanceLinePainter(points)),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(label: 'DCA', color: AppColors.buy),
              SizedBox(width: AppSpacing.x5),
              _Legend(label: 'Lump Sum', color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCompareCard extends StatelessWidget {
  const _MetricCompareCard(this.metric);

  final DcaComparisonMetric metric;

  @override
  Widget build(BuildContext context) {
    final dcaWins = metric.winner == DcaPerformanceWinner.dca;
    return VitCard(
      radius: VitCardRadius.standard,
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MetricValueBox(
                  value: metric.dcaValue,
                  label: 'DCA',
                  active: dcaWins,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricValueBox(
                  value: metric.lumpSumValue,
                  label: 'Lump Sum',
                  active: !dcaWins,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricValueBox extends StatelessWidget {
  const _MetricValueBox({
    required this.value,
    required this.label,
    required this.active,
    required this.color,
  });

  final String value;
  final String label;
  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: active ? color.withValues(alpha: 0.12) : AppColors.surface2,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: DcaSpacingTokens.dcaPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: active ? color : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final DcaVolatilityScenario scenario;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scenario.name,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          Text(
            scenario.scenario,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            scenario.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _AdvantageBar(
            label: 'DCA Advantage',
            value: scenario.dcaAdvantage,
            color: AppColors.buy,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _AdvantageBar(
            label: 'Lump Sum Advantage',
            value: scenario.lumpSumAdvantage,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _AdvantageBar extends StatelessWidget {
  const _AdvantageBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
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
              '$value/10',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: DcaSpacingTokens.dcaPerformanceCompareProgressHeight,
            value: (value / 10).clamp(0.0, 1.0),
            backgroundColor: AppColors.surface3,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _RadarCard extends StatelessWidget {
  const _RadarCard({required this.metrics});

  final List<DcaRadarMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Multi-Dimensional Comparison'),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: DcaSpacingTokens.dcaPerformanceCompareRadarHeight,
            width: double.infinity,
            child: CustomPaint(painter: _RadarPainter(metrics)),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(label: 'DCA', color: AppColors.buy),
              SizedBox(width: AppSpacing.x5),
              _Legend(label: 'Lump Sum', color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}
