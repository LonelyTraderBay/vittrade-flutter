import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Small leading icon + gap + expanded caption text row, used for bullet
/// lists, checklists and guide items across feature pages.
class VitBulletRow extends StatelessWidget {
  const VitBulletRow({
    super.key,
    required this.text,
    this.icon = Icons.circle,
    this.color = AppColors.text2,
    this.iconSize,
    this.textStyle,
    this.iconPadding,
  });

  final String text;
  final IconData icon;
  final Color color;

  /// Defaults to [AppSurfaceSpacing.iconSm].
  final double? iconSize;

  /// Defaults to [AppTextStyles.caption]. [AppColors.text2] is always
  /// applied on top via [TextStyle.copyWith].
  final TextStyle? textStyle;

  /// When set, wraps the icon in a [Padding] instead of laying it out
  /// directly in the [Row] (useful to nudge the icon to align with the
  /// first line of multi-line text).
  final EdgeInsetsGeometry? iconPadding;

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = Icon(
      icon,
      color: color,
      size: iconSize ?? AppSurfaceSpacing.iconSm,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconPadding != null
            ? Padding(padding: iconPadding!, child: resolvedIcon)
            : resolvedIcon,
        SizedBox(width: AppSurfaceSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: (textStyle ?? AppTextStyles.caption).copyWith(
              color: AppColors.text2,
            ),
          ),
        ),
      ],
    );
  }
}
