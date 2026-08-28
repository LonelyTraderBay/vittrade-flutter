part of '../repositories/mock_market_repository.dart';

mixin _MockMarketRepositoryCalendarDerivativesMethods
    on _MockMarketRepositoryBase {
  @override
  Future<MarketCalendarSnapshot> getMarketCalendar({
    MarketCalendarQuery? query,
  }) async {
    await _simulateNetwork();
    final appliedQuery = query ?? MarketCalendarQuery.defaults;
    final events = _applyCalendarQuery(_marketEvents, appliedQuery);

    return MarketCalendarSnapshot(
      events: events,
      stats: _marketCalendarStats,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'calendar-high-impact',
          pairId: 'ethusdt',
          label: 'Sự kiện tác động cao trong tuần',
        ),
        MarketAlertDraft(
          id: 'calendar-token-unlock',
          pairId: 'arbusdt',
          label: 'Token unlock cần theo dõi',
        ),
      ],
      screenFilters: _marketCalendarFilters,
      chartSeries: {
        'impact': [
          _marketCalendarStats.upcoming.toDouble(),
          _marketCalendarStats.highImpact.toDouble(),
          _marketCalendarStats.thisWeek.toDouble(),
        ],
        for (final event in _marketEvents)
          event.id: [
            _daysUntil(event.dateIso).toDouble(),
            event.impact.index.toDouble(),
          ],
      },
      appliedQuery: appliedQuery,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      },
    );
  }

  @override
  Future<MarketDerivativesSnapshot> getMarketDerivatives({
    MarketDerivativesSort sortBy = MarketDerivativesSort.openInterest,
  }) async {
    await _simulateNetwork();
    final sortedPairs = [..._derivativePairs];
    switch (sortBy) {
      case MarketDerivativesSort.openInterest:
        sortedPairs.sort((a, b) => b.openInterest.compareTo(a.openInterest));
      case MarketDerivativesSort.volume:
        sortedPairs.sort((a, b) => b.volume24h.compareTo(a.volume24h));
      case MarketDerivativesSort.funding:
        sortedPairs.sort(
          (a, b) => b.fundingRate.abs().compareTo(a.fundingRate.abs()),
        );
      case MarketDerivativesSort.change:
        sortedPairs.sort(
          (a, b) => b.change24h.abs().compareTo(a.change24h.abs()),
        );
    }

    return MarketDerivativesSnapshot(
      globalStats: _derivativesGlobalStats,
      pairs: sortedPairs,
      liquidationHistory: _liquidationHistory,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'derivatives-liquidation-spike',
          pairId: 'btcusdt',
          label: 'Liquidation spike in BTC perpetuals',
        ),
        MarketAlertDraft(
          id: 'derivatives-funding-watch',
          pairId: 'solusdt',
          label: 'Funding rate watchlist',
        ),
      ],
      screenFilters: _marketDerivativesFilters,
      chartSeries: {
        'liquidationLong': [
          for (final point in _liquidationHistory) point.long,
        ],
        'liquidationShort': [
          for (final point in _liquidationHistory) point.short,
        ],
        for (final pair in _derivativePairs)
          pair.id: [
            pair.openInterest,
            pair.volume24h,
            pair.fundingRate,
            pair.longRatio,
            pair.shortRatio,
          ],
      },
      sortBy: sortBy,
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      },
    );
  }

  @override
  Future<MarketDepthSnapshot> getMarketDepth({
    String pairId = 'btcusdt',
    int levels = 25,
  }) async {
    await _simulateNetwork();
    final normalizedLevels = _marketDepthLevels.contains(levels) ? levels : 25;
    final pair = _findMarketPair(pairId);
    final depth = _generateDepthData(pair.price, normalizedLevels);
    final whales = _generateWhaleOrders(pair.price);

    return MarketDepthSnapshot(
      pair: pair,
      depth: depth,
      whaleOrders: whales,
      availableLevels: _marketDepthLevels,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'depth-btc-spread',
          pairId: 'btcusdt',
          label: 'BTC đường nền chênh lệch giá sổ lệnh',
        ),
        MarketAlertDraft(
          id: 'depth-whale-wall',
          pairId: 'btcusdt',
          label: 'Theo dõi tường lệnh cá voi',
        ),
      ],
      screenFilters: _marketDepthFilters,
      chartSeries: {
        'bidCumulative': [for (final level in depth.bids) level.cumulative],
        'askCumulative': [for (final level in depth.asks) level.cumulative],
        'whaleUsdValue': [for (final order in whales) order.usdValue],
        pair.id: pair.sparklineData,
      },
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      },
    );
  }
}

