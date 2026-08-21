import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Full-width ticker banner spanning both dashboard columns (SC-048 tablet,
/// banner slot of `VitTwoColumnTabletDashboard`). Promotes the order form's
/// instrument hero into a fixed one-line strip — symbol + sparkline, live
/// price + 24h delta + high/low/volume (via [VitTradeHeaderMetricsRow]), and
/// the available balance for the active side — so the primary column below
/// starts directly at product tabs + the order form, while the price facts
/// stay visible regardless of either column's scroll offset. The order-entry
/// backbone itself (form + risk panel) keeps its column grouping untouched.
class TradeTickerStrip extends StatelessWidget {
  const TradeTickerStrip({
    super.key,
    required this.symbol,
    required this.priceLabel,
    required this.changePct,
    required this.highLabel,
    required this.lowLabel,
    required this.volumeLabel,
    required this.sparklineValues,
    required this.availableBalanceLabel,
  });

  final String symbol;
  final String priceLabel;
  final double changePct;
  final String highLabel;
  final String lowLabel;
  final String volumeLabel;
  final List<double> sparklineValues;
  final String availableBalanceLabel;

  @override
  Widget build(BuildContext context) {
    final positive = changePct >= 0;
    final trendColor = positive ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: TradeTabletKeys.tickerStrip,
      radius: VitCardRadius.standard,
      clip: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          symbol,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Thị trường Spot',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  SizedBox(
                    width: AppSpacing.x7,
                    height: SharedSpacingTokens.homeSparklineHeight,
                    child: VitSparkline(
                      values: sparklineValues,
                      color: trendColor,
                    ),
                  ),
                ],
              ),
            ),
            const _TickerDivider(),
            Expanded(
              flex: 6,
              child: Center(
                child: VitTradeHeaderMetricsRow(
                  priceLabel: priceLabel,
                  changePct: changePct,
                  highLabel: highLabel,
                  lowLabel: lowLabel,
                  volumeLabel: volumeLabel,
                ),
              ),
            ),
            const _TickerDivider(),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Số dư khả dụng',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    availableBalanceLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TickerDivider extends StatelessWidget {
  const _TickerDivider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      thickness: AppSpacing.dividerHairline,
      width: AppSpacing.x3 * 2 + AppSpacing.dividerHairline,
      color: AppColors.divider,
    );
  }
}
