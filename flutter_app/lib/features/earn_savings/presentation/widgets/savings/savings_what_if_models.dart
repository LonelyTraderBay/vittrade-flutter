part of '../../phone/pages/savings/savings_what_if_page.dart';

final class _ScenarioResult {
  const _ScenarioResult({
    required this.scenarioValue,
    required this.baselineValue,
    required this.difference,
    required this.differencePct,
    required this.baselineInterest,
    required this.scenarioInterest,
    required this.maxDrawdown,
    required this.recoveryMonths,
    required this.monthlyData,
    required this.assetImpact,
  });

  final double scenarioValue;
  final double baselineValue;
  final double difference;
  final double differencePct;
  final double baselineInterest;
  final double scenarioInterest;
  final double maxDrawdown;
  final int recoveryMonths;
  final List<_MonthlyPoint> monthlyData;
  final List<_AssetImpact> assetImpact;
}

final class _MonthlyPoint {
  const _MonthlyPoint({required this.baseline, required this.scenario});

  final double baseline;
  final double scenario;
}

final class _AssetImpact {
  const _AssetImpact({
    required this.asset,
    required this.color,
    required this.baseInterest,
    required this.scenarioInterest,
    required this.diff,
  });

  final String asset;
  final Color color;
  final double baseInterest;
  final double scenarioInterest;
  final double diff;
}

final class _StressScenarioResult {
  const _StressScenarioResult({required this.scenario, required this.result});

  final SavingsWhatIfScenarioDraft scenario;
  final _ScenarioResult result;
}

SavingsWhatIfScenarioDraft _scenarioById(
  SavingsWhatIfSnapshot snapshot,
  SavingsWhatIfScenarioId id,
) {
  return snapshot.scenarios.firstWhere((scenario) => scenario.id == id);
}

double _totalPortfolioValue(
  List<SavingsWhatIfPortfolioPositionDraft> positions,
) {
  return positions.fold<double>(0, (sum, position) => sum + position.amountUsd);
}
