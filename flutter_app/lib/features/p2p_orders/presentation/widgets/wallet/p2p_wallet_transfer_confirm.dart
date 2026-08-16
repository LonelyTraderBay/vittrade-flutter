part of '../../phone/pages/wallet/p2p_wallet_transfer_page.dart';

class _ConfirmTransferView extends StatelessWidget {
  const _ConfirmTransferView({
    required this.snapshot,
    required this.source,
    required this.destination,
    required this.amount,
    required this.asset,
    required this.onEdit,
    required this.onConfirm,
  });

  final P2PWalletTransferSnapshot snapshot;
  final P2PWalletTransferBalanceDraft source;
  final P2PWalletTransferBalanceDraft destination;
  final double amount;
  final String asset;
  final VoidCallback onEdit;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PWalletTransferPage.confirmPanelKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pWalletTransferConfirmHeroPadding,
          child: Column(
            children: [
              Material(
                color: AppModuleAccents.p2p.withValues(alpha: .14),
                shape: const CircleBorder(),
                child: const SizedBox(
                  width: _p2pTransferConfirmIconBox,
                  height: _p2pTransferConfirmIconBox,
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    color: AppModuleAccents.p2p,
                    size: _p2pTransferConfirmIcon,
                  ),
                ),
              ),
              const SizedBox(height: _p2pTransferMajorGap),
              const Text(
                'Kiểm tra thông tin',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Đảm bảo thông tin chính xác trước khi xác nhận',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: _p2pTransferMajorGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              _ConfirmRow(
                label: 'Số tiền',
                value: '${_formatAvailable(amount, asset)} $asset',
                large: true,
              ),
              const Divider(
                color: AppColors.divider,
                height: AppSpacing.dividerHairline,
              ),
              _ConfirmRow(label: 'Từ', value: source.walletLabel),
              _ConfirmRow(label: 'Đến', value: destination.walletLabel),
              _ConfirmRow(
                label: 'Phí giao dịch',
                value: snapshot.feeLabel,
                valueColor: AppColors.buy,
              ),
              _ConfirmRow(
                label: 'Thời gian',
                value: snapshot.processingLabel,
                valueColor: AppModuleAccents.p2p,
              ),
              const _ConfirmRow(
                label: 'Loại giao dịch',
                value: 'Chuyển nội bộ',
              ),
            ],
          ),
        ),
        const SizedBox(height: _p2pTransferMajorGap),
        P2PNoticeCard(
          icon: Icons.info_outline_rounded,
          message: snapshot.confirmationNote,
          borderColor: AppModuleAccents.p2p.withValues(alpha: .32),
          padding: P2PSpacingTokens.p2pWalletCompactCardPadding,
        ),
        const SizedBox(height: _p2pTransferMajorGap),
        Row(
          children: [
            Expanded(
              child: _ConfirmButton(
                label: 'Quay lại',
                variant: VitCtaButtonVariant.secondary,
                onTap: onEdit,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _ConfirmButton(
                buttonKey: P2PWalletTransferPage.confirmKey,
                label: 'Xác nhận',
                variant: VitCtaButtonVariant.primary,
                onTap: onConfirm,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.large = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pWalletTransferConfirmSummaryPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            flex: large ? 2 : 1,
            child: Text(
              value,
              maxLines: large ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style:
                  (large ? AppTextStyles.sectionTitle : AppTextStyles.caption)
                      .copyWith(
                        color: valueColor ?? AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    this.buttonKey,
    required this.label,
    required this.variant,
    required this.onTap,
  });

  final Key? buttonKey;
  final String label;
  final VitCtaButtonVariant variant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: buttonKey,
      onPressed: onTap,
      height: _p2pTransferConfirmButtonHeight,
      variant: variant,
      child: Text(label),
    );
  }
}

IconData _walletIcon(String walletKey) {
  return switch (walletKey) {
    'p2p' => Icons.account_balance_wallet_outlined,
    _ => Icons.wallet_outlined,
  };
}

Color _assetColor(String symbol) {
  return switch (symbol) {
    'BTC' => AppColors.warn,
    'VND' => AppColors.text1,
    _ => AppModuleAccents.p2p,
  };
}

String _formatTransferAmount(double value, String asset) {
  final decimals = switch (asset) {
    'BTC' => 8,
    'VND' => 0,
    _ => 2,
  };
  return value.toStringAsFixed(decimals);
}

String _formatAvailable(double value, String asset) {
  return _withCommas(_formatTransferAmount(value, asset));
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
