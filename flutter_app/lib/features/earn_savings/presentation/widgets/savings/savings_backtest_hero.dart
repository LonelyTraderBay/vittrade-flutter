import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_backtest_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class BacktestHero extends StatelessWidget {
  const BacktestHero({
    super.key,
    required this.snapshot,
    required this.amountUsd,
    required this.preset,
    required this.period,
    required this.weightedApy,
    required this.hasRun,
    required this.result,
  });

  final SavingsBacktestSnapshot snapshot;
  final int amountUsd;
  final SavingsBacktestPresetDraft preset;
  final SavingsBacktestPeriodDraft period;
  final double weightedApy;
  final bool hasRun;
  final SavingsBacktestResultDraft result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsBacktestPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vốn ban đầu',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      usd(amountUsd),
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasRun)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Giá trị cuối kỳ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      usd(result.finalValueUsd),
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.buy,
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
                child: _HeroMetric(label: 'Chiến lược', value: preset.label),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'APY TB',
                  value: '${weightedApy.toStringAsFixed(1)}%',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(label: 'Thời gian', value: period.label),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: captionBoldStyle.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
