import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Color family for a [VitMetricDeltaPill], also picking its default icon.
enum VitMetricDeltaTone { positive, negative, neutral, warning }

/// Padding/icon size preset of a [VitMetricDeltaPill].
enum VitMetricDeltaPillSize { sm, md }

/// Small tone-colored pill showing a metric delta (e.g. % change) with an
/// optional leading icon.
class VitMetricDeltaPill extends StatelessWidget {
  const VitMetricDeltaPill({
    super.key,
    required this.label,
    this.tone = VitMetricDeltaTone.neutral,
    this.icon,
    this.size = VitMetricDeltaPillSize.sm,
  });

  final String label;
  final VitMetricDeltaTone tone;
  final IconData? icon;
  final VitMetricDeltaPillSize size;

  _MetricDeltaPalette get _palette {
    return switch (tone) {
      VitMetricDeltaTone.positive => const _MetricDeltaPalette(
        foreground: AppColors.buy,
        background: AppColors.buy15,
        border: AppColors.buy20,
        defaultIcon: Icons.trending_up_rounded,
      ),
      VitMetricDeltaTone.negative => const _MetricDeltaPalette(
        foreground: AppColors.sell,
        background: AppColors.sell15,
        border: AppColors.sell20,
        defaultIcon: Icons.trending_down_rounded,
      ),
      VitMetricDeltaTone.warning => const _MetricDeltaPalette(
        foreground: AppColors.warn,
        background: AppColors.warn15,
        border: AppColors.warningBorder,
        defaultIcon: Icons.warning_amber_rounded,
      ),
      VitMetricDeltaTone.neutral => const _MetricDeltaPalette(
        foreground: AppColors.text2,
        background: AppColors.surface2,
        border: AppColors.cardBorder,
      ),
    };
  }

  _MetricDeltaMetrics get _metrics {
    return switch (size) {
      VitMetricDeltaPillSize.sm => const _MetricDeltaMetrics(
        paddingX: SharedSpacingTokens.homePortfolioBadgeHorizontalPadding,
        paddingY: SharedSpacingTokens.homePortfolioBadgeVerticalPadding,
        iconSize: SharedSpacingTokens.homePortfolioBadgeIcon,
        textStyle: AppTextStyles.caption,
      ),
      VitMetricDeltaPillSize.md => _MetricDeltaMetrics(
        paddingX: AppSurfaceSpacing.statusPillHorizontalPaddingMd,
        paddingY: AppSurfaceSpacing.x2,
        iconSize: SharedSpacingTokens.homeNextActionIconSize,
        textStyle: AppTextStyles.caption,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;
    final metrics = _metrics;
    final resolvedIcon = icon ?? palette.defaultIcon;

    return Semantics(
      label: '${tone.name} delta $label',
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: palette.background,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: palette.border),
            borderRadius: AppRadii.smRadius,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: metrics.paddingX,
            vertical: metrics.paddingY,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (resolvedIcon != null) ...[
                Icon(
                  resolvedIcon,
                  color: palette.foreground,
                  size: metrics.iconSize,
                ),
                SizedBox(width: AppSurfaceSpacing.x1),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: metrics.textStyle.copyWith(
                    color: palette.foreground,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricDeltaPalette {
  const _MetricDeltaPalette({
    required this.foreground,
    required this.background,
    required this.border,
    this.defaultIcon,
  });

  final Color foreground;
  final Color background;
  final Color border;
  final IconData? defaultIcon;
}

class _MetricDeltaMetrics {
  const _MetricDeltaMetrics({
    required this.paddingX,
    required this.paddingY,
    required this.iconSize,
    required this.textStyle,
  });

  final double paddingX;
  final double paddingY;
  final double iconSize;
  final TextStyle textStyle;
}
