import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Compact label-over-value metric tile for stat grids.
///
/// Not to be confused with [VitMetricCard], which renders a horizontal
/// accent-bar row (label + value + optional trailing widget). [VitMetricBox]
/// is a plain [VitCardVariant.inner] surface stacking a micro label above a
/// bold value, optionally left-aligned instead of centered.
class VitMetricBox extends StatelessWidget {
  const VitMetricBox({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.alignLeft = false,
    this.radius = VitCardRadius.standard,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignLeft;
  final VitCardRadius radius;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      radius: radius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          SizedBox(height: AppSurfaceSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
