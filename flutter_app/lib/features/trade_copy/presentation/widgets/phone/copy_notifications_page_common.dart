part of '../../phone/pages/hub/copy_notifications_page.dart';

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({required this.activeTab});

  final String activeTab;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      icon: Icons.notifications_none_rounded,
      title: activeTab == 'unread'
          ? 'Không có thông báo chưa đọc'
          : 'Chưa có thông báo nào',
    );
  }
}

IconData _notificationIcon(TradeCopyNotification notification) {
  if (notification.severity == TradeCopyNotificationSeverity.critical) {
    return Icons.warning_amber_rounded;
  }
  return switch (notification.type) {
    TradeCopyNotificationType.trade => Icons.show_chart_rounded,
    TradeCopyNotificationType.risk => Icons.track_changes_rounded,
    TradeCopyNotificationType.update => Icons.feed_outlined,
    TradeCopyNotificationType.system => Icons.info_outline_rounded,
  };
}

Color _notificationColor(TradeCopyNotification notification) {
  if (notification.severity == TradeCopyNotificationSeverity.critical) {
    return AppColors.sell;
  }
  if (notification.severity == TradeCopyNotificationSeverity.warning) {
    return AppColors.warn;
  }
  return switch (notification.type) {
    TradeCopyNotificationType.trade => _notificationPrimary,
    TradeCopyNotificationType.risk => AppColors.sell,
    TradeCopyNotificationType.update => AppColors.accent,
    TradeCopyNotificationType.system => AppColors.text3,
  };
}

String _formatPnl(double value) {
  final prefix = value >= 0 ? '+' : '-';
  return '$prefix\$${value.abs().toStringAsFixed(0)}';
}
