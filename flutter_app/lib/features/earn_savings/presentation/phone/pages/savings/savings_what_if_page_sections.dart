part of 'savings_what_if_page.dart';

class _WhatIfHero extends StatelessWidget {
  const _WhatIfHero({
    required this.snapshot,
    required this.totalValue,
    required this.weightedApy,
    required this.selectedScenario,
    required this.assetCount,
  });

  final SavingsWhatIfSnapshot snapshot;
  final double totalValue;
  final double weightedApy;
  final SavingsWhatIfScenarioDraft selectedScenario;
  final int assetCount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsWhatIfPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: AppModuleAccents.earn,
                size: EarnSpacingTokens.savingsWhatIfHeroIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                snapshot.heroLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            'Danh mục hiện tại',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          Text(
            _money(totalValue),
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'APY ước tính hiện tại',
                  value: '${weightedApy.toStringAsFixed(1)}%',
                  valueColor: AppModuleAccents.earn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(label: 'Tài sản', value: '$assetCount'),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'Kịch bản',
                  value: selectedScenario.label,
                  valueColor: _riskColor(selectedScenario.riskLevel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: EarnSpacingTokens.earnCardPaddingX3X4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(
              color: valueColor ?? AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatIfTabs extends StatelessWidget {
  const _WhatIfTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: active,
      onChanged: onChanged,
      tabs: [for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label)],
    );
  }
}

class _ScenarioList extends StatelessWidget {
  const _ScenarioList({
    required this.scenarios,
    required this.selected,
    required this.customMultiplier,
    required this.customVolatility,
    required this.onScenarioChanged,
    required this.onCustomMultiplierChanged,
    required this.onCustomVolatilityChanged,
  });

  final List<SavingsWhatIfScenarioDraft> scenarios;
  final SavingsWhatIfScenarioId selected;
  final double customMultiplier;
  final double customVolatility;
  final ValueChanged<SavingsWhatIfScenarioId> onScenarioChanged;
  final ValueChanged<double> onCustomMultiplierChanged;
  final ValueChanged<double> onCustomVolatilityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsWhatIfPage.scenariosKey,
      children: [
        for (final scenario in scenarios) ...[
          _ScenarioCard(
            scenario: scenario,
            selected: selected == scenario.id,
            onTap: () => onScenarioChanged(scenario.id),
          ),
          if (scenario != scenarios.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        if (selected == SavingsWhatIfScenarioId.custom) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _CustomScenarioControls(
            multiplier: customMultiplier,
            volatility: customVolatility,
            onMultiplierChanged: onCustomMultiplierChanged,
            onVolatilityChanged: onCustomVolatilityChanged,
          ),
        ],
      ],
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({
    required this.scenario,
    required this.selected,
    required this.onTap,
  });

  final SavingsWhatIfScenarioDraft scenario;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(scenario.riskLevel);
    return VitCard(
      key: SavingsWhatIfPage.scenarioKey(scenario.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      borderColor: selected ? color.withValues(alpha: .45) : null,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(color: color, icon: _scenarioIcon(scenario.iconKey)),
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
                      scenario.label,
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    _RiskPill(level: scenario.riskLevel),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  scenario.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Wrap(
                  spacing: AppSpacing.x4,
                  runSpacing: AppSpacing.x1,
                  children: [
                    _MicroMetric(
                      label: 'APY',
                      value: _signedPct((scenario.apyMultiplier - 1) * 100),
                    ),
                    _MicroMetric(
                      label: 'Vol',
                      value: '${(scenario.volatility * 100).round()}%',
                    ),
                    _MicroMetric(
                      label: '',
                      value: '${scenario.durationMonths}M',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.visibility_outlined,
            color: selected ? color : AppColors.text3,
            size: EarnSpacingTokens.savingsWhatIfInlineIcon,
          ),
        ],
      ),
    );
  }
}

class _CustomScenarioControls extends StatelessWidget {
  const _CustomScenarioControls({
    required this.multiplier,
    required this.volatility,
    required this.onMultiplierChanged,
    required this.onVolatilityChanged,
  });

  final double multiplier;
  final double volatility;
  final ValueChanged<double> onMultiplierChanged;
  final ValueChanged<double> onVolatilityChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        children: [
          _SliderRow(
            label: 'APY multiplier',
            value: multiplier,
            min: .25,
            max: 2.5,
            divisions: 9,
            display: '${multiplier.toStringAsFixed(2)}x',
            onChanged: onMultiplierChanged,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _SliderRow(
            label: 'Biến động',
            value: volatility,
            min: .05,
            max: .45,
            divisions: 8,
            display: '${(volatility * 100).round()}%',
            onChanged: onVolatilityChanged,
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String display;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: _captionBold.copyWith(color: AppColors.text1),
              ),
            ),
            Text(
              display,
              style: _captionBold.copyWith(color: AppModuleAccents.earn),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppModuleAccents.earn,
            inactiveTrackColor: AppColors.surface3,
            thumbColor: AppModuleAccents.earn,
            overlayColor: AppModuleAccents.earn.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _PortfolioList extends StatelessWidget {
  const _PortfolioList({required this.positions});

  final List<SavingsWhatIfPortfolioPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsWhatIfPage.portfolioKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        children: [
          for (final position in positions) ...[
            _PortfolioRow(position: position),
            if (position != positions.last)
              const Divider(color: AppColors.divider, height: AppSpacing.x5),
          ],
        ],
      ),
    );
  }
}

class _PortfolioRow extends StatelessWidget {
  const _PortfolioRow({required this.position});

  final SavingsWhatIfPortfolioPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(position.colorKey);
    return Row(
      children: [
        _AssetBadge(asset: position.asset, color: color),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            position.product,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(color: AppColors.text1),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _money(position.amountUsd),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            Text(
              '${position.currentApyPct.toStringAsFixed(1)}%',
              style: _captionBold.copyWith(
                color: AppModuleAccents.earn,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
