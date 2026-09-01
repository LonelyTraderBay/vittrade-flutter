import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_financial_safety_summary.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

/// Preview + confirm bottom sheet for financial / security mutations
/// (see AGENTS.md). Returns `true` only when the user confirms.
Future<bool> showVitPreviewConfirmSheet({
  required BuildContext context,
  required String title,
  required List<VitFinancialSafetyItem> items,
  String summaryTitle = 'Xem lại trước khi xác nhận',
  String? contractId,
  String? footer,
  String confirmLabel = 'Xác nhận',
  String cancelLabel = 'Hủy',
  VitCtaButtonVariant confirmVariant = VitCtaButtonVariant.primary,
  Key? confirmKey,
  Key? cancelKey,
  Key? sheetKey,
}) async {
  assert(items.isNotEmpty, 'Preview sheet requires at least one safety row.');

  final confirmed = await showVitBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => VitSheetPanel(
      title: title,
      child: KeyedSubtree(
        key: sheetKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitFinancialSafetySummary(
              title: summaryTitle,
              items: items,
              contractId: contractId,
              footer: footer,
              density: VitDensity.compact,
            ),
            SizedBox(height: AppSurfaceSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: VitCtaButton(
                    key: cancelKey,
                    density: VitDensity.compact,
                    variant: VitCtaButtonVariant.secondary,
                    onPressed: () => Navigator.of(sheetContext).pop(false),
                    child: Text(cancelLabel),
                  ),
                ),
                SizedBox(width: AppSurfaceSpacing.x3),
                Expanded(
                  child: VitCtaButton(
                    key: confirmKey,
                    density: VitDensity.compact,
                    variant: confirmVariant,
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                    child: Text(confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  return confirmed ?? false;
}
