part of '../../phone/pages/savings/savings_what_if_page.dart';

class _ResultsTab extends StatelessWidget {
  const _ResultsTab({
    required this.result,
    required this.scenario,
    required this.hasRun,
    required this.onRun,
    required this.onReset,
  });

  final _ScenarioResult result;
  final SavingsWhatIfScenarioDraft scenario;
  final bool hasRun;
  final VoidCallback onRun;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (!hasRun) {
      return _EmptyResults(onRun: onRun);
    }

    final positive = result.difference >= 0;
    final impactColor = positive ? AppColors.buy : AppColors.sell;
    return Column(
      key: SavingsWhatIfPage.resultsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VitSectionHeader(
          title: 'Kết quả mô phỏng',
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: AppModuleAccents.earn,
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX4,
          borderColor: impactColor.withValues(alpha: .35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _RoundIcon(
                    color: impactColor,
                    icon: _scenarioIcon(scenario.iconKey),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kịch bản: ${scenario.label}',
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        Text(
                          '${scenario.durationMonths} tháng · ${_riskLabel(scenario.riskLevel)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ImpactBadge(value: result.differencePct),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Giá trị cuối',
                      value: _money(result.scenarioValue),
                      color: impactColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Chênh lệch',
                      value:
                          '${positive ? '+' : ''}${_money(result.difference)}',
                      color: impactColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Lãi baseline',
                      value: _money(result.baselineInterest),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Lãi kịch bản',
                      value: _money(result.scenarioInterest),
                      color: impactColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ComparisonChart(result: result),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const VitSectionHeader(
          title: 'Ảnh hưởng theo tài sản',
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: AppModuleAccents.earn,
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        _AssetImpactList(result: result),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: SavingsWhatIfPage.resetKey,
                variant: VitCtaButtonVariant.secondary,
                onPressed: onReset,
                leading: const Icon(Icons.restart_alt_rounded),
                child: const Text('Reset'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                onPressed: onRun,
                leading: const Icon(Icons.play_arrow_rounded),
                child: const Text('Chạy lại'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onRun});

  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX5,
      child: Column(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: AppColors.text3,
            size: EarnSpacingTokens.savingsWhatIfEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Chưa chạy mô phỏng',
            style: _captionBold.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Chọn kịch bản và bấm "Chạy mô phỏng" để xem kết quả.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            onPressed: onRun,
            leading: const Icon(Icons.play_arrow_rounded),
            child: const Text('Chạy mô phỏng'),
          ),
        ],
      ),
    );
  }
}

class _ComparisonChart extends StatelessWidget {
  const _ComparisonChart({required this.result});

  final _ScenarioResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Baseline vs kịch bản',
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: EarnSpacingTokens.savingsWhatIfComparisonChartHeight,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(points: result.monthlyData),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VitLegendItem(color: AppColors.primary, label: 'Baseline'),
              SizedBox(width: AppSpacing.x4),
              VitLegendItem(color: AppColors.buy, label: 'Kịch bản'),
            ],
          ),
        ],
      ),
    );
  }
}
