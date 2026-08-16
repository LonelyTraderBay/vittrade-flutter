part of '../../phone/pages/dashboard/bot_performance_analytics_page.dart';

/// Presentation slice of [TradeBotPerformanceAnalyticsSnapshot] for the
/// active timeframe tab (mock-UI; no repo signature change).
class TradeBotPerformanceView {
  const TradeBotPerformanceView({
    required this.metrics,
    required this.pnlPoints,
    required this.winLossPoints,
    required this.strategyPerformance,
    required this.durationDistribution,
    required this.insightLabel,
    required this.deltaVsPrior,
    required this.netWinLossTrades,
  });

  final TradeBotPerformanceMetrics metrics;
  final List<TradeBotPnlPoint> pnlPoints;
  final List<TradeBotWinLossPoint> winLossPoints;
  final List<TradeBotStrategyPerformance> strategyPerformance;
  final List<TradeBotDurationDistribution> durationDistribution;
  final String insightLabel;
  final double deltaVsPrior;
  final int netWinLossTrades;
}

TradeBotPerformanceView _buildPerformanceView(
  TradeBotPerformanceAnalyticsSnapshot snapshot,
  _AnalyticsTimeframe timeframe,
) {
  final allPnl = snapshot.pnlPoints;
  final allWl = snapshot.winLossPoints;
  final base = snapshot.metrics;

  final List<TradeBotPnlPoint> pnl;
  final List<TradeBotWinLossPoint> wl;
  final String insight;

  switch (timeframe) {
    case _AnalyticsTimeframe.sevenDays:
      pnl = allPnl.length <= 4
          ? List<TradeBotPnlPoint>.from(allPnl)
          : allPnl.sublist(allPnl.length - 4);
      wl = allWl.isEmpty ? const [] : allWl.sublist(allWl.length - 1);
      insight =
          '7 ngày gần nhất · Sharpe ${base.sharpeRatio.toStringAsFixed(2)}';
    case _AnalyticsTimeframe.thirtyDays:
      pnl = List<TradeBotPnlPoint>.from(allPnl);
      wl = allWl.length <= 2
          ? List<TradeBotWinLossPoint>.from(allWl)
          : allWl.sublist(allWl.length - 2);
      insight =
          '30 ngày · Sharpe ${base.sharpeRatio.toStringAsFixed(2)} · PF ${base.profitFactor.toStringAsFixed(2)}';
    case _AnalyticsTimeframe.allTime:
      pnl = List<TradeBotPnlPoint>.from(allPnl);
      wl = List<TradeBotWinLossPoint>.from(allWl);
      insight =
          'Toàn thời gian · Sharpe > 1.5 · lợi nhuận đã điều chỉnh rủi ro mạnh';
  }

  final wins = wl.fold<int>(0, (sum, p) => sum + p.wins);
  final losses = wl.fold<int>(0, (sum, p) => sum + p.losses);
  final trades = wins + losses;
  final winRate = trades == 0 ? base.winRate : wins / trades * 100;

  // Period contribution for short windows so tab changes are visible when
  // the series still ends on the same cumulative last point.
  final double totalPnl;
  if (timeframe == _AnalyticsTimeframe.sevenDays && pnl.length >= 2) {
    totalPnl = pnl.last.pnl - pnl.first.pnl;
  } else if (pnl.isNotEmpty) {
    totalPnl = pnl.last.pnl;
  } else {
    totalPnl = base.totalPnl;
  }

  final deltaVsPrior = pnl.length >= 2
      ? pnl.last.pnl - pnl[pnl.length - 2].pnl
      : 0.0;

  return TradeBotPerformanceView(
    metrics: TradeBotPerformanceMetrics(
      totalPnl: totalPnl,
      winRate: winRate,
      sharpeRatio: base.sharpeRatio,
      avgWin: base.avgWin,
      avgLoss: base.avgLoss,
      profitFactor: base.profitFactor,
      totalTrades: trades == 0 ? base.totalTrades : trades,
      bestTrade: base.bestTrade,
      worstTrade: base.worstTrade,
    ),
    pnlPoints: pnl,
    winLossPoints: wl,
    strategyPerformance: snapshot.strategyPerformance,
    durationDistribution: snapshot.durationDistribution,
    insightLabel: insight,
    deltaVsPrior: deltaVsPrior,
    netWinLossTrades: wins - losses,
  );
}
