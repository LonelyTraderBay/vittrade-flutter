final class PredictionsRoutePaths {
  const PredictionsRoutePaths._();

  static const String marketsPredictions = '/predictions';
  static const String marketsPredictionsSearch = '/predictions/search';
  static const String marketsPredictionsBreaking = '/predictions/breaking';
  static const String marketsPredictionsPortfolio = '/predictions/portfolio';
  static String marketsPredictionEvent(String eventId) =>
      '/predictions/event/$eventId';
  static String marketsPredictionReceipt(String receiptId) =>
      '/predictions/receipt/$receiptId';
  static const String marketsPredictionsRewards = '/predictions/rewards';
  static const String marketsPredictionsLeaderboard =
      '/predictions/leaderboard';
  static const String marketsPredictionsActivity = '/predictions/activity';
  static const String marketsPredictionsRiskCalculator =
      '/predictions/risk-calculator';
  static const String marketsPredictionsMarketMaker =
      '/predictions/market-maker';
  static const String marketsPredictionsPortfolioAnalyzer =
      '/predictions/portfolio-analyzer';
  static const String marketsPredictionsEventCalendar =
      '/predictions/event-calendar';
  static const String marketsPredictionsSocial = '/predictions/social';
  static String marketsPredictionsAdvancedChart(String eventId) =>
      '/predictions/advanced-chart/$eventId';
  static const String marketsPredictionsTournaments =
      '/predictions/tournaments';
  static String marketsPredictionTournament(String tournamentId) =>
      '/predictions/tournament/$tournamentId';
  static const String marketsPredictionsDataIntegration =
      '/predictions/data-integration';
}

final class PredictionsRouteNames {
  const PredictionsRouteNames._();

  static const String sc027PredictionsHome = 'sc027PredictionsHome';
  static const String sc028PredictionsSearch = 'sc028PredictionsSearch';
  static const String sc029PredictionsBreaking = 'sc029PredictionsBreaking';
  static const String sc030PredictionEventDetail = 'sc030PredictionEventDetail';
  static const String sc031PredictionsPortfolio = 'sc031PredictionsPortfolio';
  static const String sc032PredictionsRewards = 'sc032PredictionsRewards';
  static const String sc033PredictionsLeaderboard =
      'sc033PredictionsLeaderboard';
  static const String sc034PredictionsGlobalActivity =
      'sc034PredictionsGlobalActivity';
  static const String sc035PredictionOrderReceipt =
      'sc035PredictionOrderReceipt';
  static const String sc036PredictionRiskCalculator =
      'sc036PredictionRiskCalculator';
  static const String sc037PredictionMarketMaker = 'sc037PredictionMarketMaker';
  static const String sc038PredictionPortfolioAnalyzer =
      'sc038PredictionPortfolioAnalyzer';
  static const String sc039PredictionEventCalendar =
      'sc039PredictionEventCalendar';
  static const String sc040PredictionSocial = 'sc040PredictionSocial';
  static const String sc041PredictionAdvancedChart =
      'sc041PredictionAdvancedChart';
  static const String sc042PredictionTournaments = 'sc042PredictionTournaments';
  static const String sc043PredictionDataIntegration =
      'sc043PredictionDataIntegration';
  static const String sc414PredictionTournamentDetail =
      'sc414PredictionTournamentDetail';
}
