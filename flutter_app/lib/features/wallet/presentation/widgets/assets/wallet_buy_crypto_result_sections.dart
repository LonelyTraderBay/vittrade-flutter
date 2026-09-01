part of 'wallet_buy_crypto_sections.dart';

class _BuyButton extends StatelessWidget {
  const _BuyButton({
    required this.enabled,
    required this.symbol,
    required this.onTap,
  });

  final bool enabled;
  final String symbol;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: enabled
          ? 'Xem lại lệnh mua'
          : 'Mua crypto chưa khả dụng. Nhập số tiền trong hạn mức hỗ trợ.',
      child: Tooltip(
        message: enabled
            ? 'Xem lại lệnh mua'
            : 'Nhập số tiền trong hạn mức hỗ trợ.',
        child: VitCtaButton(
          key: const Key('sc145_buy_crypto_buy'),
          onPressed: enabled ? onTap : null,
          variant: VitCtaButtonVariant.success,
          height: AppSurfaceSpacing.ctaHeight,
          child: Text(
            enabled ? 'Mua $symbol' : 'Nhập số tiền mua',
            style: AppTextStyles.baseMedium.copyWith(
              color: enabled ? AppColors.onAccent : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BuyConfirmContent extends StatelessWidget {
  const BuyConfirmContent({
    super.key,
    required this.crypto,
    required this.payment,
    required this.amountVnd,
    required this.receiveAmount,
    required this.submitting,
    required this.onConfirm,
    required this.onBack,
  });

  final WalletBuyCryptoOption crypto;
  final WalletPaymentMethod payment;
  final int amountVnd;
  final double receiveAmount;
  final bool submitting;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chi tiết xác nhận',
      headerIcon: Icons.receipt_long_outlined,
      headerIconColor: _buyPrimary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: _buyPrimary,
      innerGap: AppSurfaceSpacing.pageRhythmFormInnerGap,
      children: [
        VitCard(
          density: VitDensity.compact,
          borderColor: AppColors.primary40,
          clip: true,
          background: const ColoredBox(color: AppColors.surface),
          child: Column(
            children: [
              Text(
                'Bạn sẽ nhận được',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: WalletSpacingTokens.walletBuyCompactGap),
              Text(
                '${_formatCrypto(receiveAmount)} ${crypto.symbol}',
                style: AppTextStyles.sectionTitle.copyWith(color: _buyGreen),
              ),
              const SizedBox(
                height: WalletSpacingTokens.walletBuyConfirmAmountGap,
              ),
              VitInfoRow(
                label: 'Thanh toán',
                value: '${_formatInt(amountVnd)} VND',
                density: VitDensity.compact,
                showDivider: true,
              ),
              VitInfoRow(
                label: 'Phương thức',
                value: payment.name,
                density: VitDensity.compact,
                showDivider: true,
              ),
              const VitInfoRow(
                label: 'Phí',
                value: 'Miễn phí',
                valueColor: _buyGreen,
                density: VitDensity.compact,
              ),
            ],
          ),
        ),
        _ActionButton(
          label: submitting ? 'Đang xử lý' : 'Xác nhận thanh toán',
          onTap: onConfirm,
          enabled: !submitting,
        ),
        _GhostButton(
          label: 'Quay lại chỉnh sửa',
          onTap: onBack,
          enabled: !submitting,
        ),
      ],
    );
  }
}

class BuySuccessState extends StatelessWidget {
  const BuySuccessState({
    super.key,
    required this.crypto,
    required this.amountVnd,
    required this.receiveAmount,
    required this.onWallet,
    required this.onBuyMore,
  });

  final WalletBuyCryptoOption crypto;
  final int amountVnd;
  final double receiveAmount;
  final VoidCallback onWallet;
  final VoidCallback onBuyMore;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Mua Crypto - đặt lệnh thành công',
      semanticIdentifier: 'SC-145',
      child: Material(
        color: _buyBackground,
        child: VitAutoHideHeaderScaffold(
          header: const VitHeader(
            title: 'Mua Crypto',
            subtitle: 'Giao dịch · Wallet',
          ),
          child: VitInsetScrollView(
            bottomInset: WalletSpacingTokens.walletBuySuccessCtaGap,
            child: VitPageContent(
              rhythm: VitPageRhythm.form,
              padding: VitContentPadding.compact,
              gap: VitContentGap.tight,
              children: [
                VitCard(
                  variant: VitCardVariant.standard,
                  density: VitDensity.compact,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: WalletSpacingTokens.walletBuySuccessIconRadius,
                        backgroundColor: AppColors.buy10,
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          color: _buyGreen,
                          size: WalletSpacingTokens.walletBuySuccessGlyph,
                        ),
                      ),
                      const SizedBox(
                        height: WalletSpacingTokens.walletBuySuccessTitleGap,
                      ),
                      const Text(
                        'Đặt lệnh thành công!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(
                        height: WalletSpacingTokens.walletBuyCompactGap,
                      ),
                      Text(
                        'Lệnh mua ${_formatCrypto(receiveAmount)} ${crypto.symbol} từ ${_formatInt(amountVnd)} VND đã được đặt.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                _ActionButton(label: 'Về Ví', onTap: onWallet),
                _GhostButton(label: 'Mua thêm', onTap: onBuyMore),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: enabled ? onTap : null,
      variant: VitCtaButtonVariant.primary,
      height: AppSurfaceSpacing.ctaHeight,
      child: Text(
        label,
        style: AppTextStyles.baseMedium.copyWith(
          color: enabled ? AppColors.onAccent : AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: enabled ? onTap : null,
      variant: VitCtaButtonVariant.ghost,
      height: AppSurfaceSpacing.ctaHeight,
      child: Text(
        label,
        style: AppTextStyles.baseMedium.copyWith(
          color: enabled ? AppColors.text2 : AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class BuyCryptoOptionRow extends StatelessWidget {
  const BuyCryptoOptionRow({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final WalletBuyCryptoOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: selected ? _buyPrimary : AppColors.borderSolid,
      clip: true,
      background: ColoredBox(
        color: selected ? AppColors.primary08 : _buyPanel2,
      ),
      onTap: onTap,
      child: Row(
        children: [
          _CryptoLogo(option: option),
          const SizedBox(width: WalletSpacingTokens.walletBuyInlineGap),
          Expanded(
            child: Text(
              '${option.symbol} · ${option.name}',
              style: AppTextStyles.body,
            ),
          ),
          if (selected)
            Icon(
              Icons.check_circle_rounded,
              color: _buyPrimary,
              size: AppSurfaceSpacing.iconMd,
            ),
        ],
      ),
    );
  }
}

class _CryptoLogo extends StatelessWidget {
  const _CryptoLogo({
    required this.option,
    this.size = WalletSpacingTokens.walletBuyCryptoLogoSize,
  });

  final WalletBuyCryptoOption option;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Color(option.colorHex).withValues(alpha: .18),
      child: Text(
        option.symbol.length > 3
            ? option.symbol.substring(0, 3)
            : option.symbol,
        style: (size <= 26 ? AppTextStyles.micro : AppTextStyles.caption)
            .copyWith(
              color: Color(option.colorHex),
              fontFeatures: AppTextStyles.tabularFigures,
            ),
      ),
    );
  }
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    buffer.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

String _formatCrypto(double value) {
  if (value == 0) return '0';
  if (value < 1) return value.toStringAsFixed(8);
  return value.toStringAsFixed(4);
}
