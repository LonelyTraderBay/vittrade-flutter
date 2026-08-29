part of '../repositories/mock_market_repository.dart';

mixin _MockMarketRepositoryTokenDetailMethods on _MockMarketRepositoryBase {
  @override
  Future<MarketPairDetailSnapshot> getPairDetail(String pairId) async {
    await _simulateNetwork();
    final pair = _findMarketPair(pairId);
    return MarketPairDetailSnapshot(
      pair: pair,
      marketPairs: _marketPairs,
      watchlist: {
        for (final item in _marketPairs)
          if (item.isFavorite) item.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'btc-breakout',
          pairId: 'btcusdt',
          label: 'BTC vuot 68,000',
        ),
        MarketAlertDraft(
          id: 'eth-dip',
          pairId: 'ethusdt',
          label: 'ETH giam duoi 3,500',
        ),
      ],
      screenFilters: const MarketScreenFilters(
        categories: ['Tat ca', 'Layer 1', 'Layer 2', 'DeFi', 'Meme', 'AI'],
        defaultCategory: 'Tat ca',
        defaultSort: 'default',
        sortOptions: [
          MarketSortOption(id: 'default', label: 'Mac dinh'),
          MarketSortOption(id: 'price_desc', label: 'Gia cao -> thap'),
          MarketSortOption(id: 'price_asc', label: 'Gia thap -> cao'),
          MarketSortOption(id: 'change_desc', label: 'Tang nhieu nhat'),
          MarketSortOption(id: 'change_asc', label: 'Giam nhieu nhat'),
          MarketSortOption(id: 'volume_desc', label: 'Volume lon nhat'),
        ],
      ),
      chartSeries: {
        for (final item in _marketPairs) item.id: item.sparklineData,
      },
      depth: _generateDepthData(pair.price, 25),
      recentTrades: _generateRecentTrades(pair.price, 24),
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
      },
    );
  }

  @override
  Future<MarketTokenInfoSnapshot> getTokenInfo(String pairId) async {
    await _simulateNetwork();
    final pair = _findMarketPair(pairId);
    final fundamentals = _tokenFundamentals[pair.id] ?? _btcFundamentals;
    return MarketTokenInfoSnapshot(
      pair: pair,
      fundamentals: fundamentals,
      marketPairs: _marketPairs,
      watchlist: {
        for (final item in _marketPairs)
          if (item.isFavorite) item.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'btc-breakout',
          pairId: 'btcusdt',
          label: 'BTC vuot 68,000',
        ),
        MarketAlertDraft(
          id: 'eth-dip',
          pairId: 'ethusdt',
          label: 'ETH giam duoi 3,500',
        ),
      ],
      screenFilters: const MarketScreenFilters(
        categories: ['Tong quan', 'On-chain', 'Du an'],
        defaultCategory: 'Tong quan',
        defaultSort: 'token-info',
        sortOptions: [
          MarketSortOption(id: 'overview', label: 'Tong quan'),
          MarketSortOption(id: 'onchain', label: 'On-chain'),
          MarketSortOption(id: 'project', label: 'Du an'),
        ],
      ),
      chartSeries: {
        for (final item in _marketPairs) item.id: item.sparklineData,
      },
      lastUpdatedLabel: 'read-only',
      supportedStates: const {
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
      },
    );
  }

  @override
  Future<MarketAdvancedChartsSnapshot> getAdvancedCharts({
    String indicatorCategory = 'all',
    String drawingCategory = 'all',
  }) async {
    await _simulateNetwork();
    final indicators = indicatorCategory == 'all'
        ? _advancedChartIndicators
        : [
            for (final indicator in _advancedChartIndicators)
              if (indicator.categoryId == indicatorCategory) indicator,
          ];
    final drawingTools = drawingCategory == 'all'
        ? _advancedChartDrawingTools
        : [
            for (final tool in _advancedChartDrawingTools)
              if (tool.categoryId == drawingCategory) tool,
          ];

    return MarketAdvancedChartsSnapshot(
      indicators: indicators,
      drawingTools: drawingTools,
      signalSummaries: _advancedChartSignalSummaries,
      indicatorCategories: _advancedChartIndicatorCategories,
      drawingCategories: _advancedChartDrawingCategories,
      activeIndicatorIds: const {'sma', 'rsi'},
      selectedIndicatorCategory: indicatorCategory,
      selectedDrawingCategory: drawingCategory,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'advanced-chart-sma-rsi',
          pairId: 'btcusdt',
          label: 'SMA + RSI active chart setup',
        ),
        MarketAlertDraft(
          id: 'advanced-chart-sol-signal',
          pairId: 'solusdt',
          label: 'SOL technical signal leads watchlist',
        ),
      ],
      screenFilters: _advancedChartsFilters,
      chartSeries: {
        for (final indicator in _advancedChartIndicators)
          indicator.id: [
            for (final param in indicator.params) param.value.toDouble(),
          ],
        for (final signal in _advancedChartSignalSummaries)
          signal.pair: [
            signal.buyCount.toDouble(),
            signal.neutralCount.toDouble(),
            signal.sellCount.toDouble(),
          ],
        for (final pair in _marketPairs.take(3)) pair.id: pair.sparklineData,
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

  @override
  Future<MarketTokenUnlocksSnapshot> getTokenUnlocks({
    MarketUnlockSort sortBy = MarketUnlockSort.nearest,
    MarketUnlockImpact? impactFilter,
  }) async {
    await _simulateNetwork();
    final unlocks = [
      for (final unlock in _tokenUnlocks)
        if (impactFilter == null || unlock.impactLevel == impactFilter) unlock,
    ];

    switch (sortBy) {
      case MarketUnlockSort.nearest:
        unlocks.sort((a, b) => a.daysUntil.compareTo(b.daysUntil));
      case MarketUnlockSort.value:
        unlocks.sort((a, b) => b.unlockValueUsd.compareTo(a.unlockValueUsd));
      case MarketUnlockSort.impact:
        unlocks.sort(
          (a, b) => b.unlockPctCirculating.compareTo(a.unlockPctCirculating),
        );
    }

    final totalValue = _tokenUnlocks.fold<double>(
      0,
      (sum, unlock) => sum + unlock.unlockValueUsd,
    );
    final totalDilution = _tokenUnlocks.fold<double>(
      0,
      (sum, unlock) => sum + unlock.unlockPctCirculating,
    );

    return MarketTokenUnlocksSnapshot(
      unlocks: unlocks,
      totalValueNext30d: totalValue,
      highImpactCount: _tokenUnlocks
          .where((unlock) => unlock.impactLevel == MarketUnlockImpact.high)
          .length,
      avgDilution: totalDilution / _tokenUnlocks.length,
      impactConfigs: _unlockImpactConfigs,
      categoryConfigs: _unlockCategoryConfigs,
      sortBy: sortBy,
      impactFilter: impactFilter,
      marketPairs: _marketPairs,
      watchlist: {
        for (final pair in _marketPairs)
          if (pair.isFavorite) pair.id,
      },
      alerts: const [
        MarketAlertDraft(
          id: 'unlock-apt-high-impact',
          pairId: 'aptusdt',
          label: 'APT high impact unlock in 1 day',
        ),
        MarketAlertDraft(
          id: 'unlock-tia-dilution-risk',
          pairId: 'tiausdt',
          label: 'TIA dilution risk leads unlock calendar',
        ),
      ],
      screenFilters: _tokenUnlockFilters,
      chartSeries: {
        'unlockValueUsd': [
          for (final unlock in _tokenUnlocks) unlock.unlockValueUsd,
        ],
        'unlockDilutionPct': [
          for (final unlock in _tokenUnlocks) unlock.unlockPctCirculating,
        ],
        'daysUntil': [
          for (final unlock in _tokenUnlocks) unlock.daysUntil.toDouble(),
        ],
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

MarketPair _findMarketPair(String pairId) {
  for (final pair in _marketPairs) {
    if (pair.id == pairId) return pair;
  }
  return _marketPairs.first;
}

MarketDepthData _generateDepthData(double midPrice, int levels) {
  final bids = <MarketDepthLevel>[];
  final asks = <MarketDepthLevel>[];
  final step = midPrice * 0.0003;
  final multiplier = midPrice > 10000
      ? 0.01
      : midPrice > 100
      ? 1.0
      : 100.0;

  var bidCumulative = 0.0;
  for (var index = 0; index < levels; index += 1) {
    final price = midPrice - (index + 1) * step;
    final quantity =
        _depthBidPattern[index % _depthBidPattern.length] * multiplier;
    bidCumulative += quantity;
    bids.add(
      MarketDepthLevel(
        price: price,
        quantity: quantity,
        cumulative: bidCumulative,
      ),
    );
  }

  var askCumulative = 0.0;
  for (var index = 0; index < levels; index += 1) {
    final price = midPrice + (index + 1) * step;
    final quantity =
        _depthAskPattern[index % _depthAskPattern.length] * multiplier;
    askCumulative += quantity;
    asks.add(
      MarketDepthLevel(
        price: price,
        quantity: quantity,
        cumulative: askCumulative,
      ),
    );
  }

  final spread = asks.first.price - bids.first.price;
  return MarketDepthData(
    bids: bids,
    asks: asks,
    midPrice: midPrice,
    spread: spread,
    spreadPct: spread / midPrice * 100,
  );
}

const List<double> _depthBidPattern = [
  2.1,
  3.5,
  1.8,
  5.2,
  2.7,
  1.3,
  4.8,
  2.2,
  6.1,
  3.3,
  1.5,
  2.9,
  7.4,
  2.1,
  3.8,
  1.6,
  4.2,
  2.8,
  1.9,
  12.5,
  3.1,
  2.4,
  1.7,
  3.6,
  2.3,
];

const List<double> _depthAskPattern = [
  1.9,
  2.8,
  4.1,
  1.6,
  3.2,
  2.5,
  1.4,
  5.6,
  2.9,
  1.8,
  3.7,
  2.1,
  1.3,
  4.5,
  2.6,
  8.9,
  1.7,
  3.4,
  2.2,
  1.5,
  2.8,
  3.1,
  1.9,
  2.4,
  4.7,
];

const List<MarketRecentTrade> _marketRecentTrades = [
  MarketRecentTrade(
    id: 'tr-1',
    price: 67543.21,
    amount: 0.1842,
    time: '23:29:14',
    side: MarketOrderSide.buy,
  ),
  MarketRecentTrade(
    id: 'tr-2',
    price: 67541.10,
    amount: 0.0724,
    time: '23:29:08',
    side: MarketOrderSide.sell,
  ),
  MarketRecentTrade(
    id: 'tr-3',
    price: 67545.80,
    amount: 0.4200,
    time: '23:28:57',
    side: MarketOrderSide.buy,
  ),
  MarketRecentTrade(
    id: 'tr-4',
    price: 67538.40,
    amount: 0.2105,
    time: '23:28:42',
    side: MarketOrderSide.sell,
  ),
  MarketRecentTrade(
    id: 'tr-5',
    price: 67552.30,
    amount: 0.0961,
    time: '23:28:25',
    side: MarketOrderSide.buy,
  ),
];

/// Terminal desk (2026-08-30): sinh [count] giao dịch deterministic quanh
/// [basePrice] — lặp khuôn của 5 seed gốc với giá trượt dần theo index,
/// đủ mật độ 24 dòng chuẩn sàn lớn; không đụng domain.
List<MarketRecentTrade> _generateRecentTrades(double basePrice, int count) {
  final seeds = _marketRecentTrades;
  return List.generate(count, (index) {
    final seed = seeds[index % seeds.length];
    final drift = (index ~/ seeds.length) + 1;
    return MarketRecentTrade(
      id: '${seed.id}-$index',
      price: basePrice * (1 - 0.0004 * index - 0.0002 * drift),
      amount: seed.amount * (1 + 0.05 * drift),
      side: index.isEven ? MarketOrderSide.buy : MarketOrderSide.sell,
      time:
          '12:0${(24 - index).clamp(0, 9)}:${(59 - index * 2).clamp(10, 59).toString().padLeft(2, '0')}',
    );
  });
}

const TokenFundamentalsDraft _btcFundamentals = TokenFundamentalsDraft(
  id: 'btcusdt',
  symbol: 'BTC',
  name: 'Bitcoin',
  description:
      'Bitcoin la tien te ky thuat so phi tap trung dau tien, hoat dong tren mang luoi ngang hang khong can trung gian, su dung co che Proof of Work.',
  consensus: 'Proof of Work (SHA-256)',
  network: 'Bitcoin',
  website: 'https://bitcoin.org',
  whitepaper: 'https://bitcoin.org/bitcoin.pdf',
  github: 'https://github.com/bitcoin/bitcoin',
  twitter: 'https://x.com/bitcoin',
  telegram: '',
  circulatingSupply: 19630000,
  totalSupply: 19630000,
  maxSupply: 21000000,
  fullyDilutedValuation: 1418410000000,
  inflationRate: 1.74,
  allTimeHigh: 73750.07,
  allTimeHighDate: '2024-03-14',
  allTimeLow: 67.81,
  allTimeLowDate: '2013-07-06',
  roi1y: 125.40,
  activeAddresses24h: 987654,
  txCount24h: 543210,
  holders: 53120000,
  tvl: null,
  supplyDistribution: [
    SupplyDistributionDraft(
      label: 'Luu hanh',
      percentage: 93.5,
      color: AccentTone.buy,
    ),
    SupplyDistributionDraft(
      label: 'Chua dao',
      percentage: 6.5,
      color: AccentTone.text3,
    ),
  ],
  contractAddresses: [],
);

const Map<String, TokenFundamentalsDraft> _tokenFundamentals = {
  'btcusdt': _btcFundamentals,
};

const MarketScreenFilters _advancedChartsFilters = MarketScreenFilters(
  categories: ['Tất cả', 'Xu hướng', 'Động lượng', 'Biến động', 'Khối lượng'],
  defaultCategory: 'Tất cả',
  defaultSort: 'indicators',
  sortOptions: [
    MarketSortOption(id: 'indicators', label: 'Chỉ báo'),
    MarketSortOption(id: 'drawing', label: 'Công cụ vẽ'),
    MarketSortOption(id: 'signals', label: 'Tín hiệu kỹ thuật'),
  ],
);

const List<AdvancedChartCategory> _advancedChartIndicatorCategories = [
  AdvancedChartCategory(id: 'trend', label: 'Xu hướng', color: AccentTone.info),
  AdvancedChartCategory(
    id: 'momentum',
    label: 'Động lượng',
    color: AccentTone.caution,
  ),
  AdvancedChartCategory(
    id: 'volatility',
    label: 'Biến động',
    color: AccentTone.accent,
  ),
  AdvancedChartCategory(
    id: 'volume',
    label: 'Khối lượng',
    color: AccentTone.buy,
  ),
];

const List<AdvancedChartCategory> _advancedChartDrawingCategories = [
  AdvancedChartCategory(id: 'line', label: 'Đường', color: AccentTone.info),
  AdvancedChartCategory(
    id: 'shape',
    label: 'Hình dạng',
    color: AccentTone.accent,
  ),
  AdvancedChartCategory(
    id: 'fib',
    label: 'Fibonacci',
    color: AccentTone.caution,
  ),
  AdvancedChartCategory(
    id: 'measure',
    label: 'Đo lường',
    color: AccentTone.buy,
  ),
];

const List<TechnicalIndicator> _advancedChartIndicators = [
  TechnicalIndicator(
    id: 'sma',
    name: 'Simple Moving Average',
    shortName: 'SMA',
    categoryId: 'trend',
    color: AccentTone.info,
    description: 'Trung bình giá đóng cửa trong N kỳ',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 20)],
  ),
  TechnicalIndicator(
    id: 'ema',
    name: 'Exponential Moving Average',
    shortName: 'EMA',
    categoryId: 'trend',
    color: AccentTone.accent,
    description: 'Trung bình trọng số hàm mũ, phản ứng nhanh hơn SMA',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 12)],
  ),
  TechnicalIndicator(
    id: 'boll',
    name: 'Bollinger Bands',
    shortName: 'BOLL',
    categoryId: 'volatility',
    color: AccentTone.accent,
    description: 'Dải biến động quanh SMA +/- 2 độ lệch chuẩn',
    params: [
      TechnicalIndicatorParam(label: 'Chu kỳ', value: 20),
      TechnicalIndicatorParam(label: 'Sigma', value: 2),
    ],
  ),
  TechnicalIndicator(
    id: 'rsi',
    name: 'Relative Strength Index',
    shortName: 'RSI',
    categoryId: 'momentum',
    color: AccentTone.caution,
    description: 'Chỉ số sức mạnh tương đối, quá mua >70, quá bán <30',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 14)],
  ),
  TechnicalIndicator(
    id: 'macd',
    name: 'MACD',
    shortName: 'MACD',
    categoryId: 'momentum',
    color: AccentTone.buy,
    description: 'Chênh lệch EMA nhanh và EMA chậm, phát hiện đảo chiều',
    params: [
      TechnicalIndicatorParam(label: 'Nhanh', value: 12),
      TechnicalIndicatorParam(label: 'Chậm', value: 26),
      TechnicalIndicatorParam(label: 'Signal', value: 9),
    ],
  ),
  TechnicalIndicator(
    id: 'stoch',
    name: 'Stochastic Oscillator',
    shortName: 'STOCH',
    categoryId: 'momentum',
    color: AccentTone.info,
    description: 'So sánh giá đóng cửa với phạm vi giá trong kỳ',
    params: [
      TechnicalIndicatorParam(label: 'K', value: 14),
      TechnicalIndicatorParam(label: 'D', value: 3),
    ],
  ),
  TechnicalIndicator(
    id: 'atr',
    name: 'Average True Range',
    shortName: 'ATR',
    categoryId: 'volatility',
    color: AccentTone.sell,
    description: 'Đo lường biến động trung bình, dùng đặt stop-loss',
    params: [TechnicalIndicatorParam(label: 'Chu kỳ', value: 14)],
  ),
  TechnicalIndicator(
    id: 'vwap',
    name: 'Volume Weighted Average Price',
    shortName: 'VWAP',
    categoryId: 'volume',
    color: AccentTone.buy,
    description: 'Giá trung bình trọng số khối lượng trong phiên',
    params: [],
  ),
  TechnicalIndicator(
    id: 'obv',
    name: 'On-Balance Volume',
    shortName: 'OBV',
    categoryId: 'volume',
    color: AccentTone.accent,
    description: 'Tích lũy khối lượng theo chiều giá, phát hiện phân kỳ',
    params: [],
  ),
  TechnicalIndicator(
    id: 'ichimoku',
    name: 'Ichimoku Cloud',
    shortName: 'ICHI',
    categoryId: 'trend',
    color: AccentTone.buyDark,
    description: 'Hệ thống đa chỉ số: xu hướng, hỗ trợ/kháng cự, động lượng',
    params: [
      TechnicalIndicatorParam(label: 'Tenkan', value: 9),
      TechnicalIndicatorParam(label: 'Kijun', value: 26),
      TechnicalIndicatorParam(label: 'Senkou', value: 52),
    ],
  ),
];

