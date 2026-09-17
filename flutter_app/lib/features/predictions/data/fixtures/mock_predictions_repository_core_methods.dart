part of '../repositories/mock_predictions_repository.dart';

mixin _MockPredictionsRepositoryMethodsPart01
    on _MockPredictionsRepositoryBase {
  @override
  Future<PredictionHomeSnapshot> getHome({
    PredictionFilterTab filter = PredictionFilterTab.trending,
    String? category,
    String searchQuery = '',
  }) async {
    await _simulateNetwork();
    var events = _applyFilter(_predictionEvents, filter);
    if (category != null && category.isNotEmpty) {
      events = events.where((event) => event.category == category).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      events = events
          .where(
            (event) =>
                event.title.toLowerCase().contains(query) ||
                event.category.toLowerCase().contains(query) ||
                event.tags.any((tag) => tag.toLowerCase().contains(query)),
          )
          .toList();
    }

    final breakingMovers =
        _predictionEvents
            .where((event) => event.status == PredictionEventStatus.active)
            .toList()
          ..sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));

    return PredictionHomeSnapshot(
      events: events,
      // PERF-HN3: cap 8 (đồng bộ _visibleLimit của markets) tính một lần
      // tại đây — trang hub không bao giờ dựng quá 8 event card.
      visibleEvents: List<PredictionEventDraft>.unmodifiable(events.take(8)),
      categories: _predictionCategories,
      positions: _predictionPositions,
      orders: _predictionOrders,
      receipts: _predictionReceipts,
      rewards: _predictionRewards,
      breakingMovers: breakingMovers.take(3).toList(),
      openPositionCount: _predictionPositions
          .where((position) => position.status == PredictionPositionStatus.open)
          .length,
      filter: filter,
      category: category,
      searchQuery: searchQuery,
      lastUpdatedLabel: 'chỉ đọc',
      highRiskContractId: HighRiskFlowContractIds.predictionMarketEvent,
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
  Future<PredictionSearchSnapshot> getSearch({
    PredictionSearchSort sort = PredictionSearchSort.trending,
    PredictionStatusFilter status = PredictionStatusFilter.active,
    String? category,
    String searchQuery = '',
  }) async {
    await _simulateNetwork();
    var events = _predictionEvents.toList();

    switch (status) {
      case PredictionStatusFilter.active:
        events = events
            .where((event) => event.status == PredictionEventStatus.active)
            .toList();
      case PredictionStatusFilter.resolved:
        events = events
            .where((event) => event.status == PredictionEventStatus.resolved)
            .toList();
      case PredictionStatusFilter.all:
        break;
    }

    if (category != null && category.isNotEmpty) {
      events = events.where((event) => event.category == category).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      events = events
          .where(
            (event) =>
                event.title.toLowerCase().contains(query) ||
                event.category.toLowerCase().contains(query) ||
                event.tags.any((tag) => tag.toLowerCase().contains(query)),
          )
          .toList();
    }

    events = _sortSearchEvents(events, sort);

    return PredictionSearchSnapshot(
      results: events,
      categories: _predictionCategories,
      sort: sort,
      status: status,
      category: category,
      searchQuery: searchQuery,
      orders: _predictionOrders,
      receipts: _predictionReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'chỉ đọc',
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
  Future<PredictionBreakingSnapshot> getBreaking({String? category}) async {
    await _simulateNetwork();
    var movers = _predictionEvents
        .where(
          (event) =>
              event.status == PredictionEventStatus.active &&
              event.change24h != 0,
        )
        .toList();
    if (category != null && category.isNotEmpty) {
      movers = movers.where((event) => event.category == category).toList();
    }
    movers.sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));

    return PredictionBreakingSnapshot(
      movers: movers,
      categories: const [
        'Politics',
        'Sports',
        'Live Crypto',
        'Finance',
        'Tech',
        'AI',
        'Culture',
      ],
      category: category,
      upCount: movers.where((event) => event.change24h > 0).length,
      downCount: movers.where((event) => event.change24h < 0).length,
      orders: _predictionOrders,
      receipts: _predictionReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'chỉ đọc',
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
  Future<PredictionEventDetailSnapshot> getEventDetail(String eventId) async {
    await _simulateNetwork();
    final event = _predictionEvents.firstWhere(
      (item) => item.id == eventId,
      orElse: () => _predictionEvents.first,
    );
    PredictionPositionDraft? openPosition;
    for (final position in _predictionPositions) {
      if (position.eventId == event.id) {
        openPosition = position;
        break;
      }
    }
    final relatedEvents = _predictionEvents
        .where(
          (item) =>
              item.id != event.id &&
              item.status == PredictionEventStatus.active &&
              item.category == event.category,
        )
        .take(2)
        .toList();

    return PredictionEventDetailSnapshot(
      event: event,
      position: openPosition == null
          ? null
          : PredictionDetailPositionDraft(
              outcome: openPosition.outcome,
              shares: openPosition.shares,
              avgPrice: openPosition.avgPrice,
              pnl: 30,
              pnlPct: 21.4,
            ),
      relatedEvents: relatedEvents,
      probabilityHistory: [
        14,
        13,
        12,
        13,
        12,
        18,
        12,
        10,
        24,
        17,
        12,
        21,
        21,
        20,
        18,
        19,
        29,
        21,
        19,
        33,
        27,
        23,
        30,
        30,
        30,
        27,
        29,
        39,
        31,
        event.outcomes.first.chance,
      ],
      volumeHistory: const [
        9,
        5,
        7,
        13,
        6,
        16,
        8,
        15,
        12,
        17,
        7,
        13,
        19,
        17,
        17,
        12,
        9,
        5,
        13,
        15,
        11,
        9,
        8,
        10,
        6,
        15,
        8,
        7,
        9,
        6,
      ],
      orderBook: const PredictionOrderBookDraft(
        bids: [
          PredictionOrderBookEntryDraft(price: .33, shares: 1280),
          PredictionOrderBookEntryDraft(price: .32, shares: 2140),
          PredictionOrderBookEntryDraft(price: .31, shares: 1740),
        ],
        asks: [
          PredictionOrderBookEntryDraft(price: .35, shares: 1160),
          PredictionOrderBookEntryDraft(price: .36, shares: 1890),
          PredictionOrderBookEntryDraft(price: .37, shares: 1420),
        ],
      ),
      rules: const [
        'Resolution is based on publicly verifiable information from the specified source.',
        'If the outcome is ambiguous, the market operator will consult multiple sources.',
        'Markets may be voided if the underlying event is cancelled or fundamentally altered.',
        'All times are in UTC. The market closes at 23:59:59 UTC on the end date.',
        'Shares of the winning outcome pay out \$1.00. Losing shares pay \$0.00.',
      ],
      topHolders: const [
        PredictionHolderDraft(name: 'AlphaDesk', outcome: 'Yes', shares: 8200),
        PredictionHolderDraft(name: 'NorthStar', outcome: 'No', shares: 6400),
        PredictionHolderDraft(name: 'QuantPro', outcome: 'Yes', shares: 5100),
      ],
      activity: const [
        PredictionActivityDraft(
          actor: 'Trader A',
          action: 'bought Yes',
          amount: '200 shares',
          time: '2m ago',
        ),
        PredictionActivityDraft(
          actor: 'Market maker',
          action: 'added liquidity',
          amount: '\$12K',
          time: '9m ago',
        ),
      ],
      arenaRooms: const [
        PredictionArenaRoomDraft(
          title: 'BTC \$70K? — Tuần 9',
          slots: '38/50 slots',
          points: 100,
          badge: 'Closest Guess',
        ),
        PredictionArenaRoomDraft(
          title: 'Altcoin Battle — SOL vs AVAX',
          slots: '40/40 slots',
          points: 200,
          badge: 'Team Battle',
        ),
      ],
      orders: _predictionOrders,
      receipts: _predictionReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'chỉ đọc',
      highRiskContractId: HighRiskFlowContractIds.predictionMarketEvent,
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
  Future<PredictionPortfolioSnapshot> getPortfolio() async {
    await _simulateNetwork();
    final totalCurrent = _predictionPortfolioPositions.fold<double>(
      0,
      (sum, position) => sum + position.currentValue,
    );
    final totalInvested = _predictionPortfolioPositions.fold<double>(
      0,
      (sum, position) => sum + position.investedAmount,
    );
    final totalPnl = _predictionPortfolioPositions.fold<double>(
      0,
      (sum, position) => sum + position.pnl,
    );

    return PredictionPortfolioSnapshot(
      endpoint: '/api/mobile/predictions/markets-predictions-portfolio',
      profileEndpoint: '/api/mobile/profile/profile-predictions',
      actionDraft: 'POST /predictions/orders|claim|watchlist where applicable',
      events: _predictionEvents,
      positions: _predictionPortfolioPositions,
      openOrders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      totalCurrentValue: totalCurrent,
      totalInvested: totalInvested,
      totalPnl: totalPnl,
      totalPnlPct: totalInvested == 0 ? 0 : (totalPnl / totalInvested) * 100,
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
  Future<PredictionRewardsSnapshot> getRewards() async {
    await _simulateNetwork();
    final totalDailyPool = _predictionRewardOpportunities.fold<double>(
      0,
      (sum, reward) => sum + reward.dailyReward,
    );

    return PredictionRewardsSnapshot(
      events: _predictionEvents,
      categories: _predictionCategories,
      rewards: _predictionRewardOpportunities,
      arenaRooms: _predictionRewardArenaRooms,
      totalDailyPool: totalDailyPool,
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
  Future<PredictionLeaderboardSnapshot> getLeaderboard({
    PredictionLeaderboardTimeFilter timeFilter =
        PredictionLeaderboardTimeFilter.weekly,
    PredictionLeaderboardMetric metric = PredictionLeaderboardMetric.pnl,
  }) async {
    await _simulateNetwork();
    final base =
        (_predictionLeaderboardData[timeFilter] ??
                _predictionLeaderboardData[PredictionLeaderboardTimeFilter
                    .weekly]!)
            .toList();
    final traders = metric == PredictionLeaderboardMetric.volume
        ? (base..sort((a, b) => b.volume.compareTo(a.volume)))
              .asMap()
              .entries
              .map((entry) => entry.value.copyWith(rank: entry.key + 1))
              .toList()
        : base;

    return PredictionLeaderboardSnapshot(
      events: _predictionEvents,
      traders: traders,
      biggestWins: traders
          .where(
            (trader) =>
                trader.biggestWin != null && trader.biggestWinMarket != null,
          )
          .take(4)
          .toList(),
      timeFilter: timeFilter,
      metric: metric,
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
  Future<PredictionGlobalActivitySnapshot> getGlobalActivity({
    double minAmount = 0,
  }) async {
    await _simulateNetwork();
    final allActivity = _generatePredictionGlobalActivity();
    final filtered = minAmount <= 0
        ? allActivity
        : allActivity
              .where((activity) => activity.amount >= minAmount)
              .toList();

    return PredictionGlobalActivitySnapshot(
      events: _predictionEvents,
      activities: filtered,
      totalVolume: allActivity.fold<double>(
        0,
        (sum, activity) => sum + activity.amount,
      ),
      buyCount: allActivity
          .where(
            (activity) =>
                activity.action == PredictionGlobalActivityAction.bought,
          )
          .length,
      sellCount: allActivity
          .where(
            (activity) =>
                activity.action == PredictionGlobalActivityAction.sold,
          )
          .length,
      minAmount: minAmount,
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
  Future<PredictionOrderReceiptSnapshot> getOrderReceipt(
    String receiptId,
  ) async {
    await _simulateNetwork();
    PredictionPortfolioReceiptDraft? receipt;
    for (final candidate in _predictionPortfolioReceipts) {
      if (candidate.id == receiptId) {
        receipt = candidate;
        break;
      }
    }

    return PredictionOrderReceiptSnapshot(
      receiptId: receiptId,
      receipt: receipt,
      events: _predictionEvents,
      orders: _predictionPortfolioOrders,
      receipts: _predictionPortfolioReceipts,
      rewards: _predictionRewards,
      lastUpdatedLabel: 'trực tiếp',
      highRiskContractId: HighRiskFlowContractIds.predictionMarketEvent,
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
  Future<String> submitOrder({
    required String eventId,
    required String outcome,
    required bool isBuy,
    required bool isMarket,
    required double amount,
  }) async {
    await Future<void>.delayed(loadDelay);
    if (simulateError) {
      throw StateError('prediction_submit_failed');
    }
    // Mock trả về biên lai fixture có thật để trang receipt resolve đầy đủ.
    return 'po-1';
  }

  @override
  Future<PredictionRiskCalculatorSnapshot> getRiskCalculator() async {
    await _simulateNetwork();
    return PredictionRiskCalculatorSnapshot(
      defaultEventName: 'BTC > \$100K by Dec 2026?',
      defaultOutcome: 'yes',
      defaultShares: 100,
      defaultEntryPrice: .65,
      defaultCurrentPrice: .68,
      defaultBankroll: 10000,
      events: _predictionEvents,
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
  Future<PredictionMarketMakerSnapshot> getMarketMaker() async {
    await _simulateNetwork();
    return PredictionMarketMakerSnapshot(
      defaultEventName: 'BTC > \$100K by Dec 2026?',
      defaultSpreadBps: 50,
      defaultMinDepth: 1000,
      positions: _predictionLiquidityPositions,
      earningsHistory: _predictionEarningsHistory,
      events: _predictionEvents,
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
  Future<PredictionPortfolioAnalyzerSnapshot> getPortfolioAnalyzer() async {
    await _simulateNetwork();
    return PredictionPortfolioAnalyzerSnapshot(
      positions: _predictionAnalyzerPositions,
      pnlHistory: _predictionAnalyzerPnlHistory,
      events: _predictionEvents,
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
