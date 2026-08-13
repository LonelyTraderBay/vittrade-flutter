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

const double _marketColumnCompactHeaderHeight = AppSpacing.buttonCompact;
const EdgeInsets _marketPairCompactHeaderPadding =
    MarketsSpacingTokens.marketListPairCompactHeaderPadding;
const EdgeInsets _marketPairCompactRowPadding =
    MarketsSpacingTokens.marketListPairCompactRowPadding;
const double _marketPairCompactGap = AppSpacing.x3;
const double _marketPairCompactMicroGap = AppSpacing.x1;
const double _marketPairCompactSparklineWidth = AppSpacing.x7;
const double _marketPairCompactSparklineHeight = AppSpacing.x5 + AppSpacing.x2;
const double _marketPairCompactPriceColumnWidth = AppSpacing.x7 + AppSpacing.x4;
const double _marketPairCompactPriceGap = AppSpacing.x1;
const double _marketPairCompactFavoriteGap = AppSpacing.x2;
const double _marketPairCompactFavoriteIcon = AppSpacing.iconMd - AppSpacing.x1;
const double _marketPairCompactAvatar = AppSpacing.x6 - AppSpacing.x1;

class MarketListColumnHeader extends StatelessWidget {
  const MarketListColumnHeader({super.key, required this.lastUpdatedLabel});

  final String lastUpdatedLabel;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Cập nhật $lastUpdatedLabel',
      child: SizedBox(
        height: _marketColumnCompactHeaderHeight,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: _marketPairCompactHeaderPadding,
                child: Row(
                  children: [
                    Expanded(
                      flex: 44,
                      child: Text(
                        'Cặp giao dịch',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 36,
                      child: Text(
                        'Giá',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppSpacing.x7 + AppSpacing.x2,
                      child: Text(
                        '24h',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: AppColors.divider,
              height: AppSpacing.dividerHairline,
            ),
          ],
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
          child: Column(
            children: [
              Padding(
                padding: _marketPairCompactRowPadding,
                child: Row(
                  children: [
                    _CoinAvatar(pair: pair),
                    const SizedBox(width: _marketPairCompactGap),
                    Expanded(
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
                          const SizedBox(height: _marketPairCompactMicroGap),
                          Text(
                            'Vol ${marketListFormatVolume(pair.volume24h)}',
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
                    SizedBox(
                      width: _marketPairCompactSparklineWidth,
                      height: _marketPairCompactSparklineHeight,
                      child: VitSparkline(
                        values: pair.sparklineData,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: _marketPairCompactGap),
                    SizedBox(
                      width: _marketPairCompactPriceColumnWidth,
                      child: Text(
                        marketListFormatPrice(displayPrice),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                    const SizedBox(width: _marketPairCompactPriceGap),
                    VitStatusPill(
                      label: marketListFormatPct(pair.change24h),
                      status: positive
                          ? VitStatusPillStatus.success
                          : VitStatusPillStatus.error,
                      size: VitStatusPillSize.sm,
                    ),
                    const SizedBox(width: _marketPairCompactFavoriteGap),
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
                        color: favorite
                            ? marketListArenaAccent
                            : AppColors.text3,
                        size: _marketPairCompactFavoriteIcon,
                        padding: AppSpacing.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: AppColors.divider,
                height: AppSpacing.dividerHairline,
              ),
            ],
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
