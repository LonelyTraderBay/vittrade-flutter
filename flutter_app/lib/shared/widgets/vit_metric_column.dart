import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Text style tier for [VitMetricColumn]'s value line.
enum VitMetricValueStyle { caption, numericCode, sectionTitle }

/// Bare label/value column meant to be embedded directly inside a
/// Row/Expanded that the caller already builds — unlike [VitStatsGrid],
/// which self-cards and owns its own Row, this widget has no card or
/// background of its own.
class VitMetricColumn extends StatelessWidget {
  const VitMetricColumn({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.valueStyle = VitMetricValueStyle.caption,
    this.align = CrossAxisAlignment.start,
    this.gap,
    this.ellipsizeValue = true,
  });

  final String label;
  final String value;
  final Color valueColor;
  final VitMetricValueStyle valueStyle;
  final CrossAxisAlignment align;
  final double? gap;
  final bool ellipsizeValue;

  TextStyle get _resolvedValueStyle {
    switch (valueStyle) {
      case VitMetricValueStyle.caption:
        return AppTextStyles.caption;
      case VitMetricValueStyle.numericCode:
        return AppTextStyles.numericCode;
      case VitMetricValueStyle.sectionTitle:
        return AppTextStyles.sectionTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedGap = gap ?? AppSurfaceSpacing.pageRhythmCompactInnerGap;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        SizedBox(height: resolvedGap),
        Text(
          value,
          maxLines: ellipsizeValue ? 1 : null,
          overflow: ellipsizeValue
              ? TextOverflow.ellipsis
              : TextOverflow.visible,
          style: _resolvedValueStyle.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
