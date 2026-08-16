part of '../../phone/pages/wallet/p2p_wallet_transfer_page.dart';

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.controller,
    required this.asset,
    required this.insufficient,
    required this.onChanged,
    required this.onMax,
  });

  final TextEditingController controller;
  final String asset;
  final bool insufficient;
  final VoidCallback onChanged;
  final VoidCallback onMax;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: VitSectionHeader(
                title: 'Số tiền',
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                icon: Icons.payments_outlined,
                accentColor: AppModuleAccents.p2p,
                density: VitDensity.compact,
              ),
            ),
            VitChoicePill(
              key: P2PWalletTransferPage.maxKey,
              label: 'MAX',
              selected: true,
              onTap: onMax,
              accentColor: AppModuleAccents.p2p,
              padding: P2PSpacingTokens.p2pWalletTransferChipPadding,
              semanticLabel: 'Chọn số dư tối đa',
            ),
          ],
        ),
        const SizedBox(height: _p2pTransferTightGap),
        VitInput(
          controller: controller,
          fieldKey: P2PWalletTransferPage.amountFieldKey,
          semanticLabel: 'Số tiền chuyển ví P2P',
          hintText: '0.00',
          errorText: insufficient ? 'Số dư không đủ' : null,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          textStyle: AppTextStyles.amountSm,
          suffix: Text(
            asset,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: P2PWalletTransferPage.submitKey,
      onPressed: enabled ? onTap : null,
      height: AppSpacing.inputHeight,
      variant: VitCtaButtonVariant.primary,
      child: Text(label.trim()),
    );
  }
}
