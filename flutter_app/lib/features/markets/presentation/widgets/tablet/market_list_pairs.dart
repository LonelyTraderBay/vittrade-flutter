import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

/// Tablet pair table — a dense multi-column workspace replacing the phone
/// pair row's 4-cluster layout: star, coin, live price, 24h%, 24h high/low,
/// 24h volume, market cap and sparkline all get their own scan column, and
/// the price/24h%/volume headers sort the list by tapping (mapping onto the
/// `MarketSortOption` ids the state controller already owns). Every data
/// column is an `Expanded` flex cell so the table reflows — never overflows
/// — from the single-column fallback width up to the capped primary column.
const EdgeInsets _marketPairCompactHeaderPadding =
    MarketsSpacingTokens.marketListPairCompactHeaderPadding;
const EdgeInsets _marketPairCompactRowPadding =
    MarketsSpacingTokens.marketListPairCompactRowPadding;
const double _marketPairCompactGap = AppSpacing.x3;
const double _marketPairCompactMicroGap = AppSpacing.x1;
const double _marketPairCompactSparklineWidth = AppSpacing.x7;
const double _marketPairCompactSparklineHeight = AppSpacing.x5 + AppSpacing.x2;
const double _marketPairCompactFavoriteGap = AppSpacing.x2;
const double _marketPairCompactFavoriteIcon = AppSpacing.iconMd - AppSpacing.x1;
const double _marketPairCompactAvatar = AppSpacing.x6 - AppSpacing.x1;
const double _marketColumnCompactHeaderHeight = AppSpacing.buttonCompact;

/// Sort column ids → the state controller's sort values (`MarketSortOption`
/// ids). `volume` has no ascending option in the shared sort set, so its
/// cycle is default → desc → default.
const _sortCycle = <String, List<String>>{
  'price': ['price_desc', 'price_asc'],
  'change': ['change_desc', 'change_asc'],
  'volume': ['volume_desc'],
};

/// Next sort value when the user taps the column header [columnId] while
/// [activeSort] is current. Tapping an inactive column starts at that
/// column's first step; tapping through the cycle's end falls back to
/// `'default'`.
String nextSortForColumn(String columnId, String activeSort) {
  final cycle = _sortCycle[columnId] ?? const <String>[];
  if (cycle.isEmpty) return activeSort;
  if (!cycle.contains(activeSort)) return cycle.first;
  final index = cycle.indexOf(activeSort);
  return index + 1 < cycle.length ? cycle[index + 1] : 'default';
}

class MarketListTableHeader extends StatelessWidget {
  const MarketListTableHeader({
    super.key,
    required this.activeSort,
    required this.onSortSelected,
  });

  final String activeSort;
  final ValueChanged<String> onSortSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _marketColumnCompactHeaderHeight,
      child: Padding(
        padding: _marketPairCompactHeaderPadding,
        child: Row(
          children: [
            const SizedBox(width: _marketPairCompactFavoriteIcon),
            const SizedBox(width: _marketPairCompactFavoriteGap),
            Expanded(
              flex: 5,
              child: Text('Cặp giao dịch', style: _headerStyle),
            ),
            Expanded(
              flex: 4,
              child: _SortHeaderCell(
                columnId: 'price',
                label: 'Giá',
                activeSort: activeSort,
                onSortSelected: onSortSelected,
              ),
            ),
            Expanded(
              flex: 3,
              child: _SortHeaderCell(
                columnId: 'change',
                label: '24h',
                activeSort: activeSort,
                onSortSelected: onSortSelected,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                'Cao / Thấp 24h',
                textAlign: TextAlign.end,
                style: _headerStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: _SortHeaderCell(
                columnId: 'volume',
                label: 'KL 24h',
                activeSort: activeSort,
                onSortSelected: onSortSelected,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Vốn hóa',
                textAlign: TextAlign.end,
                style: _headerStyle,
              ),
            ),
            const SizedBox(width: _marketPairCompactSparklineWidth),
          ],
        ),
      ),
    );
  }
}

TextStyle get _headerStyle =>
    AppTextStyles.micro.copyWith(color: AppColors.text3);

class _SortHeaderCell extends StatelessWidget {
  const _SortHeaderCell({
    required this.columnId,
    required this.label,
    required this.activeSort,
    required this.onSortSelected,
  });

  final String columnId;
  final String label;
  final String activeSort;
  final ValueChanged<String> onSortSelected;

