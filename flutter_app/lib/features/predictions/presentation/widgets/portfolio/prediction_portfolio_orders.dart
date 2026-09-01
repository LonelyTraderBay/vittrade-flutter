import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/portfolio/prediction_portfolio_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

class PredictionPortfolioOpenOrdersSection extends StatelessWidget {
  const PredictionPortfolioOpenOrdersSection({
    required this.snapshot,
    required this.orders,
    required this.onCancel,
    super.key,
  });

  final PredictionPortfolioSnapshot snapshot;
  final List<PredictionPortfolioOrderDraft> orders;
  final ValueChanged<String> onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          title: 'Open Orders',
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            Expanded(
              child: Text(
                'Pending limit orders awaiting fill',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '${orders.length}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          clip: true,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < orders.length; index += 1) ...[
                _OrderRow(
                  key: predictionPortfolioOpenOrderKey(orders[index].id),
                  order: orders[index],
                  event: snapshot.eventFor(orders[index].eventId),
                  onCancel: () => onCancel(orders[index].id),
                ),
                if (index != orders.length - 1)
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    thickness: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.order,
    required this.event,
    required this.onCancel,
    super.key,
  });

  final PredictionPortfolioOrderDraft order;
  final PredictionEventDraft event;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isBuy = order.side == 'buy';
    final color = isBuy ? AppColors.buy : AppColors.sell;
    final fillPct = order.shares == 0 ? 0.0 : (order.filled / order.shares);

    return InkWell(
      onTap: () =>
          context.go(AppRoutePaths.marketsPredictionReceipt(order.receiptId)),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension:
                  PredictionsSpacingTokens.predictionPortfolioOrderIconBox,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color.withValues(alpha: .12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                ),
                child: Icon(
                  Icons.attach_money_rounded,
                  color: color,
                  size: PredictionsSpacingTokens.predictionPortfolioOrderIcon,
                ),
              ),
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionPortfolioOrderGap,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(
                    height: PredictionsSpacingTokens
                        .predictionPortfolioOrderTitleGap,
                  ),
                  Wrap(
                    spacing:
                        PredictionsSpacingTokens.predictionPortfolioChipGap,
                    runSpacing:
                        PredictionsSpacingTokens.predictionPortfolioChipRunGap,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      VitAccentPill(
                        label: '${order.side.toUpperCase()} ${order.outcome}',
                        accentColor: color,
                      ),
                      Text(
                        '${formatPredictionPortfolioShares(order.shares)} @ '
                        '\$${order.price.toStringAsFixed(2)}',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text2,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      Text(
                        'Filled: ${(fillPct * 100).round()}%',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: PredictionsSpacingTokens
                        .predictionPortfolioOrderProgressGap,
                  ),
                  ClipRRect(
                    borderRadius: AppRadii.pillRadius,
                    child: SizedBox(
                      height: PredictionsSpacingTokens
                          .predictionPortfolioOrderProgressHeight,
                      child: LinearProgressIndicator(
                        value: fillPct,
                        backgroundColor: AppColors.surface3,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width:
                  PredictionsSpacingTokens.predictionPortfolioOrderTrailingGap,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size:
                      PredictionsSpacingTokens.predictionPortfolioOrderChevron,
                ),
                const SizedBox(
                  height: PredictionsSpacingTokens
                      .predictionPortfolioOrderCancelGap,
                ),
                // card-tile: allow-start — fixed surface, not horizontal strip tile
                VitCard(
                  key: predictionPortfolioCancelOrderKey(order.id),
                  onTap: onCancel,
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.standard,
                  borderColor: AppColors.sell20,
                  background: const ColoredBox(color: AppColors.sell10),
                  clip: true,
                  height: PredictionsSpacingTokens
                      .predictionPortfolioOrderCancelHeight,
                  padding: PredictionsSpacingTokens
                      .predictionPortfolioOrderCancelPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.close_rounded,
                        color: AppColors.sell,
                        size: PredictionsSpacingTokens
                            .predictionPortfolioOrderCancelIcon,
                      ),
                      const SizedBox(
                        width: PredictionsSpacingTokens
                            .predictionPortfolioOrderCancelIconGap,
                      ),
                      Text(
                        'Cancel',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
