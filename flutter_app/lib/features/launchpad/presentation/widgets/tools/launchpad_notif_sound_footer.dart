part of '../../phone/pages/tools/launchpad_notif_sound_page.dart';

class _InlineSaveActions extends StatelessWidget {
  const _InlineSaveActions({
    required this.saved,
    required this.hasChanges,
    required this.onSave,
  });

  final bool saved;
  final bool hasChanges;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadNotifSoundPage.footerKey,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (saved) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Đã lưu cài đặt',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
          VitCtaButton(
            key: LaunchpadNotifSoundPage.saveKey,
            onPressed: onSave,
            leading: const Icon(Icons.notifications_none_rounded),
            child: Text(
              saved
                  ? 'Lưu cài đặt âm thanh'
                  : hasChanges
                  ? 'Lưu cài đặt âm thanh'
                  : 'Lưu cài đặt âm thanh',
            ),
          ),
        ],
      ),
    );
  }
}

class _SoundSwitch extends StatelessWidget {
  const _SoundSwitch({
    super.key,
    required this.enabled,
    required this.onTap,
    this.small = false,
  });

  final bool enabled;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final width = small
        ? AppSpacing.x6 + LaunchpadSpacingTokens.launchpadGapXxs
        : LaunchpadSpacingTokens.launchpadBox44 + AppSpacing.hairlineStroke;
    final height = small
        ? AppSpacing.iconMd + AppSpacing.dividerHairline
        : AppSpacing.iconMd + AppSpacing.x2;
    final knob = small
        ? AppSpacing.iconMd - AppSpacing.x1
        : AppSpacing.iconMd + AppSpacing.dividerHairline;

    return Semantics(
      button: true,
      toggled: enabled,
      // card-tile: allow-start — fixed surface, not horizontal strip tile
      child: VitCard(
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        width: width,
        height: height,
        padding: AppSpacing.zeroInsets,
        clip: true,
        child: VitTogglePill(
          enabled: enabled,
          width: width,
          height: height,
          knobSize: knob,
          knobMargin: AppSpacing.zeroInsets,
          activeColor: AppModuleAccents.launchpad,
          inactiveColor: AppColors.surface3,
          activeKnobColor: AppColors.onAccent,
          inactiveKnobColor: AppColors.onAccent,
          inactiveBorderColor: AppColors.borderSolid,
          duration: const Duration(milliseconds: 180),
        ),
      ),
    );
  }
}

IconData _categoryIcon(String iconKey) {
  return switch (iconKey) {
    'chart' => Icons.query_stats_rounded,
    'check' => Icons.check_box_rounded,
    'unlock' => Icons.lock_open_rounded,
    'bridge' => Icons.compare_arrows_rounded,
    'gift' => Icons.card_giftcard_rounded,
    'shield' => Icons.shield_outlined,
    'chat' => Icons.chat_bubble_outline_rounded,
    'settings' => Icons.settings_rounded,
    _ => Icons.notifications_none_rounded,
  };
}

String _hourLabel(int hour) {
  return '${hour.toString().padLeft(2, '0')}:00';
}
