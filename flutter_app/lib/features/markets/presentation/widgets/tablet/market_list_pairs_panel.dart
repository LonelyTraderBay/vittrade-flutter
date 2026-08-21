// Tablet-specific Markets pair panel.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_pairs.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Public port of `market_list_page.dart`'s private `_MarketListPairsSection`
/// (PERF-HN4 leaf: watches only the filtered list/sort/favoriteIds, so
/// toggling a favorite, sorting a column or typing a search query only
/// rebuilds this widget, not the whole page). The tablet panel renders the
/// FULL filtered list (the phone feed keeps its 8-row take) inside one
/// clipped card, headed by the sortable table header.
class MarketListPairsPanel extends ConsumerWidget {
  const MarketListPairsPanel({
    super.key,
    required this.onNavigate,
    required this.onResetFilters,
  });

  final ValueChanged<String> onNavigate;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pairs = ref.watch(
      marketListStateControllerProvider.select((state) => state.filteredPairs),
    );
    final activeSort = ref.watch(
      marketListStateControllerProvider.select((state) => state.sort),
    );
    final favoriteIds = ref.watch(
      marketListStateControllerProvider.select((state) => state.favoriteIds),
    );
    final notifier = ref.read(marketListStateControllerProvider.notifier);

    if (pairs.isEmpty) {
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

    return VitCard(
      clip: true,
      child: Column(
        children: [
          MarketListTableHeader(
            activeSort: activeSort,
            onSortSelected: notifier.setSort,
          ),
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
          ),
          MarketListPairList(
            pairs: pairs,
            favoriteIds: favoriteIds,
            onFavoriteToggle: notifier.toggleFavorite,
            onNavigate: onNavigate,
          ),
        ],
      ),
    );
  }
}
