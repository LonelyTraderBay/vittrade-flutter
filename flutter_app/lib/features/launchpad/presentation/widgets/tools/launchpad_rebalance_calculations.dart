part of '../../phone/pages/tools/launchpad_rebalance_page.dart';

final class RebalanceSuggestion {
  const RebalanceSuggestion({
    required this.asset,
    required this.action,
    required this.currentPercent,
    required this.targetPercent,
    required this.deviation,
    required this.suggestedAmount,
    required this.suggestedValue,
  });

  final LaunchpadRebalanceAssetDraft asset;
  final LaunchpadRebalanceAction action;
  final double currentPercent;
  final double targetPercent;
  final double deviation;
  final double suggestedAmount;
  final double suggestedValue;
}

List<LaunchpadRebalanceAssetDraft> launchpadRebalanceAssetsWithTargets(
  List<LaunchpadRebalanceAssetDraft> assets,
  LaunchpadRebalanceStrategyDraft strategy,
) {
  final otherTarget = _targetPercentFor(strategy, 'Other');
  return [
    for (final asset in assets)
      asset.copyWith(
        targetPercent:
            _targetPercentFor(strategy, asset.symbol) ??
            otherTarget ??
            asset.targetPercent,
      ),
  ];
}

List<RebalanceSuggestion> launchpadRebalanceSuggestionsFor(
  List<LaunchpadRebalanceAssetDraft> assets,
) {
  final totalValue = assets.fold<double>(
    0,
    (sum, asset) => sum + asset.currentValue,
  );
  final suggestions = [
    for (final asset in assets) _suggestionFor(asset, totalValue),
  ];
  suggestions.sort((a, b) => b.deviation.abs().compareTo(a.deviation.abs()));
  return suggestions;
}

Color launchpadRebalanceActionColor(LaunchpadRebalanceAction action) {
  return switch (action) {
    LaunchpadRebalanceAction.buy => AppColors.buy,
    LaunchpadRebalanceAction.sell => AppColors.sell,
    LaunchpadRebalanceAction.hold => AppColors.text3,
  };
}

IconData launchpadRebalanceActionIcon(LaunchpadRebalanceAction action) {
  return switch (action) {
    LaunchpadRebalanceAction.buy => Icons.arrow_upward_rounded,
    LaunchpadRebalanceAction.sell => Icons.arrow_downward_rounded,
    LaunchpadRebalanceAction.hold => Icons.remove_rounded,
  };
}

String launchpadRebalanceActionLabel(LaunchpadRebalanceAction action) {
  return switch (action) {
    LaunchpadRebalanceAction.buy => 'Mua',
    LaunchpadRebalanceAction.sell => 'Ban',
    LaunchpadRebalanceAction.hold => 'Giu',
  };
}

String launchpadRebalanceRiskLabel(LaunchpadRebalanceRisk risk) {
  return switch (risk) {
    LaunchpadRebalanceRisk.conservative => 'conservative',
    LaunchpadRebalanceRisk.moderate => 'moderate',
    LaunchpadRebalanceRisk.aggressive => 'aggressive',
  };
}

String launchpadRebalanceMoney(double value) {
  final whole = value.toStringAsFixed(2);
  final parts = whole.split('.');
  final chars = parts.first.split('').reversed.toList();
  final buffer = StringBuffer();
  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) buffer.write(',');
    buffer.write(chars[i]);
  }
  return '${buffer.toString().split('').reversed.join()}.${parts.last}';
}

String launchpadRebalanceAmount(double value) {
  if (value < 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(2);
}

double? _targetPercentFor(
  LaunchpadRebalanceStrategyDraft strategy,
  String symbol,
) {
  for (final target in strategy.targets) {
    if (target.symbol == symbol) {
      return target.percent;
    }
  }
  return null;
}

RebalanceSuggestion _suggestionFor(
  LaunchpadRebalanceAssetDraft asset,
  double totalValue,
) {
  final deviation = asset.currentPercent - asset.targetPercent;
  final targetValue = totalValue * asset.targetPercent / 100;
  final diffValue = asset.currentValue - targetValue;
  final action = deviation.abs() < 1
      ? LaunchpadRebalanceAction.hold
      : deviation > 0
      ? LaunchpadRebalanceAction.sell
      : LaunchpadRebalanceAction.buy;
  return RebalanceSuggestion(
    asset: asset,
    action: action,
    currentPercent: asset.currentPercent,
    targetPercent: asset.targetPercent,
    deviation: deviation,
    suggestedAmount: (diffValue / asset.price).abs(),
    suggestedValue: diffValue.abs(),
  );
}
