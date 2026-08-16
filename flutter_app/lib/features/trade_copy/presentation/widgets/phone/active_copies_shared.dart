part of '../../phone/pages/hub/active_copies_page.dart';

const _copyPrimary = AppColors.primary;

final class _StatusStyle {
  const _StatusStyle({required this.label, required this.color});

  final String label;
  final Color color;
}

_StatusStyle _statusStyle(TradeActiveCopyStatus status) {
  return switch (status) {
    TradeActiveCopyStatus.active => const _StatusStyle(
      label: 'Đang chạy',
      color: AppColors.buy,
    ),
    TradeActiveCopyStatus.coolingOff => const _StatusStyle(
      label: 'Chờ kích hoạt',
      color: AppColors.caution,
    ),
    TradeActiveCopyStatus.paused => const _StatusStyle(
      label: 'Tạm dừng',
      color: AppColors.text3,
    ),
    TradeActiveCopyStatus.stopped => const _StatusStyle(
      label: 'Đã dừng',
      color: AppColors.sell,
    ),
  };
}

String _copyModeLabel(TradeActiveCopy copy) {
  return switch (copy.copyMode) {
    TradeActiveCopyMode.mirror => 'Mirror',
    TradeActiveCopyMode.fixed => 'Fixed ${copy.copyRatio?.toStringAsFixed(0)}%',
    TradeActiveCopyMode.smart => 'Smart',
  };
}

String _formatUsd(double value) {
  return '\$${value.toStringAsFixed(0)}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatUsd(value.abs())}';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${value.abs().toStringAsFixed(2)}%';
}
