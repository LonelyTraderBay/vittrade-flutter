import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_ladder_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class LadderHero extends StatelessWidget {
  const LadderHero({
    super.key,
    required this.snapshot,
    required this.amountUsd,
    required this.annualInterest,
    required this.rungCount,
    required this.weightedApy,
    required this.liquidityScore,
  });

  final SavingsLadderSnapshot snapshot;
  final int amountUsd;
  final double annualInterest;
  final int rungCount;
  final double weightedApy;
  final int liquidityScore;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsLadderPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.layers_outlined,
                color: AppColors.accent,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng vốn phân bổ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        savingsLadderMoney(amountUsd),
                        style: AppTextStyles.pageTitle.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Dự kiến lãi/năm',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '+${savingsLadderMoney(annualInterest)}',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroStat(label: 'Số bậc', value: '$rungCount'),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'APY TB',
                  value: '${weightedApy.toStringAsFixed(1)}%',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'Thanh khoản',
                  value: '$liquidityScore',
                  valueColor: AppColors.buy,
                  dot: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label,
    required this.value,
    this.valueColor,
    this.dot = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final color = valueColor ?? AppColors.text1;
    return VitCardStat(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              if (dot) ...[
                const SizedBox.square(
                  dimension: EarnSpacingTokens.savingsLadderHeroDot,
                  child: Material(color: AppColors.buy, shape: CircleBorder()),
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
