part of '../../phone/pages/tools/launchpad_limit_orders_page.dart';

class _SideChoice extends StatelessWidget {
  const _SideChoice({
    required this.side,
    required this.active,
    required this.onTap,
  });

  final LaunchpadLimitOrderSide side;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isBuy = side == LaunchpadLimitOrderSide.buy;
    final color = isBuy ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: LaunchpadLimitOrdersPage.sideKey(side),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: active ? color : AppColors.cardBorder,
      background: ColoredBox(
        color: active ? color.withValues(alpha: .10) : AppColors.surface,
      ),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        children: [
          Icon(
            isBuy ? Icons.south_rounded : Icons.north_rounded,
            color: active ? color : AppColors.text3,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            isBuy ? 'Buy' : 'Sell',
            style: AppTextStyles.base.copyWith(
              color: active ? color : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            isBuy ? 'Mua khi gia xuong' : 'Ban khi gia len',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitInput(
          fieldKey: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.text
              ? const []
              : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: (_) => onChanged(),
          semanticLabel: label,
          hintText: hintText,
          textStyle: AppTextStyles.base.copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}

class _ExpiryButton extends StatelessWidget {
  const _ExpiryButton({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final String value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: LaunchpadLimitOrdersPage.expiryKey(value),
      label: '${value}d',
      selected: active,
      onTap: onTap,
      accentColor: AppColors.primary,
      fullWidth: true,
      height: LaunchpadSpacingTokens.launchpadBox40,
    );
  }
}
