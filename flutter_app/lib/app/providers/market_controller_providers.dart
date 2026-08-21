import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/comparison_tool_common.dart'
    show comparisonToolMaxCompare;

export 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';

final marketControllerProvider = Provider<MarketController>((ref) {
  return MarketController(ref.watch(marketRepositoryProvider));
});

// GD4-F3 (mục 3+4 GD4-Async-Playbook): provider trung gian cho mọi snapshot
// markets — trang/controller `.watch()` một trong các provider dưới đây
// thay vì gọi `marketControllerProvider.getX()` trực tiếp trong `build()`
// (repo giờ trả `Future<T>`). Đọc thuần → FutureProvider forward thẳng,
// KHÔNG thêm async/await thừa (mục 4).

final marketListSnapshotProvider = FutureProvider<MarketListSnapshot>(
  (ref) => ref.watch(marketControllerProvider).getMarketList(),
);

// GD4 Cụm F7 (REALTIME): lớp "cập-nhật-đè" trên `marketListSnapshotProvider`
// — `getMarketList()` (Future) vẫn cấp phần tĩnh (filters/alerts/watchlist/
// chartSeries) và trạng thái loading/error/empty cho trang; 2 provider dưới
// đây chỉ đẩy PHẦN GIÁ SỐNG, không thay thế snapshot Future ở trên.

/// Ticker giá realtime — xem dartdoc [MarketRepository.watchTicker] cho lý
/// do chọn `Stream<List<MarketPair>>` (không phải `MarketListSnapshot`
/// nặng hơn). `.autoDispose`: `watchTicker()` là `Stream.periodic` — timer
/// sống mãi nếu không giải phóng khi không còn trang nào theo dõi.
final marketTickerStreamProvider = StreamProvider.autoDispose<List<MarketPair>>(
  (ref) => ref.watch(marketControllerProvider).watchTicker(),
);

/// Giá sống của MỘT pair, tách khỏi [marketTickerStreamProvider] qua
/// `.select()` — mỗi hàng trong danh sách/thẻ chỉ watch provider này với
/// `id` của chính nó nên chỉ hàng có giá đổi mới rebuild (không rebuild cả
/// danh sách mỗi tick). Trả `null` khi tick đầu tiên chưa tới hoặc pair
/// không có trong ticker — call site tự fallback về giá tĩnh
/// (`snapshot`/`pair.price`). `.autoDispose` để không giữ
/// [marketTickerStreamProvider] sống khi hàng cuối cùng rời màn hình.
final marketPairLivePriceProvider = Provider.autoDispose
    .family<double?, String>((ref, pairId) {
      return ref.watch(
        marketTickerStreamProvider.select((async) {
          final pairs = async.value;
          if (pairs == null) return null;
          for (final pair in pairs) {
            if (pair.id == pairId) return pair.price;
          }
          return null;
        }),
      );
    });

final marketOverviewSnapshotProvider = FutureProvider<MarketOverviewSnapshot>(
  (ref) => ref.watch(marketControllerProvider).getMarketOverview(),
);

final marketMoversSnapshotProvider = FutureProvider<MarketMoversSnapshot>(
  (ref) => ref.watch(marketControllerProvider).getMarketMovers(),
);

final marketSectorsSnapshotProvider = FutureProvider<MarketSectorsSnapshot>(
  (ref) => ref.watch(marketControllerProvider).getMarketSectors(),
);

final marketWatchlistSnapshotProvider = FutureProvider<MarketWatchlistSnapshot>(
  (ref) => ref.watch(marketControllerProvider).getMarketWatchlist(),
);

final marketHeatmapSnapshotProvider = FutureProvider<MarketHeatmapSnapshot>(
  (ref) => ref.watch(marketControllerProvider).getMarketHeatmap(),
);

final marketPriceAlertsSnapshotProvider = FutureProvider<MarketAlertsSnapshot>(
  (ref) => ref.watch(marketControllerProvider).getPriceAlerts(),
);

final marketComparisonSnapshotProvider =
    FutureProvider<MarketComparisonSnapshot>(
      (ref) => ref.watch(marketControllerProvider).getMarketComparison(),
    );