const List<MarketCalendarEvent> _marketEvents = [
  MarketCalendarEvent(
    id: 'ev7',
    title: 'WLD niêm yết trên Coinbase',
    type: MarketCalendarEventType.listing,
    dateIso: '2026-03-11T18:00:00Z',
    symbol: 'WLD',
    impact: MarketCalendarImpact.medium,
    description: 'Worldcoin (WLD) sẽ được list trên Coinbase với cặp WLD/USD.',
    source: 'Coinbase Blog',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev1',
    title: 'Mở khóa ARB',
    type: MarketCalendarEventType.unlock,
    dateIso: '2026-03-12T08:00:00Z',
    symbol: 'ARB',
    impact: MarketCalendarImpact.high,
    description:
        '92.65M ARB mở khóa từ investor và team, khoảng 3.49% tổng cung.',
    source: 'TokenUnlocks.app',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev11',
    title: 'Báo cáo CPI Mỹ',
    type: MarketCalendarEventType.report,
    dateIso: '2026-03-12T12:30:00Z',
    impact: MarketCalendarImpact.high,
    description:
        'Báo cáo chỉ số giá tiêu dùng tháng 2 của Mỹ, dự kiến 3.1% YoY.',
    source: 'Bureau of Labor Statistics',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev6',
    title: 'Mở khóa MATIC',
    type: MarketCalendarEventType.unlock,
    dateIso: '2026-03-13T08:00:00Z',
    symbol: 'MATIC',
    impact: MarketCalendarImpact.medium,
    description: '200M MATIC mở khóa từ quỹ phát triển ecosystem.',
    source: 'TokenUnlocks.app',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev3',
    title: 'Airdrop PYTH Mùa 2',
    type: MarketCalendarEventType.airdrop,
    dateIso: '2026-03-14T00:00:00Z',
    symbol: 'PYTH',
    impact: MarketCalendarImpact.medium,
    description: 'Đợt phát hành airdrop thứ 2 cho người dùng DeFi và staker.',
    source: 'pyth.network',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev2',
    title: 'Nâng cấp Ethereum Pectra',
    type: MarketCalendarEventType.upgrade,
    dateIso: '2026-03-15T14:00:00Z',
    symbol: 'ETH',
    impact: MarketCalendarImpact.high,
    description: 'Nâng cấp Pectra bao gồm EIP-7251 và EIP-7702.',
    source: 'ethereum.org',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev4',
    title: 'Đốt BNB Hàng Quý',
    type: MarketCalendarEventType.burn,
    dateIso: '2026-03-18T12:00:00Z',
    symbol: 'BNB',
    impact: MarketCalendarImpact.medium,
    description: 'Đợt BNB định kỳ hàng quý, ước tính 1.5M BNB sẽ bị đốt.',
    source: 'bnbchain.org',
    confirmed: false,
  ),
  MarketCalendarEvent(
    id: 'ev12',
    title: 'Họp FOMC',
    type: MarketCalendarEventType.report,
    dateIso: '2026-03-19T18:00:00Z',
    impact: MarketCalendarImpact.high,
    description:
        'Cuộc họp Fed quyết định lãi suất. Thị trường dự đoán giữ nguyên.',
    source: 'Federal Reserve',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev5',
    title: 'Solana Firedancer Mainnet',
    type: MarketCalendarEventType.upgrade,
    dateIso: '2026-03-20T16:00:00Z',
    symbol: 'SOL',
    impact: MarketCalendarImpact.high,
    description:
        'Client Firedancer ra mắt mainnet, tập trung cải thiện hiệu suất mạng.',
    source: 'solana.com',
    confirmed: false,
  ),
  MarketCalendarEvent(
    id: 'ev8',
    title: 'Hội nghị Token2049 Dubai',
    type: MarketCalendarEventType.conference,
    dateIso: '2026-03-22T09:00:00Z',
    impact: MarketCalendarImpact.low,
    description:
        'Hội nghị blockchain lớn tại MENA, dự kiến 10,000+ người tham dự.',
    source: 'token2049.com',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev9',
    title: 'Mở khóa OP',
    type: MarketCalendarEventType.unlock,
    dateIso: '2026-03-25T08:00:00Z',
    symbol: 'OP',
    impact: MarketCalendarImpact.high,
    description: '31.3M OP mở khóa từ core contributors và investors.',
    source: 'TokenUnlocks.app',
    confirmed: true,
  ),
  MarketCalendarEvent(
    id: 'ev10',
    title: 'Chainlink CCIP V2 Launch',
    type: MarketCalendarEventType.upgrade,
    dateIso: '2026-03-28T14:00:00Z',
    symbol: 'LINK',
    impact: MarketCalendarImpact.medium,
    description:
        'Cross-Chain Interoperability Protocol v2 hỗ trợ hơn 20 chains.',
    source: 'chain.link',
    confirmed: false,
  ),
];

