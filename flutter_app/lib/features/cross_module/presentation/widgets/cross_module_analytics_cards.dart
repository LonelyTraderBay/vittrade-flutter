part of '../phone/pages/cross_module_analytics_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Avg ROI',
                value: '+${snapshot.averageRoi.toStringAsFixed(1)}%',
                valueColor: AppColors.buy,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _SummaryCard(
                label: 'Total Trades',
                value: '${snapshot.totalTrades}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Total Volume',
                value: '\$${(snapshot.totalVolume / 1000).toStringAsFixed(0)}K',
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: _SummaryCard(
                label: 'Avg Win Rate',
                value: '${snapshot.averageWinRate.toStringAsFixed(0)}%',
                valueColor: AppColors.buy,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightCards extends StatelessWidget {
  const _HighlightCards({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HighlightCard(
            title: 'Best ROI',
            module: snapshot.bestRoiModule.name,
            value: '+${snapshot.bestRoiModule.roi.toStringAsFixed(1)}%',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _HighlightCard(
            title: 'Most Active',
            module: snapshot.mostActiveModule.name,
            value: '${snapshot.mostActiveModule.totalTrades} trades',
            icon: Icons.timeline_rounded,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.title,
    required this.module,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String module;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .24),
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            module,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricDetailCard extends StatelessWidget {
  const _MetricDetailCard({required this.module});

  final CrossModuleMetricDraft module;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            module.name,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _MetricValue(label: 'ROI', value: '+${module.roi}%'),
              ),
              Expanded(
                child: _MetricValue(
                  label: 'Win Rate',
                  value: '${module.winRate}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MetricValue(
                  label: 'Total Trades',
                  value: '${module.totalTrades}',
                ),
              ),
              Expanded(
                child: _MetricValue(
                  label: 'Avg Size',
                  value: '\$${module.avgTradeSize}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Risk Score',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${module.riskScore}/100',
                style: AppTextStyles.caption.copyWith(
                  color: _riskColor(module.riskScore),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: module.riskScore / 100,
              minHeight: AppSpacing.x2,
              backgroundColor: AppColors.surface3,
              color: _riskColor(module.riskScore),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _EfficiencyRow extends StatelessWidget {
  const _EfficiencyRow({required this.rank, required this.module});

  final int rank;
  final CrossModuleMetricDraft module;

  @override
  Widget build(BuildContext context) {
    final efficiency = _efficiency(module);
    return VitCard(
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.buttonCompact,
                child: rank == 1
                    ? const Icon(
                        Icons.adjust_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconMd,
                      )
                    : Text(
                        '#$rank',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  module.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                efficiency.toStringAsFixed(1),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MetricValue(label: 'ROI', value: '${module.roi}%'),
              ),
              Expanded(
                child: _MetricValue(
                  label: 'Risk',
                  value: '${module.riskScore}/100',
                ),
              ),
              Expanded(
                child: _MetricValue(
                  label: 'Efficiency',
                  value: efficiency.toStringAsFixed(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