final marketScreenerSnapshotProvider =
    FutureProvider.family<MarketScreenerSnapshot, MarketScreenerQuery>(
      (ref, query) =>
          ref.watch(marketControllerProvider).getMarketScreener(query: query),
    );

final marketCalendarSnapshotProvider =
    FutureProvider.family<MarketCalendarSnapshot, MarketCalendarQuery>(
      (ref, query) =>
          ref.watch(marketControllerProvider).getMarketCalendar(query: query),
    );

final marketDerivativesSnapshotProvider =
    FutureProvider.family<MarketDerivativesSnapshot, MarketDerivativesSort>(
      (ref, sortBy) => ref
          .watch(marketControllerProvider)
          .getMarketDerivatives(sortBy: sortBy),
    );

/// Family key cho `getMarketDepth(pairId:, levels:)`.
typedef MarketDepthQuery = ({String pairId, int levels});

final marketDepthSnapshotProvider =
    FutureProvider.family<MarketDepthSnapshot, MarketDepthQuery>(
      (ref, query) => ref
          .watch(marketControllerProvider)
          .getMarketDepth(pairId: query.pairId, levels: query.levels),
    );

/// GD4 Cụm F7 (REALTIME): lớp "cập-nhật-đè" trên [marketDepthSnapshotProvider]
/// — cùng family key ([MarketDepthQuery]) để trang chọn đúng số levels đang
/// xem. `.autoDispose` vì `watchDepth()` là `Stream.periodic` — timer sống
/// mãi nếu không giải phóng khi rời trang Độ sâu thị trường.
final marketDepthStreamProvider = StreamProvider.autoDispose
    .family<MarketDepthSnapshot, MarketDepthQuery>(
      (ref, query) => ref
          .watch(marketControllerProvider)
          .watchDepth(query.pairId, levels: query.levels),
    );

final marketSocialSentimentSnapshotProvider =
    FutureProvider.family<MarketSocialSentimentSnapshot, MarketSentimentSort>(
      (ref, sortBy) => ref
          .watch(marketControllerProvider)
          .getSocialSentiment(sortBy: sortBy),
    );

final marketPortfolioSnapshotProvider =
    FutureProvider.family<MarketPortfolioSnapshot, MarketPortfolioSort>(
      (ref, sortBy) => ref
          .watch(marketControllerProvider)
          .getPortfolioTracker(sortBy: sortBy),
    );

/// Family key cho `getMarketNews(category:, sentiment:)`.
typedef MarketNewsQuery = ({String category, MarketNewsSentiment? sentiment});

final marketNewsSnapshotProvider =
    FutureProvider.family<MarketNewsSnapshot, MarketNewsQuery>(
      (ref, query) => ref
          .watch(marketControllerProvider)
          .getMarketNews(category: query.category, sentiment: query.sentiment),
    );

/// Family key cho `getAdvancedCharts(indicatorCategory:, drawingCategory:)`.
typedef MarketAdvancedChartsQuery = ({
  String indicatorCategory,
  String drawingCategory,
});

final marketAdvancedChartsSnapshotProvider =
    FutureProvider.family<
      MarketAdvancedChartsSnapshot,
      MarketAdvancedChartsQuery
    >(
      (ref, query) => ref
          .watch(marketControllerProvider)
          .getAdvancedCharts(
            indicatorCategory: query.indicatorCategory,
            drawingCategory: query.drawingCategory,
          ),
    );

/// Family key cho `getTokenUnlocks(sortBy:, impactFilter:)`.
typedef MarketTokenUnlocksQuery = ({
  MarketUnlockSort sortBy,
  MarketUnlockImpact? impactFilter,
});

final marketTokenUnlocksSnapshotProvider =
    FutureProvider.family<MarketTokenUnlocksSnapshot, MarketTokenUnlocksQuery>(
      (ref, query) => ref
          .watch(marketControllerProvider)
          .getTokenUnlocks(
            sortBy: query.sortBy,
            impactFilter: query.impactFilter,
          ),
    );

/// Family key cho `getSocialSignals(statusFilter:, categoryFilter:)`.
typedef MarketSocialSignalsQuery = ({
  TradingSignalStatus? statusFilter,
  TradingSignalCategory? categoryFilter,
});

