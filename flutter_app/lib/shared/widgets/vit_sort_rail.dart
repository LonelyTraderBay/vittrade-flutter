import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_choice_pill.dart';

/// One selectable sort option rendered as a [VitChoicePill] inside
/// [VitSortRail].
class VitSortRailOption<T> {
  const VitSortRailOption({required this.value, required this.label, this.key});

  /// The module-specific sort enum value this option selects.
  final T value;
  final String label;
  final Key? key;
}

/// Icon + "Sắp xếp:" label + horizontal-scrolling row of [VitChoicePill]
/// sort options.
///
/// Generic over the module-specific sort enum [T] so pages don't need to
/// hand-roll this "icon + label + choice pill row" shape per sort domain —
/// see referral history/rewards pages for reference usage.
class VitSortRail<T> extends StatelessWidget {
  const VitSortRail({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.optionHeight,
    required this.optionPadding,
    required this.iconSize,
    this.label = 'Sắp xếp:',
    this.icon = Icons.swap_vert_rounded,
    this.accentColor = AppColors.primary,
    this.optionGap,
  });

  final List<VitSortRailOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final double optionHeight;
  final EdgeInsetsGeometry optionPadding;
  final double iconSize;
  final String label;
  final IconData icon;
  final Color accentColor;
  final double? optionGap;

  @override
  Widget build(BuildContext context) {
    final resolvedOptionGap = optionGap ?? AppSurfaceSpacing.x2;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Icon(icon, color: AppColors.text3, size: iconSize),
          SizedBox(width: AppSurfaceSpacing.x2),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          SizedBox(width: AppSurfaceSpacing.x3),
          for (final option in options) ...[
            VitChoicePill(
              key: option.key,
              label: option.label,
              selected: option.value == selected,
              onTap: () => onChanged(option.value),
              accentColor: accentColor,
              height: optionHeight,
              padding: optionPadding,
            ),
            SizedBox(width: resolvedOptionGap),
          ],
        ],
      ),
    );
  }
}
