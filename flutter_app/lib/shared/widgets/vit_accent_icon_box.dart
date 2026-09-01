import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';

/// Module accent icon container for list rows, bonus rows, and task cards.
///
/// One visual family app-wide — 34px box, tinted fill, accent border.
/// See Accent-Icon-Box-Standard.md.
class VitAccentIconBox extends StatelessWidget {
  const VitAccentIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.muted = false,
    this.iconSize,
    this.bordered = true,
    this.boxSize,
  });

  final IconData icon;
  final Color color;
  final bool muted;
  final double? iconSize;

  /// When false, renders the tinted fill without the accent border stroke.
  /// Defaults to true to match the original bordered visual.
  final bool bordered;

  /// Overrides [AppSurfaceSpacing.accentIconBoxSize] (34px) when set.
  final double? boxSize;

  @override
  Widget build(BuildContext context) {
    final resolvedIconSize = iconSize ?? AppSurfaceSpacing.iconMd;
    final resolvedBoxSize = boxSize ?? AppSurfaceSpacing.accentIconBoxSize;

    if (muted) {
      return SizedBox(
        width: resolvedBoxSize,
        height: resolvedBoxSize,
        child: DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
          ),
          child: Center(
            child: Icon(icon, size: resolvedIconSize, color: color),
          ),
        ),
      );
    }

    return SizedBox(
      width: resolvedBoxSize,
      height: resolvedBoxSize,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: AppSurfaceSpacing.accentIconFillAlpha),
          shape: RoundedRectangleBorder(
            side: bordered
                ? BorderSide(
                    color: color.withValues(
                      alpha: AppSurfaceSpacing.accentIconBorderAlpha,
                    ),
                  )
                : BorderSide.none,
            borderRadius: AppRadii.mdRadius,
          ),
        ),
        child: Center(
          child: Icon(icon, size: resolvedIconSize, color: color),
        ),
      ),
    );
  }
}