final marketSocialSignalsSnapshotProvider =
    FutureProvider.family<
      MarketSocialSignalsSnapshot,
      MarketSocialSignalsQuery
    >(
      (ref, query) => ref
          .watch(marketControllerProvider)
          .getSocialSignals(
            statusFilter: query.statusFilter,
            categoryFilter: query.categoryFilter,
          ),
    );

/// Family key cho `getMarketCorrelations(timeframe:, sortOrder:)`.
typedef MarketCorrelationsQuery = ({
  MarketCorrelationTimeframe timeframe,
  CorrelationSortOrder sortOrder,
});

final marketCorrelationsSnapshotProvider =
    FutureProvider.family<MarketCorrelationsSnapshot, MarketCorrelationsQuery>(
      (ref, query) => ref
          .watch(marketControllerProvider)
          .getMarketCorrelations(
            timeframe: query.timeframe,
            sortOrder: query.sortOrder,
          ),
    );

final marketPairDetailSnapshotProvider =
    FutureProvider.family<MarketPairDetailSnapshot, String>(
      (ref, pairId) =>
          ref.watch(marketControllerProvider).getPairDetail(pairId),
    );

final marketTokenInfoSnapshotProvider =
    FutureProvider.family<MarketTokenInfoSnapshot, String>(
      (ref, pairId) => ref.watch(marketControllerProvider).getTokenInfo(pairId),
    );

/// STATE-S23: view-state bất biến của Danh sách theo dõi — entries sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class MarketWatchlistViewState {
  const MarketWatchlistViewState({
    required this.snapshot,
    required this.entries,
  });

  factory MarketWatchlistViewState.fromSnapshot(
    MarketWatchlistSnapshot snapshot,
  ) {
    return MarketWatchlistViewState(
      snapshot: snapshot,
      entries: List.unmodifiable(snapshot.entries),
    );
  }

  final MarketWatchlistSnapshot snapshot;
  final List<MarketWatchlistEntry> entries;

  MarketWatchlistViewState copyWith({List<MarketWatchlistEntry>? entries}) {
    return MarketWatchlistViewState(
      snapshot: snapshot,
      entries: entries == null ? this.entries : List.unmodifiable(entries),
    );
  }
}

/// STATE-S23 (khuôn NotificationsStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — state danh mục
/// giữ nguyên khi điều hướng đi/về trong phiên.
final class MarketWatchlistStateController
    extends Notifier<MarketWatchlistViewState> {
  @override
  MarketWatchlistViewState build() {
    // GD4-F3 (mục 6, biến thể A): seed từ AsyncValue.value + fallback rỗng —
    // trang gate qua marketWatchlistSnapshotProvider.when() trước khi đọc
    // Notifier này nên fallback chỉ chạm tới khi test đọc Notifier trực
    // tiếp trước khi provider async resolve.
    final snapshot =
        ref.watch(marketWatchlistSnapshotProvider).value ??
        _emptyMarketWatchlistSnapshot;
    return MarketWatchlistViewState.fromSnapshot(snapshot);
  }

  void removeEntry(String entryId) {
    state = state.copyWith(
      entries: state.entries
          .where((entry) => entry.id != entryId)
          .toList(growable: false),
    );
  }

  void setNote(String entryId, String? note) {
    state = state.copyWith(
      entries: [
        for (final entry in state.entries)
          if (entry.id == entryId)
            MarketWatchlistEntry(id: entry.id, pairId: entry.pairId, note: note)
          else
            entry,
      ],
    );
  }
}

final marketWatchlistStateControllerProvider =
    NotifierProvider<MarketWatchlistStateController, MarketWatchlistViewState>(
      MarketWatchlistStateController.new,
    );

/// STATE-S23: view-state bất biến của Công cụ so sánh — selectedIds sống ở
/// Notifier (một nguồn sự thật), trang chỉ watch + gọi method.
final class MarketComparisonViewState {
  const MarketComparisonViewState({
    required this.snapshot,
    required this.selectedIds,
  });

  factory MarketComparisonViewState.fromSnapshot(
    MarketComparisonSnapshot snapshot,
  ) {
    return MarketComparisonViewState(
      snapshot: snapshot,
      selectedIds: List.unmodifiable(snapshot.selectedPairIds),
    );
  }