const MarketScreenFilters _marketCalendarFilters = MarketScreenFilters(
  categories: [
    'Tất cả',
    'Token Unlock',
    'Nâng cấp',
    'Airdrop',
    'Đốt token',
    'Niêm yết',
    'Báo cáo',
    'Hội nghị',
  ],
  defaultCategory: 'Tất cả',
  defaultSort: 'date',
  sortOptions: [
    MarketSortOption(id: 'high', label: 'Cao'),
    MarketSortOption(id: 'medium', label: 'Trung bình'),
    MarketSortOption(id: 'low', label: 'Thấp'),
  ],
);

const MarketCalendarStats _marketCalendarStats = MarketCalendarStats(
  upcoming: 12,
  highImpact: 6,
  thisWeek: 7,
);

List<MarketCalendarEvent> _applyCalendarQuery(
  List<MarketCalendarEvent> source,
  MarketCalendarQuery query,
) {
  var events = source;
  if (query.type != null) {
    events = [
      for (final event in events)
        if (event.type == query.type) event,
    ];
  }
  if (query.impact != null) {
    events = [
      for (final event in events)
        if (event.impact == query.impact) event,
    ];
  }
  return [...events]..sort(
    (a, b) => DateTime.parse(a.dateIso).compareTo(DateTime.parse(b.dateIso)),
  );
}

int _daysUntil(String dateIso) {
  final now = DateTime.utc(2026, 3, 11, 12);
  final eventDate = DateTime.parse(dateIso).toUtc();
  return ((eventDate.difference(now).inMilliseconds) /
          Duration.millisecondsPerDay)
      .ceil();
}

const MarketScreenFilters _marketDerivativesFilters = MarketScreenFilters(
  categories: ['Tổng quan', 'Perpetual', 'Thanh lý'],
  defaultCategory: 'Tổng quan',
  defaultSort: 'openInterest',
  sortOptions: [
    MarketSortOption(id: 'openInterest', label: 'OI'),
    MarketSortOption(id: 'volume', label: 'Volume'),
    MarketSortOption(id: 'funding', label: 'Funding'),
    MarketSortOption(id: 'change', label: 'Thay đổi'),
  ],
);

