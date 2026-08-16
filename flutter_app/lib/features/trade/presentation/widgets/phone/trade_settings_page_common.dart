part of '../../phone/pages/hub/trade_settings_page.dart';

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    this.description,
    required this.trailing,
  });

  final String label;
  final String? description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: _settingsLineTight,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: _settingsTinySpace),
                Text(
                  description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navLabel.copyWith(
                    color: AppColors.text3,
                    height: _settingsLineBody,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: _settingsSpace),
        trailing,
      ],
    );
  }
}

class _VitToggle extends StatelessWidget {
  const _VitToggle({super.key, required this.on, required this.onToggle});

  final bool on;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      child: VitCard(
        onTap: onToggle,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.tight,
        padding: AppSpacing.zeroInsets,
        child: VitTogglePill(
          enabled: on,
          width: _settingsToggleWidth,
          height: _settingsToggleHeight,
          knobSize: _settingsToggleKnob,
          knobMargin: _settingsToggleKnobMargin,
          inactiveColor: AppColors.surface3,
          inactiveKnobColor: AppColors.onAccent,
          inactiveBorderColor: AppColors.surface3,
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: TradeSettingsPage.resetKey,
      onPressed: onReset,
      variant: VitCtaButtonVariant.danger,
      density: VitDensity.tool,
      height: _settingsButtonHeight,
      leading: const Icon(Icons.restart_alt_rounded),
      child: const Text('Đặt lại mặc định'),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    return const VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      title: 'Settings apply locally',
      message:
          'Settings are saved on this device and apply immediately. Other devices keep default settings until changed there.',
      contractId: 'SC-052 local settings result',
      density: VitDensity.tool,
    );
  }
}
