import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Placement of the label row relative to the progress track in
/// [VitProgressBar].
enum VitProgressBarHeaderPosition {
  /// Label row renders above the progress track (default).
  above,

  /// Label row renders below the progress track.
  below,
}

/// Labeled linear progress track (0–1). Prefer [progress] for all call sites.
class VitProgressBar extends StatelessWidget {
  const VitProgressBar({
    super.key,
    required this.progress,
    this.label,
    this.trailingLabel,
    this.color = AppColors.primary,
    this.trackColor = AppColors.surface2,
    this.height,
    this.gap,
    this.borderRadius,
    this.headerPosition = VitProgressBarHeaderPosition.above,
  });

  /// Progress in \[0, 1\]. Values outside the range are clamped.
  final double progress;
  final String? label;
  final String? trailingLabel;
  final Color color;
  final Color trackColor;
  final double? height;
  final double? gap;
  final BorderRadiusGeometry? borderRadius;

  /// Whether the label row renders above or below the progress track.
  final VitProgressBarHeaderPosition headerPosition;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final hasHeader = label != null || trailingLabel != null;
    final radius = borderRadius ?? AppRadii.lgRadius;
    final resolvedHeight = height ?? AppSurfaceSpacing.x2;
    final resolvedGap = gap ?? AppSurfaceSpacing.x2;

    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (label != null)
          Expanded(
            child: Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          )
        else
          const Spacer(),
        if (trailingLabel != null)
          Text(
            trailingLabel!,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
      ],
    );

    final track = ClipRRect(
      borderRadius: radius,
      child: LinearProgressIndicator(
        minHeight: resolvedHeight,
        value: clamped,
        backgroundColor: trackColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: headerPosition == VitProgressBarHeaderPosition.above
          ? [
              if (hasHeader) ...[header, SizedBox(height: resolvedGap)],
              track,
            ]
          : [
              track,
              if (hasHeader) ...[SizedBox(height: resolvedGap), header],
            ],
    );
  }
}
