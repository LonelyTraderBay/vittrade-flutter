part of '../../phone/pages/disclosures/performance_scenarios_page.dart';

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({
    required this.scenario,
    required this.investment,
    required this.holdingPeriod,
  });

  final TradePerformanceScenario scenario;
  final double investment;
  final int holdingPeriod;

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(scenario.type);
    final outcome = scenario.outcomeFor(investment, holdingPeriod);
    final profit = scenario.profitFor(investment, holdingPeriod);

    return VitCard(
      key: PerformanceScenariosPage.scenarioKey(scenario.label),
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _scenarioBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            width: _scenarioIconTile,
            height: _scenarioIconTile,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .18),
            child: Icon(
              _iconForType(scenario.type),
              color: color,
              size: AppSpacing.x4,
            ),
          ),
          const SizedBox(width: _scenarioSpace),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${scenario.label} Scenario',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          height: _scenarioLineTight,
                        ),
                      ),
                    ),
                    const SizedBox(width: _scenarioTinySpace),
                    Text(
                      _formatReturn(scenario.annualReturnPct),
                      style: AppTextStyles.baseMedium.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        height: _scenarioLineTight,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _scenarioSpace),
                Row(
                  children: [
                    Expanded(
                      child: _MetricBox(
                        label: 'Value After ${holdingPeriod}Y',
                        value: _formatEur(outcome),
                        valueColor: AppColors.text1,
                      ),
                    ),
                    const SizedBox(width: _scenarioTinySpace),
                    Expanded(
                      child: _MetricBox(
                        label: 'Profit/Loss',
                        value: _formatSignedEur(profit),
                        valueColor: profit >= 0 ? _scenarioGreen : _scenarioRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _scenarioLineTight,
            ),
          ),
          const SizedBox(height: _scenarioTinySpace),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.numericCode.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              height: _scenarioLineTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: AppColors.borderSolid.withValues(alpha: .5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text1,
            size: AppSpacing.x4,
          ),
          const SizedBox(width: _scenarioSpace),
          Expanded(
            child: Text(
              'Scenarios calculated using statistical models based on '
              'historical volatility and returns. The stress scenario shows '
              'what you might get back in extreme market conditions.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: _scenarioLineTight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconForType(TradePerformanceScenarioType type) {
  return switch (type) {
    TradePerformanceScenarioType.stress => Icons.trending_down_rounded,
    TradePerformanceScenarioType.unfavorable => Icons.trending_down_rounded,
    TradePerformanceScenarioType.moderate => Icons.remove_rounded,
    TradePerformanceScenarioType.favorable => Icons.trending_up_rounded,
  };
}

Color _colorForType(TradePerformanceScenarioType type) {
  return switch (type) {
    TradePerformanceScenarioType.stress => _scenarioRed,
    TradePerformanceScenarioType.unfavorable => _scenarioAmber,
    TradePerformanceScenarioType.moderate => _scenarioPrimary,
    TradePerformanceScenarioType.favorable => _scenarioGreen,
  };
}

String _formatReturn(double value) {
  final rounded = value.round();
  final sign = rounded > 0 ? '+' : '';
  return '$sign$rounded% p.a.';
}

String _formatSignedEur(double value) {
  final rounded = value.round();
  final sign = rounded >= 0 ? '+' : '-';
  return '$sign\u20AC${_groupThousands(rounded.abs())}';
}

String _formatEur(double value) => formatTradeEur(value);

String _groupThousands(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < raw.length; index += 1) {
    if (index > 0 && (raw.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(raw[index]);
  }
  return buffer.toString();
}
