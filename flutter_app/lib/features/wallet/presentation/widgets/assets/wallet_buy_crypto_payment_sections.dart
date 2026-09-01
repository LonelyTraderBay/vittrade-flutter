part of 'wallet_buy_crypto_sections.dart';

class _PaymentMethodGroup extends StatelessWidget {
  const _PaymentMethodGroup({
    required this.icon,
    required this.label,
    required this.methods,
    required this.selectedId,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final List<WalletPaymentMethod> methods;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.text3, size: 13),
            const SizedBox(width: WalletSpacingTokens.walletBuyGroupIconGap),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: WalletSpacingTokens.walletBuyPaymentCardGap),
        for (var i = 0; i < methods.length; i++) ...[
          _PaymentMethodCard(
            method: methods[i],
            selected: methods[i].id == selectedId,
            onTap: () => onChanged(methods[i].id),
          ),
          if (i != methods.length - 1)
            const SizedBox(height: WalletSpacingTokens.walletBuyPaymentCardGap),
        ],
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final WalletPaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final instant = method.type != WalletPaymentMethodType.bank;
    return VitCard(
      key: Key('sc145_buy_crypto_payment_${method.id}'),
      onTap: onTap,
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      borderColor: selected ? _buyPrimary : AppColors.borderSolid,
      clip: true,
      background: ColoredBox(color: selected ? AppColors.primary08 : _buyPanel),
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: WalletSpacingTokens.walletBuyPaymentLogoSize,
            height: WalletSpacingTokens.walletBuyPaymentLogoSize,
            alignment: Alignment.center,
            radius: VitCardRadius.large,
            clip: true,
            background: ColoredBox(
              color: Color(method.logoColorHex).withValues(alpha: .18),
            ),
            child: Text(
              method.logo,
              style: method.logo.length > 3
                  ? AppTextStyles.micro.copyWith(
                      color: Color(method.logoColorHex),
                    )
                  : AppTextStyles.badge.copyWith(
                      color: Color(method.logoColorHex),
                    ),
            ),
          ),
          SizedBox(width: AppSurfaceSpacing.cardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        method.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    if (method.isPopular) ...[
                      const SizedBox(
                        width: WalletSpacingTokens.walletBuyPaymentPopularGap,
                      ),
                      const _PopularBadge(),
                    ],
                  ],
                ),
                const SizedBox(
                  height: WalletSpacingTokens.walletBuyGroupIconGap,
                ),
                Row(
                  children: [
                    Icon(
                      instant
                          ? Icons.flash_on_rounded
                          : Icons.access_time_rounded,
                      color: instant ? _buyGreen : AppColors.text3,
                      size: AppSurfaceSpacing.iconSm,
                    ),
                    const SizedBox(
                      width: WalletSpacingTokens.walletBuyPaymentMetaGap,
                    ),
                    Text(
                      method.processingTime,
                      style: AppTextStyles.micro.copyWith(
                        height: WalletSpacingTokens.walletBuyMetaLineHeight,
                        color: instant ? _buyGreen : AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _RadioMark(selected: selected),
        ],
      ),
    );
  }
}

class _PopularBadge extends StatelessWidget {
  const _PopularBadge();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: WalletSpacingTokens.walletBuyPopularBadgePadding,
      radius: VitCardRadius.standard,
      clip: true,
      background: const ColoredBox(color: AppColors.buy10),
      child: Text(
        'Phổ biến',
        style: AppTextStyles.badge.copyWith(color: _buyGreen),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Icon(
      selected
          ? Icons.radio_button_checked_rounded
          : Icons.radio_button_unchecked_rounded,
      color: selected ? _buyPrimary : AppColors.borderSolid,
      size: AppSurfaceSpacing.iconMd,
    );
  }
}

class _RateInfoCard extends StatelessWidget {
  const _RateInfoCard({required this.crypto, required this.payment});

  final WalletBuyCryptoOption crypto;
  final WalletPaymentMethod payment;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.overlayStroke,
      clip: true,
      background: const ColoredBox(color: _buyPanel),
      child: Column(
        children: [
          VitInfoRow(
            label: 'Tỷ giá hiện tại',
            value: '1 ${crypto.symbol} = ${_formatInt(crypto.priceVnd)} VND',
            density: VitDensity.compact,
            showDivider: true,
          ),
          const _RateRow(
            label: 'Phí giao dịch',
            value: 'Miễn phí',
            valueColor: _buyGreen,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Hạn mức ngày',
            value: '${payment.dailyLimitLabel} VND',
            density: VitDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  const _RateRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.showDivider = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return VitInfoRow(
      label: label,
      value: value,
      valueColor: valueColor,
      density: VitDensity.compact,
      showDivider: showDivider,
    );
  }
}
