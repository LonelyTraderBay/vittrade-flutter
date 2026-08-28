part of '../repositories/mock_market_repository.dart';

/// GD4 Cụm F7 (REALTIME): 2 method Stream của [MarketRepository] —
/// `watchTicker`/`watchDepth`. Tick phát qua `Stream.periodic` với công
/// thức DETERMINISTIC dựa trên chỉ số tick (KHÔNG `Random`/`DateTime.now`
/// — xem GD4-Async-Playbook + AGENTS.md "Financial Safety" cho lý do cấm
/// nguồn ngẫu nhiên/đồng hồ hệ thống trong mock dữ liệu tài chính).
mixin _MockMarketRepositoryRealtimeMethods on _MockMarketRepositoryBase {
  @override
  Stream<List<MarketPair>> watchTicker() {
    return Stream<int>.periodic(
      tickInterval,
      (tick) => tick,
    ).map((tick) => _tickerPairsAtTick(tick));
  }

  @override
  Stream<MarketDepthSnapshot> watchDepth(String pairId, {int levels = 25}) {
    final normalizedLevels = _marketDepthLevels.contains(levels) ? levels : 25;
    final pair = _findMarketPair(pairId);
    return Stream<int>.periodic(
      tickInterval,
      (tick) => tick,
    ).map((tick) => _depthSnapshotAtTick(pair, normalizedLevels, tick));
  }
}

/// Bảng delta % cố định cho ticker realtime — mỗi tick CHỈ MỘT pair (theo
/// `tick % pairCount`, vòng tròn qua toàn bộ [_marketPairs]) nhận delta mới
/// quanh giá fixture gốc; các pair còn lại giữ nguyên giá của lần kích hoạt
/// gần nhất. Nhờ vậy `marketPairLivePriceProvider.select()` ở tầng UI chỉ
/// thấy giá trị đổi (và chỉ rebuild) đúng 1 hàng mỗi tick thay vì cả 10.
const List<double> _tickerDeltaPct = [
  0.12,
  -0.18,
  0.24,
  -0.09,
  0.15,
  -0.21,
  0.06,
  -0.14,
];

/// Tick gần nhất (`<= tick`) mà pair ở vị trí [pairIndex] (trong tổng
/// [pairCount] pairs) được "kích hoạt" — mỗi tick chỉ đúng 1 pair kích hoạt
/// theo vòng `tick % pairCount`. Trả `-1` nếu pair đó chưa từng kích hoạt
/// (còn giữ giá fixture gốc).
int _tickerLastActivation(int pairIndex, int tick, int pairCount) {
  if (tick < pairIndex) return -1;
  return pairIndex + pairCount * ((tick - pairIndex) ~/ pairCount);
}

double _tickerPriceAtTick(
  MarketPair pair,
  int pairIndex,
  int tick,
  int pairCount,
) {
  final activation = _tickerLastActivation(pairIndex, tick, pairCount);
  if (activation < 0) return pair.price;
  final deltaPct = _tickerDeltaPct[activation % _tickerDeltaPct.length];
  return pair.price * (1 + deltaPct / 100);
}

List<MarketPair> _tickerPairsAtTick(int tick) {
  return [
    for (var index = 0; index < _marketPairs.length; index += 1)
      _withLivePrice(
        _marketPairs[index],
        _tickerPriceAtTick(
          _marketPairs[index],
          index,
          tick,
          _marketPairs.length,
        ),
      ),
  ];
}

MarketPair _withLivePrice(MarketPair pair, double price) {
  if (price == pair.price) return pair;
  return MarketPair(
    id: pair.id,
    symbol: pair.symbol,
    baseAsset: pair.baseAsset,
    quoteAsset: pair.quoteAsset,
    price: price,
    prevPrice: pair.prevPrice,
    change24h: pair.change24h,
    high24h: pair.high24h,
    low24h: pair.low24h,
    volume24h: pair.volume24h,
    marketCap: pair.marketCap,
    sparklineData: pair.sparklineData,
    isFavorite: pair.isFavorite,
    category: pair.category,
  );
}

/// Bảng delta % cố định cho sổ lệnh realtime — dao động NHỎ hơn ticker
/// (toàn bộ sổ lệnh dịch chuyển theo mid-price mỗi tick, khác ticker chỉ 1
/// pair/tick) quanh giá fixture gốc của pair đang xem, KHÔNG dồn tích qua
/// các tick (mỗi tick tính lại từ giá gốc — dao động quanh mốc, không trôi
/// dạt vĩnh viễn).
const List<double> _depthDeltaPct = [0.05, -0.08, 0.03, -0.04];

double _depthMidPriceAtTick(double basePrice, int tick) {
  final deltaPct = _depthDeltaPct[tick % _depthDeltaPct.length];
  return basePrice * (1 + deltaPct / 100);
}

MarketDepthSnapshot _depthSnapshotAtTick(
  MarketPair pair,
  int levels,
  int tick,
) {
  final midPrice = _depthMidPriceAtTick(pair.price, tick);
  final livePair = _withLivePrice(pair, midPrice);
  final depth = _generateDepthData(midPrice, levels);
  final whales = _generateWhaleOrders(midPrice);

  return MarketDepthSnapshot(
    pair: livePair,
    depth: depth,
    whaleOrders: whales,
    availableLevels: _marketDepthLevels,
    marketPairs: _marketPairs,
    watchlist: {
      for (final entry in _marketPairs)
        if (entry.isFavorite) entry.id,
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
      livePair.id: livePair.sparklineData,
    },
    lastUpdatedLabel: 'realtime',
    supportedStates: const {
      MarketScreenState.loading,
      MarketScreenState.empty,
      MarketScreenState.error,
      MarketScreenState.offline,
      MarketScreenState.realtimeRefresh,
    },
  );
}
