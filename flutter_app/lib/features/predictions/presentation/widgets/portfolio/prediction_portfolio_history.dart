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

class PredictionPortfolioHistorySection extends StatelessWidget {
  const PredictionPortfolioHistorySection({required this.snapshot, super.key});

  final PredictionPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final receipts = snapshot.historyReceipts;
    if (receipts.isEmpty) {
      return const VitEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Ch\u01b0a c\u00f3 l\u1ecbch s\u1eed l\u1ec7nh',
        message:
            'C\u00e1c l\u1ec7nh \u0111\u00e3 kh\u1edbp ho\u1eb7c \u0111\u00e3 h\u1ee7y s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\u00e2y',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          title: 'L\u1ecbch s\u1eed l\u1ec7nh',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          clip: true,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < receipts.length; index += 1) ...[
                _ReceiptRow(
                  key: predictionPortfolioReceiptKey(receipts[index].id),
                  receipt: receipts[index],
                ),
                if (index != receipts.length - 1)
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

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.receipt, super.key});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == 'buy';
    final isFilled = receipt.status == 'filled';
    final color = isFilled
        ? AppColors.buy
        : receipt.status == 'canceled'
        ? AppColors.text3
        : AppColors.sell;

    return InkWell(
      onTap: () =>
          context.go(AppRoutePaths.marketsPredictionReceipt(receipt.id)),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: PredictionsSpacingTokens.predictionPortfolioReceiptIconBox,
              height:
                  PredictionsSpacingTokens.predictionPortfolioReceiptIconBox,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color.withValues(alpha: .12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                ),
                child: Icon(
                  isFilled
                      ? Icons.check_circle_outline_rounded
                      : Icons.cancel_outlined,
                  color: color,
                  size: PredictionsSpacingTokens.predictionPortfolioReceiptIcon,
                ),
              ),
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionPortfolioReceiptGap,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receipt.eventTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(
                    height: PredictionsSpacingTokens
                        .predictionPortfolioReceiptTitleGap,
                  ),
                  Wrap(
                    spacing:
                        PredictionsSpacingTokens.predictionPortfolioChipGap,
                    runSpacing:
                        PredictionsSpacingTokens.predictionPortfolioChipRunGap,
                    children: [
                      VitAccentPill(
                        label: '${isBuy ? 'Buy' : 'Sell'} ${receipt.outcome}',
                        accentColor: isBuy ? AppColors.buy : AppColors.sell,
                      ),
                      VitAccentPill(
                        label: isFilled ? 'Filled' : 'Canceled',
                        accentColor: color,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: PredictionsSpacingTokens
                        .predictionPortfolioReceiptMetaGap,
                  ),
                  Text(
                    '${formatPredictionPortfolioShares(receipt.filledShares)}/'
                    '${formatPredictionPortfolioShares(receipt.shares)} shares \u00b7 '
                    '${formatPredictionPortfolioMoney(receipt.total)} \u00b7 ${receipt.createdAt}',
                    style: AppTextStyles.numericMicro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: PredictionsSpacingTokens.predictionPortfolioReceiptChevron,
            ),
          ],
        ),
      ),
    );
  }
}
