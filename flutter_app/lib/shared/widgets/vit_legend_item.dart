import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Shape of the color swatch rendered by [VitLegendItem].
enum VitLegendSwatchShape {
  /// Filled circle (default; matches original legend visuals).
  circle,

  /// Filled square / rounded-square, using [VitLegendItem.swatchRadius].
  square,

  /// Short horizontal dash, useful for line-chart legends.
  dash,
}

/// Color-swatch + label row for chart / allocation legends.
class VitLegendItem extends StatelessWidget {
  const VitLegendItem({
    super.key,
    required this.color,
    required this.label,
    this.swatchSize,
    this.dotSize,
    this.maxWidth,
    this.shape = VitLegendSwatchShape.circle,
    this.swatchRadius,
    this.value,
  });

  final Color color;
  final String label;

  /// Preferred size of the color swatch. Falls back to [dotSize], then
  /// [AppSurfaceSpacing.x3].
  final double? swatchSize;

  /// Alias used by existing chart legends; same as [swatchSize].
  final double? dotSize;
  final double? maxWidth;

  /// Shape of the swatch. Defaults to [VitLegendSwatchShape.circle] to
  /// preserve pre-existing legend visuals.
  final VitLegendSwatchShape shape;

  /// Corner radius used when [shape] is [VitLegendSwatchShape.square].
  /// Defaults to [AppRadii.xsRadius].
  final BorderRadius? swatchRadius;

  /// Optional second line rendered below [label] (e.g. a numeric value),
  /// producing a 2-line legend item.
  final String? value;

  double get _resolvedSwatch => swatchSize ?? dotSize ?? AppSurfaceSpacing.x3;

  Widget _buildSwatch(double size) {
    switch (shape) {
      case VitLegendSwatchShape.circle:
        return DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: const CircleBorder(),
          ),
          child: SizedBox(width: size, height: size),
        );
      case VitLegendSwatchShape.square:
        return DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: swatchRadius ?? AppRadii.xsRadius,
            ),
          ),
          child: SizedBox(width: size, height: size),
        );
      case VitLegendSwatchShape.dash:
        return DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: swatchRadius ?? AppRadii.xsRadius,
            ),
          ),
          child: SizedBox(width: size * 2, height: size / 2),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = _resolvedSwatch;
    final labelColumn = value == null
        ? Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          );

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSwatch(size),
        SizedBox(width: AppSurfaceSpacing.x2),
        Flexible(child: labelColumn),
      ],
    );

    if (maxWidth == null) return row;
    return SizedBox(width: maxWidth, child: row);
  }
}
