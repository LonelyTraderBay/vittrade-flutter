part of 'wallet_buy_crypto_sections.dart';

class BuyInputContent {
  const BuyInputContent._();

  static List<Widget> sections({
    required WalletBuyCryptoSnapshot snapshot,
    required WalletBuyCryptoOption selectedCrypto,
    required String selectedPaymentId,
    required TextEditingController amountController,
    required int amountVnd,
    required double receiveAmount,
    required VoidCallback onAmountChanged,
    required ValueChanged<int> onPreset,
    required VoidCallback onCryptoTap,
    required ValueChanged<String> onPaymentChanged,
    required VoidCallback? onBuy,
  }) {
    final selectedPayment = snapshot.paymentMethods.firstWhere(
      (method) => method.id == selectedPaymentId,
    );

    return [
      const _ZeroFeeBanner(),
      VitPageSection(
        label: 'Số tiền & tài sản nhận',
        headerIcon: Icons.payments_outlined,
        headerIconColor: _buyPrimary,
        headerVariant: VitSectionHeaderVariant.plain,
        accentColor: _buyPrimary,
        innerGap: AppSurfaceSpacing.pageRhythmFormInnerGap,
        children: [
          _AmountCard(
            snapshot: snapshot,
            selectedCrypto: selectedCrypto,
            amountController: amountController,
            amountVnd: amountVnd,
            receiveAmount: receiveAmount,
            onAmountChanged: onAmountChanged,
            onPreset: onPreset,
            onCryptoTap: onCryptoTap,
          ),
        ],
      ),
      VitPageSection(
        label: 'Phương thức thanh toán',
        headerIcon: Icons.verified_user_outlined,
        headerIconColor: _buyPrimary,
        headerVariant: VitSectionHeaderVariant.plain,
        accentColor: _buyPrimary,
        innerGap: AppSurfaceSpacing.pageRhythmFormInnerGap,
        children: [
          _PaymentMethodGroup(
            icon: Icons.account_balance_rounded,
            label: 'Chuyển khoản ngân hàng',
            methods: snapshot.paymentMethods
                .where((method) => method.type == WalletPaymentMethodType.bank)
                .toList(),
            selectedId: selectedPaymentId,
            onChanged: onPaymentChanged,
          ),
          _PaymentMethodGroup(
            icon: Icons.phone_android_rounded,
            label: 'Ví điện tử',
            methods: snapshot.paymentMethods
                .where((method) => method.type != WalletPaymentMethodType.bank)
                .toList(),
            selectedId: selectedPaymentId,
            onChanged: onPaymentChanged,
          ),
        ],
      ),
      VitPageSection(
        label: 'Phí & hạn mức',
        headerIcon: Icons.receipt_long_outlined,
        headerIconColor: _buyGreen,
        headerVariant: VitSectionHeaderVariant.plain,
        accentColor: _buyGreen,
        innerGap: AppSurfaceSpacing.pageRhythmFormInnerGap,
        children: [
          _RateInfoCard(crypto: selectedCrypto, payment: selectedPayment),
          _BuyButton(
            enabled: onBuy != null,
            symbol: selectedCrypto.symbol,
            onTap: onBuy,
          ),
        ],
      ),
    ];
  }
}

