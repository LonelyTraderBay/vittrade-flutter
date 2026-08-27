import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_input_states.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_filters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

/// Chiếc chip watchlist đứng trước mọi chip danh mục trong master list —
/// Watchlist-first: người dùng quay lại terminal để xem lại cặp đã lưu.
const _watchlistCategoryLabel = 'Yêu thích';

const double _masterFavoriteIcon = AppSpacing.iconMd - AppSpacing.x1;
const double _masterFavoriteGap = AppSpacing.x2;
const double _masterAvatar = AppSpacing.x6 - AppSpacing.x1;
const double _masterColumnGap = AppSpacing.x2;
const double _masterHeaderHeight = AppSpacing.buttonCompact;
const EdgeInsets _masterHeaderPadding =
    MarketsSpacingTokens.marketListPairCompactHeaderPadding;
const EdgeInsets _masterRowPadding =
    MarketsSpacingTokens.marketListPairCompactRowPadding;
const EdgeInsets _masterBodyPadding =
    MarketsSpacingTokens.marketListFilterCompactPadding;

/// Cột master của Markets terminal tablet (SC-008): search + chips danh mục
/// (chip «Yêu thích» đứng đầu, Watchlist-first) + hàng header sort 3 cột +
/// danh sách cặp compact. Đây là cách duy nhất để đi tới một cặp — bấm hàng
/// mở `/pair/:id` vào detail pane bên phải; hàng đang active được suy từ
/// route (`selectedPairId`), không giữ state cục bộ. Watchlist-mode là UI
/// filter thuần (bộ lọc theo `favoriteIds` có sẵn của state controller) —
/// không đụng tới `category`/`sort` của controller.
///
/// Khung master full-height là idiom cột cố định cuộn độc lập (R4) — khi
/// watchlist chỉ có vài cặp, phần khung còn trống được lấp bằng hint dẫn về
/// danh sách đầy đủ (cùng idiom empty-state 0-cặp) thay vì dead space.
class MarketsMasterList extends ConsumerStatefulWidget {
  const MarketsMasterList({
    super.key,
    required this.selectedPairId,
    required this.onNavigate,
    this.onRefresh,
  });

  final String? selectedPairId;
  final ValueChanged<String> onNavigate;
  final RefreshCallback? onRefresh;

  @override
  ConsumerState<MarketsMasterList> createState() => _MarketsMasterListState();
}

class _MarketsMasterListState extends ConsumerState<MarketsMasterList> {
  /// Mặc định vào thẳng watchlist (Watchlist-first). Khi rỗng, empty state
  /// hướng dẫn bấm sao trong tab khác — không tự thần bí chuyển tab.
  bool _watchlistMode = true;

  /// Ngưỡng "danh sách ngắn": không đủ cặp để lấp nổi khung master
  /// (~5 hàng compact) thì hiện hint dẫn về danh sách đầy đủ.
  static const int _shortListMaxPairs = 5;

