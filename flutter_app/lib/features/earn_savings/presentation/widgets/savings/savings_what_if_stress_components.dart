part of '../../phone/pages/savings/savings_what_if_page.dart';

class _StressBars extends StatelessWidget {
  const _StressBars({required this.results});

  final List<_StressScenarioResult> results;

  @override
  Widget build(BuildContext context) {
    final maxAbs = results.fold<double>(
      1,
      (maxValue, entry) => math.max(maxValue, entry.result.differencePct.abs()),
    );
    return Column(
      children: [
        for (final entry in results) ...[
          Row(
            children: [
              SizedBox(
                width: EarnSpacingTokens.savingsWhatIfStressLabelWidth,
                child: Text(
                  entry.scenario.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.smRadius,
                  child: LinearProgressIndicator(
                    minHeight:
                        EarnSpacingTokens.savingsWhatIfStressProgressHeight,
                    value: entry.result.differencePct.abs() / maxAbs,
                    backgroundColor: AppColors.surface3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      entry.result.differencePct >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              SizedBox(
                width: EarnSpacingTokens.savingsWhatIfStressValueWidth,
                child: Text(
                  '${entry.result.differencePct >= 0 ? '+' : ''}${entry.result.differencePct.toStringAsFixed(1)}%',
                  textAlign: TextAlign.right,
                  style: _microBold.copyWith(
                    color: entry.result.differencePct >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          if (entry != results.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _StressRankCard extends StatelessWidget {
  const _StressRankCard({required this.entry});

  final _StressScenarioResult entry;

  @override
  Widget build(BuildContext context) {
    final result = entry.result;
    final color = result.difference >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      borderColor: color.withValues(alpha: .18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoundIcon(
                color: color,
                icon: _scenarioIcon(entry.scenario.iconKey),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          entry.scenario.label,
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        _RiskPill(level: entry.scenario.riskLevel),
                      ],
                    ),
                    Text(
                      entry.scenario.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                '${result.differencePct >= 0 ? '+' : ''}${result.differencePct.toStringAsFixed(1)}%',
                style: _captionBold.copyWith(
                  color: color,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Giá trị cuối',
                  value: _money(result.scenarioValue),
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricTile(
                  label: 'Drawdown',
                  value: '${result.maxDrawdown.toStringAsFixed(2)}%',
                  color: result.maxDrawdown > 1
                      ? AppColors.sell
                      : AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricTile(
                  label: 'Hồi phục',
                  value: result.recoveryMonths == 0
                      ? '-'
                      : '${result.recoveryMonths}M',
                  color: result.recoveryMonths == 0
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
