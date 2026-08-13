import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_discover.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_filters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_header.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_movers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_pairs.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_tools.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketListPage extends ConsumerStatefulWidget {
  const MarketListPage({super.key, this.shellRenderMode});

  static const contentKey = MarketListKeys.content;
  static const searchKey = MarketListKeys.search;
  static const sortToggleKey = MarketListKeys.sortToggle;

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketListPage> createState() => _MarketListPageState();
}

/// PERF-HN4: query/category/sort/favoriteIds sống ở
/// `marketListStateControllerProvider` (Notifier, một nguồn sự thật) —
/// trang chỉ giữ `TextEditingController` (bắt buộc cho `VitSearchBar`) và
/// `_showSort` (toggle hiển thị bảng sắp xếp — UI ephemeral thuần, không
/// phải state nghiệp vụ nên không cần đưa vào Notifier).
class _MarketListPageState extends ConsumerState<MarketListPage> {
  final _searchController = TextEditingController();
  bool _showSort = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _go(String path) {
    context.go(path);
  }

  void _resetFilters() {
    _searchController.clear();
    ref.read(marketListStateControllerProvider.notifier).resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    // GD4-F3: trang gate qua marketListSnapshotProvider.when() (mục 5+6)
    // trước khi đọc marketListStateControllerProvider — khi `data:` chạy,
    // snapshot async đã resolve nên Notifier không bao giờ trả fallback rỗng.
    final listAsync = ref.watch(marketListSnapshotProvider);
    // `snapshot` giữ nguyên tham chiếu suốt phiên (Notifier chỉ gọi
    // getMarketList() một lần trong build()) nên select này không kích
    // rebuild khi query/category/sort/favoriteIds đổi.
    final snapshot = ref.watch(
      marketListStateControllerProvider.select((state) => state.snapshot),
    );
    final category = ref.watch(
      marketListStateControllerProvider.select((state) => state.category),
    );
    final sort = ref.watch(
      marketListStateControllerProvider.select((state) => state.sort),
    );
    // Chỉ theo dõi phần "có/không có từ khóa" — tránh rebuild toàn trang ở
    // MỖI ký tự gõ vào ô tìm kiếm (chỉ đổi khi qua ranh giới rỗng/không rỗng).
    final searchActive = ref.watch(
      marketListStateControllerProvider.select(
        (state) => state.query.trim().isNotEmpty,
      ),
    );
    final notifier = ref.read(marketListStateControllerProvider.notifier);

    final shellRenderMode = widget.shellRenderMode ?? defaultShellRenderMode();
    final nativeShell = !shellRenderMode.usesVisualQaFrame;
    final bottomChrome = shellRenderMode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomScrollInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (nativeShell
            ? MarketsSpacingTokens.marketNativeBottomExtra
            : MarketsSpacingTokens.marketVisualBottomExtra);
    final showMarketSummary =
        !searchActive && category == snapshot.screenFilters.defaultCategory;

    return VitPageLayout(
      variant: nativeShell ? VitPageVariant.flush : VitPageVariant.defaultPage,
      semanticLabel: 'Thị trường',
      semanticIdentifier: 'SC-008',
      child: Material(
        type: MaterialType.transparency,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            key: MarketListPage.contentKey,
            padding: MarketsSpacingTokens.marketScrollPadding(
              bottomScrollInset,
            ),
            child: VitPageContent(
              rhythm: VitPageRhythm.compact,
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              gap: VitContentGap.tight,
              children: listAsync.when(
                loading: () => const [VitSkeletonList()],
                error: (error, stackTrace) => [
                  VitErrorState(
                    title: 'Không tải được thị trường',
                    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                    actionLabel: 'Thử lại',
                    onAction: () => ref.invalidate(marketListSnapshotProvider),
                  ),
                ],
                data: (_) => [
                  MarketListHeader(
                    onNavigate: _go,
                    lastUpdatedLabel: snapshot.lastUpdatedLabel,
                  ),
                  VitSearchBar(
                    key: MarketListPage.searchKey,
                    controller: _searchController,
                    placeholder: 'Tìm kiếm BTC, ETH...',
                    variant: VitSearchBarVariant.compact,
                    filterActive: _showSort || sort != 'default',
                    filterInline: true,
                    onChanged: notifier.setQuery,
                    onClear: () => notifier.setQuery(''),
                    onFilterTap: () => setState(() => _showSort = !_showSort),
                  ),
                  if (_showSort)
                    MarketListSortSheet(
                      sortOptions: snapshot.screenFilters.sortOptions,
                      activeSort: sort,
                      onSelected: (value) {
                        notifier.setSort(value);
                        setState(() => _showSort = false);
                      },
                    ),
                  MarketListCategoryTabs(
                    categories: snapshot.screenFilters.categories,
                    activeCategory: category,
                    onSelected: notifier.setCategory,
                  ),
                  if (showMarketSummary) ...[
                    MarketListTopMovers(pairs: snapshot.marketPairs),
                    MarketListTools(onNavigate: _go),
                  ],
                  MarketListColumnHeader(
                    lastUpdatedLabel: snapshot.lastUpdatedLabel,
                  ),
                  _MarketListPairsSection(
                    onNavigate: _go,
                    onResetFilters: _resetFilters,
                  ),
                  const MarketListDiscoverMoreSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// PERF-HN4 leaf: chỉ watch `visiblePairs`/`favoriteIds` (và `query` khi
/// rỗng để dựng thông báo trống) — toggle yêu thích hay gõ tìm kiếm chỉ
/// rebuild widget này, không rebuild cả `MarketListPage`.
class _MarketListPairsSection extends ConsumerWidget {
  const _MarketListPairsSection({
    required this.onNavigate,
    required this.onResetFilters,
  });

  final ValueChanged<String> onNavigate;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visiblePairs = ref.watch(
      marketListStateControllerProvider.select((state) => state.visiblePairs),
    );
    final favoriteIds = ref.watch(
      marketListStateControllerProvider.select((state) => state.favoriteIds),
    );
    final notifier = ref.read(marketListStateControllerProvider.notifier);

    if (visiblePairs.isEmpty) {
      final query = ref.watch(
        marketListStateControllerProvider.select((state) => state.query.trim()),
      );
      return VitEmptyState(
        icon: Icons.search_rounded,
        title: query.isNotEmpty
            ? 'Không tìm thấy "$query"'
            : 'Không có kết quả',
        message: 'Thử thay đổi bộ lọc hoặc tìm kiếm từ khóa khác',
        actionLabel: 'Xóa bộ lọc',
        onAction: onResetFilters,
      );
    }

    return MarketListPairList(
      pairs: visiblePairs,
      favoriteIds: favoriteIds,
      onFavoriteToggle: notifier.toggleFavorite,
      onNavigate: onNavigate,
    );
  }
}
