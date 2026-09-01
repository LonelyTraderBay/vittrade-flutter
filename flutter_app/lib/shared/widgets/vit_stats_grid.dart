import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// One label/value cell rendered by [VitStatsGrid].
class VitStatCell {
  const VitStatCell({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueStyle,
  });

  final String label;
  final String value;
  final Color? valueColor;

  /// Overrides the default [AppTextStyles.sectionTitle] value style.
  final TextStyle? valueStyle;
}

/// Horizontal row of equal-width label/value cells inside one card.
class VitStatsGrid extends StatelessWidget {
  const VitStatsGrid({
    super.key,
    required this.cells,
    this.padding,
    this.gap,
    this.radius = VitCardRadius.large,
    this.cellBackground = false,
    this.dividers = false,
  });

  final List<VitStatCell> cells;
  final EdgeInsetsGeometry? padding;
  final double? gap;
  final VitCardRadius radius;

  /// When true, wraps each cell in its own [AppColors.surface2] tile.
  final bool cellBackground;

  /// When true, separates cells with a [VerticalDivider] instead of a bare
  /// gap.
  final bool dividers;

  @override
  Widget build(BuildContext context) {
    assert(cells.isNotEmpty, 'VitStatsGrid requires at least one cell.');
    final resolvedGap = gap ?? AppSurfaceSpacing.x3;

    return VitCard(
      radius: radius,
      padding: padding ?? EdgeInsetsDirectional.all(AppSurfaceSpacing.x4),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i > 0)
              dividers
                  ? SizedBox(
                      height: AppSurfaceSpacing.x6,
                      child: VerticalDivider(
                        width: resolvedGap,
                        color: AppColors.divider,
                      ),
                    )
                  : SizedBox(width: resolvedGap),
            Expanded(
              child: _Cell(cell: cells[i], background: cellBackground),
            ),
          ],
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.cell, this.background = false});

  final VitStatCell cell;
  final bool background;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            cell.value,
            style: (cell.valueStyle ?? AppTextStyles.sectionTitle).copyWith(
              color: cell.valueColor ?? AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        SizedBox(height: AppSurfaceSpacing.x1),
        Text(
          cell.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );

    if (!background) {
      return content;
    }

    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSurfaceSpacing.x3,
          vertical: AppSurfaceSpacing.x3,
        ),
        child: content,
      ),
    );
  }
}
