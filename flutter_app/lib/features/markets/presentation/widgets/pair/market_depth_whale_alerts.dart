import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketDepthWhaleAlertsView extends StatelessWidget {
  const MarketDepthWhaleAlertsView({required this.snapshot, super.key});

  final MarketDepthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _WhaleWarningCard(),
        SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        const MarketDepthSectionHeader(
          label: 'Lệnh lớn gần đây',
          accentColor: AppColors.warn,
        ),
        SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        for (final order in snapshot.whaleOrders) ...[
          _WhaleOrderCard(order: order, baseAsset: snapshot.pair.baseAsset),
          if (order != snapshot.whaleOrders.last)
            SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        ],
        SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        _WhaleSummary(orders: snapshot.whaleOrders),
      ],
    );
  }
}

class _WhaleWarningCard extends StatelessWidget {
  const _WhaleWarningCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn15,
      padding: MarketsSpacingTokens.marketDepthWhaleCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: MarketsSpacingTokens.marketAdvancedTipIcon,
          ),
          const SizedBox(width: MarketsSpacingTokens.marketHeatmapSummaryGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo cá voi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: MarketsSpacingTokens.marketLineHeightTight,
                  ),
                ),
                const SizedBox(
                  height: MarketsSpacingTokens.marketAnalyticsTinyGap,
                ),
                Text(
                  'Các lệnh lớn bất thường trong sổ lệnh BTC/USDT. Không phải tín hiệu giao dịch, chỉ mang tính tham khảo.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: MarketsSpacingTokens.marketLineHeightReadable,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhaleOrderCard extends StatelessWidget {
  const _WhaleOrderCard({required this.order, required this.baseAsset});

  final MarketWhaleOrder order;
  final String baseAsset;

  @override
  Widget build(BuildContext context) {
    final buy = order.side == MarketOrderSide.buy;
    final color = buy ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: MarketsSpacingTokens.marketDepthWhaleCardPadding,
      child: Row(
        children: [
          Material(
            color: color.withValues(alpha: .1),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.mdRadius,
            ),
            child: const SizedBox.square(
              dimension: MarketsSpacingTokens.marketDepthWhaleIconBox,
              child: Icon(Icons.waves_rounded, color: AppColors.text2),
            ),
          ),
          const SizedBox(width: MarketsSpacingTokens.marketHeatmapSummaryGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    VitAccentPill(
                      label: buy ? 'MUA' : 'BÁN',
                      accentColor: color,
                    ),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketAnalyticsCompactGap,
                    ),
                    Text(
                      order.timeAgo,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: MarketsSpacingTokens.marketLineHeightTight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: MarketsSpacingTokens.marketAnalyticsSmallGap,
                ),
                Text(
                  '${order.quantity.toStringAsFixed(4)} $baseAsset',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: MarketsSpacingTokens.marketLineHeightTight,
                  ),
                ),
                const SizedBox(
                  height: MarketsSpacingTokens.marketAnalyticsTinyGap,
                ),
                Text(
                  '@ \$${formatMarketDepthPrice(order.price)}  ≈ ${formatMarketDepthCompact(order.usdValue, prefix: r'$')}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: MarketsSpacingTokens.marketLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhaleSummary extends StatelessWidget {
  const _WhaleSummary({required this.orders});

  final List<MarketWhaleOrder> orders;

  @override
  Widget build(BuildContext context) {
    final buyOrders = [
      for (final order in orders)
        if (order.side == MarketOrderSide.buy) order,
    ];
    final sellOrders = [
      for (final order in orders)
        if (order.side == MarketOrderSide.sell) order,
    ];
    return Row(
      children: [
        Expanded(
          child: _WhaleSummaryCard(
            count: buyOrders.length,
            label: 'Lệnh mua lớn',
            total: buyOrders.fold<double>(
              0,
              (sum, order) => sum + order.usdValue,
            ),
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketAnalyticsCompactGap),
        Expanded(
          child: _WhaleSummaryCard(
            count: sellOrders.length,
            label: 'Lệnh bán lớn',
            total: sellOrders.fold<double>(
              0,
              (sum, order) => sum + order.usdValue,
            ),
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _WhaleSummaryCard extends StatelessWidget {
  const _WhaleSummaryCard({
    required this.count,
    required this.label,
    required this.total,
    required this.color,
  });

  final int count;
  final String label;
  final double total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: MarketsSpacingTokens.marketDepthWhaleSummaryPadding,
      child: Column(
        children: [
          Text(
            '$count',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: MarketsSpacingTokens.marketLineHeightCaption,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: MarketsSpacingTokens.marketLineHeightTight,
            ),
          ),
          const SizedBox(height: MarketsSpacingTokens.marketAnalyticsTinyGap),
          Text(
            formatMarketDepthCompact(total, prefix: r'$'),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.medium,
              fontFeatures: AppTextStyles.tabularFigures,
              height: MarketsSpacingTokens.marketLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}
