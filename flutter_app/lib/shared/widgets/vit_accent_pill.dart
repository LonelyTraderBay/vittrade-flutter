import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Small tinted label pill (accent-colored fill + border) used for coin
/// symbols, tags, and other compact accent badges.
class VitAccentPill extends StatelessWidget {
  const VitAccentPill({
    super.key,
    required this.label,
    required this.accentColor,
    this.size = VitStatusPillSize.sm,
    this.semanticStatus,
    this.backgroundAlpha,
    this.radiusOverride,
  });

  final String label;
  final Color accentColor;
  final VitStatusPillSize size;
  final VitStatusPillStatus? semanticStatus;

  /// Overrides the default `.14` background tint alpha. Null preserves
  /// current behavior unchanged.
  final double? backgroundAlpha;

  /// Overrides the default [AppRadii.pillRadius]. Null preserves current
  /// pill-shaped corners unchanged.
  final BorderRadius? radiusOverride;

  _AccentPillMetrics get _metrics {
    return switch (size) {
      VitStatusPillSize.sm => const _AccentPillMetrics(
        minHeight: SharedSpacingTokens.homeChipMinHeight,
        paddingX: SharedSpacingTokens.homeChipHorizontalPadding,
        paddingY: SharedSpacingTokens.homeChipVerticalPadding,
        style: AppTextStyles.micro,
      ),
      VitStatusPillSize.md => _AccentPillMetrics(
        minHeight: AppSurfaceSpacing.statusPillHeightMd,
        paddingX: AppSurfaceSpacing.statusPillHorizontalPaddingMd,
        paddingY: AppSurfaceSpacing.x1,
        style: AppTextStyles.navLabel,
      ),
      VitStatusPillSize.lg => _AccentPillMetrics(
        minHeight: AppSurfaceSpacing.statusPillHeightLg,
        paddingX: AppSurfaceSpacing.statusPillHorizontalPaddingLg,
        paddingY: AppSurfaceSpacing.x2,
        style: AppTextStyles.navLabel,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics;
    return Semantics(
      label: semanticStatus == null ? label : '$label ${semanticStatus!.name}',
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: metrics.minHeight),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: accentColor.withValues(alpha: backgroundAlpha ?? .14),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: accentColor.withValues(alpha: .26)),
              borderRadius: radiusOverride ?? AppRadii.pillRadius,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: metrics.paddingX,
              vertical: metrics.paddingY,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: metrics.style.copyWith(
                color: accentColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccentPillMetrics {
  const _AccentPillMetrics({
    required this.minHeight,
    required this.paddingX,
    required this.paddingY,
    required this.style,
  });

  final double minHeight;
  final double paddingX;
  final double paddingY;
  final TextStyle style;
}
