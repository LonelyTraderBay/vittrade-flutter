import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_motion.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Accent color family for a [VitChoicePill] when [VitChoicePill.accentColor]
/// is not explicitly set.
enum VitChoicePillTone { neutral, primary, success, danger, warning }

/// Tappable selectable pill (single filter/option toggle) with a
/// tone-driven accent, optional leading icon, and selected-state styling.
class VitChoicePill extends StatelessWidget {
  const VitChoicePill({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.enabled = true,
    this.tone = VitChoicePillTone.primary,
    this.accentColor,
    this.density = VitDensity.compact,
    this.fullWidth = false,
    this.height,
    this.padding,
    this.leading,
    this.showSelectedIcon = false,
    this.selectedIcon = Icons.check_circle_rounded,
    this.semanticLabel,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool enabled;
  final VitChoicePillTone tone;
  final Color? accentColor;
  final VitDensity density;
  final bool fullWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? leading;
  final bool showSelectedIcon;
  final IconData selectedIcon;
  final String? semanticLabel;

  bool get _interactive => enabled && onTap != null;

  Color get _accent {
    if (accentColor != null) return accentColor!;
    return switch (tone) {
      VitChoicePillTone.neutral => AppColors.text2,
      VitChoicePillTone.primary => AppColors.primarySoft,
      VitChoicePillTone.success => AppColors.buy,
      VitChoicePillTone.danger => AppColors.sell,
      VitChoicePillTone.warning => AppColors.warn,
    };
  }

  Color get _selectedFill {
    if (accentColor != null) return accentColor!.withValues(alpha: .14);
    return switch (tone) {
      VitChoicePillTone.neutral => AppColors.surface2,
      VitChoicePillTone.primary => AppColors.primary12,
      VitChoicePillTone.success => AppColors.buy20,
      VitChoicePillTone.danger => AppColors.sell20,
      VitChoicePillTone.warning => AppColors.warn10,
    };
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent;
    final foreground = !_interactive
        ? AppColors.text3
        : selected
        ? accent
        : AppColors.text2;
    final border = !_interactive
        ? AppColors.cardBorder
        : selected
        ? accent.withValues(alpha: .48)
        : AppColors.cardBorder;
    final fill = selected ? _selectedFill : AppColors.surface2;
    final resolvedHeight = height ?? density.controlHeight;
    final resolvedPadding =
        padding ??
        (density == VitDensity.compact
            ? EdgeInsetsDirectional.symmetric(horizontal: AppSurfaceSpacing.x3)
            : EdgeInsetsDirectional.symmetric(
                horizontal: AppSurfaceSpacing.x4,
              ));

    final labelText = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.caption.copyWith(
        color: foreground,
        fontWeight: AppTextStyles.bold,
      ),
    );

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (selected && showSelectedIcon) ...[
          Icon(selectedIcon, color: accent, size: AppSurfaceSpacing.iconSm),
          SizedBox(width: AppSurfaceSpacing.x1),
        ] else if (leading != null) ...[
          IconTheme(
            data: IconThemeData(
              color: foreground,
              size: AppSurfaceSpacing.iconSm,
            ),
            child: leading!,
          ),
          SizedBox(width: AppSurfaceSpacing.x1),
        ],
        if (fullWidth) Flexible(child: labelText) else labelText,
      ],
    );

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      selected: selected,
      enabled: _interactive,
      child: AnimatedOpacity(
        duration: AppMotion.respect(context, AppMotion.feedback),
        opacity: enabled ? 1 : .52,
        child: SizedBox(
          width: fullWidth ? double.infinity : null,
          height: resolvedHeight,
          child: Material(
            color: AppColors.transparent,
            borderRadius: AppRadii.inputRadius,
            child: Ink(
              decoration: ShapeDecoration(
                color: fill,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.inputRadius,
                  side: BorderSide(color: border),
                ),
              ),
              child: InkWell(
                onTap: _interactive ? onTap : null,
                borderRadius: AppRadii.inputRadius,
                child: Padding(padding: resolvedPadding, child: row),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
