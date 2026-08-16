part of '../../phone/pages/tools/launchpad_limit_orders_page.dart';

class _CreateOrderSection extends StatelessWidget {
  const _CreateOrderSection({
    required this.orderSide,
    required this.tokenController,
    required this.targetPriceController,
    required this.amountController,
    required this.expiryDays,
    required this.partialFill,
    required this.onSideChanged,
    required this.onExpiryChanged,
    required this.onPartialFillChanged,
    required this.onInputChanged,
  });

  final LaunchpadLimitOrderSide orderSide;
  final TextEditingController tokenController;
  final TextEditingController targetPriceController;
  final TextEditingController amountController;
  final String expiryDays;
  final bool partialFill;
  final ValueChanged<LaunchpadLimitOrderSide> onSideChanged;
  final ValueChanged<String> onExpiryChanged;
  final ValueChanged<bool> onPartialFillChanged;
  final VoidCallback onInputChanged;

  @override
  Widget build(BuildContext context) {
    final hasPreview =
        targetPriceController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty;
    return KeyedSubtree(
      key: LaunchpadLimitOrdersPage.createKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Loai lenh',
            accentColor: AppColors.primary,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SideChoice(
                      side: LaunchpadLimitOrderSide.buy,
                      active: orderSide == LaunchpadLimitOrderSide.buy,
                      onTap: () => onSideChanged(LaunchpadLimitOrderSide.buy),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _SideChoice(
                      side: LaunchpadLimitOrderSide.sell,
                      active: orderSide == LaunchpadLimitOrderSide.sell,
                      onTap: () => onSideChanged(LaunchpadLimitOrderSide.sell),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitPageSection(
            label: 'Chi tiet lenh',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: LaunchpadSpacingTokens.launchpadPaddingX4,
                child: Column(
                  children: [
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.tokenFieldKey,
                      label: 'Token',
                      controller: tokenController,
                      hintText: 'ARB',
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.targetFieldKey,
                      label: 'Target Price (USD)',
                      controller: targetPriceController,
                      hintText: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.amountFieldKey,
                      label: 'Amount',
                      controller: amountController,
                      hintText: '0',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Expiry (days)',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        for (final value in ['1', '7', '14', '30']) ...[
                          Expanded(
                            child: _ExpiryButton(
                              value: value,
                              active: expiryDays == value,
                              onTap: () => onExpiryChanged(value),
                            ),
                          ),
                          if (value != '30')
                            const SizedBox(width: AppSpacing.x2),
                        ],
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    const Divider(
                      height: AppSpacing.dividerHairline,
                      color: AppColors.border,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Allow Partial Fill',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              Text(
                                'Cho phep khop mot phan',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: LaunchpadLimitOrdersPage.partialFillKey,
                          value: partialFill,
                          activeThumbColor: AppColors.primary,
                          onChanged: onPartialFillChanged,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasPreview) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            _OrderPreview(
              side: orderSide,
              token: tokenController.text.trim(),
              targetPrice: targetPriceController.text.trim(),
              amount: amountController.text.trim(),
              expiryDays: expiryDays,
              partialFill: partialFill,
            ),
          ],
        ],
      ),
    );
  }
}
