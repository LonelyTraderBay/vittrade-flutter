import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Compact label/value row used in receipts, confirm previews, and history
/// detail panels. Prefer this over local `_DetailRow` / `_KeyValueRow`.
///
/// For denser list rows with optional leading/trailing chrome, use
/// [VitInfoRow] instead.
class VitKeyValueRow extends StatelessWidget {
  const VitKeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.labelWidth,
    this.padding,
    this.labelStyle,
    this.valueStyle,
    this.valueMaxLines,
    this.valueOverflow,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final double? labelWidth;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  /// Optional line clamp for [value]. Defaults to unlimited (null), matching
  /// prior behavior. Pass `1` for local `_DetailRow`/`_SheetRow`-style
  /// ellipsizing rows.
  final int? valueMaxLines;

  /// Optional overflow behavior for [value]. Defaults to null (no clipping),
  /// matching prior behavior.
  final TextOverflow? valueOverflow;

  @override
  Widget build(BuildContext context) {
    final resolvedLabelStyle =
        labelStyle ?? AppTextStyles.caption.copyWith(color: AppColors.text3);
    final resolvedValueStyle =
        valueStyle ??
        AppTextStyles.caption.copyWith(
          color: valueColor ?? AppColors.text1,
          fontWeight: AppTextStyles.medium,
        );

    final labelWidget = Text(
      label,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: resolvedLabelStyle,
    );

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelWidth != null)
            SizedBox(width: labelWidth, child: labelWidget)
          else
            Expanded(child: labelWidget),
          SizedBox(width: AppSurfaceSpacing.x3),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: valueMaxLines,
              overflow: valueOverflow,
              style: resolvedValueStyle,
            ),
          ),
        ],
      ),
    );
  }
}
