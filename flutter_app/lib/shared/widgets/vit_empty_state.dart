import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
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
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x6,
          vertical:
              AppSpacing.buttonStandard +
              AppSpacing.x3 +
              AppSpacing.dividerHairline,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (compact)
              Icon(icon, color: AppColors.borderSolid, size: AppSpacing.iconLg)
            else
              SizedBox(
                width:
                    AppSpacing.buttonStandard +
                    AppSpacing.contentPad +
                    AppSpacing.x2,
                height:
                    AppSpacing.buttonStandard +
                    AppSpacing.contentPad +
                    AppSpacing.x2,
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
                      size: AppSpacing.iconLg + AppSpacing.hairlineStroke,
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: compact
                  ? AppSpacing.pageRhythmCompactInnerGap
                  : AppSpacing.x4,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: compact
                  ? AppTextStyles.caption.copyWith(color: AppColors.text3)
                  : AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.x2),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
            if (secondaryMessage != null) ...[
              const SizedBox(height: AppSpacing.x1),
              Text(
                secondaryMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.x4),
              VitCtaButton(
                key: actionKey,
                onPressed: onAction,
                fullWidth: false,
                height: AppSpacing.inputHeight - AppSpacing.x3,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
