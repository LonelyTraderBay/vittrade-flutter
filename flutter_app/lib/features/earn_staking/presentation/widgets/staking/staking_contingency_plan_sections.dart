part of '../../phone/pages/staking/staking_contingency_plan_page.dart';

class _RecoveryMetrics extends StatelessWidget {
  const _RecoveryMetrics({required this.metrics});

  final List<StakingContingencyMetricDraft> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingContingencyPlanPage.metricsKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Recovery Metrics', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  EarnSpacingTokens.stakingContingencyMetricGridColumns,
              crossAxisSpacing: AppSpacing.x3,
              mainAxisSpacing: AppSpacing.x3,
              childAspectRatio:
                  EarnSpacingTokens.stakingContingencyMetricGridAspect,
            ),
            itemBuilder: (context, index) {
              return _MetricTile(metric: metrics[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final StakingContingencyMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(metric.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: metric.tone == 'success' ? AppColors.buy20 : null,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            metric.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: metric.tone == 'success' ? color : AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenariosSection extends StatelessWidget {
  const _ScenariosSection({required this.scenarios});

  final List<StakingContingencyScenarioDraft> scenarios;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingContingencyPlanPage.scenariosKey,
      label: 'Contingency Scenarios',
      accentColor: AppColors.primarySoft,
      children: [
        for (final scenario in scenarios) _ScenarioCard(scenario: scenario),
      ],
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final StakingContingencyScenarioDraft scenario;

  @override
  Widget build(BuildContext context) {
    final impactColor = _impactColor(scenario.impact);
    return VitCard(
      key: StakingContingencyPlanPage.scenarioKey(scenario.scenario),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(scenario.scenario, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _Pill(label: scenario.likelihood, color: AppColors.text3),
              _Pill(
                label: '${scenario.impact} Impact',
                color: impactColor,
                emphasis: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            padding: EarnSpacingTokens.earnCardPaddingX4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Immediate Response',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                for (var i = 0; i < scenario.response.length; i++)
                  Padding(
                    padding: EarnSpacingTokens.earnBottomPaddingX2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: AppSpacing.x5,
                          child: Text(
                            '${i + 1}.',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            scenario.response[i],
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text2,
                              height: EarnSpacingTokens
                                  .stakingContingencyResponseLineHeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Preventative Measures',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final measure in scenario.preventative)
                _Pill(label: measure, color: AppColors.buy, emphasis: true),
            ],
          ),
        ],
      ),
    );
  }
}
