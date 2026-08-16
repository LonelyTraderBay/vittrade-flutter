part of '../../phone/pages/hub/p2p_settings_page.dart';

class _HoursSection extends StatelessWidget {
  const _HoursSection({required this.mode, required this.onChanged});

  final String mode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSettingsPage.hoursKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Giờ giao dịch',
          icon: Icons.schedule_rounded,
          iconColor: AppColors.buy,
          iconSize: AppSpacing.iconSm,
          titleColor: AppColors.text2,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: P2PSpacingTokens.p2pSettingsPageCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VitSegmentedChoice<String>(
                selected: mode,
                onChanged: onChanged,
                options: const [
                  VitSegmentedChoiceOption(value: '247', label: '24/7'),
                  VitSegmentedChoiceOption(value: 'custom', label: 'Tùy chỉnh'),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                mode == '247'
                    ? 'Quảng cáo của bạn hiển thị mọi lúc.'
                    : 'Quảng cáo chỉ hiển thị từ 08:00 đến 22:00 (GMT+7).',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AutoReplySection extends StatelessWidget {
  const _AutoReplySection({
    required this.autoReply,
    required this.enabled,
    required this.onToggle,
  });

  final P2PSettingsAutoReplyDraft autoReply;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSettingsPage.autoReplyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Tin nhắn tự động',
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: AppColors.primary,
          iconSize: AppSpacing.iconSm,
          titleColor: AppColors.text2,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: P2PSpacingTokens.p2pSettingsPageCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SettingToggleRow(
                toggle: const P2PSettingsToggleDraft(
                  id: 'auto_reply',
                  label: 'Tự động gửi tin nhắn',
                  description: 'Gửi ngay khi đối tác tạo đơn',
                  iconKey: 'message',
                  toneKey: 'primary',
                  enabled: true,
                ),
                value: enabled,
                onToggle: onToggle,
                last: true,
              ),
              if (enabled) ...[
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Mẫu tin nhắn MUA',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Sửa',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.primary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitCard(
                  variant: VitCardVariant.inner,
                  padding: P2PSpacingTokens.p2pSettingsPageCompactCardPadding,
                  child: Text(
                    autoReply.buyTemplate,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: _p2pSettingsAutoReplyLineHeight,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.buttonCompact,
      child: Material(
        color: color.withValues(alpha: .10),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _SwitchButton extends StatelessWidget {
  const _SwitchButton({
    super.key,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final bool value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: value,
      child: VitCard(
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: AppSpacing.zeroInsets,
        child: VitTogglePill(
          enabled: value,
          width: _p2pSettingsSwitchWidth,
          height: _p2pSettingsSwitchHeight,
          knobSize: _p2pSettingsSwitchThumbSize,
          knobMargin: P2PSpacingTokens.p2pSettingsSwitchPadding,
          activeColor: color,
        ),
      ),
    );
  }
}

IconData _settingsIcon(String iconKey) {
  return switch (iconKey) {
    'bell' => Icons.notifications_none_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'alert' => Icons.report_problem_outlined,
    'globe' => Icons.public_rounded,
    'volume' => Icons.volume_up_outlined,
    'eye' => Icons.visibility_outlined,
    'shield' => Icons.shield_outlined,
    'wallet' => Icons.account_balance_wallet_outlined,
    'clock' => Icons.schedule_rounded,
    'lock' => Icons.lock_outline_rounded,
    'fingerprint' => Icons.fingerprint_rounded,
    _ => Icons.tune_rounded,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'danger' => AppColors.sell,
    'accent' => AppColors.accent,
    'warning' => AppColors.warn,
    _ => AppColors.primary,
  };
}
