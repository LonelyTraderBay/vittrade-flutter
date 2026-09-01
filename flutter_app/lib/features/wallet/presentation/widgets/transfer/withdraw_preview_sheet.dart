import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class WithdrawPreviewSheet extends StatelessWidget {
  const WithdrawPreviewSheet({required this.preview, super.key});

  final WithdrawPreview preview;

  @override
  Widget build(BuildContext context) {
    // Confirm sheets prefer calmer density than the compact form (craft #6).
    const confirmDensity = VitDensity.standard;

    return VitSheetPanel(
      title: 'Xác nhận rút tiền',
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSurfaceSpacing.x4,
              vertical: AppSurfaceSpacing.x3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Số lượng',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    preview.amountLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.amountSm.copyWith(
                      color: AppColors.text1,
                      fontFeatures: AppTextStyles.tabularFigures,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: AppSurfaceSpacing.dividerHairline,
            thickness: AppSurfaceSpacing.dividerHairline,
            color: AppColors.border,
          ),
          VitInfoRow(
            label: 'Mạng lưới',
            value: preview.networkName,
            density: confirmDensity,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Phí mạng',
            value: preview.feeLabel,
            density: confirmDensity,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Nhận dự kiến',
            value: preview.receivedLabel,
            density: confirmDensity,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Địa chỉ nhận',
            value: preview.maskedAddress,
            density: confirmDensity,
          ),
          const SizedBox(height: WalletSpacingTokens.transferInfoGap),
          VitCard(
            variant: VitCardVariant.inner,
            density: confirmDensity,
            borderColor: withdrawAmber.withValues(alpha: .24),
            child: Text(
              'Không hoàn tác sau khi xác nhận. Bước tiếp theo: mạng xử lý giao dịch rút tiền và ghi nhật ký kiểm toán.',
              style: AppTextStyles.caption.copyWith(color: withdrawAmber),
            ),
          ),
          const SizedBox(height: WalletSpacingTokens.transferInfoGap),
          Row(
            children: [
              Expanded(
                child: WithdrawConfirmActionButton(
                  key: withdrawCancelConfirmKey,
                  label: 'Hủy',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              SizedBox(width: AppSurfaceSpacing.pageRhythmStandardInnerGap),
              Expanded(
                child: WithdrawConfirmActionButton(
                  key: withdrawConfirmWithdrawKey,
                  label: 'Xác nhận rút',
                  primary: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WithdrawConfirmActionButton extends StatelessWidget {
  const WithdrawConfirmActionButton({
    required this.label,
    required this.onTap,
    this.primary = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: primary ? 'Xác nhận rút' : 'Hủy xem trước lệnh rút',
      child: VitCtaButton(
        height: AppSurfaceSpacing.ctaHeight,
        variant: primary
            ? VitCtaButtonVariant.warning
            : VitCtaButtonVariant.secondary,
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
      ),
    );
  }
}
