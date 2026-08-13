// Phone-specific Markets pair panel.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_pairs.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Public port of `market_list_page.dart`'s private `_MarketListPairsSection`
/// (PERF-HN4 leaf: watches only `visiblePairs`/`favoriteIds`, so toggling a
/// favorite or typing a search query only rebuilds this widget, not the
/// whole page) — needed because `MarketsTabletPage` cannot import a private
/// class from `market_list_page.dart`. Straight duplication of already
/// battle-tested logic, not new behavior.
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
