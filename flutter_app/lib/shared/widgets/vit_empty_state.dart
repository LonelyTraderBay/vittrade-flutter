import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

/// Centered "nothing here" placeholder: icon, title, optional
/// message/secondary message, and optional action button.
class VitEmptyState extends StatelessWidget {
  const VitEmptyState({
    super.key,
    required this.title,
    this.message,
    this.secondaryMessage,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.actionKey,
    this.onAction,
    this.density = VitDensity.standard,
  });

  final String title;
  final String? message;
  final String? secondaryMessage;
  final IconData icon;
  final String? actionLabel;
  final Key? actionKey;
  final VoidCallback? onAction;

  /// [VitDensity.compact] renders the icon bare (no boxed container), tightens
  /// the icon-to-title gap, and downshifts the title to a caption-style line.
  /// All other densities keep the original full-page boxed-icon look.
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    final compact = density == VitDensity.compact;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppSurfaceSpacing.x6,
          vertical:
              AppSurfaceSpacing.buttonStandard +
              AppSurfaceSpacing.x3 +
              AppSurfaceSpacing.dividerHairline,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (compact)
              Icon(
                icon,
                color: AppColors.borderSolid,
                size: AppSurfaceSpacing.iconLg,
              )
            else
              SizedBox(
                width:
                    AppSurfaceSpacing.buttonStandard +
                    AppSurfaceSpacing.contentPad +
                    AppSurfaceSpacing.x2,
                height:
                    AppSurfaceSpacing.buttonStandard +
                    AppSurfaceSpacing.contentPad +
                    AppSurfaceSpacing.x2,
                child: DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.borderSolid),
                      borderRadius: AppRadii.cardLargeRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: AppColors.borderSolid,
                      size:
                          AppSurfaceSpacing.iconLg +
                          AppSurfaceSpacing.hairlineStroke,
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: compact
                  ? AppSurfaceSpacing.pageRhythmCompactInnerGap
                  : AppSurfaceSpacing.x4,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: compact
                  ? AppTextStyles.caption.copyWith(color: AppColors.text3)
                  : AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
            ),
            if (message != null) ...[
              SizedBox(height: AppSurfaceSpacing.x2),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
            if (secondaryMessage != null) ...[
              SizedBox(height: AppSurfaceSpacing.x1),
              Text(
                secondaryMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSurfaceSpacing.x4),
              VitCtaButton(
                key: actionKey,
                onPressed: onAction,
                fullWidth: false,
                height: AppSurfaceSpacing.inputHeight - AppSurfaceSpacing.x3,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
