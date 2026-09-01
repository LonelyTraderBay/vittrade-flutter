import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

/// A single label/value row inside a [showVitConfirmDialog] body.
class VitConfirmDialogRow {
  const VitConfirmDialogRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

/// Shared confirm-before-apply dialog for security/financial-relevant
/// settings changes (see AGENTS.md: "Preview and confirm... security
/// changes"). Modeled on the AlertDialog already used in
/// `p2p_payment_method_add_page.dart`'s `_confirmSave`. Returns `true` only
/// when the user taps the confirm action; `false`/`null` otherwise (Cancel,
/// dismiss, or the context is unmounted by the time the dialog resolves).
Future<bool> showVitConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  List<VitConfirmDialogRow> rows = const [],
  String confirmLabel = 'Xác nhận',
  String cancelLabel = 'Hủy',
  VitCtaButtonVariant confirmVariant = VitCtaButtonVariant.primary,
  Key? confirmKey,
  Key? cancelKey,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      title: Text(
        title,
        style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final row in rows)
            Padding(
              padding: EdgeInsetsDirectional.only(bottom: AppSurfaceSpacing.x2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      row.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.caption.copyWith(
                        color: row.valueColor ?? AppColors.text1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (message != null) ...[
            if (rows.isNotEmpty)
              SizedBox(height: AppSurfaceSpacing.pageRhythmStandardInnerGap),
            Text(
              message,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ],
      ),
      actions: [
        VitCtaButton(
          key: cancelKey,
          onPressed: () => Navigator.of(dialogContext).pop(false),
          variant: VitCtaButtonVariant.secondary,
          fullWidth: false,
          height: AppSurfaceSpacing.buttonCompact,
          child: Text(cancelLabel),
        ),
        VitCtaButton(
          key: confirmKey,
          onPressed: () => Navigator.of(dialogContext).pop(true),
          variant: confirmVariant,
          fullWidth: false,
          height: AppSurfaceSpacing.buttonCompact,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
