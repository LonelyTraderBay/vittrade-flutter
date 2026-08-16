part of '../../phone/pages/flow/copy_configuration_page.dart';

class _RiskToggle extends StatelessWidget {
  const _RiskToggle({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text3,
            size: TradeSpacingTokens.copyConfigurationRiskIcon,
          ),
          const SizedBox(width: _configurationCardSpace),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _configurationPrimary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ValidationCard extends StatelessWidget {
  const _ValidationCard({required this.item});

  final TradeCopyConfigurationValidation item;

  @override
  Widget build(BuildContext context) {
    final color = switch (item.level) {
      TradeCopyConfigurationValidationLevel.error => _configurationRed,
      TradeCopyConfigurationValidationLevel.warning => AppColors.warn,
      TradeCopyConfigurationValidationLevel.info => _configurationPrimary,
    };

    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: .55),
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _validationIcon(item.level),
            color: color,
            size: TradeSpacingTokens.copyConfigurationValidationIcon,
          ),
          const SizedBox(width: _configurationSpace),
          Expanded(
            child: Text(
              item.message,
              style: AppTextStyles.caption.copyWith(
                color: color,
                height: _configurationDescriptionLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _modeLabel(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror => 'Mirror Copy',
    TradeCopyConfigurationMode.fixed => 'Fixed Ratio',
    TradeCopyConfigurationMode.smart => 'Smart Copy',
  };
}

String _modeDescription(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror =>
      'Sao chép chính xác tỷ lệ vị thế của provider.',
    TradeCopyConfigurationMode.fixed =>
      'Copy với tỷ lệ cố định để kiểm soát vốn tốt hơn.',
    TradeCopyConfigurationMode.smart =>
      'Tự điều chỉnh size theo volatility và risk.',
  };
}

IconData _validationIcon(TradeCopyConfigurationValidationLevel level) {
  return switch (level) {
    TradeCopyConfigurationValidationLevel.error => Icons.error_outline_rounded,
    TradeCopyConfigurationValidationLevel.warning =>
      Icons.warning_amber_rounded,
    TradeCopyConfigurationValidationLevel.info => Icons.info_outline_rounded,
  };
}
