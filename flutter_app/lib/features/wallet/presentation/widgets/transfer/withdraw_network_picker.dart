import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

class WithdrawNetworkPicker extends StatelessWidget {
  const WithdrawNetworkPicker({
    required this.networks,
    required this.selectedNetworkId,
    required this.onSelected,
    super.key,
  });

  final List<WalletWithdrawNetwork> networks;
  final String selectedNetworkId;
  final ValueChanged<WalletWithdrawNetwork> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'Chọn mạng lưới',
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: networks.length,
        separatorBuilder: (_, _) => SizedBox(height: AppSurfaceSpacing.x1),
        itemBuilder: (context, index) {
          final network = networks[index];
          return WithdrawNetworkOption(
            network: network,
            selected: network.id == selectedNetworkId,
            onTap: () => onSelected(network),
          );
        },
      ),
    );
  }
}

class WithdrawNetworkOption extends StatelessWidget {
  const WithdrawNetworkOption({
    required this.network,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final WalletWithdrawNetwork network;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Mạng rút ${network.name}',
      child: VitCard(
        key: withdrawNetworkKey(network.id),
        onTap: onTap,
        variant: VitCardVariant.inner,
        density: VitDensity.compact,
        borderColor: selected ? withdrawPrimary : AppColors.border,
        child: Row(
          children: [
            Expanded(
              child: Column(
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
                    'Phí: ${formatWithdrawCompact(network.fee)} · Tối thiểu: ${formatWithdrawCompact(network.minWithdraw)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: withdrawPrimary,
                size: AppSurfaceSpacing.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}
