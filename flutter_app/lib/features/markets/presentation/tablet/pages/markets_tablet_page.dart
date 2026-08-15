import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_discover.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_filters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_header.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_movers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_pairs.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_pairs_panel.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_tools.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet composition of Markets (SC-008) — same route, same
/// [marketListSnapshotProvider]/[marketListStateControllerProvider] data and
/// the same public Markets widgets as [MarketListPage], but laid out as a
/// persistent two-column dashboard instead of one scrolling phone column:
/// filter/sort/pair list on the left, market snapshot (top movers, tools,
/// discover) on the right. Does not touch `market_list_page.dart` — reached
/// via `createTabletAppRouter`/surface bootstrap. Third reference implementation for
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md` (see
/// `home_tablet_page.dart`, `wallet_tablet_page.dart` for the first two).
class MarketsTabletPage extends ConsumerStatefulWidget {
  const MarketsTabletPage({super.key});

  @override
  ConsumerState<MarketsTabletPage> createState() => _MarketsTabletPageState();
}

class _MarketsTabletPageState extends ConsumerState<MarketsTabletPage> {
  final _searchController = TextEditingController();
  bool _showSort = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _go(String path) => context.go(path);

  void _resetFilters() {
    _searchController.clear();
    ref.read(marketListStateControllerProvider.notifier).resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(marketListSnapshotProvider);
    final snapshot = ref.watch(
      marketListStateControllerProvider.select((state) => state.snapshot),
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thị trường',
      semanticIdentifier: 'SC-008',
      child: Column(
        children: [
          MarketListHeader(
            onNavigate: _go,
            lastUpdatedLabel: snapshot.lastUpdatedLabel,
          ),
          Expanded(
            child: listAsync.when(
              loading: () =>
                  const SingleChildScrollView(child: VitSkeletonList()),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được thị trường',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(marketListSnapshotProvider),
                ),
              ),
              data: (_) => _buildDashboard(snapshot),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(MarketListSnapshot snapshot) {
    final category = ref.watch(
      marketListStateControllerProvider.select((state) => state.category),
    );
    final sort = ref.watch(
      marketListStateControllerProvider.select((state) => state.sort),
    );
    final notifier = ref.read(marketListStateControllerProvider.notifier);

    final primaryChildren = [
      VitSearchBar(
        key: MarketsTabletKeys.search,
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
      MarketListColumnHeader(lastUpdatedLabel: snapshot.lastUpdatedLabel),
      MarketListPairsPanel(onNavigate: _go, onResetFilters: _resetFilters),
    ];

    // Unlike the phone page, the market-snapshot block (movers + tools)
    // renders unconditionally here — not gated on `showMarketSummary`
    // (`!searchActive && category == defaultCategory`). On phone that gate
    // exists purely to keep one shared scroll short while filtering; once
    // this content lives in an independently-scrolling secondary column
    // (R4), that constraint doesn't apply, and gating it would leave an
    // empty-looking panel whenever the user searches/filters — exactly the
    // "accidental gap" R7 says a secondary panel must not read as. Neither
    // widget's own data depends on the filter: `MarketListTopMovers` already
    // takes the raw `snapshot.marketPairs`, not the filtered list, and
    // `MarketListTools` is static navigation chips.
    final secondaryChildren = [
      MarketListTopMovers(pairs: snapshot.marketPairs),
      VitPageSection(
        label: 'Công cụ thị trường',
        headerVariant: VitSectionHeaderVariant.plain,
        innerGap: AppSpacing.pageRhythmCompactInnerGap,
        children: [MarketListTools(onNavigate: _go, tablet: true)],
      ),
      const MarketListDiscoverMoreSection(),
    ];

    return VitTwoColumnTabletDashboard(
      primaryChildren: primaryChildren,
      secondaryChildren: secondaryChildren,
      primaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
      secondaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
    );
  }
}
