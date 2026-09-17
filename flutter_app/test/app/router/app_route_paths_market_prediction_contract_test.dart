import 'package:vit_trade_flutter/app/router/app_router.dart';

import 'app_route_paths_contract_test_utils.dart';

void main() {
  routePathContractTest('defines stable market and prediction route paths', [
    c(AppRoutePaths.markets, '/markets'),
    c(AppRoutePaths.marketsOverview, '/markets/overview'),
    c(AppRoutePaths.marketsMovers, '/markets/movers'),
    c(AppRoutePaths.marketsSectors, '/markets/sectors'),
    c(AppRoutePaths.marketsWatchlist, '/markets/watchlist'),
    c(AppRoutePaths.marketsHeatmap, '/markets/heatmap'),
    c(AppRoutePaths.marketsAlerts, '/markets/alerts'),
    c(AppRoutePaths.marketsScreener, '/markets/screener'),
    c(AppRoutePaths.marketsCompare, '/markets/compare'),
    c(AppRoutePaths.marketsCalendar, '/markets/calendar'),
    c(AppRoutePaths.marketsDerivatives, '/markets/derivatives'),
    c(AppRoutePaths.marketsDepth, '/markets/depth'),
    c(AppRoutePaths.marketsSocialSentiment, '/markets/social-sentiment'),
    c(AppRoutePaths.marketsPortfolioTracker, '/markets/portfolio-tracker'),
    c(AppRoutePaths.marketsNews, '/markets/news'),
    c(AppRoutePaths.marketsAdvancedCharts, '/markets/advanced-charts'),
    c(AppRoutePaths.marketsUnlocks, '/markets/unlocks'),
    c(AppRoutePaths.marketsSignals, '/markets/signals'),
    c(AppRoutePaths.marketsCorrelations, '/markets/correlations'),
    c(AppRoutePaths.marketsPredictions, '/predictions'),
    c(AppRoutePaths.marketsPredictionsSearch, '/predictions/search'),
    c(AppRoutePaths.marketsPredictionsBreaking, '/predictions/breaking'),
    c(
      AppRoutePaths.marketsPredictionEvent('pred-1'),
      '/predictions/event/pred-1',
    ),
    c(AppRoutePaths.marketsPredictionsPortfolio, '/predictions/portfolio'),
    c(
      AppRoutePaths.marketsPredictionReceipt('po-1'),
      '/predictions/receipt/po-1',
    ),
    c(AppRoutePaths.marketsPredictionsRewards, '/predictions/rewards'),
    c(AppRoutePaths.marketsPredictionsLeaderboard, '/predictions/leaderboard'),
    c(AppRoutePaths.marketsPredictionsActivity, '/predictions/activity'),
    c(
      AppRoutePaths.marketsPredictionsRiskCalculator,
      '/predictions/risk-calculator',
    ),
    c(AppRoutePaths.marketsPredictionsMarketMaker, '/predictions/market-maker'),
    c(
      AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
      '/predictions/portfolio-analyzer',
    ),
    c(
      AppRoutePaths.marketsPredictionsEventCalendar,
      '/predictions/event-calendar',
    ),
    c(AppRoutePaths.marketsPredictionsSocial, '/predictions/social'),
    c(
      AppRoutePaths.marketsPredictionsAdvancedChart('btcusdt'),
      '/predictions/advanced-chart/btcusdt',
    ),
    c(AppRoutePaths.marketsPredictionsTournaments, '/predictions/tournaments'),
    c(
      AppRoutePaths.marketsPredictionTournament('tour1'),
      '/predictions/tournament/tour1',
    ),
    c(
      AppRoutePaths.marketsPredictionsDataIntegration,
      '/predictions/data-integration',
    ),
    c(AppRoutePaths.pairDetail('btcusdt'), '/pair/btcusdt'),
    c(AppRoutePaths.pairInfo('btcusdt'), '/pair/btcusdt/info'),
    c(AppRoutePaths.pairDepth('btcusdt'), '/pair/btcusdt/depth'),
    c(AppRoutePaths.profilePredictions, '/profile/predictions'),
  ]);
}