const List<AdvancedDrawingTool> _advancedChartDrawingTools = [
  AdvancedDrawingTool(
    id: 'trendline',
    name: 'Đường xu hướng',
    icon: 'timeline',
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'hline',
    name: 'Đường ngang',
    icon: 'horizontalRule',
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'channel',
    name: 'Kênh giá',
    icon: 'stackedLineChart',
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'ray',
    name: 'Tia',
    icon: 'trendingUp',
    categoryId: 'line',
  ),
  AdvancedDrawingTool(
    id: 'rect',
    name: 'Hình chữ nhật',
    icon: 'cropSquare',
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'circle',
    name: 'Hình tròn',
    icon: 'circleOutlined',
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'text',
    name: 'Ghi chú',
    icon: 'notes',
    categoryId: 'shape',
  ),
  AdvancedDrawingTool(
    id: 'fib_ret',
    name: 'Fibonacci Retracement',
    icon: 'formatListNumbered',
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'fib_ext',
    name: 'Fibonacci Extension',
    icon: 'barChart',
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'fib_fan',
    name: 'Fibonacci Fan',
    icon: 'radar',
    categoryId: 'fib',
  ),
  AdvancedDrawingTool(
    id: 'measure',
    name: 'Đo khoảng cách',
    icon: 'straighten',
    categoryId: 'measure',
  ),
  AdvancedDrawingTool(
    id: 'daterange',
    name: 'Đo thời gian',
    icon: 'dateRange',
    categoryId: 'measure',
  ),
];