  final MarketComparisonSnapshot snapshot;
  final List<String> selectedIds;

  MarketComparisonViewState copyWith({List<String>? selectedIds}) {
    return MarketComparisonViewState(
      snapshot: snapshot,
      selectedIds: selectedIds == null
          ? this.selectedIds
          : List.unmodifiable(selectedIds),
    );
  }
}

/// STATE-S23 (khuôn MarketWatchlistStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — danh sách token
/// đang so sánh giữ nguyên khi điều hướng đi/về trong phiên.
final class MarketComparisonStateController
    extends Notifier<MarketComparisonViewState> {
  @override
  MarketComparisonViewState build() {
    // GD4-F3 (mục 6, biến thể A): seed từ AsyncValue.value + fallback rỗng.
    final snapshot =
        ref.watch(marketComparisonSnapshotProvider).value ??
        _emptyMarketComparisonSnapshot;
    return MarketComparisonViewState.fromSnapshot(snapshot);
  }

  /// Trả về `true` nếu token được thêm; `false` khi đã đạt giới hạn so sánh
  /// hoặc token đã có trong danh sách (giữ nguyên guard của trang cũ).
  bool addToken(String id) {
    if (state.selectedIds.length >= comparisonToolMaxCompare ||
        state.selectedIds.contains(id)) {
      return false;
    }
    state = state.copyWith(selectedIds: [...state.selectedIds, id]);
    return true;
  }

  void removeToken(String id) {
    if (state.selectedIds.length <= 2) return;
    state = state.copyWith(
      selectedIds: state.selectedIds
          .where((value) => value != id)
          .toList(growable: false),
    );
  }
}

final marketComparisonStateControllerProvider =
    NotifierProvider<
      MarketComparisonStateController,
      MarketComparisonViewState
    >(MarketComparisonStateController.new);

/// STATE-S23: view-state bất biến của Cảnh báo giá — alerts sống ở Notifier
/// (một nguồn sự thật), trang chỉ watch + gọi method.
final class MarketPriceAlertsViewState {
  const MarketPriceAlertsViewState({
    required this.snapshot,
    required this.alerts,
  });

  factory MarketPriceAlertsViewState.fromSnapshot(
    MarketAlertsSnapshot snapshot,
  ) {
    return MarketPriceAlertsViewState(
      snapshot: snapshot,
      alerts: List.unmodifiable(snapshot.priceAlerts),
    );
  }

  final MarketAlertsSnapshot snapshot;
  final List<MarketPriceAlert> alerts;

  MarketPriceAlertsViewState copyWith({List<MarketPriceAlert>? alerts}) {
    return MarketPriceAlertsViewState(
      snapshot: snapshot,
      alerts: alerts == null ? this.alerts : List.unmodifiable(alerts),
    );
  }
}

/// STATE-S23 (khuôn MarketWatchlistStateController): build() seed từ repo,
/// method mutate `state = copyWith(...)`. KHÔNG autoDispose — danh sách cảnh
/// báo giá giữ nguyên khi điều hướng đi/về trong phiên.
final class MarketPriceAlertsStateController
    extends Notifier<MarketPriceAlertsViewState> {
  @override
  MarketPriceAlertsViewState build() {
    // GD4-F3 (mục 6, biến thể A): seed từ AsyncValue.value + fallback rỗng.
    final snapshot =
        ref.watch(marketPriceAlertsSnapshotProvider).value ??
        _emptyMarketAlertsSnapshot;
    return MarketPriceAlertsViewState.fromSnapshot(snapshot);
  }

  void toggleAlert(String id) {
    state = state.copyWith(
      alerts: [
        for (final alert in state.alerts)
          if (alert.id == id)
            MarketPriceAlert(
              id: alert.id,
              pairId: alert.pairId,
              symbol: alert.symbol,
              condition: alert.condition,
              targetPrice: alert.targetPrice,
              currentPrice: alert.currentPrice,
              isActive: !alert.isActive,
              createdAt: alert.createdAt,
              triggeredAt: alert.triggeredAt,
            )
          else
            alert,
      ],
    );
  }

  void deleteAlert(String id) {
    state = state.copyWith(
      alerts: state.alerts
          .where((alert) => alert.id != id)
          .toList(growable: false),
    );
  }
}

