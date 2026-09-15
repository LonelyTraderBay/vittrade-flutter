import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_confirm_dialog.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

/// Bottom-sheet twin của [showVitConfirmDialog] — cùng tham số, cùng hợp
/// đồng await (true chỉ khi bấm xác nhận). Trên **tablet surface** mọi
/// popup đều phải là bottom sheet (Bottom-Sheet-Standard "Dialog vs
/// Sheet"): confirm bảo mật/tài chính dùng API này thay vì dialog căn
/// giữa; phone giữ `showVitConfirmDialog`. Rows tái dùng
/// [VitConfirmDialogRow] để call site đổi API mà không đổi dữ liệu.
Future<bool> showVitConfirmSheet({
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
  final confirmed = await showVitBottomSheet<bool>(
    context: context,
    // Tier của panel chỉ hiệu lực khi modal không bị kẹp 9/16 màn hình.
    isScrollControlled: true,
    builder: (sheetContext) => VitSheetPanel(
      title: title,
      footer: Row(
        children: [
          Expanded(
            child: VitCtaButton(
              key: cancelKey,
              onPressed: () => Navigator.of(sheetContext).pop(false),
              variant: VitCtaButtonVariant.secondary,
              child: Text(cancelLabel),
            ),
          ),
          // AppSurfaceSpacing.x3 là getter (không const được).
          SizedBox(width: AppSurfaceSpacing.x3),
          Expanded(
            child: VitCtaButton(
              key: confirmKey,
              onPressed: () => Navigator.of(sheetContext).pop(true),
              variant: confirmVariant,
              child: Text(confirmLabel),
            ),
          ),
        ],
      ),
      child: Column(
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
    ),
  );

  return confirmed ?? false;
}
