part of '../../phone/pages/hub/p2p_express_page.dart';

class _AssetMark extends StatelessWidget {
  const _AssetMark({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: symbol,
      accentColor: color,
      size: _p2pExpressAssetMark,
      radius: BorderRadius.zero,
      textStyle: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({
    required this.method,
    required this.selected,
    required this.onPressed,
  });

  final P2PPaymentMethodDraft method;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: P2PExpressPage.paymentKey(method.id),
      label: method.bankName,
      selected: selected,
      onTap: onPressed,
      height: AppSpacing.buttonCompact,
      padding: P2PSpacingTokens.p2pExpressChoiceChipPadding,
      accentColor: AppColors.primary,
      showSelectedIcon: selected,
      selectedIcon: Icons.check_circle_outline,
      semanticLabel: 'Phương thức thanh toán ${method.bankName}',
    );
  }
}

class _MerchantOfferRow extends StatelessWidget {
  const _MerchantOfferRow({required this.ad, required this.onMerchant});

  final P2PAdDraft ad;
  final VoidCallback onMerchant;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pExpressMerchantRowPadding,
          child: Row(
            children: [
              SizedBox.square(
                dimension: _p2pExpressIconBox,
                child: Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  child: Center(
                    child: Text(
                      ad.merchant.substring(0, 1),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ad.merchant,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        const Icon(
                          Icons.shield_outlined,
                          color: AppColors.primary,
                          size: AppSpacing.iconSm,
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        Text(
                          '${ad.completedOrders} đơn',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        Text(
                          '${ad.completionRate.toStringAsFixed(1)}%',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          ad.avgResponseTime,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VitIconButton(
                onPressed: onMerchant,
                icon: Icons.chevron_right_rounded,
                tooltip: 'View merchant',
                size: VitIconButtonSize.sm,
                variant: VitIconButtonVariant.transparent,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppSpacing.dividerHairline,
          child: ColoredBox(color: AppColors.divider),
        ),
      ],
    );
  }
}

class _OfferMetric extends StatelessWidget {
  const _OfferMetric({
    required this.label,
    required this.value,
    required this.caption,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: Padding(
        padding: P2PSpacingTokens.p2pExpressTightCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallTextChip extends StatelessWidget {
  const _SmallTextChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      child: Padding(
        padding: P2PSpacingTokens.p2pExpressSmallChipPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }
}

IconData _stepIcon(String key) {
  return switch (key) {
    'amount' => Icons.payments_outlined,
    'match' => Icons.bolt_outlined,
    'confirm' => Icons.check_circle_outline,
    _ => Icons.info_outline,
  };
}

String _formatVnd(int value) => formatP2PVnd(value);

String _formatAmount(double value) {
  if (value == 0) return '0.00';
  if (value == value.roundToDouble()) return value.toStringAsFixed(2);
  return value.toStringAsFixed(6);
}
