import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_icon_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

/// Color/tone treatment of a [VitBanner].
enum VitBannerVariant { info, warning, error, success }

/// Shows [title]/[message] as a [VitBanner] inside the shared bottom sheet
/// chrome ([showVitBottomSheet] + [VitSheetPanel]). Use this instead of a
/// hand-rolled scrim overlay or a bare [ScaffoldMessenger] SnackBar for any
/// notice that needs the user's acknowledgement.
///
/// Optional [secondaryLabel] adds a full-width ghost CTA above the primary
/// button (stacked sheet layout). [ctaVariant] defaults to
/// [VitCtaButtonVariant.primary] for existing call sites; pass
/// [VitCtaButtonVariant.success] for trade-success flows.
/// When [secondaryPressedLabel] is set, the secondary button label switches
/// after tap.
Future<void> showVitNoticeSheet({
  required BuildContext context,
  required String title,
  required String message,
  VitBannerVariant variant = VitBannerVariant.info,
  String ctaLabel = 'Đã hiểu',
  VitCtaButtonVariant ctaVariant = VitCtaButtonVariant.primary,
  VoidCallback? onPrimary,
  Key? primaryKey,
  String? secondaryLabel,
  String? secondaryPressedLabel,
  VoidCallback? onSecondary,
  Key? secondaryKey,
  bool isDismissible = true,
}) {
  return showVitBottomSheet<void>(
    context: context,
    isDismissible: isDismissible,
    builder: (sheetContext) {
      var secondaryPressed = false;
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final secondaryText =
              secondaryPressed && secondaryPressedLabel != null
              ? secondaryPressedLabel
              : secondaryLabel;
          return VitSheetPanel(
            title: title,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VitBanner(variant: variant, message: message),
                SizedBox(height: AppSurfaceSpacing.x4),
                if (secondaryText != null) ...[
                  VitCtaButton(
                    key: secondaryKey,
                    variant: VitCtaButtonVariant.ghost,
                    density: VitDensity.compact,
                    onPressed: () {
                      onSecondary?.call();
                      if (secondaryPressedLabel != null) {
                        setSheetState(() => secondaryPressed = true);
                      }
                    },
                    child: Text(secondaryText),
                  ),
                  SizedBox(height: AppSurfaceSpacing.x3),
                ],
                VitCtaButton(
                  key: primaryKey,
                  variant: ctaVariant,
                  density: VitDensity.compact,
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    onPrimary?.call();
                  },
                  child: Text(ctaLabel),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// General-purpose tone-colored inline banner: icon, optional title,
/// message, detail line, optional action slot, and dismiss button.
class VitBanner extends StatelessWidget {
  const VitBanner({
    super.key,
    required this.variant,
    required this.message,
    this.icon,
    this.title,
    this.detail,
    this.onDismiss,
    this.action,
  });

  final VitBannerVariant variant;
  final String message;
  final IconData? icon;

  /// Optional bold headline shown above [message]. When set, [message]
  /// renders as a secondary line instead of the single-line banner style.
  final String? title;
  final String? detail;

  /// Trailing dismiss control (e.g. replacing a manually-closed toast).
  final VoidCallback? onDismiss;

  /// Optional content below the text, e.g. a CTA button.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final palette = switch (variant) {
      VitBannerVariant.info => _BannerPalette.info,
      VitBannerVariant.warning => _BannerPalette.warning,
      VitBannerVariant.error => _BannerPalette.error,
      VitBannerVariant.success => _BannerPalette.success,
    };
    final hasMultiline = detail != null || title != null;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: palette.background,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: palette.border),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppSurfaceSpacing.x4,
          vertical: AppSurfaceSpacing.x2 + AppSurfaceSpacing.x2,
        ),
        child: Row(
          crossAxisAlignment: hasMultiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: palette.foreground, size: 16),
              SizedBox(width: AppSurfaceSpacing.x3),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  Text(
                    message,
                    style: title == null
                        ? AppTextStyles.caption.copyWith(
                            color: palette.foreground,
                            fontWeight: AppTextStyles.medium,
                          )
                        : AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                  ),
                  if (detail != null) ...[
                    SizedBox(height: AppSurfaceSpacing.x1),
                    Text(
                      detail!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                  if (action != null) ...[
                    SizedBox(height: AppSurfaceSpacing.x3),
                    action!,
                  ],
                ],
              ),
            ),
            if (onDismiss != null) ...[
              SizedBox(width: AppSurfaceSpacing.x3),
              VitIconButton(
                onPressed: onDismiss,
                icon: Icons.close_rounded,
                tooltip: 'Dismiss',
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.sm,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BannerPalette {
  const _BannerPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  static const success = _BannerPalette(
    background: AppColors.buy15,
    foreground: AppColors.buy,
    border: AppColors.buy20,
  );

  static const info = _BannerPalette(
    background: AppColors.primary08,
    foreground: AppColors.primary,
    border: AppColors.primary20,
  );

  static const warning = _BannerPalette(
    background: AppColors.riskWarning08,
    foreground: AppColors.riskWarning,
    border: AppColors.warningBorder,
  );

  static const error = _BannerPalette(
    background: AppColors.sell10,
    foreground: AppColors.sell,
    border: AppColors.sell20,
  );

  final Color background;
  final Color foreground;
  final Color border;
}
