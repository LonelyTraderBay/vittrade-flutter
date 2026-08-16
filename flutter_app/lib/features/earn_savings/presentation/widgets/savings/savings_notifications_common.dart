part of '../../phone/pages/savings/savings_notifications_page.dart';

class _ClearAllButton extends StatelessWidget {
  const _ClearAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: SavingsNotificationsPage.clearAllButtonKey,
      onPressed: onTap,
      variant: VitCtaButtonVariant.destructive,
      height: AppSpacing.buttonCompact,
      leading: const Icon(Icons.delete_outline_rounded),
      child: const Text('Xóa tất cả thông báo'),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      icon: Icons.notifications_off_outlined,
      title: 'Chưa có thông báo',
      message: 'Thông báo về tiết kiệm sẽ hiển thị tại đây',
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

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
            Icons.shield_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                height:
                    EarnSpacingTokens.savingsNotificationHistoryBodyLineHeight,
              ),
            ),
          ),
        ],
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
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
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
    return const Padding(
      padding: EarnSpacingTokens.earnTopPaddingX1,
      child: SizedBox(
        width: AppSpacing.x2,
        height: AppSpacing.x2,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.primary,
            shape: CircleBorder(),
          ),
        ),
      ),
    );
  }
}

Color _notificationColor(SavingsNotificationType type) {
  return switch (type) {
    SavingsNotificationType.maturity => AppColors.warn,
    SavingsNotificationType.apy => AppColors.buy,
    SavingsNotificationType.interest => AppColors.primary,
    SavingsNotificationType.compound => AppColors.accent,
    SavingsNotificationType.product => AppColors.primarySoft,
    SavingsNotificationType.system => AppColors.text3,
  };
}

Color _notificationFill(SavingsNotificationType type) {
  return switch (type) {
    SavingsNotificationType.maturity => AppColors.warn10,
    SavingsNotificationType.apy => AppColors.buy10,
    SavingsNotificationType.interest => AppColors.primary08,
    SavingsNotificationType.compound => AppColors.accent08,
    SavingsNotificationType.product => AppColors.primary08,
    SavingsNotificationType.system => AppColors.surface2,
  };
}

IconData _notificationIcon(SavingsNotificationType type) {
  return switch (type) {
    SavingsNotificationType.maturity => Icons.calendar_today_outlined,
    SavingsNotificationType.apy => Icons.trending_up_rounded,
    SavingsNotificationType.interest => Icons.savings_outlined,
    SavingsNotificationType.compound => Icons.bolt_rounded,
    SavingsNotificationType.product => Icons.notifications_none_rounded,
    SavingsNotificationType.system => Icons.settings_outlined,
  };
}

Color _priorityColor(SavingsNotificationPriority priority) {
  return switch (priority) {
    SavingsNotificationPriority.high => AppColors.sell,
    SavingsNotificationPriority.medium => AppColors.primary,
    SavingsNotificationPriority.low => AppColors.text3,
  };
}

String _priorityLabel(SavingsNotificationPriority priority) {
  return switch (priority) {
    SavingsNotificationPriority.high => 'Quan trọng',
    SavingsNotificationPriority.medium => 'Trung bình',
    SavingsNotificationPriority.low => 'Phụ',
  };
}

IconData _settingsIcon(String iconKey) {
  return switch (iconKey) {
    'calendar' => Icons.calendar_today_outlined,
    'trend' => Icons.trending_up_rounded,
    'piggy' => Icons.savings_outlined,
    'zap' => Icons.bolt_rounded,
    'bell' => Icons.notifications_none_rounded,
    'alert' => Icons.warning_amber_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.notifications_none_rounded,
  };
}
