part of '../../phone/pages/hub/copy_settings_page.dart';

class _CircuitBreakerCard extends StatelessWidget {
  const _CircuitBreakerCard({
    required this.enabled,
    required this.threshold,
    required this.onToggle,
    required this.onThresholdChanged,
  });

  final bool enabled;
  final double threshold;
  final VoidCallback onToggle;
  final ValueChanged<double> onThresholdChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: _settingsPrimary, size: 16),
              const SizedBox(width: WalletSpacingTokens.walletAssetSmallGap),
              Expanded(
                child: Text('Circuit Breaker', style: _cardTitleStyle()),
              ),
              _ToggleSwitch(
                key: CopySettingsPage.circuitBreakerKey,
                value: enabled,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Tự động dừng TẤT CẢ copy khi tổng portfolio lỗ quá X%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          if (enabled) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                Text(
                  'Ngưỡng kích hoạt',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
                const SizedBox(width: AppSpacing.x2),
                const Expanded(child: SizedBox.shrink()),
                Text(
                  '-${threshold.toStringAsFixed(0)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            _CompactSlider(
              value: threshold,
              min: 10,
              max: 50,
              divisions: 8,
              color: AppColors.sell,
              onChanged: onThresholdChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompactSlider extends StatelessWidget {
  const _CompactSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.color,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.ctaLoadingIcon,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: AppSpacing.formFieldLabelGap,
          activeTrackColor: color,
          inactiveTrackColor: _sliderInactive,
          thumbColor: color,
          overlayColor: AppColors.transparent,
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: WalletSpacingTokens.walletAssetSmallGap,
          ),
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.id,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String id;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _cardTitleStyle()),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.cardGap),
          _ToggleSwitch(
            key: CopySettingsPage.notificationKey(id),
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: value,
      child: VitCard(
        onTap: () => onChanged(!value),
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.tight,
        padding: AppSpacing.zeroInsets,
        child: VitTogglePill(
          enabled: value,
          activeColor: _settingsPrimary,
          inactiveColor: AppColors.surface3,
          inactiveBorderColor: AppColors.surface3,
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: AppSpacing.dividerHairline,
      thickness: AppSpacing.dividerHairline,
      color: AppColors.cardBorder,
    );
  }
}

class _ChannelButton extends StatelessWidget {
  const _ChannelButton({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      fullWidth: true,
      density: VitDensity.tool,
      leading: Icon(icon),
      semanticLabel: 'Kênh thông báo $label',
    );
  }
}
