import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

/// Centered error placeholder: icon, title, message, and optional
/// retry/secondary action buttons.
class VitErrorState extends StatelessWidget {
  const VitErrorState({
    super.key,
    this.title = 'Đã xảy ra lỗi',
    this.message = 'Vui lòng thử lại hoặc kiểm tra kết nối.',
    this.icon = Icons.warning_amber_rounded,
    this.iconContainerSize =
        AppSpacing.buttonStandard + AppSpacing.contentPad + AppSpacing.x2,
    this.iconSize = AppSpacing.iconLg + AppSpacing.hairlineStroke,
    this.iconShape = BoxShape.rectangle,
    this.iconBorderRadius,
    this.verticalPadding =
        AppSpacing.buttonStandard + AppSpacing.x3 + AppSpacing.dividerHairline,
    this.horizontalPadding = AppSpacing.x6,
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
  final double iconContainerSize;
  final double iconSize;
  final BoxShape iconShape;
  final BorderRadius? iconBorderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final String actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
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
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: iconContainerSize,
              height: iconContainerSize,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: AppColors.sell10,
                  shape: iconShapeBorder,
                ),
                child: Center(
                  child: Icon(icon, color: AppColors.sell, size: iconSize),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle ?? AppTextStyles.baseMedium,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              message,
              textAlign: TextAlign.center,
              style: messageStyle ?? AppTextStyles.caption,
            ),
            if (onAction != null) ...[
              const SizedBox(height: AppSpacing.x4),
              VitCtaButton(
                onPressed: onAction,
                variant: VitCtaButtonVariant.danger,
                fullWidth: false,
                height: AppSpacing.inputHeight - AppSpacing.x3,
                leading: const Icon(Icons.refresh_rounded),
                child: Text(actionLabel),
              ),
            ],
            if (secondaryLabel != null && onSecondary != null) ...[
              const SizedBox(height: AppSpacing.x3),
              VitCtaButton(
                onPressed: onSecondary,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                height: AppSpacing.inputHeight - AppSpacing.x3,
                child: Text(secondaryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