  @override
  Widget build(BuildContext context) {
    final pairs = ref.watch(
      marketListStateControllerProvider.select((state) => state.filteredPairs),
    );
    final favoriteIds = ref.watch(
      marketListStateControllerProvider.select((state) => state.favoriteIds),
    );
    final activeSort = ref.watch(
      marketListStateControllerProvider.select((state) => state.sort),
    );
    final category = ref.watch(
      marketListStateControllerProvider.select((state) => state.category),
    );
    final defaultSort = ref.watch(
      marketListStateControllerProvider.select(
        (state) => state.snapshot.screenFilters.defaultSort,
      ),
    );
    final categories = ref.watch(
      marketListStateControllerProvider.select(
        (state) => state.snapshot.screenFilters.categories,
      ),
    );
    final notifier = ref.read(marketListStateControllerProvider.notifier);

    final shown = _watchlistMode
        ? pairs.where((pair) => favoriteIds.contains(pair.id)).toList()
        : pairs;

    // Watchlist ngắn không lấp nổi khung full-height → mục cuối của danh
    // sách là hint dẫn về danh sách đầy đủ (dead space thành hành động).
    final showShortHint =
        _watchlistMode &&
        shown.isNotEmpty &&
        shown.length <= _shortListMaxPairs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: _masterBodyPadding,
          child: VitSearchBar(
            key: MarketsTabletKeys.search,
            placeholder: 'Tìm kiếm BTC, ETH...',
            variant: VitSearchBarVariant.compact,
            filterActive: activeSort != defaultSort,
            filterInline: true,
            onChanged: notifier.setQuery,
            onClear: () => notifier.setQuery(''),
            onFilterTap: () => notifier.resetFilters(),
          ),
        ),
        Padding(
          padding: _masterBodyPadding.copyWith(top: AppSpacing.zero),
          child: MarketListCategoryTabs(
            categories: [_watchlistCategoryLabel, ...categories],
            activeCategory: _watchlistMode ? _watchlistCategoryLabel : category,
            onSelected: (value) {
              if (value == _watchlistCategoryLabel) {
                setState(() => _watchlistMode = true);
                return;
              }
              setState(() => _watchlistMode = false);
              notifier.setCategory(value);
            },
          ),
        ),
        Expanded(
          child: _watchlistMode && shown.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: VitEmptyState(
                      key: MarketsTabletKeys.watchlistEmpty,
                      icon: Icons.star_border_rounded,
                      title: 'Chưa có cặp yêu thích',
                      message:
                          'Bấm biểu tượng sao ở một cặp trong tab khác để lưu vào đây.',
                      actionLabel: 'Xem tất cả cặp',
                      onAction: () => setState(() => _watchlistMode = false),
                    ),
                  ),
                )
              : _wrapRefresh(
                  ListView.builder(
                    physics: widget.onRefresh == null
                        ? const ClampingScrollPhysics()
                        : const AlwaysScrollableScrollPhysics(),
                    // Hàng 0 là cụm sort header + divider — cuộn cùng danh
                    // sách để cột master không bao giờ tràn phần cố định ở
                    // khung tablet hẹp (narrow fallback flex share ~300px).
                    itemCount: shown.length + 1 + (showShortHint ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _MasterSortHeader(
                              activeSort: activeSort,
                              onSortSelected: notifier.setSort,
                            ),
                            const Divider(
                              color: AppColors.divider,
                              height: AppSpacing.dividerHairline,
                              thickness: AppSpacing.dividerHairline,
                            ),
                          ],
                        );
                      }
                      final itemIndex = index - 1;
                      if (itemIndex == shown.length) {
                        return _ShortWatchlistHint(
                          count: shown.length,
                          onShowAll: () =>
                              setState(() => _watchlistMode = false),
                        );
                      }
                      final pair = shown[itemIndex];
                      return _MasterPairRow(
                        key: MarketsTabletKeys.pair(pair.id),
                        pair: pair,
                        favorite: favoriteIds.contains(pair.id),
                        selected: pair.id == widget.selectedPairId,
                        onFavoriteToggle: () =>
                            notifier.toggleFavorite(pair.id),
                        onTap: () => widget.onNavigate('/pair/${pair.id}'),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _wrapRefresh(Widget child) {
    final onRefresh = widget.onRefresh;
    if (onRefresh == null) return child;
    return RefreshIndicator(onRefresh: onRefresh, child: child);
  }
}

class _MasterSortHeader extends StatelessWidget {
  const _MasterSortHeader({
    required this.activeSort,
    required this.onSortSelected,
  });

