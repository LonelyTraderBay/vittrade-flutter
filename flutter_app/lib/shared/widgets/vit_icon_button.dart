import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Color treatment of a [VitIconButton].
enum VitIconButtonVariant {
  defaultAction,
  ghost,
  primary,
  success,
  danger,
  transparent,
}

/// Size preset of a [VitIconButton].
enum VitIconButtonSize { sm, md, lg }

/// Icon (optionally + label) button with variant/size-driven styling, a
/// tap-target-safe minimum size, and a loading spinner state.
class VitIconButton extends StatelessWidget {
  const VitIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.label,
    this.variant = VitIconButtonVariant.ghost,
    this.size = VitIconButtonSize.lg,
    this.loading = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final String? label;
  final VitIconButtonVariant variant;
  final VitIconButtonSize size;
  final bool loading;

  bool get _enabled => onPressed != null && !loading;

  _IconButtonMetrics get _metrics {
    switch (size) {
      case VitIconButtonSize.sm:
        return _IconButtonMetrics(
          height:
              AppSurfaceSpacing.buttonCompact -
              AppSurfaceSpacing.formFieldLabelGap,
          iconSize: AppSurfaceSpacing.rowPy,
          labelStyle: AppTextStyles.badge,
          gap: AppSurfaceSpacing.x1 + AppSurfaceSpacing.dividerHairline,
          paddingX: AppSurfaceSpacing.x3,
        );
      case VitIconButtonSize.md:
        return _IconButtonMetrics(
          height:
              AppSurfaceSpacing.buttonCompact +
              AppSurfaceSpacing.formFieldLabelGap,
          iconSize: AppSurfaceSpacing.iconMd,
          labelStyle: AppTextStyles.caption,
          gap: AppSurfaceSpacing.formFieldLabelGap,
          paddingX: AppSurfaceSpacing.rowPy - AppSurfaceSpacing.hairlineStroke,
        );
      case VitIconButtonSize.lg:
        return _IconButtonMetrics(
          height: AppSurfaceSpacing.inputHeight - AppSurfaceSpacing.x3,
          iconSize: AppSurfaceSpacing.contentPad,
          labelStyle: AppTextStyles.control,
          gap: AppSurfaceSpacing.x3,
          paddingX: AppSurfaceSpacing.x4 + AppSurfaceSpacing.x1,
        );
    }
  }

  _IconButtonStyle get _style {
    switch (variant) {
      case VitIconButtonVariant.defaultAction:
        return const _IconButtonStyle(
          background: AppColors.transparent,
          foreground: AppColors.text1,
        );
      case VitIconButtonVariant.ghost:
        return const _IconButtonStyle(
          background: AppColors.searchBg,
          foreground: AppColors.text2,
          border: AppColors.cardBorder,
        );
      case VitIconButtonVariant.primary:
        return const _IconButtonStyle(
          background: AppColors.primary12,
          foreground: AppColors.primary,
          border: AppColors.primary20,
        );
      case VitIconButtonVariant.success:
        return const _IconButtonStyle(
          background: AppColors.buy15,
          foreground: AppColors.buy,
          border: AppColors.buy20,
        );
      case VitIconButtonVariant.danger:
        return const _IconButtonStyle(
          background: AppColors.sell15,
          foreground: AppColors.sell,
          border: AppColors.sell20,
        );
      case VitIconButtonVariant.transparent:
        return const _IconButtonStyle(
          background: AppColors.transparent,
          foreground: AppColors.text2,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics;
    final style = _enabled
        ? _style
        : const _IconButtonStyle(
            background: AppColors.surface2,
            foreground: AppColors.text3,
            border: AppColors.cardBorder,
          );
    final hasLabel = label != null && label!.isNotEmpty;
    final radius = AppRadii.inputRadius;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: metrics.iconSize,
            height: metrics.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: AppSurfaceSpacing.hairlineStroke,
              valueColor: AlwaysStoppedAnimation<Color>(style.foreground),
            ),
          )
        else
          Icon(icon, color: style.foreground, size: metrics.iconSize),
        if (hasLabel) ...[
          SizedBox(width: metrics.gap),
          Text(
            label!,
            style: metrics.labelStyle.copyWith(
              color: style.foreground,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ],
    );

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        enabled: _enabled,
        child: Material(
          color: AppColors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: _enabled ? onPressed : null,
            borderRadius: radius,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: hasLabel ? 0 : AppSurfaceSpacing.minTapTarget,
                minHeight: AppSurfaceSpacing.minTapTarget,
              ),
              child: Center(
                // widthFactor/heightFactor: 1 makes Center shrink-wrap to
                // its child's size instead of its Flutter default of
                // expanding to fill any *bounded* incoming constraint —
                // without this, the tap target would grow to whatever the
                // surrounding layout happens to allow instead of stopping
                // at the ConstrainedBox minimum above.
                widthFactor: 1,
                heightFactor: 1,
                child: SizedBox(
                  width: hasLabel ? null : metrics.height,
                  height: metrics.height,
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: style.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: radius,
                        side: style.border == null
                            ? BorderSide.none
                            : BorderSide(color: style.border!),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: hasLabel ? metrics.paddingX : 0,
                      ),
                      // Same shrink-wrap fix as the outer Center: without
                      // widthFactor, this would expand to fill whatever
                      // bounded width the ancestor chain allows instead of
                      // hugging the Row's content width when hasLabel.
                      child: Center(
                        widthFactor: 1,
                        heightFactor: 1,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButtonMetrics {
  const _IconButtonMetrics({
    required this.height,
    required this.iconSize,
    required this.labelStyle,
    required this.gap,
    required this.paddingX,
  });

  final double height;
  final double iconSize;
  final TextStyle labelStyle;
  final double gap;
  final double paddingX;
}

class _IconButtonStyle {
  const _IconButtonStyle({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}
