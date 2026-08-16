part of '../../phone/pages/orders/p2p_my_orders_page.dart';

final class _StatMeta {
  const _StatMeta(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;
}

final class _StatusMeta {
  const _StatusMeta(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

_StatusMeta _statusMeta(String status) {
  return switch (status) {
    'pending_payment' => const _StatusMeta(
      'Chờ thanh toán',
      AppModuleAccents.p2p,
      Icons.schedule_rounded,
    ),
    'paid' => const _StatusMeta(
      'Đã thanh toán',
      AppColors.primary,
      Icons.schedule_rounded,
    ),
    'released' => const _StatusMeta(
      'Hoàn tất',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    'cancelled' => const _StatusMeta(
      'Đã hủy',
      AppColors.sell,
      Icons.cancel_outlined,
    ),
    'disputed' => const _StatusMeta(
      'Tranh chấp',
      AppColors.sell,
      Icons.report_problem_outlined,
    ),
    _ => const _StatusMeta('Hết hạn', AppColors.text3, Icons.schedule_rounded),
  };
}

VitStatusPillStatus _statusPillStatus(String status) {
  return switch (status) {
    'pending_payment' => VitStatusPillStatus.warning,
    'paid' => VitStatusPillStatus.info,
    'released' => VitStatusPillStatus.success,
    'cancelled' => VitStatusPillStatus.neutral,
    'disputed' => VitStatusPillStatus.error,
    _ => VitStatusPillStatus.neutral,
  };
}

String _formatCrypto(double value) => formatP2PCrypto(value);

String _formatVnd(num value) => formatP2PVnd(value);

String _formatCompactVnd(double value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(2)}M';
  }
  return _formatVnd(value);
}

String _formatDateTime(String value) {
  if (value.length < 16) return value;
  return '${value.substring(5, 10)} ${value.substring(11, 16)}';
}
