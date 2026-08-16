part of '../../phone/pages/savings/auto_compound_settings_page.dart';

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.86,
      child: VitSheetSurface(
        color: AppColors.surface,
        borderRadius: AppRadii.sheetTopRadius,
        padding: AppSpacing.zeroInsets,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: WalletSpacingTokens.transferSheetPadding.copyWith(
              top: AppSpacing.x5,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      child: VitTogglePill(
        enabled: on,
        onChanged: (_) => onTap(),
        width: EarnSpacingTokens.autoCompoundSettingsSwitchWidth,
        height: AppSpacing.buttonCompact - AppSpacing.x2,
        knobSize: AppSpacing.x4,
        knobMargin: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.x1,
          top: AppSpacing.x1,
          right: AppSpacing.x1,
          bottom: AppSpacing.x1,
        ),
        activeColor: AppColors.buy,
        inactiveColor: AppColors.borderSolid,
        inactiveKnobColor: AppColors.onAccent,
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.xlRadius,
        side: BorderSide(color: color.withValues(alpha: 0.25)),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

List<double> _thresholdPresets(String asset) {
  return switch (asset) {
    'BTC' => const [0.00001, 0.0001, 0.001, 0.01],
    'ETH' => const [0.001, 0.005, 0.01, 0.05],
    _ => const [0.1, 0.5, 1, 5],
  };
}

String _frequencyLabel(String frequency) {
  return switch (frequency) {
    'daily' => 'Hàng ngày',
    'weekly' => 'Hàng tuần',
    'monthly' => 'Hàng tháng',
    _ => frequency,
  };
}

double _usdValue(String asset, double amount) {
  return switch (asset) {
    'BTC' => amount * 67543,
    'ETH' => amount * 2800,
    'SOL' => amount * 130,
    _ => amount,
  };
}

String _formatUsd(double value) => EarnFormatters.usd(value);

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  if (value < 0.01) return value.toStringAsFixed(6);
  if (value < 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(2);
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'ETH' => AppColors.primary,
    _ => AppColors.accent,
  };
}

Color _riskColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.warn,
  };
}
