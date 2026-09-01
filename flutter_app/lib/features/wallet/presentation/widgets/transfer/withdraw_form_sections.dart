import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part 'withdraw_amount_actions.dart';

class WithdrawBalanceCard extends StatelessWidget {
  const WithdrawBalanceCard({
    required this.asset,
    required this.value,
    super.key,
  });

  final String asset;
  final double value;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      height: AppSurfaceSpacing.inputHeight,
      density: VitDensity.tool,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Số dư khả dụng',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            '${formatWithdrawBalance(value)} $asset',
            style: AppTextStyles.control.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawNetworkSelector extends StatelessWidget {
  const WithdrawNetworkSelector({
    required this.asset,
    required this.network,
    required this.onTap,
    super.key,
  });

  final String asset;
  final WalletWithdrawNetwork network;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          label:
              'Chọn mạng rút ${network.name}, phí ${formatWithdrawNetworkFee(network.fee)} $asset, tối thiểu ${formatWithdrawCompact(network.minWithdraw)}',
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          child: VitCard(
            key: withdrawNetworkSelectorKey,
            onTap: onTap,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            height: AppSurfaceSpacing.inputHeight,
            density: VitDensity.tool,
            borderColor: withdrawPrimary.withValues(alpha: .34),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.name,
                        style: AppTextStyles.control.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      SizedBox(height: AppSurfaceSpacing.x1),
                      Text(
                        'Phí: ${formatWithdrawNetworkFee(network.fee)} $asset · Tối thiểu: ${formatWithdrawCompact(network.minWithdraw)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: WalletSpacingTokens.transferActionIcon,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height:
              AppSurfaceSpacing.pageRhythmCompactInnerGap +
              AppSurfaceSpacing.x1,
        ),
        Row(
          children: [
            SizedBox(
              width: AppSurfaceSpacing.x2,
              height: AppSurfaceSpacing.x2,
              child: const ClipOval(child: ColoredBox(color: withdrawGreen)),
            ),
            SizedBox(width: AppSurfaceSpacing.pageRhythmStandardInnerGap),
            Expanded(
              child: Text(
                'Mạng hoạt động tốt  ·  Phí: ${formatWithdrawNetworkFee(network.fee)} $asset',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WithdrawAddressInput extends StatelessWidget {
  const WithdrawAddressInput({
    required this.asset,
    required this.network,
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final String asset;
  final WalletWithdrawNetwork network;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      fieldKey: withdrawAddressFieldKey,
      controller: controller,
      hintText: 'Nhập địa chỉ $asset (${network.name.split(' ').first})',
      semanticLabel: 'Địa chỉ nhận rút',
      textStyle: AppTextStyles.control,
      onChanged: onChanged,
      suffix: Padding(
        padding: WalletSpacingTokens.walletWithdrawInputSuffixPadding,
        child: Text(
          asset,
          style: AppTextStyles.control.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}
