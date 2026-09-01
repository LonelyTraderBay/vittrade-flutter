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

class PredictionPortfolioPositionsList extends StatelessWidget {
  const PredictionPortfolioPositionsList({
    required this.snapshot,
    required this.positions,
    this.emptyTitle = 'No active positions',
    this.emptySubtitle = 'Start trading to build your portfolio',
    super.key,
  });

  final PredictionPortfolioSnapshot snapshot;
  final List<PredictionPortfolioPositionDraft> positions;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return VitEmptyState(
        icon: Icons.work_outline_rounded,
        title: emptyTitle,
        message: emptySubtitle,
      );
    }

    return VitCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < positions.length; index += 1) ...[
            _PositionRow(
              key: predictionPortfolioPositionKey(positions[index].id),
              position: positions[index],
              event: snapshot.eventFor(positions[index].eventId),
            ),
            if (index != positions.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _PositionRow extends StatelessWidget {
  const _PositionRow({required this.position, required this.event, super.key});

  final PredictionPortfolioPositionDraft position;
  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final isOpen = position.status == PredictionPortfolioPositionStatus.open;
    final isWon = position.status == PredictionPortfolioPositionStatus.won;
    final statusColor = isWon
        ? AppColors.buy
        : isOpen
        ? AppColors.warn
        : AppColors.sell;
    final statusLabel = isWon
        ? 'Won'
        : isOpen
        ? 'Open'
        : 'Lost';
    final outcomeColor = position.outcome == 'No'
        ? AppColors.sell
        : AppColors.buy;
    final pnlColor = position.pnl >= 0 ? AppColors.buy : AppColors.sell;

    return InkWell(
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width:
                  PredictionsSpacingTokens.predictionPortfolioPositionIconBox,
              height:
                  PredictionsSpacingTokens.predictionPortfolioPositionIconBox,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: statusColor.withValues(alpha: .12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                ),
                child: Icon(
                  isWon
                      ? Icons.check_circle_outline_rounded
                      : isOpen
                      ? Icons.schedule_rounded
                      : Icons.cancel_outlined,
                  color: statusColor,
                  size:
                      PredictionsSpacingTokens.predictionPortfolioPositionIcon,
                ),
              ),
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionPortfolioPositionGap,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(
                    height: PredictionsSpacingTokens
                        .predictionPortfolioPositionTitleGap,
                  ),
                  Wrap(
                    spacing:
                        PredictionsSpacingTokens.predictionPortfolioChipGap,
                    runSpacing:
                        PredictionsSpacingTokens.predictionPortfolioChipRunGap,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      VitAccentPill(
                        label: position.outcome,
                        accentColor: outcomeColor,
                      ),
                      Text(
                        '${formatPredictionPortfolioShares(position.shares)} shares @ '
                        '\$${position.avgPrice.toStringAsFixed(2)}',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      VitStatusPill(
                        label: statusLabel,
                        status: isWon
                            ? VitStatusPillStatus.success
                            : isOpen
                            ? VitStatusPillStatus.warning
                            : VitStatusPillStatus.error,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: PredictionsSpacingTokens
                        .predictionPortfolioPositionMetricsGap,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PredictionPortfolioSmallMetric(
                          label: 'Avg:',
                          value: '\$${position.avgPrice.toStringAsFixed(2)}',
                        ),
                      ),
                      const SizedBox(
                        width: PredictionsSpacingTokens
                            .predictionPortfolioPositionMetricsGap,
                      ),
                      Expanded(
                        child: PredictionPortfolioSmallMetric(
                          label: 'Current:',
                          value:
                              '\$${position.currentPrice.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: PredictionsSpacingTokens
                        .predictionPortfolioPositionRowsGap,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PredictionPortfolioSmallMetric(
                          label: 'Value:',
                          value: formatPredictionPortfolioMoney(
                            position.currentValue,
                          ),
                          strong: true,
                        ),
                      ),
                      const SizedBox(
                        width: PredictionsSpacingTokens
                            .predictionPortfolioPositionMetricsGap,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              position.pnl >= 0
                                  ? Icons.arrow_outward_rounded
                                  : Icons.south_east_rounded,
                              color: pnlColor,
                              size: PredictionsSpacingTokens
                                  .predictionPortfolioPnlArrowIcon,
                            ),
                            const SizedBox(
                              width: PredictionsSpacingTokens
                                  .predictionPortfolioPnlArrowGap,
                            ),
                            Flexible(
                              child: Text(
                                '${formatPredictionPortfolioSignedMoney(position.pnl)} '
                                '(${position.pnlPct.toStringAsFixed(1)}%)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: AppTextStyles.badge.copyWith(
                                  color: pnlColor,
                                  fontWeight: AppTextStyles.bold,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
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
            const SizedBox(
              width: PredictionsSpacingTokens.predictionPortfolioTrailingGap,
            ),
            const Padding(
              padding: PredictionsSpacingTokens
                  .predictionPortfolioTrailingIconPadding,
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: PredictionsSpacingTokens.predictionPortfolioTrailingIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionPortfolioSmallMetric extends StatelessWidget {
  const PredictionPortfolioSmallMetric({
    required this.label,
    required this.value,
    this.strong = false,
    super.key,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(
          width: PredictionsSpacingTokens.predictionPortfolioMetricGap,
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (strong ? AppTextStyles.badge : AppTextStyles.numericMicro)
                .copyWith(
                  color: strong ? AppColors.text1 : AppColors.text2,
                  fontWeight: strong
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
          ),
        ),
      ],
    );
  }
}
