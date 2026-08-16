part of 'savings_what_if_page.dart';

double _weightedApy(List<SavingsWhatIfPortfolioPositionDraft> positions) {
  final total = _totalPortfolioValue(positions);
  if (total == 0) return 0;
  return positions.fold<double>(
    0,
    (sum, position) =>
        sum + position.currentApyPct * position.amountUsd / total,
  );
}

_ScenarioResult _simulateScenario(
  List<SavingsWhatIfPortfolioPositionDraft> portfolio,
  SavingsWhatIfScenarioDraft scenario,
  double customMultiplier,
  double customVolatility,
) {
  final totalValue = _totalPortfolioValue(portfolio);
  final multiplier = scenario.id == SavingsWhatIfScenarioId.custom
      ? customMultiplier
      : scenario.apyMultiplier;
  final volatility = scenario.id == SavingsWhatIfScenarioId.custom
      ? customVolatility
      : scenario.volatility;
  final months = scenario.durationMonths;
  const baseVariance = [
    .02,
    -.01,
    .03,
    -.02,
    .01,
    -.01,
    .02,
    -.015,
    .025,
    -.01,
    .015,
    -.02,
  ];
  const scenarioVariance = [
    -.05,
    .08,
    -.12,
    .06,
    -.03,
    .1,
    -.08,
    .04,
    -.06,
    .07,
    -.04,
    .05,
  ];

  var baselineValue = totalValue;
  var scenarioValue = totalValue;
  var baselineInterest = 0.0;
  var scenarioInterest = 0.0;
  var maxScenarioValue = totalValue;
  var maxDrawdown = 0.0;
  var recoveryMonths = 0;
  var hasRecovered = true;
  final baselineApy = _weightedApy(portfolio);
  final scenarioApy = baselineApy * multiplier;
  final points = <_MonthlyPoint>[];

  for (var i = 0; i < months; i++) {
    final baseRate = (baselineApy / 100 / 12) * (1 + baseVariance[i % 12]);
    final scenarioRate =
        (scenarioApy / 100 / 12) * (1 + scenarioVariance[i % 12] * volatility);
    final baseInterest = baselineValue * baseRate;
    final scenInterest = scenarioValue * scenarioRate;
    final boundedScenarioInterest = math.max(
      scenInterest,
      -scenarioValue * .02,
    );

    baselineValue += baseInterest;
    scenarioValue += boundedScenarioInterest;
    baselineInterest += baseInterest;
    scenarioInterest += math.max(scenInterest, 0);

    if (scenarioValue > maxScenarioValue) maxScenarioValue = scenarioValue;
    final drawdown =
        ((maxScenarioValue - scenarioValue) / maxScenarioValue) * 100;
    maxDrawdown = math.max(maxDrawdown, drawdown);
    if (scenarioValue < totalValue && hasRecovered) {
      hasRecovered = false;
      recoveryMonths = 0;
    }
    if (!hasRecovered && scenarioValue >= totalValue) {
      hasRecovered = true;
    }
    if (!hasRecovered) recoveryMonths++;

    points.add(
      _MonthlyPoint(
        baseline: _roundMoney(baselineValue),
        scenario: _roundMoney(scenarioValue),
      ),
    );
  }

  final assetImpact = [
    for (final position in portfolio)
      _AssetImpact(
        asset: position.asset,
        color: _assetColor(position.colorKey),
        baseInterest: _roundMoney(
          position.amountUsd * position.currentApyPct / 100 * months / 12,
        ),
        scenarioInterest: _roundMoney(
          math.max(
            position.amountUsd *
                position.currentApyPct *
                multiplier /
                100 *
                months /
                12,
            0,
          ),
        ),
        diff: _roundMoney(
          position.amountUsd *
              position.currentApyPct *
              (multiplier - 1) /
              100 *
              months /
              12,
        ),
      ),
  ];

  return _ScenarioResult(
    scenarioValue: _roundMoney(scenarioValue),
    baselineValue: _roundMoney(baselineValue),
    difference: _roundMoney(scenarioValue - baselineValue),
    differencePct: _roundMoney(
      ((scenarioValue - baselineValue) / baselineValue) * 100,
    ),
    baselineInterest: _roundMoney(baselineInterest),
    scenarioInterest: _roundMoney(scenarioInterest),
    maxDrawdown: _roundMoney(maxDrawdown),
    recoveryMonths: hasRecovered ? 0 : recoveryMonths,
    monthlyData: points,
    assetImpact: assetImpact,
  );
}

double _roundMoney(double value) => (value * 100).roundToDouble() / 100;

String _money(double value) {
  final sign = value < 0 ? '-' : '';
  final dollars = value.abs().round();
  final text = dollars.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return '$sign\$${buffer.toString()}.00';
}

String _signedPct(double value) {
  final rounded = value.round();
  return '${rounded >= 0 ? '+' : ''}$rounded%';
}

IconData _scenarioIcon(String key) {
  return switch (key) {
    'trending_down' => Icons.trending_down_rounded,
    'trending_up' => Icons.trending_up_rounded,
    'snowflake' => Icons.ac_unit_rounded,
    'storm' => Icons.thunderstorm_outlined,
    'flame' => Icons.local_fire_department_outlined,
    'sliders' => Icons.tune_rounded,
    _ => Icons.analytics_outlined,
  };
}

Color _riskColor(SavingsWhatIfRiskLevel level) {
  return switch (level) {
    SavingsWhatIfRiskLevel.low => AppColors.buy,
    SavingsWhatIfRiskLevel.medium => AppColors.warn,
    SavingsWhatIfRiskLevel.high => AppColors.sell,
    SavingsWhatIfRiskLevel.extreme => AppColors.sell,
  };
}

String _riskLabel(SavingsWhatIfRiskLevel level) {
  return switch (level) {
    SavingsWhatIfRiskLevel.low => 'Thấp',
    SavingsWhatIfRiskLevel.medium => 'Trung bình',
    SavingsWhatIfRiskLevel.high => 'Cao',
    SavingsWhatIfRiskLevel.extreme => 'Cực cao',
  };
}

Color _assetColor(String key) {
  return switch (key) {
    'buy' => AppColors.buy,
    'sell' => AppColors.sell,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    'primary' => AppColors.primary,
    _ => AppColors.text2,
  };
}
