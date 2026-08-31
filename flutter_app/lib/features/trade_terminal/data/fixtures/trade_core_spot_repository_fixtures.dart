part of '../repositories/mock_trade_terminal_repository.dart';

const List<TradePair> _pairs = [
  TradePair(
    id: 'btcusdt',
    symbol: 'BTC/USDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    price: 67543.21,
    changePct: 2.34,
    logoColorHex: 0xFFE58A00,
  ),
  TradePair(
    id: 'ethusdt',
    symbol: 'ETH/USDT',
    baseAsset: 'ETH',
    quoteAsset: 'USDT',
    price: 3521.44,
    changePct: 1.18,
    logoColorHex: 0xFF8B5CF6,
  ),
  TradePair(
    id: 'solusdt',
    symbol: 'SOL/USDT',
    baseAsset: 'SOL',
    quoteAsset: 'USDT',
    price: 146.72,
    changePct: -0.42,
    logoColorHex: 0xFF10B981,
  ),
];

const TradeSettings _defaultTradeSettings = TradeSettings(
  defaultOrderType: 'limit',
  defaultSlippage: .5,
  confirmOrders: true,
  skipConfirmSmall: false,
  smallOrderThreshold: 50,
  soundOnFill: true,
  hapticOnFill: true,
  showTpsl: false,
  bracketMode: false,
  priceDecimals: 'auto',
  defaultPctButtons: true,
  showOrderBook: true,
  showRecentTrades: true,
  chartTimeframe: '1h',
);

const List<TradeDashboardPosition> _dashboardPositions = [
  TradeDashboardPosition(
    id: 'sp1',
    symbol: 'BTC/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: .045,
    entryPrice: 65200,
    currentPrice: 67543.21,
    pnl: 105.44,
    pnlPct: 3.59,
    takeProfit: 72000,
    stopLoss: 63000,
  ),
  TradeDashboardPosition(
    id: 'sp2',
    symbol: 'ETH/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: 1.2,
    entryPrice: 3380,
    currentPrice: 3521.45,
    pnl: 169.74,
    pnlPct: 4.18,
  ),
  TradeDashboardPosition(
    id: 'sp3',
    symbol: 'SOL/USDT',
    type: TradePositionType.spot,
    side: TradePositionSide.long,
    size: 25,
    entryPrice: 192,
    currentPrice: 185.32,
    pnl: -167,
    pnlPct: -3.48,
  ),
  TradeDashboardPosition(
    id: 'ft1',
    symbol: 'ETH/USDT',
    type: TradePositionType.futures,
    side: TradePositionSide.long,
    size: .5,
    entryPrice: 3480,
    currentPrice: 3521.45,
    pnl: 20.73,
    pnlPct: 1.19,
    leverage: 10,
    liquidPrice: 3150,
    margin: 174,
    takeProfit: 3800,
    stopLoss: 3300,
  ),
  TradeDashboardPosition(
    id: 'ft2',
    symbol: 'SOL/USDT',
    type: TradePositionType.futures,
    side: TradePositionSide.short,
    size: 10,
    entryPrice: 185,
    currentPrice: 178.32,
    pnl: 66.8,
    pnlPct: 3.61,
    leverage: 5,
    liquidPrice: 222,
    margin: 370,
  ),
  TradeDashboardPosition(
    id: 'mg1',
    symbol: 'BTC/USDT',
    type: TradePositionType.margin,
    side: TradePositionSide.long,
    size: .02,
    entryPrice: 66800,
    currentPrice: 67543.21,
    pnl: 14.86,
    pnlPct: 1.11,
    leverage: 3,
    margin: 445.33,
  ),
];

const TradeAdvancedDemoPosition _advancedDemoPosition =
    TradeAdvancedDemoPosition(
      id: 'pos1',
      pair: 'BTC/USDT',
      side: 'long',
      currentSize: .5,
      currentPnl: 1250,
      markPrice: 67543.21,
      entryPrice: 65200,
      currentMargin: 6520,
      availableBalance: 5000,
      liquidationPrice: 52160,
    );