const List<TechSignalSummaryDraft> _advancedChartSignalSummaries = [
  TechSignalSummaryDraft(
    pair: 'BTC/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.strongBuy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.buy,
    buyCount: 9,
    sellCount: 2,
    neutralCount: 1,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 62100),
      TechPivotPointDraft(label: 'S2', value: 64200),
      TechPivotPointDraft(label: 'S1', value: 65800),
      TechPivotPointDraft(label: 'Pivot', value: 67000),
      TechPivotPointDraft(label: 'R1', value: 68500),
      TechPivotPointDraft(label: 'R2', value: 70100),
      TechPivotPointDraft(label: 'R3', value: 72300),
    ],
  ),
  TechSignalSummaryDraft(
    pair: 'ETH/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.buy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.neutral,
    buyCount: 7,
    sellCount: 3,
    neutralCount: 2,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 3220),
      TechPivotPointDraft(label: 'S2', value: 3340),
      TechPivotPointDraft(label: 'S1', value: 3420),
      TechPivotPointDraft(label: 'Pivot', value: 3500),
      TechPivotPointDraft(label: 'R1', value: 3580),
      TechPivotPointDraft(label: 'R2', value: 3680),
      TechPivotPointDraft(label: 'R3', value: 3800),
    ],
  ),
  TechSignalSummaryDraft(
    pair: 'SOL/USDT',
    timeframe: '1D',
    overallSignal: TechSignal.strongBuy,
    maSummary: TechSignal.buy,
    oscSummary: TechSignal.buy,
    buyCount: 10,
    sellCount: 1,
    neutralCount: 1,
    pivotPoints: [
      TechPivotPointDraft(label: 'S3', value: 155),
      TechPivotPointDraft(label: 'S2', value: 162),
      TechPivotPointDraft(label: 'S1', value: 168),
      TechPivotPointDraft(label: 'Pivot', value: 175),
      TechPivotPointDraft(label: 'R1', value: 182),
      TechPivotPointDraft(label: 'R2', value: 190),
      TechPivotPointDraft(label: 'R3', value: 198),
    ],
  ),
];

