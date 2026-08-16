part of '../../phone/pages/provider/provider_leaderboard_page.dart';

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.providerLeaderboardDisclaimerPadding,
      density: VitDensity.tool,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: _leaderLineLoose,
        ),
      ),
    );
  }
}

bool _isProviderVerified(TradeCopyTrader provider) {
  return provider.sharpeRatio >= 2 ||
      provider.riskLevel == TradeCopyRiskLevel.low;
}

List<String> _redFlags(TradeCopyTrader provider) {
  final flags = <String>[];
  if (provider.maxDrawdown > 20) flags.add('High drawdown');
  if (provider.sharpeRatio < 1) flags.add('Low Sharpe');
  if (provider.totalPnlPct > 100 && provider.totalTrades < 50) {
    flags.add('Low sample size');
  }
  return flags;
}

Color _riskColor(TradeCopyRiskLevel riskLevel) {
  switch (riskLevel) {
    case TradeCopyRiskLevel.low:
      return AppColors.buy;
    case TradeCopyRiskLevel.medium:
      return _leaderWarningText;
    case TradeCopyRiskLevel.high:
      return AppColors.sell;
  }
}

String _riskLabel(TradeCopyRiskLevel riskLevel) {
  switch (riskLevel) {
    case TradeCopyRiskLevel.low:
      return 'LOW';
    case TradeCopyRiskLevel.medium:
      return 'MEDIUM';
    case TradeCopyRiskLevel.high:
      return 'HIGH';
  }
}

String _formatSignedPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _formatInteger(int value) {
  final chars = value.toString().split('').reversed.toList();
  final groups = <String>[];
  for (var i = 0; i < chars.length; i += 3) {
    groups.add(chars.skip(i).take(3).toList().reversed.join());
  }
  return groups.reversed.join(',');
}