final marketPriceAlertsStateControllerProvider =
    NotifierProvider<
      MarketPriceAlertsStateController,
      MarketPriceAlertsViewState
    >(MarketPriceAlertsStateController.new);

/// PERF-HN4: view-state bất biến của Danh sách thị trường (SC-008) —
/// query/category/sort/favoriteIds sống ở Notifier (một nguồn sự thật).
/// `visiblePairs` được lọc + sắp xếp + memoize NGAY khi input đổi (trong
/// `copyWithFilters`), KHÔNG tính lại mỗi lần widget build().
final class MarketListViewState {
  const MarketListViewState({
    required this.snapshot,
    required this.query,
    required this.category,
    required this.sort,
    required this.favoriteIds,
    required this.visiblePairs,
    required this.filteredPairs,
  });

  /// [favoriteIdsOverride] ghi đè yêu thích seed từ `snapshot.watchlist` —
  /// dùng khi đã có watchlist persist trong [KeyValueStore] (GĐ4-F1); `null`
  /// giữ hành vi cũ (seed từ snapshot).
  factory MarketListViewState.fromSnapshot(
    MarketListSnapshot snapshot, {
    Set<String>? favoriteIdsOverride,
  }) {
    return MarketListViewState._recomputed(
      snapshot: snapshot,
      query: '',
      category: snapshot.screenFilters.defaultCategory,
      sort: snapshot.screenFilters.defaultSort,
      favoriteIds: Set<String>.unmodifiable(
        favoriteIdsOverride ?? snapshot.watchlist,
      ),
    );
  }

  final MarketListSnapshot snapshot;
  final String query;
  final String category;
  final String sort;
  final Set<String> favoriteIds;
  final List<MarketPair> visiblePairs;

  /// The same filtered+sorted list [visiblePairs] memoizes, WITHOUT the
  /// phone feed's 8-row take — the Tablet dashboard's primary column is a
  /// scrollable workspace table and shows every matching pair. Phone keeps
  /// reading [visiblePairs]; nothing existing changes behavior.
  final List<MarketPair> filteredPairs;

  static const _visibleLimit = 8;