const MarketScreenFilters _tokenUnlockFilters = MarketScreenFilters(
  categories: ['Sắp mở khóa', 'Phân tích', 'Lịch trình'],
  defaultCategory: 'Sắp mở khóa',
  defaultSort: 'nearest',
  sortOptions: [
    MarketSortOption(id: 'nearest', label: 'Gần nhất'),
    MarketSortOption(id: 'value', label: 'Giá trị cao'),
    MarketSortOption(id: 'impact', label: 'Tác động lớn'),
  ],
);

const Map<MarketUnlockImpact, UnlockImpactConfig> _unlockImpactConfigs = {
  MarketUnlockImpact.high: UnlockImpactConfig(
    label: 'Cao',
    color: AccentTone.sell,
  ),
  MarketUnlockImpact.medium: UnlockImpactConfig(
    label: 'Trung bình',
    color: AccentTone.warn,
  ),
  MarketUnlockImpact.low: UnlockImpactConfig(
    label: 'Thấp',
    color: AccentTone.buy,
  ),
};

const Map<MarketUnlockCategory, UnlockCategoryConfig> _unlockCategoryConfigs = {
  MarketUnlockCategory.team: UnlockCategoryConfig(
    label: 'Team',
    color: AccentTone.info,
  ),
  MarketUnlockCategory.investor: UnlockCategoryConfig(
    label: 'Nhà đầu tư',
    color: AccentTone.sell,
  ),
  MarketUnlockCategory.ecosystem: UnlockCategoryConfig(
    label: 'Hệ sinh thái',
    color: AccentTone.buy,
  ),
  MarketUnlockCategory.community: UnlockCategoryConfig(
    label: 'Cộng đồng',
    color: AccentTone.warn,
  ),
  MarketUnlockCategory.foundation: UnlockCategoryConfig(
    label: 'Quỹ',
    color: AccentTone.accent,
  ),
};

