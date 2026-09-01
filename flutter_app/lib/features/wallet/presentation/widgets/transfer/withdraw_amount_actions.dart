part of 'withdraw_form_sections.dart';

class WithdrawRecentAddresses extends StatelessWidget {
  const WithdrawRecentAddresses({
    required this.addresses,
    required this.onSelect,
    super.key,
  });

  final List<WalletRecentAddress> addresses;
  final ValueChanged<WalletRecentAddress> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: AppColors.text3,
              size: AppSurfaceSpacing.iconSm,
            ),
            SizedBox(width: AppSurfaceSpacing.x2),
            Text(
              'Lịch sử địa chỉ gần đây',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        SizedBox(height: AppSurfaceSpacing.rowGap),
        for (var i = 0; i < addresses.length; i++) ...[
          Semantics(
            button: true,
            label: 'Dùng địa chỉ rút gần đây ${addresses[i].label}',
            hint: addresses[i].address,
            child: VitCard(
              key: withdrawRecentAddressKey(addresses[i].label),
              onTap: () => onSelect(addresses[i]),
              variant: VitCardVariant.ghost,
              borderColor: AppColors.divider,
              padding: WalletSpacingTokens.walletWithdrawRecentAddressPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          addresses[i].label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        SizedBox(height: AppSurfaceSpacing.x1),
                        Text(
                          maskWithdrawAddress(addresses[i].address),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSurfaceSpacing.x2),
                  Text(
                    addresses[i].lastUsed,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
          if (i < addresses.length - 1)
            SizedBox(height: AppSurfaceSpacing.rowGap),
        ],
      ],
    );
  }
}

class WithdrawAmountInput extends StatelessWidget {
  const WithdrawAmountInput({
    required this.asset,
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final String asset;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      fieldKey: withdrawAmountFieldKey,
      controller: controller,
      semanticLabel: 'Số tiền rút',
      hintText: '0.00',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      textStyle: AppTextStyles.amountSm.copyWith(
        fontFeatures: AppTextStyles.tabularFigures,
        fontWeight: AppTextStyles.bold,
      ),
      onChanged: onChanged,
      suffix: Text(
        asset,
        style: AppTextStyles.caption.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class WithdrawPreviewBlockedNotice extends StatelessWidget {
  const WithdrawPreviewBlockedNotice({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: withdrawAmber.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: withdrawAmber,
            size: AppSurfaceSpacing.iconMd,
          ),
          SizedBox(width: AppSurfaceSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.micro.copyWith(
                color: withdrawAmber,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawWarning extends StatelessWidget {
  const WithdrawWarning({
    required this.asset,
    required this.network,
    super.key,
  });

  final String asset;
  final WalletWithdrawNetwork network;

  @override
  Widget build(BuildContext context) {
    final warningItems = [
      'Chỉ rút $asset qua mạng ${network.name}',
      'Rút sai mạng có thể mất tiền vĩnh viễn, không thể khôi phục',
      'Rút tối thiểu: ${formatWithdrawCompact(network.minWithdraw)} $asset',
      'Rút cần xác minh 2FA · >\$10,000 xem xét trong 24h',
    ];

    return VitCard(
      variant: VitCardVariant.standard,
      borderColor: withdrawAmber.withValues(alpha: .38),
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: withdrawAmber,
            size: AppSurfaceSpacing.iconMd,
          ),
          SizedBox(width: AppSurfaceSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quan trọng — Đọc trước khi rút',
                  style: AppTextStyles.body.copyWith(
                    color: withdrawAmber,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                SizedBox(height: AppSurfaceSpacing.x1),
                for (final item in warningItems) ...[
                  Text(
                    '• $item',
                    style: AppTextStyles.micro.copyWith(
                      color: withdrawAmber,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  SizedBox(height: AppSurfaceSpacing.x1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawSupportLink extends StatelessWidget {
  const WithdrawSupportLink({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Mở hỗ trợ rút tiền theo ngữ cảnh',
      child: VitCtaButton(
        key: withdrawSupportKey,
        onPressed: onTap,
        variant: VitCtaButtonVariant.ghost,
        height: AppSurfaceSpacing.inputHeight - AppSurfaceSpacing.x2,
        leading: const Icon(Icons.support_agent_rounded),
        trailing: const Icon(Icons.chevron_right_rounded),
        child: const Text('Mở hồ sơ hỗ trợ'),
      ),
    );
  }
}

class WithdrawNextButton extends StatelessWidget {
  const WithdrawNextButton({
    required this.onTap,
    this.disabledReason,
    super.key,
  });

  final VoidCallback? onTap;
  final String? disabledReason;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: 'Xem trước lệnh rút',
      hint: disabledReason,
      child: Tooltip(
        message: disabledReason ?? 'Xem trước lệnh rút',
        child: VitCtaButton(
          key: withdrawNextKey,
          onPressed: onTap,
          height: AppSurfaceSpacing.inputHeight,
          child: const Text('Tiếp tục →'),
        ),
      ),
    );
  }
}