const List<TradeAdvancedDemoAction> _advancedDemoPositionActions = [
  TradeAdvancedDemoAction(
    id: 'partial-close',
    label: 'Partial Close Position (25%/50%/75%/100%)',
    description: 'Close a controlled percentage of the current position.',
  ),
  TradeAdvancedDemoAction(
    id: 'ladder-tpsl',
    label: 'Ladder TP/SL (Multiple Levels)',
    description: 'Split take-profit and stop-loss into multiple levels.',
  ),
  TradeAdvancedDemoAction(
    id: 'trailing-stop',
    label: 'Trailing Stop Loss',
    description: 'Move stop distance automatically as price moves.',
  ),
  TradeAdvancedDemoAction(
    id: 'margin-adjust',
    label: 'Add/Reduce Margin',
    description: 'Adjust margin allocation without leaving the position.',
  ),
];

const List<TradeAdvancedDemoAction> _advancedDemoOrderTypes = [
  TradeAdvancedDemoAction(
    id: 'market',
    label: 'Market',
    description: 'Khớp ngay lập tức với giá tốt nhất',
  ),
  TradeAdvancedDemoAction(
    id: 'limit',
    label: 'Limit',
    description: 'Đặt giá mong muốn, chờ khớp',
  ),
  TradeAdvancedDemoAction(
    id: 'stop-market',
    label: 'Stop Market',
    description: 'Kích hoạt Market khi chạm trigger',
  ),
  TradeAdvancedDemoAction(
    id: 'stop-limit',
    label: 'Stop Limit',
    description: 'Kích hoạt Limit khi chạm trigger',
  ),
];

const List<TradeAdvancedDemoAction> _advancedDemoTimeInForce = [
  TradeAdvancedDemoAction(
    id: 'GTC',
    label: 'GTC',
    description: 'Good Till Cancel',
  ),
  TradeAdvancedDemoAction(
    id: 'IOC',
    label: 'IOC',
    description: 'Immediate or Cancel',
  ),
  TradeAdvancedDemoAction(id: 'FOK', label: 'FOK', description: 'Fill or Kill'),
  TradeAdvancedDemoAction(
    id: 'GTX',
    label: 'Post-Only',
    description: 'Maker only',
  ),
];

const List<TradeAdvancedDemoMetric> _advancedDemoOrderSummary = [
  TradeAdvancedDemoMetric(label: 'Order Type', value: 'LIMIT'),
  TradeAdvancedDemoMetric(label: 'Time In Force', value: 'GTC'),
  TradeAdvancedDemoMetric(label: 'Reduce-Only', value: 'No'),
  TradeAdvancedDemoMetric(label: 'Iceberg', value: 'Disabled'),
];

const List<TradeAdvancedDemoMetric> _advancedDemoPnlSummary = [
  TradeAdvancedDemoMetric(
    label: 'Realized PnL',
    value: '+\$3,250.50',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Unrealized PnL',
    value: '+\$1,250.00',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Equity',
    value: '\$15,000.00',
    tone: TradeAdvancedMetricTone.accent,
  ),
];

const List<TradeAdvancedDemoMetric> _advancedDemoPerformanceMetrics = [
  TradeAdvancedDemoMetric(label: 'Total Trades', value: '47'),
  TradeAdvancedDemoMetric(
    label: 'Win Rate',
    value: '68.1%',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Profit',
    value: '+\$8,450.00',
    tone: TradeAdvancedMetricTone.positive,
  ),
  TradeAdvancedDemoMetric(
    label: 'Total Loss',
    value: '-\$3,200.00',
    tone: TradeAdvancedMetricTone.negative,
  ),
  TradeAdvancedDemoMetric(label: 'Avg Win', value: '\$264.06'),
  TradeAdvancedDemoMetric(label: 'Avg Loss', value: '-\$213.33'),
];

