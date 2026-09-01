import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Label/value row (optional leading/trailing widgets, divider, tap
/// handler) used for key-value detail lists.
class VitInfoRow extends StatelessWidget {
  const VitInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.leading,
    this.trailing,
    this.valueColor,
    this.density = VitDensity.standard,
    this.showDivider = false,
    this.onTap,
  });

  final String label;
  final String value;
  final Widget? leading;
  final Widget? trailing;
  final Color? valueColor;
  final VitDensity density;
  final bool showDivider;
  final VoidCallback? onTap;

  bool get _isCompact =>
      density == VitDensity.compact || density == VitDensity.tool;

  EdgeInsetsGeometry get _padding {
    return EdgeInsetsDirectional.symmetric(
      horizontal: _isCompact ? AppSurfaceSpacing.x3 : AppSurfaceSpacing.x4,
      vertical: _isCompact ? AppSurfaceSpacing.x2 : AppSurfaceSpacing.x3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: density.controlHeight),
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            if (leading != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: AppColors.text2,
                  size: _isCompact
                      ? AppSurfaceSpacing.iconSm
                      : AppSurfaceSpacing.iconMd,
                ),
                child: leading!,
              ),
              SizedBox(
                width: _isCompact ? AppSurfaceSpacing.x2 : AppSurfaceSpacing.x3,
              ),
            ],
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            SizedBox(width: AppSurfaceSpacing.x3),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: (_isCompact ? AppTextStyles.caption : AppTextStyles.body)
                    .copyWith(
                      color: valueColor ?? AppColors.text1,
                      fontWeight: AppTextStyles.medium,
                    ),
              ),
            ),
            if (trailing != null) ...[
              SizedBox(
                width: _isCompact ? AppSurfaceSpacing.x2 : AppSurfaceSpacing.x3,
              ),
              trailing!,
            ],
          ],
        ),
      ),
    );

    final content = showDivider
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              row,
              Divider(
                height: AppSurfaceSpacing.dividerHairline,
                thickness: AppSurfaceSpacing.dividerHairline,
                color: AppColors.border,
              ),
            ],
          )
        : row;

    final interactive = onTap == null
        ? content
        : Material(
            type: MaterialType.transparency,
            child: InkWell(onTap: onTap, child: content),
          );

    return Semantics(
      container: true,
      excludeSemantics: true,
      button: onTap != null,
      label: '$label, $value',
      child: interactive,
    );
  }
}