class _ZeroFeeBanner extends StatelessWidget {
  const _ZeroFeeBanner();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.buy20,
      clip: true,
      background: ColoredBox(color: AppColors.buy.withValues(alpha: .08)),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: _buyGreen, size: 15),
          const SizedBox(width: WalletSpacingTokens.walletBuyInlineGap),
          Expanded(
            child: Text(
              'Mua trực tiếp bằng VND — Phí 0% — Nhận USDT tức thì',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: WalletSpacingTokens.walletBuyBannerLineHeight,
              ),
            ),
          ),
          const SizedBox(width: WalletSpacingTokens.walletBuyCompactGap),
          Text('0% phí', style: AppTextStyles.badge.copyWith(color: _buyGreen)),
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.snapshot,
    required this.selectedCrypto,
    required this.amountController,
    required this.amountVnd,
    required this.receiveAmount,
    required this.onAmountChanged,
    required this.onPreset,
    required this.onCryptoTap,
  });

  final WalletBuyCryptoSnapshot snapshot;
  final WalletBuyCryptoOption selectedCrypto;
  final TextEditingController amountController;
  final int amountVnd;
  final double receiveAmount;
  final VoidCallback onAmountChanged;
  final ValueChanged<int> onPreset;
  final VoidCallback onCryptoTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      constraints: const BoxConstraints(
        minHeight: WalletSpacingTokens.walletBuyAmountCardMinHeight,
      ),
      density: VitDensity.compact,
      borderColor: AppColors.overlayStroke,
      clip: true,
      background: const ColoredBox(color: _buyPanel),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số tiền (VND)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                'Số dư: 0 VND',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: WalletSpacingTokens.walletBuyAmountLabelGap),
          VitInput(
            fieldKey: const Key('sc145_buy_crypto_amount'),
            controller: amountController,
            semanticLabel: 'Số tiền mua tiền mã hóa bằng VND',
            hintText: '0',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => onAmountChanged(),
            textStyle: AppTextStyles.amountMd.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
              height: WalletSpacingTokens.walletBuyAmountLineHeight,
            ),
            prefix: Text(
              '₫',
              style: AppTextStyles.amountSm.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(height: WalletSpacingTokens.walletBuyPresetGap),
          Row(
            children: [
              for (var i = 0; i < snapshot.presetAmounts.length; i++) ...[
                Expanded(
                  child: _PresetChip(
                    amount: snapshot.presetAmounts[i],
                    selected:
                        amountController.text ==
                        snapshot.presetAmounts[i].toString(),
                    onTap: () => onPreset(snapshot.presetAmounts[i]),
                  ),
                ),
                if (i != snapshot.presetAmounts.length - 1)
                  const SizedBox(
                    width: WalletSpacingTokens.walletBuyPaymentPopularGap,
                  ),
              ],
            ],
          ),
          const SizedBox(height: WalletSpacingTokens.walletBuyReceiveGap),
          _ReceivePanel(
            crypto: selectedCrypto,
            receiveAmount: receiveAmount,
            onCryptoTap: onCryptoTap,
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  final int amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: Key('sc145_buy_crypto_preset_$amount'),
      label: '${amount ~/ 1000}K',
      selected: selected,
      onTap: onTap,
      fullWidth: true,
      height: WalletSpacingTokens.walletBuyPresetChipHeight,
      accentColor: _buyPrimary,
    );
  }
}

class _ReceivePanel extends StatelessWidget {
  const _ReceivePanel({
    required this.crypto,
    required this.receiveAmount,
    required this.onCryptoTap,
  });

  final WalletBuyCryptoOption crypto;
  final double receiveAmount;
  final VoidCallback onCryptoTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bạn sẽ nhận được',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: WalletSpacingTokens.walletBuyCompactGap),
                Text(
                  '${_formatCrypto(receiveAmount)} ${crypto.symbol}',
                  style: AppTextStyles.base.copyWith(
                    color: _buyGreen,
                    height: WalletSpacingTokens.walletBuyReceiveLineHeight,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            key: const Key('sc145_buy_crypto_selector'),
            onTap: onCryptoTap,
            height: WalletSpacingTokens.walletBuySelectorHeight,
            padding: WalletSpacingTokens.walletBuySelectorPadding,
            borderColor: AppColors.borderSolid,
            clip: true,
            background: const ColoredBox(color: _buyPanel),
            child: Row(
              children: [
                _CryptoLogo(
                  option: crypto,
                  size: WalletSpacingTokens.walletBuyCryptoLogoCompact,
                ),
                const SizedBox(width: WalletSpacingTokens.walletBuyCompactGap),
                Text(
                  crypto.symbol,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const SizedBox(width: WalletSpacingTokens.walletBuyMicroGap),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