const List<TradeAdvancedAnalyticsStat> _advancedAnalyticsStats = [
  TradeAdvancedAnalyticsStat(
    label: 'AI Signals',
    value: '3',
    colorHex: 0xFF8B5CF6,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Risk Score',
    value: '58',
    colorHex: 0xFFF59E0B,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Win Rate',
    value: '66.7%',
    colorHex: 0xFF10B981,
  ),
  TradeAdvancedAnalyticsStat(
    label: 'Sharpe',
    value: '1.82',
    colorHex: 0xFF3B82F6,
  ),
];

const List<TradeAiSignal> _advancedAnalyticsSignals = [
  TradeAiSignal(
    id: 'sig-1',
    pair: 'BTC/USDT',
    direction: 'long',
    confidence: 85,
    timeframe: '4h',
    entryPrice: 67500,
    targetPrice: 70200,
    stopLoss: 66800,
    riskReward: 3.9,
    accuracy: 73,
    reasoning: [
      'RSI oversold bounce from 32 to 45, bullish divergence confirmed',
      'Volume spike +320% on 4h candle, strong accumulation detected',
      'Breaking above 20-day EMA with increasing volume',
      'Whale wallets accumulated +\$1.2B in last 24h',
      'Funding rate dropped to -0.02%, shorts overleveraged',
    ],
  ),
  TradeAiSignal(
    id: 'sig-2',
    pair: 'ETH/USDT',
    direction: 'short',
    confidence: 72,
    timeframe: '1h',
    entryPrice: 3245,
    targetPrice: 3180,
    stopLoss: 3270,
    riskReward: 2.6,
    accuracy: 68,
    reasoning: [
      'Double top pattern forming at \$3,250 resistance',
      'Bearish divergence: price higher but RSI lower',
      'Volume declining on each rally attempt',
      'ETH/BTC ratio weakening against BTC',
    ],
  ),
  TradeAiSignal(
    id: 'sig-3',
    pair: 'SOL/USDT',
    direction: 'long',
    confidence: 91,
    timeframe: '15m',
    entryPrice: 145,
    targetPrice: 151,
    stopLoss: 143.5,
    riskReward: 4.0,
    accuracy: 78,
    reasoning: [
      'Breakout from ascending triangle after consolidation',
      'Volume explosion +580%, institutional flow detected',
      'All moving averages aligned bullish',
      'Solana ecosystem TVL +12% this week',
      'Major airdrop announcement driving demand',
    ],
  ),
];

const TradeAdvancedRiskSummary _advancedAnalyticsRisk =
    TradeAdvancedRiskSummary(
      var95: 5.2,
      sharpeRatio: 1.82,
      maxDrawdown: 18.5,
      riskScore: 58,
      riskLevel: 'medium',
    );

const TradeJournalSummary _advancedAnalyticsJournal = TradeJournalSummary(
  winRate: 66.7,
  totalTrades: 6,
  totalPnl: 7400,
  avgWin: 2210,
  avgLoss: 415,
);

const TradePositionSizingSummary _advancedAnalyticsSizing =
    TradePositionSizingSummary(
      accountBalance: 50000,
      entryPrice: 67500,
      stopLossPrice: 66800,
      takeProfitPrice: 70200,
      recommendedRiskPct: 2,
      positionSize: 1.43,
    );

const List<String> _advancedAnalyticsFeatures = [
  'AI Trading Signals',
  'Risk Score Dashboard',
  'VaR Calculator',
  'Sharpe/Sortino Ratios',
  'Trade Journal',
  'Win/Loss Analytics',
  'Kelly Criterion',
  'Position Sizing',
  'Performance Attribution',
  'Setup Classification',
  'Drawdown Analysis',
  'Beta Calculation',
];

