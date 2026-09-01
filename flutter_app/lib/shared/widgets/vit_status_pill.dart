import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';

/// Semantic status/color family for a [VitStatusPill] or [VitAccentPill].
enum VitStatusPillStatus {
  success,
  warning,
  error,
  info,
  neutral,
  purple,
  orange,
}

/// Size preset of a [VitStatusPill].
enum VitStatusPillSize { sm, md, lg }

/// Tone-colored status pill with optional icon, pulse dot, count badge, and
/// tap handling.
class VitStatusPill extends StatelessWidget {
  const VitStatusPill({
    super.key,
    required this.label,
    this.status = VitStatusPillStatus.neutral,
    this.icon,
    this.size = VitStatusPillSize.md,
    this.pulse = false,
    this.outline = false,
    this.count,
    this.onTap,
    this.backgroundAlpha,
    this.radiusOverride,
  });

  final String label;
  final VitStatusPillStatus status;
  final IconData? icon;
  final VitStatusPillSize size;
  final bool pulse;
  final bool outline;
  final int? count;
  final VoidCallback? onTap;

  /// Overrides the palette's default background alpha. Null preserves the
  /// existing per-status background token unchanged.
  final double? backgroundAlpha;

  /// Overrides the default [AppRadii.pillRadius]. Null preserves current
  /// pill-shaped corners unchanged.
  final BorderRadius? radiusOverride;

  _StatusPalette get _palette {
    switch (status) {
      case VitStatusPillStatus.success:
        return const _StatusPalette(
          background: AppColors.buy15,
          foreground: AppColors.buy,
          border: AppColors.buy20,
        );
      case VitStatusPillStatus.warning:
      case VitStatusPillStatus.orange:
        return const _StatusPalette(
          background: AppColors.riskWarning15,
          foreground: AppColors.riskWarning,
          border: AppColors.warningBorder,
        );
      case VitStatusPillStatus.error:
        return const _StatusPalette(
          background: AppColors.sell15,
          foreground: AppColors.sell,
          border: AppColors.sell20,
        );
      case VitStatusPillStatus.info:
        return const _StatusPalette(
          background: AppColors.primary12,
          foreground: AppColors.primary,
          border: AppColors.primary20,
        );
      case VitStatusPillStatus.purple:
        return const _StatusPalette(
          background: AppColors.accent12,
          foreground: AppColors.accent,
          border: AppColors.accent20,
        );
      case VitStatusPillStatus.neutral:
        return const _StatusPalette(
          background: AppColors.surface2,
          foreground: AppColors.text2,
          border: AppColors.borderSolid,
        );
    }
  }

  _StatusMetrics get _metrics {
    switch (size) {
      case VitStatusPillSize.sm:
        return _StatusMetrics(
          height: AppSurfaceSpacing.statusPillHeightSm,
          labelStyle: AppTextStyles.numericMicro,
          iconSize: AppSurfaceSpacing.statusPillIconSizeSm,
          paddingX: AppSurfaceSpacing.statusPillHorizontalPaddingSm,
          gap: AppSurfaceSpacing.statusPillGapSm,
        );
      case VitStatusPillSize.md:
        return _StatusMetrics(
          height: AppSurfaceSpacing.statusPillHeightMd,
          labelStyle: AppTextStyles.navLabel,
          iconSize: AppSurfaceSpacing.statusPillIconSizeMd,
          paddingX: AppSurfaceSpacing.statusPillHorizontalPaddingMd,
          gap: AppSurfaceSpacing.statusPillGapMd,
        );
      case VitStatusPillSize.lg:
        return _StatusMetrics(
          height: AppSurfaceSpacing.statusPillHeightLg,
          labelStyle: AppTextStyles.navLabel,
          iconSize: AppSurfaceSpacing.statusPillIconSizeLg,
          paddingX: AppSurfaceSpacing.statusPillHorizontalPaddingLg,
          gap: AppSurfaceSpacing.statusPillGapLg,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;
    final metrics = _metrics;
    final hasCount = count != null && count! > 0;
    final resolvedBackground = backgroundAlpha != null
        ? palette.background.withValues(alpha: backgroundAlpha)
        : palette.background;
    final resolvedRadius = radiusOverride ?? AppRadii.pillRadius;

    Widget content = SizedBox(
      height: metrics.height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: outline ? AppColors.transparent : resolvedBackground,
          shape: RoundedRectangleBorder(
            borderRadius: resolvedRadius,
            side: BorderSide(color: palette.border),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: metrics.paddingX,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pulse) ...[
                SizedBox.square(
                  dimension: metrics.iconSize * 0.6,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: palette.foreground,
                      shape: const CircleBorder(),
                      shadows: [
                        BoxShadow(
                          color: palette.border,
                          blurRadius: AppSurfaceSpacing.statusPillBadgeBlur,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: metrics.gap),
              ] else if (icon != null) ...[
                Icon(icon, color: palette.foreground, size: metrics.iconSize),
                SizedBox(width: metrics.gap),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: metrics.labelStyle.copyWith(
                    color: palette.foreground,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              if (hasCount) ...[
                SizedBox(width: metrics.gap),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth:
                        metrics.height *
                        AppSurfaceSpacing.statusPillCountMinWidthFactor,
                  ),
                  child: SizedBox(
                    height:
                        metrics.height *
                        AppSurfaceSpacing.statusPillCountHeightFactor,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: palette.foreground,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadii.pillRadius,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: AppSurfaceSpacing.statusPillCountPadding,
                        ),
                        child: Center(
                          child: Text(
                            count! > 99 ? '99+' : '${count!}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.onAccent,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: resolvedRadius,
          child: content,
        ),
      );
    }

    return Semantics(button: onTap != null, child: content);
  }
}

class _StatusPalette {
  const _StatusPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

class _StatusMetrics {
  const _StatusMetrics({
    required this.height,
    required this.labelStyle,
    required this.iconSize,
    required this.paddingX,
    required this.gap,
  });

  final double height;
  final TextStyle labelStyle;
  final double iconSize;
  final double paddingX;
  final double gap;
}
