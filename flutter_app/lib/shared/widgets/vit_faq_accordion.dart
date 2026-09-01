import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Background treatment for a [VitFaqAccordion]'s expanded answer body.
enum VitFaqAnswerBackground {
  /// Plain answer text, no panel — current/default behavior.
  none,

  /// Answer wrapped in a rounded [AppColors.surface2] panel.
  surface2,
}

/// Single expandable FAQ tile. Parent owns expand state.
class VitFaqAccordion extends StatelessWidget {
  const VitFaqAccordion({
    super.key,
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
    this.accentColor = AppColors.primary,
    this.maxAnswerLines,
    this.leadingIcon,
    this.answerBackground = VitFaqAnswerBackground.none,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;
  final Color accentColor;
  final int? maxAnswerLines;

  /// Optional icon shown before the question text.
  final IconData? leadingIcon;

  /// Background treatment for the expanded answer body.
  final VitFaqAnswerBackground answerBackground;

  @override
  Widget build(BuildContext context) {
    final answerText = Text(
      answer,
      maxLines: maxAnswerLines,
      overflow: maxAnswerLines == null
          ? TextOverflow.visible
          : TextOverflow.ellipsis,
      style: AppTextStyles.caption.copyWith(color: AppColors.text2),
    );

    return VitCard(
      radius: VitCardRadius.standard,
      padding: EdgeInsetsDirectional.all(AppSurfaceSpacing.x4),
      borderColor: expanded ? accentColor.withValues(alpha: 0.28) : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: leadingIcon == null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  color: accentColor,
                  size: AppSurfaceSpacing.iconMd,
                ),
                SizedBox(width: AppSurfaceSpacing.x3),
              ],
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: expanded ? accentColor : AppColors.text1,
                  ),
                ),
              ),
              Icon(
                expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: AppColors.text3,
                size: AppSurfaceSpacing.iconMd,
              ),
            ],
          ),
          if (expanded) ...[
            SizedBox(height: AppSurfaceSpacing.x3),
            answerBackground == VitFaqAnswerBackground.surface2
                ? DecoratedBox(
                    decoration: const ShapeDecoration(
                      color: AppColors.surface2,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.smRadius,
                      ),
                    ),
                    child: Padding(
                      padding: AppSurfaceSpacing.cardPaddingCompact,
                      child: answerText,
                    ),
                  )
                : answerText,
          ],
        ],
      ),
    );
  }
}

/// One question/answer entry rendered as a [VitFaqAccordion] inside a
/// [VitFaqList].
class VitFaqItem {
  const VitFaqItem({
    required this.question,
    required this.answer,
    this.widgetKey,
  });

  final String question;
  final String answer;
  final Key? widgetKey;
}

/// Controlled multi-item FAQ list (single expanded index).
class VitFaqList extends StatelessWidget {
  const VitFaqList({
    super.key,
    required this.items,
    required this.expandedIndex,
    required this.onToggle,
    this.accentColor = AppColors.primary,
    this.gap,
  });

  final List<VitFaqItem> items;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;
  final Color accentColor;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final resolvedGap = gap ?? AppSurfaceSpacing.pageRhythmStandardInnerGap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: resolvedGap),
          VitFaqAccordion(
            key: items[i].widgetKey,
            question: items[i].question,
            answer: items[i].answer,
            expanded: expandedIndex == i,
            onTap: () => onToggle(i),
            accentColor: accentColor,
          ),
        ],
      ],
    );
  }
}
