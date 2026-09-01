import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_accent_icon_box.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Layout for [VitCountedSectionHeader]'s title + count-pill cluster.
enum VitCountedSectionHeaderLayout {
  /// Title and count pill hug the left edge (right after the icon box);
  /// any optional trailing action is pinned to the row's far right.
  hugging,

  /// Title expands to fill the row and the count pill sits flush against
  /// the row's right edge.
  expanded,
}

/// Shared "icon box + bold title + numeric count pill + optional trailing
/// action" section header used by discovery section/result groups.
///
/// Consolidated from near-identical `_SectionShell` (topic hub) and
/// `_ResultSection` (unified search) private widgets — both built the same
/// header shape with only the title text style, count-pill padding, and
/// title/pill layout differing.
class VitCountedSectionHeader extends StatelessWidget {
  const VitCountedSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    this.titleStyle = AppTextStyles.body,
    this.countChipPadding = LaunchpadSpacingTokens.discoveryBadgePadding,
    this.layout = VitCountedSectionHeaderLayout.hugging,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final int count;
  final Color color;

  /// Base text style for the title before the bold/[AppColors.text1]
  /// overrides are applied. Defaults to [AppTextStyles.body] (topic-hub
  /// section variant); pass [AppTextStyles.base] for the unified-search
  /// result-group variant.
  final TextStyle titleStyle;

  /// Padding for the trailing count pill. Defaults to
  /// [LaunchpadSpacingTokens.discoveryBadgePadding]; pass
  /// [LaunchpadSpacingTokens.discoveryMiniBadgePadding] for the tighter
  /// topic-hub section-header variant.
  final EdgeInsetsGeometry countChipPadding;

  /// Whether the title/count-pill cluster hugs the left edge or the title
  /// expands to push the pill flush right. See
  /// [VitCountedSectionHeaderLayout].
  final VitCountedSectionHeaderLayout layout;

  /// Optional trailing "Xem tất cả"-style action, only rendered in
  /// [VitCountedSectionHeaderLayout.hugging] layouts.
  final String? actionLabel;
  final VoidCallback? onAction;

  Widget _buildCountChip() {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: countChipPadding,
        child: Text(
          '$count',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasAction = actionLabel != null && onAction != null;
    final titleText = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: titleStyle.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );

    final middle = layout == VitCountedSectionHeaderLayout.hugging
        ? Row(
            children: [
              Flexible(child: titleText),
              SizedBox(width: AppSurfaceSpacing.x2),
              _buildCountChip(),
            ],
          )
        : Row(
            children: [
              Expanded(child: titleText),
              _buildCountChip(),
            ],
          );

    return Row(
      children: [
        VitAccentIconBox(icon: icon, color: color),
        SizedBox(width: AppSurfaceSpacing.x3),
        Expanded(child: middle),
        if (hasAction)
          VitCard(
            onTap: onAction,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            borderColor: AppColors.transparent,
            padding: LaunchpadSpacingTokens.discoveryInlineActionPadding,
            child: Padding(
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  SizedBox(width: AppSurfaceSpacing.x1),
                  Icon(Icons.arrow_forward_rounded, color: color, size: 11),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
