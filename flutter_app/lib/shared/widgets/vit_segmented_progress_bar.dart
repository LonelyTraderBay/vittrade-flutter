import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';

/// Row of [segmentCount] equal pill segments with the leading [filledCount]
/// segments highlighted — a **discrete** step/strength meter.
///
/// This is a distinct shape from [VitProgressBar] (a single continuous
/// track driven by a `0..1` value) and is unrelated to the interactive
/// segment-pill family (`VitSegmentedChoice`, `VitTabBar.segment`,
/// `VitFilterChip`, …) covered by the Segment-Pill Standard — this widget
/// is display-only and takes no `onTap` / `onChanged`.
///
/// Use for OTP-digit-entry progress, password-strength meters, or any
/// other "N equal slots, first K filled" indicator.
class VitSegmentedProgressBar extends StatelessWidget {
  const VitSegmentedProgressBar({
    super.key,
    required this.segmentCount,
    required this.filledCount,
    this.filledColor = AppColors.primary,
    this.unfilledColor = AppColors.borderSolid,
    this.height,
    this.gap,
    this.borderRadius,
  }) : assert(segmentCount > 0, 'segmentCount must be positive');

  /// Total number of segments rendered in the row.
  final int segmentCount;

  /// Number of leading segments rendered with [filledColor]. Clamped to
  /// `[0, segmentCount]`.
  final int filledCount;

  /// Fill color for the leading [filledCount] segments.
  final Color filledColor;

  /// Fill color for the remaining (unfilled) segments.
  final Color unfilledColor;

  /// Segment track height.
  final double? height;

  /// Horizontal gap between adjacent segments.
  final double? gap;

  /// Corner radius for each segment. Defaults to [AppRadii.pillRadius].
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final filled = filledCount.clamp(0, segmentCount);
    final radius = borderRadius ?? AppRadii.pillRadius;
    final resolvedHeight = height ?? AppSurfaceSpacing.x1;
    final resolvedGap = gap ?? AppSurfaceSpacing.x2;

    return Row(
      children: [
        for (var index = 0; index < segmentCount; index++) ...[
          if (index > 0) SizedBox(width: resolvedGap),
          Expanded(
            child: ClipRRect(
              borderRadius: radius,
              child: ColoredBox(
                color: index < filled ? filledColor : unfilledColor,
                child: SizedBox(height: resolvedHeight),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