const List<TokenUnlockDraft> _tokenUnlocks = [
  TokenUnlockDraft(
    id: 'u1',
    symbol: 'ARB',
    name: 'Arbitrum',
    unlockDate: '2026-03-16',
    unlockDateLabel: '16 Th3 2026',
    daysUntil: 5,
    unlockAmount: 92650000,
    unlockValueUsd: 120445000,
    unlockPctCirculating: 2.8,
    totalLocked: 3240000000,
    totalLockedValueUsd: 4212000000,
    vestingType: MarketUnlockVestingType.cliff,
    category: MarketUnlockCategory.investor,
    impactLevel: MarketUnlockImpact.high,
    currentPrice: 1.30,
    priceChange7d: -4.2,
    circulatingSupply: 3340000000,
    totalSupply: 10000000000,
    vestingSchedule: [
      TokenVestingEventDraft(
        date: '03/2026',
        pct: 2.8,
        label: 'Investor cliff',
      ),
      TokenVestingEventDraft(date: '06/2026', pct: 3.5, label: 'Team vesting'),
      TokenVestingEventDraft(
        date: '09/2026',
        pct: 2.1,
        label: 'Advisor vesting',
      ),
      TokenVestingEventDraft(
        date: '12/2026',
        pct: 4.2,
        label: 'Ecosystem fund',
      ),
    ],
  ),
  TokenUnlockDraft(
    id: 'u2',
    symbol: 'OP',
    name: 'Optimism',
    unlockDate: '2026-03-20',
    unlockDateLabel: '20 Th3 2026',
    daysUntil: 9,
    unlockAmount: 31340000,
    unlockValueUsd: 62680000,
    unlockPctCirculating: 1.9,
    totalLocked: 2890000000,
    totalLockedValueUsd: 5780000000,
    vestingType: MarketUnlockVestingType.linear,
    category: MarketUnlockCategory.team,
    impactLevel: MarketUnlockImpact.medium,
    currentPrice: 2.00,
    priceChange7d: -1.8,
    circulatingSupply: 1640000000,
    totalSupply: 4294967296,
    vestingSchedule: [
      TokenVestingEventDraft(
        date: '03/2026',
        pct: 1.9,
        label: 'Core contributor',
      ),
      TokenVestingEventDraft(
        date: '04/2026',
        pct: 1.9,
        label: 'Core contributor',
      ),
      TokenVestingEventDraft(
        date: '05/2026',
        pct: 1.9,
        label: 'Core contributor',
      ),
      TokenVestingEventDraft(
        date: '06/2026',
        pct: 2.4,
        label: 'Investor unlock',
      ),
    ],
  ),
  TokenUnlockDraft(
    id: 'u3',
    symbol: 'APT',
    name: 'Aptos',
    unlockDate: '2026-03-12',
    unlockDateLabel: '12 Th3 2026',
    daysUntil: 1,
    unlockAmount: 11310000,
    unlockValueUsd: 96135000,
    unlockPctCirculating: 2.4,
    totalLocked: 567000000,
    totalLockedValueUsd: 4819500000,
    vestingType: MarketUnlockVestingType.linear,
    category: MarketUnlockCategory.foundation,
    impactLevel: MarketUnlockImpact.high,
    currentPrice: 8.50,
    priceChange7d: -6.1,
    circulatingSupply: 472000000,
    totalSupply: 1084577833,
    vestingSchedule: [
      TokenVestingEventDraft(date: '03/2026', pct: 2.4, label: 'Foundation'),
      TokenVestingEventDraft(date: '04/2026', pct: 2.4, label: 'Foundation'),
      TokenVestingEventDraft(date: '05/2026', pct: 1.8, label: 'Community'),
      TokenVestingEventDraft(
        date: '06/2026',
        pct: 3.1,
        label: 'Investor cliff',
      ),
    ],
  ),
  TokenUnlockDraft(
    id: 'u4',
    symbol: 'SUI',
    name: 'Sui',
    unlockDate: '2026-04-01',
    unlockDateLabel: '01 Th4 2026',
    daysUntil: 21,
    unlockAmount: 64190000,
    unlockValueUsd: 96285000,
    unlockPctCirculating: 2.6,
    totalLocked: 5420000000,
    totalLockedValueUsd: 8130000000,
    vestingType: MarketUnlockVestingType.cliff,
    category: MarketUnlockCategory.investor,
    impactLevel: MarketUnlockImpact.medium,
    currentPrice: 1.50,
    priceChange7d: 3.2,
    circulatingSupply: 2480000000,
    totalSupply: 10000000000,
    vestingSchedule: [
      TokenVestingEventDraft(
        date: '04/2026',
        pct: 2.6,
        label: 'Investor unlock',
      ),
      TokenVestingEventDraft(date: '07/2026', pct: 3.8, label: 'Team vesting'),
      TokenVestingEventDraft(
        date: '10/2026',
        pct: 2.2,
        label: 'Community rewards',
      ),
      TokenVestingEventDraft(date: '01/2027', pct: 4.5, label: 'Foundation'),
    ],
  ),
  TokenUnlockDraft(
    id: 'u5',
    symbol: 'TIA',
    name: 'Celestia',
    unlockDate: '2026-03-25',
    unlockDateLabel: '25 Th3 2026',
    daysUntil: 14,
    unlockAmount: 18500000,
    unlockValueUsd: 148000000,
    unlockPctCirculating: 8.2,
    totalLocked: 818000000,
    totalLockedValueUsd: 6544000000,
    vestingType: MarketUnlockVestingType.cliff,
    category: MarketUnlockCategory.investor,
    impactLevel: MarketUnlockImpact.high,
    currentPrice: 8.00,
    priceChange7d: -8.5,
    circulatingSupply: 226000000,
    totalSupply: 1044000000,
    vestingSchedule: [
      TokenVestingEventDraft(
        date: '03/2026',
        pct: 8.2,
        label: 'Major investor cliff',
      ),
      TokenVestingEventDraft(date: '06/2026', pct: 5.1, label: 'Team cliff'),
      TokenVestingEventDraft(date: '09/2026', pct: 3.4, label: 'Ecosystem'),
      TokenVestingEventDraft(
        date: '10/2026',
        pct: 12.0,
        label: 'Investor cliff 2',
      ),
    ],
  ),
  TokenUnlockDraft(
    id: 'u6',
    symbol: 'STRK',
    name: 'Starknet',
    unlockDate: '2026-04-15',
    unlockDateLabel: '15 Th4 2026',
    daysUntil: 35,
    unlockAmount: 127000000,
    unlockValueUsd: 88900000,
    unlockPctCirculating: 5.4,
    totalLocked: 7280000000,
    totalLockedValueUsd: 5096000000,
    vestingType: MarketUnlockVestingType.linear,
    category: MarketUnlockCategory.team,
    impactLevel: MarketUnlockImpact.medium,
    currentPrice: .70,
    priceChange7d: 1.2,
    circulatingSupply: 2350000000,
    totalSupply: 10000000000,
    vestingSchedule: [
      TokenVestingEventDraft(date: '04/2026', pct: 5.4, label: 'Team linear'),
      TokenVestingEventDraft(date: '05/2026', pct: 5.4, label: 'Team linear'),
      TokenVestingEventDraft(date: '06/2026', pct: 5.4, label: 'Team linear'),
      TokenVestingEventDraft(date: '07/2026', pct: 3.2, label: 'Ecosystem'),
    ],
  ),
];
