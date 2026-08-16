import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_backtest_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class CompareTab extends StatelessWidget {
  const CompareTab({
    super.key,
    required this.snapshot,
    required this.amountUsd,
  });

  final SavingsBacktestSnapshot snapshot;
  final int amountUsd;

  @override
  Widget build(BuildContext context) {
    final presets = snapshot.presets
        .where((preset) => preset.id != SavingsBacktestPreset.custom)
        .toList();
    return Column(
      key: SavingsBacktestPage.compareKey,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.primary,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'So sánh tăng trưởng',
                    style: captionBoldStyle.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              for (final preset in presets) ...[
                _CompareBar(preset: preset, amountUsd: amountUsd),
                if (preset != presets.last)
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final preset in presets) ...[
          _CompareCard(preset: preset, amountUsd: amountUsd),
          if (preset != presets.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _CompareBar extends StatelessWidget {
  const _CompareBar({required this.preset, required this.amountUsd});

  final SavingsBacktestPresetDraft preset;
  final int amountUsd;

  @override
  Widget build(BuildContext context) {
    final apy = weightedApy(preset.slots);
    final projected = amountUsd * apy / 100;
    final pct = (apy / 7.5).clamp(0.0, 1.0);
    final color = presetColor(preset.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                preset.label,
                style: captionBoldStyle.copyWith(color: AppColors.text1),
              ),
            ),
            Text(
              '+${usd(projected)}',
              style: captionBoldStyle.copyWith(color: AppColors.buy),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: pct,
            minHeight: EarnSpacingTokens.savingsBacktestProgressHeight,
            color: color,
            backgroundColor: AppColors.surface3,
          ),
        ),
      ],
    );
  }
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({required this.preset, required this.amountUsd});

  final SavingsBacktestPresetDraft preset;
  final int amountUsd;

  @override
  Widget build(BuildContext context) {
    final apy = weightedApy(preset.slots);
    final projected = amountUsd * apy / 100;
    final color = presetColor(preset.id);
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: preset.id == SavingsBacktestPreset.aggressive
          ? AppColors.buy20
          : AppColors.cardBorder,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        children: [
          RoundIcon(icon: iconFor(preset.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  children: [
                    Text(
                      preset.label,
                      style: captionBoldStyle.copyWith(color: AppColors.text1),
                    ),
                    StatusPill(label: preset.riskLabel, color: color),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'APY hiệu quả ${apy.toStringAsFixed(1)}% · ${preset.slots.length} sản phẩm',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '+${(projected / amountUsd * 100).toStringAsFixed(2)}%',
            style: AppTextStyles.base.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class NoResults extends StatelessWidget {
  const NoResults({super.key, required this.onSetup});

  final VoidCallback onSetup;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX6,
      child: Column(
        children: [
          const Icon(
            Icons.play_circle_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Chưa chạy mô phỏng',
            style: captionBoldStyle.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Thiết lập chiến lược và bấm "Chạy mô phỏng" để xem kết quả.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            onPressed: onSetup,
            fullWidth: false,
            child: const Text('Thiết lập'),
          ),
        ],
      ),
    );
  }
}
