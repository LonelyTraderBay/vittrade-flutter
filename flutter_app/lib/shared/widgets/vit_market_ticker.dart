import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_market_rows.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Data for one card in a [VitMarketTickerStrip]/[VitMarketTickerCard].
class VitMarketTickerData {
  const VitMarketTickerData({
    required this.title,
    required this.price,
    required this.changeLabel,
    required this.trend,
    this.leading,
    this.onTap,
  });

  final String title;
  final String price;
  final String changeLabel;
  final VitTrendDirection trend;
  final Widget? leading;
  final VoidCallback? onTap;
}

/// Horizontally scrolling strip of [VitMarketTickerCard]s built from [items].
class VitMarketTickerStrip extends StatelessWidget {
  const VitMarketTickerStrip({
    super.key,
    required this.items,
    this.cardWidth,
    this.itemGap,
  });

  final List<VitMarketTickerData> items;
  final double? cardWidth;
  final double? itemGap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            VitMarketTickerCard(data: items[index], width: cardWidth),
            if (index < items.length - 1)
              SizedBox(
                width: itemGap ?? SharedSpacingTokens.homeMarketTickerStripGap,
              ),
          ],
        ],
      ),
    );
  }
}

/// Single fixed-width ticker card: title, price, and a trend-tinted change
/// pill for one [VitMarketTickerData] entry.
class VitMarketTickerCard extends StatelessWidget {
  const VitMarketTickerCard({super.key, required this.data, this.width});

  final VitMarketTickerData data;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? SharedSpacingTokens.homeMarketTickerCardWidth,
      child: VitCard(
        onTap: data.onTap,
        borderColor: data.trend.foreground.withValues(alpha: .24),
        padding: AppSurfaceSpacing.cardTilePadding,
        contentAlign: VitCardContentAlign.center,
        constraints: const BoxConstraints(
          minHeight: SharedSpacingTokens.homeMarketTickerCardMinHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (data.leading != null) ...[
                  data.leading!,
                  SizedBox(width: AppSurfaceSpacing.x2),
                ],
                Expanded(
                  child: Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSurfaceSpacing.cardTileInnerGap),
            Text(
              data.price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            SizedBox(height: AppSurfaceSpacing.x1),
            DecoratedBox(
              decoration: ShapeDecoration(
                color: data.trend.background,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSurfaceSpacing.x2,
                  vertical: AppSurfaceSpacing.x1,
                ),
                child: Text(
                  data.changeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: data.trend.foreground,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
