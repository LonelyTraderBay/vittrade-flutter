part of '../repositories/mock_predictions_repository.dart';

mixin _MockPredictionsRepositoryMethodsPart02
    on _MockPredictionsRepositoryBase {
  @override
  Future<PredictionEventCalendarSnapshot> getEventCalendar({
    String? category,
  }) async {
    await _simulateNetwork();
    final events = category == null
        ? _predictionCalendarEvents
        : _predictionCalendarEvents
              .where((event) => event.category == category)
              .toList();
    return PredictionEventCalendarSnapshot(
      events: events,
      categories: _predictionCalendarCategories,
      selectedCategory: category,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'trực tiếp',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  Future<PredictionSocialSnapshot> getSocial() async {
    await _simulateNetwork();
    return PredictionSocialSnapshot(
      eventTitle: 'BTC > \$100K by Dec 2026?',
      comments: _predictionSocialComments,
      sentiment: _predictionSocialSentiment,
      contributors: _predictionSocialContributors,
      shareUrl: 'https://app.example.com/predictions/event/pred-1',
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'trực tiếp',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  Future<PredictionAdvancedChartSnapshot> getAdvancedChart(
    String eventId,
  ) async {
    await _simulateNetwork();
    return PredictionAdvancedChartSnapshot(
      eventId: eventId,
      priceHistory: _predictionAdvancedPriceHistory,
      orderFlow: _predictionAdvancedOrderFlow,
      indicators: _predictionAdvancedIndicators,
      patterns: _predictionAdvancedPatterns,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'trực tiếp',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  Future<PredictionTournamentsSnapshot> getTournaments() async {
    await _simulateNetwork();
    return PredictionTournamentsSnapshot(
      tournaments: _predictionTournaments,
      leaderboard: _predictionTournamentLeaderboard,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'trực tiếp',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }

  @override
  Future<PredictionDataIntegrationSnapshot> getDataIntegration() async {
    await _simulateNetwork();
    return PredictionDataIntegrationSnapshot(
      sources: _predictionDataSources,
      apiKeys: _predictionApiKeys,
      webhooks: _predictionWebhooks,
      predictionEvents: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'trực tiếp',
      supportedStates: const {
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      },
    );
  }
}