const DerivativesGlobalStats _derivativesGlobalStats = DerivativesGlobalStats(
  totalOpenInterest: 45678901000,
  oiChange24h: 3.45,
  totalVolume24h: 98765432000,
  volumeChange24h: 12.34,
  totalLiquidations24h: 234567000,
  longLiquidations24h: 156789000,
  shortLiquidations24h: 77778000,
  avgFundingRate: 0.0065,
  btcLongShortRatio: 1.18,
  fearGreedDerivatives: 68,
);

const List<LiquidationPoint> _liquidationHistory = [
  LiquidationPoint(time: '00:00', long: 12345, short: 8901),
  LiquidationPoint(time: '04:00', long: 8901, short: 15678),
  LiquidationPoint(time: '08:00', long: 23456, short: 5678),
  LiquidationPoint(time: '12:00', long: 15678, short: 12345),
  LiquidationPoint(time: '16:00', long: 9012, short: 18901),
  LiquidationPoint(time: '20:00', long: 18901, short: 9012),
  LiquidationPoint(time: 'Hiện tại', long: 15432, short: 11234),
];

const List<DerivativePair> _derivativePairs = [
  DerivativePair(
    id: 'btc-perp',
    symbol: 'BTC/USDT',
    name: 'Bitcoin',
    price: 67589.45,
    change24h: 2.41,
    indexPrice: 67543.21,
    markPrice: 67567.89,
    fundingRate: 0.0087,
    fundingInterval: '8h',
    openInterest: 12345678000,
    openInterestChange24h: 5.67,
    volume24h: 45678901000,
    longRatio: 54.2,
    shortRatio: 45.8,
    longLiquidations24h: 23456000,
    shortLiquidations24h: 18901000,
    maxLeverage: 125,
  ),
  DerivativePair(
    id: 'eth-perp',
    symbol: 'ETH/USDT',
    name: 'Ethereum',
    price: 3524.67,
    change24h: -1.12,
    indexPrice: 3521.45,
    markPrice: 3523.01,
    fundingRate: -0.0034,
    fundingInterval: '8h',
    openInterest: 6789012000,
    openInterestChange24h: -2.34,
    volume24h: 18901234000,
    longRatio: 47.8,
    shortRatio: 52.2,
    longLiquidations24h: 12345000,
    shortLiquidations24h: 8901000,
    maxLeverage: 100,
  ),
  DerivativePair(
    id: 'sol-perp',
    symbol: 'SOL/USDT',
    name: 'Solana',
    price: 178.89,
    change24h: 8.23,
    indexPrice: 178.32,
    markPrice: 178.56,
    fundingRate: 0.0156,
    fundingInterval: '8h',
    openInterest: 2345678000,
    openInterestChange24h: 12.45,
    volume24h: 6789012000,
    longRatio: 62.3,
    shortRatio: 37.7,
    longLiquidations24h: 5678000,
    shortLiquidations24h: 15432000,
    maxLeverage: 75,
  ),
  DerivativePair(
    id: 'bnb-perp',
    symbol: 'BNB/USDT',
    name: 'BNB',
    price: 413.21,
    change24h: 3.72,
    indexPrice: 412.87,
    markPrice: 413.05,
    fundingRate: 0.0045,
    fundingInterval: '8h',
    openInterest: 1234567000,
    openInterestChange24h: 3.21,
    volume24h: 3456789000,
    longRatio: 55.1,
    shortRatio: 44.9,
    longLiquidations24h: 2345000,
    shortLiquidations24h: 3456000,
    maxLeverage: 75,
  ),
  DerivativePair(
    id: 'xrp-perp',
    symbol: 'XRP/USDT',
    name: 'Ripple',
    price: 0.6245,
    change24h: -2.48,
    indexPrice: 0.6234,
    markPrice: 0.6238,
    fundingRate: -0.0078,
    fundingInterval: '8h',
    openInterest: 890123000,
    openInterestChange24h: -4.56,
    volume24h: 2345678000,
    longRatio: 43.5,
    shortRatio: 56.5,
    longLiquidations24h: 4567000,
    shortLiquidations24h: 1234000,
    maxLeverage: 75,
  ),
  DerivativePair(
    id: 'doge-perp',
    symbol: 'DOGE/USDT',
    name: 'Dogecoin',
    price: 0.1234,
    change24h: 5.67,
    indexPrice: 0.1230,
    markPrice: 0.1232,
    fundingRate: 0.0234,
    fundingInterval: '8h',
    openInterest: 567890000,
    openInterestChange24h: 8.90,
    volume24h: 1890123000,
    longRatio: 67.8,
    shortRatio: 32.2,
    longLiquidations24h: 1234000,
    shortLiquidations24h: 5678000,
    maxLeverage: 50,
  ),
  DerivativePair(
    id: 'avax-perp',
    symbol: 'AVAX/USDT',
    name: 'Avalanche',
    price: 38.67,
    change24h: 4.89,
    indexPrice: 38.54,
    markPrice: 38.60,
    fundingRate: 0.0067,
    fundingInterval: '8h',
    openInterest: 456789000,
    openInterestChange24h: 6.78,
    volume24h: 1234567000,
    longRatio: 58.4,
    shortRatio: 41.6,
    longLiquidations24h: 890000,
    shortLiquidations24h: 2345000,
    maxLeverage: 50,
  ),
  DerivativePair(
    id: 'link-perp',
    symbol: 'LINK/USDT',
    name: 'Chainlink',
    price: 14.28,
    change24h: -5.65,
    indexPrice: 14.23,
    markPrice: 14.25,
    fundingRate: -0.0123,
    fundingInterval: '8h',
    openInterest: 345678000,
    openInterestChange24h: -7.89,
    volume24h: 890123000,
    longRatio: 41.2,
    shortRatio: 58.8,
    longLiquidations24h: 3456000,
    shortLiquidations24h: 678000,
    maxLeverage: 50,
  ),
];

