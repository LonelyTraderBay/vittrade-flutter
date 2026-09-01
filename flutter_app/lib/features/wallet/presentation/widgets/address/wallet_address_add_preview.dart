import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class AddressConfirmPreviewSheet extends StatelessWidget {
  const AddressConfirmPreviewSheet({
    super.key,
    required this.preview,
    required this.onConfirm,
  });

  static const confirmButtonKey = Key('sc143_address_confirm_save');

  final AddressAddPreview preview;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    // Confirm sheets prefer calmer density than the compact form (craft #6).
    const confirmDensity = VitDensity.standard;

    return VitSheetPanel(
      title: 'Xác nhận lưu địa chỉ',
      child: ListView(
        children: [
          Text(
            preview.auditTrailNote,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          SizedBox(height: AppSurfaceSpacing.pageRhythmStandardInnerGap),
          AddressPreviewPanel(
            density: confirmDensity,
            rows: [
              ('Tên', preview.label),
              ('Mạng', preview.networkLabel),
              ('Tài sản', preview.asset),
              ('Địa chỉ', preview.maskedAddress),
              if (preview.memo != null) ('Memo', preview.memo!),
              ('Danh sách trắng', preview.whitelistLabel),
            ],
          ),
          const SizedBox(height: WalletSpacingTokens.walletAddressFilterGap),
          AddressPrimaryActionButton(
            key: confirmButtonKey,
            enabled: true,
            label: 'Xác nhận lưu',
            semanticLabel: 'Xác nhận lưu địa chỉ ví',
            onTap: onConfirm,
          ),
        ],
      ),
    );
  }
}

class AddressPreviewPanel extends StatelessWidget {
  const AddressPreviewPanel({
    super.key,
    required this.rows,
    this.density = VitDensity.compact,
  });

  final List<(String, String)> rows;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: density,
      borderColor: AppColors.overlayStroke,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitSectionHeader(
            title: 'Xem trước',
            bottomGap: AppSurfaceSpacing.pageRhythmStandardInnerGap,
            icon: Icons.receipt_long_outlined,
            density: density,
          ),
          for (var i = 0; i < rows.length; i++)
            VitInfoRow(
              label: rows[i].$1,
              value: rows[i].$2,
              density: density,
              showDivider: i != rows.length - 1,
              valueColor: rows[i].$1 == 'Địa chỉ'
                  ? AppColors.primary
                  : AppColors.text1,
            ),
        ],
      ),
    );
  }
}

class AddressSavedState extends StatelessWidget {
  const AddressSavedState({
    super.key,
    required this.label,
    required this.whitelist,
    required this.onBack,
  });

  final String label;
  final bool whitelist;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'Thêm địa chỉ mới - đã lưu thành công',
      semanticIdentifier: 'SC-143',
      child: Material(
        color: addressAddBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Thêm địa chỉ',
              subtitle: 'Sổ địa chỉ · Wallet',
              showBack: true,
              onBack: onBack,
            ),
            Expanded(
              child: VitPageContent(
                rhythm: VitPageRhythm.form,
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                gap: VitContentGap.tight,
                children: [
                  VitHighRiskStatePanel(
                    state: VitHighRiskUiState.success,
                    title: 'Đã lưu thành công!',
                    message: 'Địa chỉ "$label" đã được thêm vào sổ địa chỉ.',
                    contractId: 'Address book save',
                    density: VitDensity.compact,
                  ),
                  VitCard(
                    density: VitDensity.compact,
                    borderColor: AppColors.buy20,
                    child: VitInfoRow(
                      label: 'Danh sách trắng',
                      value: whitelist
                          ? 'Đã thêm vào danh sách trắng'
                          : 'Chưa vào danh sách trắng - có thể bật sau',
                      leading: const Icon(Icons.shield_outlined),
                      valueColor: addressAddGreen,
                      density: VitDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
