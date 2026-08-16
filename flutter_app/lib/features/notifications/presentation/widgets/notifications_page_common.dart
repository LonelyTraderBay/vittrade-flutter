part of '../phone/pages/notifications_page.dart';

final class _NotificationTypeStyle {
  const _NotificationTypeStyle({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

_NotificationTypeStyle _typeStyle(AppNotificationType type) {
  return switch (type) {
    AppNotificationType.trade => const _NotificationTypeStyle(
      label: 'Giao dịch',
      icon: Icons.check_circle_rounded,
      color: AppColors.buy,
    ),
    AppNotificationType.deposit => const _NotificationTypeStyle(
      label: 'Nạp tiền',
      icon: Icons.arrow_downward_rounded,
      color: AppColors.primary,
    ),
    AppNotificationType.withdraw => const _NotificationTypeStyle(
      label: 'Rút tiền',
      icon: Icons.arrow_upward_rounded,
      color: AppColors.accent,
    ),
    AppNotificationType.security => const _NotificationTypeStyle(
      label: 'Bảo mật',
      icon: Icons.lock_rounded,
      color: AppColors.sell,
    ),
    AppNotificationType.system => const _NotificationTypeStyle(
      label: 'Hệ thống',
      icon: Icons.settings_rounded,
      color: AppColors.text2,
    ),
    AppNotificationType.p2p => const _NotificationTypeStyle(
      label: 'P2P',
      icon: Icons.handshake_rounded,
      color: AppColors.buy,
    ),
    AppNotificationType.priceAlert => const _NotificationTypeStyle(
      label: 'Cảnh báo giá',
      icon: Icons.notifications_active_rounded,
      color: AppColors.warn,
    ),
    AppNotificationType.referral => const _NotificationTypeStyle(
      label: 'Giới thiệu',
      icon: Icons.card_giftcard_rounded,
      color: AppColors.warn,
    ),
    AppNotificationType.arena => const _NotificationTypeStyle(
      label: 'Open Arena',
      icon: Icons.military_tech_rounded,
      color: AppColors.accent,
    ),
  };
}

String? _safeActionPath(String? rawPath) {
  return switch (rawPath) {
    null || '' => null,
    '/trade/orders' => '/trade/orders-history',
    '/pair/ethusdt' => '/pair/ethusdt',
    '/wallet' => '/wallet',
    '/profile/activity' => '/profile/activity',
    '/p2p/order/p2p001' => '/p2p/order/p2p001',
    '/news' => '/news',
    '/wallet/history' => '/wallet/history',
    '/referral/rewards' => '/referral/rewards',
    '/referral/history' => '/referral/history',
    '/arena/challenge/ch001' => '/arena/challenge/ch001',
    '/arena/challenge/room003' => '/arena/challenge/room003',
    '/arena/points' => '/arena/points',
    '/arena/challenge/room002' => '/arena/challenge/room002',
    '/arena/mode/mode001' => '/arena/mode/mode001',
    _ => null,
  };
}
