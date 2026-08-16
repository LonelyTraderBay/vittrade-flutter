part of '../../phone/pages/savings/savings_auto_rebalance_page.dart';

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.settings,
    required this.autoEnabled,
    required this.onAutoChanged,
  });

  final SavingsRebalanceSettingsDraft settings;
  final bool autoEnabled;
  final ValueChanged<bool> onAutoChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.compact,
      children: [
        _AutoStatusCard(
          autoEnabled: autoEnabled,
          settings: settings,
          onChanged: onAutoChanged,
        ),
        VitCard(
          radius: VitCardRadius.large,
          padding: _savingsRebalanceCardPadding,
          child: Column(
            children: [
              _SettingsRow(
                icon: Icons.calendar_today_rounded,
                label: 'Tần suất',
                value: settings.frequencyLabel,
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.tune_rounded,
                label: 'Ngưỡng rebalance',
                value: '${settings.driftThreshold.toStringAsFixed(0)}%',
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.lock_outline_rounded,
                label: 'Bỏ qua vị thế khóa',
                value: settings.skipLocked ? 'Bật' : 'Tắt',
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.payments_outlined,
                label: 'Lệnh tối thiểu',
                value: _formatUsd(settings.minTradeSize),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: _savingsRebalanceInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(value, style: _captionMedium.copyWith(color: AppColors.text1)),
        ],
      ),
    );
  }
}
