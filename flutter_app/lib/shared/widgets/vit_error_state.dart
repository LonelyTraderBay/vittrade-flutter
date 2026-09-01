import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

/// Centered error placeholder: icon, title, message, and optional
/// retry/secondary action buttons.
class VitErrorState extends StatelessWidget {
  const VitErrorState({
    super.key,
    this.title = 'Đã xảy ra lỗi',
    this.message = 'Vui lòng thử lại hoặc kiểm tra kết nối.',
    this.icon = Icons.warning_amber_rounded,
    this.iconContainerSize,
    this.iconSize,
    this.iconShape = BoxShape.rectangle,
    this.iconBorderRadius,
    this.verticalPadding,
    this.horizontalPadding,
    this.titleStyle,
    this.messageStyle,
    this.actionLabel = 'Thử lại',
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final IconData icon;
  final double? iconContainerSize;
  final double? iconSize;
  final BoxShape iconShape;
  final BorderRadius? iconBorderRadius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final String actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final resolvedIconContainerSize =
        iconContainerSize ??
        AppSurfaceSpacing.buttonStandard +
            AppSurfaceSpacing.contentPad +
            AppSurfaceSpacing.x2;
    final resolvedIconSize =
        iconSize ?? AppSurfaceSpacing.iconLg + AppSurfaceSpacing.hairlineStroke;
    final resolvedVerticalPadding =
        verticalPadding ??
        AppSurfaceSpacing.buttonStandard +
            AppSurfaceSpacing.x3 +
            AppSurfaceSpacing.dividerHairline;
    final resolvedHorizontalPadding = horizontalPadding ?? AppSurfaceSpacing.x6;
    final iconShapeBorder = iconShape == BoxShape.circle
        ? const CircleBorder(side: BorderSide(color: AppColors.sell20))
        : RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.sell20),
            borderRadius: iconBorderRadius ?? AppRadii.cardLargeRadius,
          );

    return Semantics(
      container: true,
      liveRegion: true,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: resolvedHorizontalPadding,
          vertical: resolvedVerticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: resolvedIconContainerSize,
              height: resolvedIconContainerSize,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: AppColors.sell10,
                  shape: iconShapeBorder,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: AppColors.sell,
                    size: resolvedIconSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSurfaceSpacing.x4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle ?? AppTextStyles.baseMedium,
            ),
            SizedBox(height: AppSurfaceSpacing.x2),
            Text(
              message,
              textAlign: TextAlign.center,
              style: messageStyle ?? AppTextStyles.caption,
            ),
            if (onAction != null) ...[
              SizedBox(height: AppSurfaceSpacing.x4),
              VitCtaButton(
                onPressed: onAction,
                variant: VitCtaButtonVariant.danger,
                fullWidth: false,
                height: AppSurfaceSpacing.inputHeight - AppSurfaceSpacing.x3,
                leading: const Icon(Icons.refresh_rounded),
                child: Text(actionLabel),
              ),
            ],
            if (secondaryLabel != null && onSecondary != null) ...[
              SizedBox(height: AppSurfaceSpacing.x3),
              VitCtaButton(
                onPressed: onSecondary,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                height: AppSurfaceSpacing.inputHeight - AppSurfaceSpacing.x3,
                child: Text(secondaryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