  final String activeSort;
  final ValueChanged<String> onSortSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _masterHeaderHeight,
      child: Padding(
        padding: _masterHeaderPadding,
        child: Row(
          children: [
            const SizedBox(width: _masterFavoriteIcon),
            const SizedBox(width: _masterFavoriteGap),
            Expanded(
              flex: 5,
              child: Text('Cặp giao dịch', style: _masterHeaderStyle),
            ),
            Expanded(
              flex: 4,
              child: MarketListSortHeaderCell(
                columnId: 'price',
                label: 'Giá',
                activeSort: activeSort,
                onSortSelected: onSortSelected,
              ),
            ),
            Expanded(
              flex: 3,
              child: MarketListSortHeaderCell(
                columnId: 'change',
                label: '24h',
                activeSort: activeSort,
                onSortSelected: onSortSelected,
              ),
            ),
            Expanded(
              flex: 4,
              child: MarketListSortHeaderCell(
                columnId: 'volume',
                label: 'KL 24h',
                activeSort: activeSort,
                onSortSelected: onSortSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _masterHeaderStyle = AppTextStyles.micro.copyWith(color: AppColors.text3);

/// Lấp phần khung master còn trống khi Yêu thích chỉ có vài cặp: cùng idiom
/// empty-state (0 cặp) nhưng dành cho danh sách NGẮN — hint mờ + CTA về
/// danh sách đầy đủ, biến dead space thành hướng dẫn hành động thay vì
/// để khung viền full-height trống trơn.
class _ShortWatchlistHint extends StatelessWidget {
  const _ShortWatchlistHint({required this.count, required this.onShowAll});

  final int count;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x5),
      child: VitEmptyState(
        key: MarketsTabletKeys.watchlistShortHint,
        icon: Icons.star_border_rounded,
        title: 'Chỉ có $count cặp trong Yêu thích',
        message:
            'Bấm biểu tượng sao ở một cặp trong tab khác để lưu thêm vào đây.',
        actionLabel: 'Xem tất cả cặp',
        onAction: onShowAll,
        density: VitDensity.compact,
      ),
    );
  }
}

class _MasterPairRow extends ConsumerWidget {
  const _MasterPairRow({
    super.key,
    required this.pair,
    required this.favorite,
    required this.selected,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final MarketPair pair;
  final bool favorite;
  final bool selected;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // GD4 Cụm F7 (REALTIME): `.select()` theo đúng `pair.id` — chỉ HÀNG NÀY
    // rebuild khi giá của chính nó đổi. `null` (chưa có tick) fallback về
    // giá tĩnh từ snapshot.
    final livePrice = ref.watch(marketPairLivePriceProvider(pair.id));
    final displayPrice = livePrice ?? pair.price;

    return RepaintBoundary(
      child: Material(
        color: selected
            ? marketListPrimary.withValues(alpha: .08)
            : AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: AppInputStates.hoverOverlay,
          focusColor: AppInputStates.focusOverlay,
          child: Padding(
            padding: _masterRowPadding,
            child: Row(
              children: [
                VitInlineIconAction(
                  icon: favorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  tooltip: favorite
                      ? 'Bỏ yêu thích ${pair.baseAsset}'
                      : 'Thêm vào yêu thích ${pair.baseAsset}',
                  onPressed: onFavoriteToggle,
                  color: favorite ? marketListArenaAccent : AppColors.text3,
                  size: _masterFavoriteIcon,
                  padding: AppSpacing.zero,
                ),
                const SizedBox(width: _masterFavoriteGap),
                VitAssetAvatar(
                  label: pair.baseAsset,
                  accentColor: AppAssetColors.forSymbol(pair.baseAsset),
                  size: _masterAvatar,
                  radius: AppRadii.pillRadius,
                  border: true,
                ),
                const SizedBox(width: _masterColumnGap),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pair.baseAsset,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '/${pair.quoteAsset}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.badge.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    marketListFormatPrice(displayPrice),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: _masterColumnGap),
                Expanded(
                  flex: 3,
                  child: Text(
                    marketListFormatPct(pair.change24h),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.badge.copyWith(
                      color: pair.change24h >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: _masterColumnGap),
                Expanded(
                  flex: 4,
                  child: Text(
                    marketListFormatVolume(pair.volume24h),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