  @override
  Widget build(BuildContext context) {
    final cycle = _sortCycle[columnId] ?? const <String>[];
    final active = cycle.contains(activeSort);
    final ascending = active && activeSort.endsWith('_asc');
    return Semantics(
      button: true,
      label: 'Sắp xếp theo $label',
      child: Tooltip(
        message: 'Sắp xếp theo $label',
        child: InkWell(
          key: MarketsTabletKeys.sortColumn(columnId),
          onTap: () => onSortSelected(nextSortForColumn(columnId, activeSort)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(
                    color: active ? AppColors.text1 : AppColors.text3,
                    fontWeight: active ? AppTextStyles.bold : null,
                  ),
                ),
              ),
              Icon(
                active
                    ? (ascending
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded)
                    : Icons.unfold_more_rounded,
                size: AppSpacing.iconSm,
                color: active ? AppColors.text1 : AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MarketListPairList extends StatelessWidget {
  const MarketListPairList({
    super.key,
    required this.pairs,
    required this.favoriteIds,
    required this.onFavoriteToggle,
    required this.onNavigate,
  });

  final List<MarketPair> pairs;
  final Set<String> favoriteIds;
  final ValueChanged<String> onFavoriteToggle;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pair in pairs)
          _MarketPairRow(
            key: MarketsTabletKeys.pair(pair.id),
            pair: pair,
            favorite: favoriteIds.contains(pair.id),
            onFavoriteToggle: () => onFavoriteToggle(pair.id),
            onTap: () => onNavigate('/pair/${pair.id}'),
          ),
      ],
    );
  }
}

class _MarketPairRow extends ConsumerWidget {
  const _MarketPairRow({
    super.key,
    required this.pair,
    required this.favorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final MarketPair pair;
  final bool favorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // GD4 Cụm F7 (REALTIME): `.select()` theo đúng `pair.id` — chỉ HÀNG
    // NÀY rebuild khi giá của chính nó đổi (không rebuild cả danh sách mỗi
    // tick). `null` (chưa có tick nào / pair ngoài ticker) fallback về giá
    // tĩnh từ snapshot Future.
    final livePrice = ref.watch(marketPairLivePriceProvider(pair.id));
    final displayPrice = livePrice ?? pair.price;
    final positive = pair.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;

    return RepaintBoundary(
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: _marketPairCompactRowPadding,
            child: Row(
              children: [
                Tooltip(
                  message: favorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích',
                  child: VitInlineIconAction(
                    icon: favorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    tooltip: favorite
                        ? 'Bỏ yêu thích ${pair.baseAsset}'
                        : 'Thêm vào yêu thích ${pair.baseAsset}',
                    onPressed: onFavoriteToggle,
                    color: favorite ? marketListArenaAccent : AppColors.text3,
                    size: _marketPairCompactFavoriteIcon,
                    padding: AppSpacing.zero,
                  ),
                ),
                const SizedBox(width: _marketPairCompactFavoriteGap),
                _CoinAvatar(pair: pair),
                const SizedBox(width: _marketPairCompactGap),
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
                const SizedBox(width: _marketPairCompactGap),
                Expanded(
                  flex: 3,
                  child: VitStatusPill(
                    label: marketListFormatPct(pair.change24h),
                    status: positive
                        ? VitStatusPillStatus.success
                        : VitStatusPillStatus.error,
                    size: VitStatusPillSize.sm,
                  ),
                ),
                const SizedBox(width: _marketPairCompactGap),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        marketListFormatPrice(pair.high24h),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.badge.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(height: _marketPairCompactMicroGap),
                      Text(
                        marketListFormatPrice(pair.low24h),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.badge.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: _marketPairCompactGap),
                Expanded(
                  flex: 3,
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
                const SizedBox(width: _marketPairCompactGap),
                Expanded(
                  flex: 3,
                  child: Text(
                    marketListFormatMarketCap(pair.marketCap),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: _marketPairCompactGap),
                SizedBox(
                  width: _marketPairCompactSparklineWidth,
                  height: _marketPairCompactSparklineHeight,
                  child: VitSparkline(values: pair.sparklineData, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: pair.baseAsset,
      accentColor: AppAssetColors.forSymbol(pair.baseAsset),
      size: _marketPairCompactAvatar,
      radius: AppRadii.pillRadius,
      border: true,
    );
  }
}