const MarketScreenFilters _marketDepthFilters = MarketScreenFilters(
  categories: ['Biểu đồ độ sâu', 'Sổ lệnh', 'Lệnh cá voi'],
  defaultCategory: 'Biểu đồ độ sâu',
  defaultSort: '25L',
  sortOptions: [
    MarketSortOption(id: '15', label: '15L'),
    MarketSortOption(id: '25', label: '25L'),
    MarketSortOption(id: '50', label: '50L'),
  ],
);

const List<int> _marketDepthLevels = [15, 25, 50];

List<MarketWhaleOrder> _generateWhaleOrders(double midPrice) {
  final multiplier = midPrice > 10000
      ? 0.01
      : midPrice > 100
      ? 1.0
      : 100.0;
  return [
    MarketWhaleOrder(
      id: 'w1',
      side: MarketOrderSide.buy,
      price: midPrice * 0.994,
      quantity: 12.5 * multiplier,
      usdValue: midPrice * 12.5 * multiplier,
      timeAgo: '2 phút trước',
    ),
    MarketWhaleOrder(
      id: 'w2',
      side: MarketOrderSide.sell,
      price: midPrice * 1.005,
      quantity: 8.9 * multiplier,
      usdValue: midPrice * 8.9 * multiplier,
      timeAgo: '5 phút trước',
    ),
    MarketWhaleOrder(
      id: 'w3',
      side: MarketOrderSide.buy,
      price: midPrice * 0.988,
      quantity: 15.2 * multiplier,
      usdValue: midPrice * 15.2 * multiplier,
      timeAgo: '8 phút trước',
    ),
    MarketWhaleOrder(
      id: 'w4',
      side: MarketOrderSide.sell,
      price: midPrice * 1.012,
      quantity: 7.4 * multiplier,
      usdValue: midPrice * 7.4 * multiplier,
      timeAgo: '12 phút trước',
    ),
    MarketWhaleOrder(
      id: 'w5',
      side: MarketOrderSide.buy,
      price: midPrice * 0.982,
      quantity: 20.1 * multiplier,
      usdValue: midPrice * 20.1 * multiplier,
      timeAgo: '18 phút trước',
    ),
  ];
}
