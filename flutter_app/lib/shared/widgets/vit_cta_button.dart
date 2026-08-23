import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_input_states.dart';
import 'package:vit_trade_flutter/app/theme/app_motion.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';

/// Color/emphasis treatment of a [VitCtaButton].
enum VitCtaButtonVariant {
  primary,
  secondary,
  success,
  danger,
  destructive,
  warning,
  ghost,
  auth,
}

/// Primary call-to-action button: variant-driven fill/gradient, loading
/// spinner state, and optional leading/trailing icons.
class VitCtaButton extends StatelessWidget {
  const VitCtaButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = VitCtaButtonVariant.primary,
    this.loading = false,
    this.fullWidth = true,
    this.height = AppSpacing.ctaHeight,
    this.density = VitDensity.standard,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x5,
    ),
  });

  final Widget child;
  final VoidCallback? onPressed;
  final VitCtaButtonVariant variant;
  final bool loading;
  final bool fullWidth;
  final double height;
  final VitDensity density;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  bool get _enabled => onPressed != null && !loading;

  _CtaStyle get _style {
    switch (variant) {
      case VitCtaButtonVariant.primary:
        return const _CtaStyle(
          gradient: AppGradients.navCenter,
          foreground: AppColors.onAccent,
          shadow: AppColors.primary30,
        );
      case VitCtaButtonVariant.secondary:
        return const _CtaStyle(
          background: AppColors.portfolioBtnGhost,
          foreground: AppColors.portfolioBtnGhostText,
          border: AppColors.portfolioBtnGhostBorder,
        );
      case VitCtaButtonVariant.success:
        return const _CtaStyle(
          background: AppColors.buy,
          foreground: AppColors.onAccent,
          shadow: AppColors.buy20,
        );
      case VitCtaButtonVariant.danger:
      case VitCtaButtonVariant.destructive:
        return const _CtaStyle(
          background: AppColors.sell,
          foreground: AppColors.onAccent,
          shadow: AppColors.sell20,
        );
      case VitCtaButtonVariant.warning:
        return const _CtaStyle(
          background: AppColors.riskWarning,
          foreground: AppColors.onAccent,
          shadow: AppColors.riskWarning15,
        );
      case VitCtaButtonVariant.ghost:
        return const _CtaStyle(
          background: AppColors.transparent,
          foreground: AppColors.text1,
          border: AppColors.borderSolid,
        );
      case VitCtaButtonVariant.auth:
        return const _CtaStyle(
          gradient: AppGradients.navCenter,
          foreground: AppColors.onAccent,
          shadow: AppColors.primary30,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _enabled
        ? _style
        : const _CtaStyle(
            background: AppColors.surface2,
            foreground: AppColors.text3,
          );
    final resolvedHeight = height == AppSpacing.ctaHeight
        ? density.controlHeight
        : height;

    final button = ConstrainedBox(
      // A11Y-3: minHeight (not a tight height) lets the button grow taller
      // when clamped OS text-scaling needs more room, instead of a fixed
      // SizedBox height forcing FittedBox to shrink the text back down and
      // silently defeating the user's larger font-size setting.
      constraints: BoxConstraints(
        minHeight: resolvedHeight,
        minWidth: fullWidth ? double.infinity : 0,
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          decoration: ShapeDecoration(
            color: style.background,
            gradient: style.gradient,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: style.border == null
                  ? BorderSide.none
                  : BorderSide(color: style.border!),
            ),
            shadows: style.shadow == null
                ? null
                : [
                    BoxShadow(
                      color: style.shadow!,
                      blurRadius: AppSpacing.ctaElevationBlur,
                      offset: const Offset(0, AppSpacing.ctaElevationYOffset),
                    ),
                  ],
          ),
          child: InkWell(
            onTap: _enabled ? onPressed : null,
            borderRadius: AppRadii.inputRadius,
            hoverColor: AppInputStates.hoverOverlay,
            focusColor: AppInputStates.focusOverlay,
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (loading) ...[
                    SizedBox(
                      width: AppSpacing.ctaLoadingIcon,
                      height: AppSpacing.ctaLoadingIcon,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSpacing.ctaStrokeWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          style.foreground,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                  ] else if (leading != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: style.foreground,
                        size: AppSpacing.iconMd,
                      ),
                      child: leading!,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                  ],
                  Flexible(
                    // A11Y-3: no FittedBox — let the label wrap (Row/height
                    // above now grows to fit) instead of shrinking the text.
                    child: DefaultTextStyle.merge(
                      style: AppTextStyles.control.copyWith(
                        color: style.foreground,
                      ),
                      child: child,
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSpacing.x3),
                    IconTheme(
                      data: IconThemeData(
                        color: style.foreground,
                        size: AppSpacing.iconMd,
                      ),
                      child: trailing!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      child: AnimatedOpacity(
        duration: AppMotion.element,
        opacity: _enabled || loading ? 1 : 0.55,
        child: button,
      ),
    );
  }
}

class _CtaStyle {
  const _CtaStyle({
    this.background,
    this.gradient,
    required this.foreground,
    this.border,
    this.shadow,
  });

  final Color? background;
  final Gradient? gradient;
  final Color foreground;
  final Color? border;
  final Color? shadow;
}
