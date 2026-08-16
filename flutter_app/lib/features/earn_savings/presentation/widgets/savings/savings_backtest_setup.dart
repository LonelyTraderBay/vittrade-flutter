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

class BacktestTabs extends StatelessWidget {
  const BacktestTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            icon: switch (tab.id) {
              'setup' => Icons.tune_rounded,
              'results' => Icons.query_stats_rounded,
              _ => Icons.compare_arrows_rounded,
            },
          ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
          ),
          child: SizedBox(
            width: EarnSpacingTokens.savingsBacktestSectionMarkerWidth,
            height: EarnSpacingTokens.savingsBacktestSectionMarkerHeight,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(label, style: captionBoldStyle.copyWith(color: AppColors.text2)),
      ],
    );
  }
}

class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.controller,
    required this.quickAmounts,
    required this.amountUsd,
    required this.onAmountChanged,
  });

  final TextEditingController controller;
  final List<int> quickAmounts;
  final int amountUsd;
  final ValueChanged<int> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitInput(
          fieldKey: SavingsBacktestPage.amountFieldKey,
          controller: controller,
          keyboardType: TextInputType.number,
          semanticLabel: 'Số tiền backtest tiết kiệm',
          prefix: const Icon(Icons.attach_money_rounded),
          suffix: Text(
            'USD',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          textStyle: AppTextStyles.base.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
          onChanged: (value) {
            final parsed = int.tryParse(value);
            if (parsed != null && parsed >= 100) {
              onAmountChanged(parsed);
            }
          },
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            for (final amount in quickAmounts) ...[
              Expanded(
                child: _CompactChip(
                  key: SavingsBacktestPage.amountKey(amount),
                  label: compactAmount(amount),
                  selected: amountUsd == amount,
                  onTap: () => onAmountChanged(amount),
                ),
              ),
              if (amount != quickAmounts.last)
                const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
      ],
    );
  }
}

class PeriodRow extends StatelessWidget {
  const PeriodRow({
    super.key,
    required this.periods,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsBacktestPeriodDraft> periods;
  final SavingsBacktestPeriod selected;
  final ValueChanged<SavingsBacktestPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final period in periods) ...[
          Expanded(
            child: _CompactChip(
              key: SavingsBacktestPage.periodKey(period.id),
              label: period.label,
              selected: period.id == selected,
              onTap: () => onChanged(period.id),
            ),
          ),
          if (period != periods.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _CompactChip extends StatelessWidget {
  const _CompactChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      fullWidth: true,
    );
  }
}

class PresetList extends StatelessWidget {
  const PresetList({
    super.key,
    required this.presets,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsBacktestPresetDraft> presets;
  final SavingsBacktestPreset selected;
  final ValueChanged<SavingsBacktestPreset> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final preset in presets) ...[
          _PresetCard(
            preset: preset,
            selected: preset.id == selected,
            onTap: () => onChanged(preset.id),
          ),
          if (preset != presets.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final SavingsBacktestPresetDraft preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = presetColor(preset.id);
    return VitCard(
      key: SavingsBacktestPage.presetKey(preset.id),
      variant: selected ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.large,
      borderColor: selected ? color : AppColors.cardBorder,
      onTap: onTap,
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
                  crossAxisAlignment: WrapCrossAlignment.center,
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
                  preset.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${preset.slots.length} sản phẩm · APY TB: ${weightedApy(preset.slots).toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          SelectionDot(selected: selected, color: color),
        ],
      ),
    );
  }
}
