part of '../../phone/pages/staking/staking_notifications_page.dart';

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingNotificationsPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: VitRiskDisclaimerNote(message: text),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.large,
        padding: AppSpacing.zeroInsets,
        onTap: onTap,
        child: VitTogglePill(
          enabled: on,
          width: EarnSpacingTokens.stakingNotificationsSwitchWidth,
          height: EarnSpacingTokens.stakingNotificationsSwitchHeight,
          knobSize: EarnSpacingTokens.stakingNotificationsSwitchThumb,
          knobMargin: EarnSpacingTokens.earnPaddingX1,
          activeColor: AppColors.buy,
          inactiveColor: AppColors.primary30,
          inactiveKnobColor: AppColors.onAccent,
          inactiveBorderColor: AppColors.primary30,
          duration: const Duration(milliseconds: 180),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.13),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.30)),
          borderRadius: AppRadii.lgRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnLeftPaddingX2(
        true,
      ).add(EarnSpacingTokens.earnTopPaddingX1),
      child: const SizedBox(
        width: AppSpacing.x2,
        height: AppSpacing.x2,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: AppModuleAccents.earn,
            shape: CircleBorder(),
          ),
        ),
      ),
    );
  }
}

Color _priorityColor(StakingNotificationPriority priority) {
  return switch (priority) {
    StakingNotificationPriority.high => AppColors.sell,
    StakingNotificationPriority.medium => AppModuleAccents.earn,
    StakingNotificationPriority.low => AppColors.text3,
  };
}

IconData _settingsIcon(String iconKey) {
  return switch (iconKey) {
    'calendar' => Icons.calendar_today_outlined,
    'trend' => Icons.trending_up_rounded,
    'reward' => Icons.attach_money_rounded,
    'zap' => Icons.bolt_rounded,
    'alert' => Icons.warning_amber_rounded,
    'clock' => Icons.schedule_rounded,
    _ => Icons.notifications_none_rounded,
  };
}

Color _notificationColor(StakingNotificationType type) {
  return switch (type) {
    StakingNotificationType.maturity => AppModuleAccents.earn,
    StakingNotificationType.apyChange => AppColors.buy,
    StakingNotificationType.reward => AppColors.buy,
    StakingNotificationType.risk => AppColors.sell,
    StakingNotificationType.system => AppModuleAccents.earn,
  };
}

IconData _notificationIcon(StakingNotificationType type) {
  return switch (type) {
    StakingNotificationType.maturity => Icons.calendar_today_outlined,
    StakingNotificationType.apyChange => Icons.trending_up_rounded,
    StakingNotificationType.reward => Icons.attach_money_rounded,
    StakingNotificationType.risk => Icons.warning_amber_rounded,
    StakingNotificationType.system => Icons.bolt_rounded,
  };
}
