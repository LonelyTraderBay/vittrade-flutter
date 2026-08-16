part of '../../phone/pages/staking/staking_history_page.dart';

String _typeFilterLabel(_HistoryTypeFilter filter) {
  return switch (filter) {
    _HistoryTypeFilter.all => 'Tất cả',
    _HistoryTypeFilter.stake => 'Stake',
    _HistoryTypeFilter.unstake => 'Unstake',
    _HistoryTypeFilter.claim => 'Nhận lãi',
    _HistoryTypeFilter.compound => 'Tái đầu tư',
    _HistoryTypeFilter.penalty => 'Phí phạt',
  };
}

String _statusFilterLabel(_HistoryStatusFilter filter) {
  return switch (filter) {
    _HistoryStatusFilter.all => 'Tất cả',
    _HistoryStatusFilter.completed => 'Hoàn thành',
    _HistoryStatusFilter.pending => 'Đang xử lý',
    _HistoryStatusFilter.failed => 'Thất bại',
  };
}

String _typeLabel(StakingHistoryTransactionType type) {
  return switch (type) {
    StakingHistoryTransactionType.stake => 'Stake',
    StakingHistoryTransactionType.unstake => 'Unstake',
    StakingHistoryTransactionType.claim => 'Nhận lãi',
    StakingHistoryTransactionType.compound => 'Tái đầu tư',
    StakingHistoryTransactionType.penalty => 'Phí phạt',
  };
}

String _statusLabel(StakingHistoryTransactionStatus status) {
  return switch (status) {
    StakingHistoryTransactionStatus.completed => 'Hoàn thành',
    StakingHistoryTransactionStatus.pending => 'Đang xử lý',
    StakingHistoryTransactionStatus.failed => 'Thất bại',
  };
}

Color _typeColor(StakingHistoryTransactionType type) {
  return switch (type) {
    StakingHistoryTransactionType.stake => AppColors.buy,
    StakingHistoryTransactionType.unstake => AppColors.sell,
    StakingHistoryTransactionType.claim => AppColors.primarySoft,
    StakingHistoryTransactionType.compound => AppColors.accent,
    StakingHistoryTransactionType.penalty => AppColors.warn,
  };
}

IconData _typeIcon(StakingHistoryTransactionType type) {
  return switch (type) {
    StakingHistoryTransactionType.stake => Icons.arrow_outward_rounded,
    StakingHistoryTransactionType.unstake => Icons.south_east_rounded,
    StakingHistoryTransactionType.claim => Icons.attach_money_rounded,
    StakingHistoryTransactionType.compound => Icons.trending_up_rounded,
    StakingHistoryTransactionType.penalty => Icons.cancel_outlined,
  };
}