  static MarketListViewState _recomputed({
    required MarketListSnapshot snapshot,
    required String query,
    required String category,
    required String sort,
    required Set<String> favoriteIds,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    Iterable<MarketPair> list = snapshot.marketPairs;

    if (normalizedQuery.isNotEmpty) {
      list = list.where((pair) {
        return pair.symbol.toLowerCase().contains(normalizedQuery) ||
            pair.baseAsset.toLowerCase().contains(normalizedQuery);
      });
    }
    if (category != snapshot.screenFilters.defaultCategory) {
      list = list.where((pair) => pair.category == category);
    }

    final sorted = list.toList();
    switch (sort) {
      case 'price_desc':
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case 'price_asc':
        sorted.sort((a, b) => a.price.compareTo(a.price));
      case 'change_desc':
        sorted.sort((a, b) => b.change24h.compareTo(a.change24h));
      case 'change_asc':
        sorted.sort((a, b) => a.change24h.compareTo(b.change24h));
      case 'volume_desc':
        sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
      case 'default':
      default:
        break;
    }

    return MarketListViewState(
      snapshot: snapshot,
      query: query,
      category: category,
      sort: sort,
      favoriteIds: favoriteIds,
      filteredPairs: List.unmodifiable(sorted),
      visiblePairs: List.unmodifiable(sorted.take(_visibleLimit)),
    );
  }

  MarketListViewState copyWithFilters({
    String? query,
    String? category,
    String? sort,
    Set<String>? favoriteIds,
  }) {
    return MarketListViewState._recomputed(
      snapshot: snapshot,
      query: query ?? this.query,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

/// PERF-HN4 (khuôn MarketWatchlistStateController): build() seed từ repo,
/// method setQuery/setCategory/setSort/toggleFavorite mutate
/// `state = state.copyWithFilters(...)` — lọc/sắp xếp tính TRONG notifier,
/// không trong build() của widget. KHÔNG autoDispose — trạng thái tìm
/// kiếm/lọc/yêu thích của Danh sách thị trường giữ nguyên khi điều hướng
/// đi/về trong phiên.
final class MarketListStateController extends Notifier<MarketListViewState> {
  @override
  MarketListViewState build() {
    // persist GĐ4-F1: watchlist yêu thích ghi đè seed từ repo nếu đã lưu.
    final storedFavorites = ref
        .read(keyValueStoreProvider)
        .getStringList(KeyValueStoreKeys.marketWatchlistFavorites);
    // GD4-F3 (mục 6, biến thể A): seed từ AsyncValue.value + fallback rỗng —
    // persistence GĐ4-F1 giữ nguyên, chỉ seed snapshot đổi sang async.
    final snapshot =
        ref.watch(marketListSnapshotProvider).value ?? _emptyMarketListSnapshot;
    return MarketListViewState.fromSnapshot(
      snapshot,
      favoriteIdsOverride: storedFavorites == null
          ? null
          : Set<String>.of(storedFavorites),
    );
  }

  void setQuery(String value) {
    if (value == state.query) return;
    state = state.copyWithFilters(query: value);
  }

  void setCategory(String value) {
    if (value == state.category) return;
    state = state.copyWithFilters(category: value);
  }

  void setSort(String value) {
    if (value == state.sort) return;
    state = state.copyWithFilters(sort: value);
  }

  void toggleFavorite(String id) {
    final next = Set<String>.of(state.favoriteIds);
    if (!next.remove(id)) next.add(id);
    state = state.copyWithFilters(favoriteIds: Set.unmodifiable(next));
    // persist GĐ4-F1: ghi lại watchlist yêu thích để giữ qua phiên.
    unawaited(
      ref
          .read(keyValueStoreProvider)
          .setStringList(
            KeyValueStoreKeys.marketWatchlistFavorites,
            next.toList()..sort(),
          ),
    );
  }

  /// Xóa bộ lọc: đưa query/category/sort về mặc định. Giữ nguyên
  /// favoriteIds — khớp hành vi trang cũ (nút "Xóa bộ lọc" không đụng tới
  /// danh sách yêu thích).
  void resetFilters() {
    state = state.copyWithFilters(
      query: '',
      category: state.snapshot.screenFilters.defaultCategory,
      sort: state.snapshot.screenFilters.defaultSort,
    );
  }
}

final marketListStateControllerProvider =
    NotifierProvider<MarketListStateController, MarketListViewState>(
      MarketListStateController.new,
    );

// GD4-F3 (mục 6, biến thể A): fallback rỗng — chỉ chạm tới khi Notifier
// build() chạy trước khi provider async tương ứng resolve lần đầu (test đọc
// Notifier trực tiếp); luồng UI thật luôn gate qua `xSnapshotProvider.when()`
// trước (mục 5) nên `.value` không bao giờ null khi `data:` chạy.
const _emptyMarketScreenFilters = MarketScreenFilters(
  categories: [],
  sortOptions: [],
  defaultCategory: '',
  defaultSort: '',
);

const _emptyMarketListSnapshot = MarketListSnapshot(
  marketPairs: [],
  watchlist: {},
  alerts: [],
  screenFilters: _emptyMarketScreenFilters,
  chartSeries: {},
  lastUpdatedLabel: '',
  supportedStates: {},
);

const _emptyMarketWatchlistSnapshot = MarketWatchlistSnapshot(
  entries: [],
  marketPairs: [],
  watchlist: {},
  alerts: [],
  screenFilters: _emptyMarketScreenFilters,
  chartSeries: {},
  lastUpdatedLabel: '',
  supportedStates: {},
);

const _emptyMarketComparisonSnapshot = MarketComparisonSnapshot(
  marketPairs: [],
  selectedPairIds: [],
  popularPairIds: [],
  metrics: [],
  watchlist: {},
  alerts: [],
  screenFilters: _emptyMarketScreenFilters,
  chartSeries: {},
  lastUpdatedLabel: '',
  supportedStates: {},
);

const _emptyMarketAlertsSnapshot = MarketAlertsSnapshot(
  priceAlerts: [],
  marketPairs: [],
  watchlist: {},
  alerts: [],
  screenFilters: _emptyMarketScreenFilters,
  chartSeries: {},
  lastUpdatedLabel: '',
  supportedStates: {},
);
