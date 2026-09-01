import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

const marketDepthPrimary = AppColors.primary;

const marketDepthContentKey = Key('sc019_market_depth_scroll_content');
const marketDepthChartTabKey = Key('sc019_tab_depth_chart');
const marketDepthOrderBookTabKey = Key('sc019_tab_order_book');
const marketDepthWhaleAlertTabKey = Key('sc019_tab_whale_alert');

Key marketDepthLevelKey(int level) => Key('sc019_depth_level_$level');

class MarketDepthPairSummary extends StatelessWidget {
  const MarketDepthPairSummary({required this.pair, super.key});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    return VitCard(
      padding: MarketsSpacingTokens.marketDepthPairSummaryPadding,
      child: Row(
        children: [
          Material(
            color: AppAssetColors.forSymbol(
              pair.baseAsset,
            ).withValues(alpha: .16),
            shape: const CircleBorder(),
            child: SizedBox.square(
              dimension: MarketsSpacingTokens.marketDepthAvatar,
              child: Center(
                child: Text(
                  pair.baseAsset.substring(0, 2),
                  style: AppTextStyles.caption.copyWith(
                    color: AppAssetColors.forSymbol(pair.baseAsset),
                    fontWeight: AppTextStyles.bold,
                    height: MarketsSpacingTokens.marketLineHeightTight,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: MarketsSpacingTokens.marketHeatmapSummaryGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair.symbol,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: MarketsSpacingTokens.marketLineHeightCaption,
                  ),
                ),
                const SizedBox(
                  height: MarketsSpacingTokens.marketAnalyticsTinyGap,
                ),
                Row(
                  children: [
                    Icon(
                      positive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: MarketsSpacingTokens.marketDepthTrendIcon,
                      color: positive ? AppColors.buy : AppColors.sell,
                    ),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketAnalyticsTinyGap,
                    ),
                    Text(
                      '${positive ? '+' : ''}${pair.change24h.toStringAsFixed(2)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: positive ? AppColors.buy : AppColors.sell,
                        fontWeight: AppTextStyles.medium,
                        height: MarketsSpacingTokens.marketLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: Text(
              '\$${formatMarketDepthPrice(pair.price)}',
              style: AppTextStyles.sectionTitle.copyWith(
                fontFeatures: AppTextStyles.tabularFigures,
                height: MarketsSpacingTokens.marketLineHeightCaption,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class MarketDepthSectionHeader extends StatelessWidget {
  const MarketDepthSectionHeader({
    required this.label,
    required this.accentColor,
    super.key,
  });

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      bottomGap: AppSurfaceSpacing.pageRhythmStandardInnerGap,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: accentColor,
    );
  }
}

String formatMarketDepthPrice(double value) {
  final fixed = value >= 1000
      ? value.toStringAsFixed(2)
      : value.toStringAsFixed(4);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    final fromEnd = whole.length - index;
    buffer.write(whole[index]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String formatMarketDepthQuantity(double value) {
  if (value >= 100) return value.toStringAsFixed(0);
  if (value >= 10) return value.toStringAsFixed(2);
  return value.toStringAsFixed(3);
}

String formatMarketDepthCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000000) {
    return '$prefix${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (abs >= 1000000) return '$prefix${(value / 1000000).toStringAsFixed(2)}M';
  if (abs >= 1000) return '$prefix${(value / 1000).toStringAsFixed(2)}K';
  return '$prefix${value.toStringAsFixed(2)}';
}
