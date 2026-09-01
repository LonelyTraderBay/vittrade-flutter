import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_agreement.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_preview.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_selectors.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class AddressAddForm {
  const AddressAddForm._();

  static List<Widget> sections({
    required WalletAddressAddSnapshot snapshot,
    required String selectedNetworkId,
    required String selectedAsset,
    required TextEditingController labelController,
    required TextEditingController addressController,
    required TextEditingController memoController,
    required bool whitelist,
    required bool agreed,
    required ValueChanged<String> onNetworkChanged,
    required ValueChanged<String> onAssetChanged,
    required VoidCallback onWhitelistChanged,
    required VoidCallback onAgreementChanged,
    required VoidCallback onInputChanged,
  }) {
    final selectedNetwork = snapshot.networks.firstWhere(
      (network) => network.id == selectedNetworkId,
      orElse: () => snapshot.networks.first,
    );

    return [
      VitPageSection(
        label: 'Mạng & tài sản',
        headerIcon: Icons.account_tree_outlined,
        headerVariant: VitSectionHeaderVariant.plain,
        headerDensity: VitDensity.compact,
        innerGap: AppSurfaceSpacing.pageRhythmFormInnerGap,
        gap: VitContentGap.tight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AddressFieldLabel(label: 'Mạng lưới', required: true),
              SizedBox(height: AppSurfaceSpacing.formFieldLabelGap),
              AddressNetworkGrid(
                networks: snapshot.networks,
                selectedId: selectedNetworkId,
                onChanged: onNetworkChanged,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AddressFieldLabel(label: 'Tài sản'),
              SizedBox(height: AppSurfaceSpacing.formFieldLabelGap),
              AddressAssetSelector(
                assets: snapshot.assets,
                selectedAsset: selectedAsset,
                onChanged: onAssetChanged,
              ),
            ],
          ),
        ],
      ),
      VitPageSection(
        label: 'Chi tiết địa chỉ',
        headerIcon: Icons.account_balance_wallet_outlined,
        headerVariant: VitSectionHeaderVariant.plain,
        headerDensity: VitDensity.compact,
        innerGap: AppSurfaceSpacing.pageRhythmFormInnerGap,
        gap: VitContentGap.tight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddressFieldSection(
                label: 'Tên địa chỉ',
                required: true,
                child: AddressTextInput(
                  fieldKey: const Key('sc143_address_label_field'),
                  semanticLabel: 'Tên địa chỉ',
                  controller: labelController,
                  hintText: 'VD: Ví lạnh cá nhân, Sàn Binance...',
                  maxLength: 30,
                  onChanged: onInputChanged,
                ),
              ),
              Padding(
                padding: WalletSpacingTokens.walletAddressAddHelperPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Đặt tên dễ nhớ cho ví',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                    Text(
                      '${labelController.text.length}/30',
                      style: AppTextStyles.micro.copyWith(
                        color: labelController.text.length > 25
                            ? addressAddAmber
                            : AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddressFieldSection(
                label: 'Địa chỉ ví',
                required: true,
                child: AddressWalletInput(
                  controller: addressController,
                  onChanged: onInputChanged,
                ),
              ),
              Padding(
                padding: WalletSpacingTokens.walletAddressAddHintPadding
                    .copyWith(top: WalletSpacingTokens.walletAddressAddHintGap),
                child: Text(
                  selectedNetwork.addressHint,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          AddressFieldSection(
            label: 'Memo / Tag',
            optionalText: '(tùy chọn)',
            child: AddressTextInput(
              fieldKey: const Key('sc143_address_memo_field'),
              semanticLabel: 'Memo địa chỉ, không bắt buộc',
              controller: memoController,
              hintText: 'Nhập memo nếu cần...',
              onChanged: onInputChanged,
            ),
          ),
        ],
      ),
      VitPageSection(
        label: 'Bảo mật & xác nhận',
        headerIcon: Icons.verified_user_outlined,
        headerIconColor: AppColors.caution,
        headerVariant: VitSectionHeaderVariant.plain,
        headerDensity: VitDensity.compact,
        innerGap: AppSurfaceSpacing.pageRhythmFormInnerGap,
        gap: VitContentGap.tight,
        children: [
          AddressWhitelistCard(enabled: whitelist, onTap: onWhitelistChanged),
          if (snapshot.highRiskContractId != null)
            AddressWarningCard(highRiskContractId: snapshot.highRiskContractId),
          AddressAgreementRow(agreed: agreed, onTap: onAgreementChanged),
          if (labelController.text.trim().isNotEmpty &&
              addressController.text.trim().isNotEmpty)
            AddressPreviewPanel(
              rows: [
                ('Tên', labelController.text.trim()),
                ('Mạng', selectedNetwork.label),
                ('Tài sản', selectedAsset),
                ('Địa chỉ', maskWalletAddress(addressController.text.trim())),
                if (memoController.text.trim().isNotEmpty)
                  ('Memo', memoController.text.trim()),
                ('Danh sách trắng', whitelist ? 'Có' : 'Không'),
              ],
            ),
        ],
      ),
    ];
  }
}
