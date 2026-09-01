import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Small centered pill used as the drag-handle indicator at the top of a
/// bottom sheet.
class VitSheetHandle extends StatelessWidget {
  const VitSheetHandle({
    super.key,
    this.width = SharedSpacingTokens.homeMoreProductsSheetHandleWidth,
    this.height = SharedSpacingTokens.homeMoreProductsSheetHandleHeight,
    this.color = AppColors.borderSolid,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.pillRadius,
            ),
          ),
        ),
      ),
    );
  }
}

/// Standard bottom sheet body chrome: drag handle, title, and a
/// height-clamped, flexible content area for [child].
class VitSheetPanel extends StatelessWidget {
  const VitSheetPanel({
    super.key,
    required this.title,
    required this.child,
    this.maxHeightFactor,
  });

  final String title;
  final Widget child;
  final double? maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    final resolvedMaxHeightFactor =
        maxHeightFactor ?? AppSurfaceSpacing.sheetPanelMaxHeightFactor;
    final maxHeight =
        MediaQuery.sizeOf(context).height * resolvedMaxHeightFactor;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: SharedSpacingTokens.homeMoreProductsSheetPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VitSheetHandle(),
              SizedBox(height: AppSurfaceSpacing.x4),
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              SizedBox(height: AppSurfaceSpacing.x4),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded-top colored surface (padding + top corner radius) used as a
/// bottom sheet's outer container.
class VitSheetSurface extends StatelessWidget {
  const VitSheetSurface({
    super.key,
    required this.child,
    this.padding = SharedSpacingTokens.homeMoreProductsSheetPadding,
    this.color = AppColors.bg,
    this.borderRadius = AppRadii.sheetTopLargeRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
