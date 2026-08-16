import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_ladder_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const _templateLineHeight = 1.18;

class AmountSelector extends StatelessWidget {
  const AmountSelector({
    super.key,
    required this.amountUsd,
    required this.quickAmounts,
    required this.onChanged,
  });

  final int amountUsd;
  final List<int> quickAmounts;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      key: SavingsLadderPage.amountKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.standard,
          borderColor: AppColors.primary30,
          density: VitDensity.compact,
          child: SizedBox(
            height: VitDensity.compact.controlHeight,
            child: Row(
              children: [
                const Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    '$amountUsd',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                Text(
                  'USD',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            for (final amount in quickAmounts) ...[
              Expanded(
                child: ChoicePill(
                  key: SavingsLadderPage.amountChipKey(amount),
                  label: savingsLadderCompactAmount(amount),
                  selected: amountUsd == amount,
                  onTap: () => onChanged(amount),
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

class TemplateList extends StatelessWidget {
  const TemplateList({
    super.key,
    required this.templates,
    required this.selected,
    required this.amountUsd,
    required this.onChanged,
  });

  final List<SavingsLadderTemplateDraft> templates;
  final SavingsLadderPreset selected;
  final int amountUsd;
  final ValueChanged<SavingsLadderPreset> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      key: SavingsLadderPage.templatesKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        for (final template in templates) ...[
          _TemplateCard(
            template: template,
            selected: template.id == selected,
            amountUsd: amountUsd,
            onTap: () => onChanged(template.id),
          ),
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.amountUsd,
    required this.onTap,
  });

  final SavingsLadderTemplateDraft template;
  final bool selected;
  final int amountUsd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = savingsLadderToneColor(template.tone);
    final rungs = savingsLadderGenerateRungs(template, amountUsd);
    final apy = savingsLadderWeightedApy(rungs);
    return VitCard(
      key: SavingsLadderPage.presetKey(template.id),
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: selected ? color.withValues(alpha: .45) : null,
      density: VitDensity.compact,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundIcon(icon: savingsLadderIconFor(template.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.none,
              fullBleed: true,
              gap: VitContentGap.tight,
              children: [
                Text(
                  template.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: savingsLadderCaptionBoldStyle.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                Text(
                  template.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _templateLineHeight,
                  ),
                ),
                Text(
                  '${template.intervals.length} bậc · APY TB: ${apy.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected ? color : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}