const List<TradeOpenOrder> _orders = [
  TradeOpenOrder(
    id: 'ord001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    price: 67050,
    amount: .12,
    filled: .04,
    createdAt: '23/02 09:24',
  ),
  TradeOpenOrder(
    id: 'ord002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    price: 3580,
    amount: 1.4,
    filled: 0,
    createdAt: '23/02 08:11',
  ),
  TradeOpenOrder(
    id: 'ord003',
    symbol: 'SOL/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.stop,
    price: 138.4,
    amount: 40,
    filled: 0,
    createdAt: '23/02 07:58',
  ),
  TradeOpenOrder(
    id: 'ord004',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    price: 68900,
    amount: .06,
    filled: 0,
    createdAt: '23/02 07:41',
  ),
  TradeOpenOrder(
    id: 'ord005',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    price: 3410,
    amount: 2.5,
    filled: 1.1,
    createdAt: '23/02 06:17',
  ),
  TradeOpenOrder(
    id: 'ord006',
    symbol: 'SOL/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    price: 152.8,
    amount: 65,
    filled: 0,
    createdAt: '23/02 05:36',
  ),
];

const List<TradeHistoryOrder> _historyOpenOrders = [
  TradeHistoryOrder(
    id: 'ord-open-001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.open,
    price: 65000,
    amount: .05,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 09:32:11',
  ),
  TradeHistoryOrder(
    id: 'ord-open-002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.partial,
    price: 3650,
    amount: 1.5,
    filled: .8,
    fee: .24,
    createdAt: '2024-02-21 10:15:44',
  ),
  TradeHistoryOrder(
    id: 'ord-open-003',
    symbol: 'SOL/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.stop,
    status: TradeOrderStatus.open,
    price: 170,
    amount: 10,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 11:02:33',
  ),
  TradeHistoryOrder(
    id: 'ord-open-004',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.market,
    status: TradeOrderStatus.open,
    price: 67500,
    amount: .02,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-21 12:18:07',
  ),
];

const List<TradeHistoryOrder> _historyOrders = [
  TradeHistoryOrder(
    id: 'ord-history-001',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.filled,
    price: 64220,
    amount: .08,
    filled: .08,
    fee: 3.71,
    createdAt: '2024-02-20 18:21:44',
  ),
  TradeHistoryOrder(
    id: 'ord-history-002',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.market,
    status: TradeOrderStatus.filled,
    price: 3588,
    amount: 1.2,
    filled: 1.2,
    fee: 2.89,
    createdAt: '2024-02-20 16:09:12',
  ),
  TradeHistoryOrder(
    id: 'ord-history-003',
    symbol: 'SOL/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.stop,
    status: TradeOrderStatus.cancelled,
    price: 154,
    amount: 12,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-19 22:40:03',
  ),
  TradeHistoryOrder(
    id: 'ord-history-004',
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.filled,
    price: 67120,
    amount: .03,
    filled: .03,
    fee: 1.71,
    createdAt: '2024-02-19 14:35:10',
  ),
  TradeHistoryOrder(
    id: 'ord-history-005',
    symbol: 'ETH/USDT',
    side: TradeOrderSide.buy,
    type: TradeOrderType.limit,
    status: TradeOrderStatus.cancelled,
    price: 3400,
    amount: .9,
    filled: 0,
    fee: 0,
    createdAt: '2024-02-18 09:12:40',
  ),
];

const List<TradePosition> _positions = [
  TradePosition(
    symbol: 'BTC/USDT',
    side: TradeOrderSide.buy,
    notional: 8105.19,
    pnl: 142.44,
  ),
  TradePosition(
    symbol: 'ETH/USDT',
    side: TradeOrderSide.buy,
    notional: 4225.73,
    pnl: 169.74,
  ),
  TradePosition(
    symbol: 'SOL/USDT',
    side: TradeOrderSide.buy,
    notional: 4633.0,
    pnl: -167.0,
  ),
  TradePosition(
    symbol: 'SOL/USDT',
    side: TradeOrderSide.sell,
    notional: 1783.2,
    pnl: 66.8,
  ),
  TradePosition(
    symbol: 'BTC/USDT',
    side: TradeOrderSide.sell,
    notional: 1350.86,
    pnl: 14.86,
  ),
];
