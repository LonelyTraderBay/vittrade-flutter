import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

class VitTradeConfirmKeys {
  VitTradeConfirmKeys._();

  static const confirmSheet = Key('sc048_trade_confirm_sheet');
  static const confirmSubmit = Key('sc048_trade_confirm_submit');
  static const confirmCancel = Key('sc048_trade_confirm_cancel');
}

class VitTradeConfirmLine {
  const VitTradeConfirmLine({required this.label, required this.value});

  final String label;
  final String value;
}

/// Financial safety: preview order details before submission.
Future<bool> showVitTradeConfirmSheet({
  required BuildContext context,
  required String title,
  required List<VitTradeConfirmLine> lines,
  String riskMessage =
      'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất.',
  Key? confirmKey,
  Key? cancelKey,
}) async {
  final result = await showVitBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    barrierColor: AppColors.modalScrim,
    builder: (context) => VitTradeConfirmSheet(
      key: VitTradeConfirmKeys.confirmSheet,
      title: title,
      lines: lines,
      riskMessage: riskMessage,
      confirmKey: confirmKey ?? VitTradeConfirmKeys.confirmSubmit,
      cancelKey: cancelKey ?? VitTradeConfirmKeys.confirmCancel,
    ),
  );
  return result ?? false;
}

class VitTradeConfirmSheet extends StatelessWidget {
  const VitTradeConfirmSheet({
    super.key,
    required this.title,
    required this.lines,
    required this.riskMessage,
    required this.confirmKey,
    required this.cancelKey,
  });

  final String title;
  final List<VitTradeConfirmLine> lines;
  final String riskMessage;
  final Key confirmKey;
  final Key cancelKey;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: title,
      child: ListView(
        shrinkWrap: true,
        children: [
          for (var i = 0; i < lines.length; i++)
            VitInfoRow(
              label: lines[i].label,
              value: lines[i].value,
              density: VitDensity.tool,
              showDivider: i < lines.length - 1,
            ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            density: VitDensity.tool,
            borderColor: AppColors.warn.withValues(alpha: .22),
            child: Text(
              riskMessage,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Huỷ xem trước lệnh giao dịch',
                  child: VitCtaButton(
                    key: cancelKey,
                    variant: VitCtaButtonVariant.secondary,
                    density: VitDensity.tool,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Huỷ'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Xác nhận gửi lệnh giao dịch',
                  child: VitCtaButton(
                    key: confirmKey,
                    density: VitDensity.tool,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Xác nhận gửi'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
