part of '../../phone/pages/pending_deposits_page.dart';

class _StatusNotice extends StatelessWidget {
  const _StatusNotice({
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitInfoCallout(
      message: text,
      icon: icon,
      accentColor: color,
      iconSize: AppSpacing.iconSm,
      padding: AppSpacing.cardTilePadding,
      messageColor: color,
      messageWeight: AppTextStyles.bold,
      maxLines: 2,
    );
  }
}

class _DepositDetails extends StatelessWidget {
  const _DepositDetails({
    required this.deposit,
    required this.copied,
    required this.onCopy,
  });

  final WalletPendingDeposit deposit;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    // Flat detail rows — no nested VitCard chrome.
    return Column(
      children: [
        VitInfoRow(
          label: 'Xác nhận yêu cầu',
          value:
              '${deposit.confirmations}/${deposit.requiredConfirmations} xác nhận',
          leading: const Icon(Icons.fact_check_outlined),
          valueColor: _statusConfig(deposit.status).color,
          density: VitDensity.compact,
          showDivider: true,
        ),
        VitInfoRow(
          label: 'Dự kiến nhận',
          value: deposit.estimatedArrival,
          leading: const Icon(Icons.timelapse_rounded),
          density: VitDensity.compact,
          showDivider: true,
        ),
        VitInfoRow(
          label: 'Mạng',
          value: deposit.network,
          leading: const Icon(Icons.hub_outlined),
          density: VitDensity.compact,
          showDivider: true,
        ),
        VitInfoRow(
          label: 'Từ địa chỉ',
          value: _maskPendingAddress(deposit.fromAddress),
          leading: const Icon(Icons.account_balance_wallet_outlined),
          density: VitDensity.compact,
          showDivider: true,
        ),
        VitInfoRow(
          label: 'Mã giao dịch',
          value: _maskPendingAddress(deposit.txHash),
          leading: const Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.primary,
          density: VitDensity.compact,
          trailing: Semantics(
            button: true,
            label: copied
                ? 'Đã sao chép mã giao dịch của ${deposit.asset}'
                : 'Sao chép mã giao dịch của ${deposit.asset}',
            child: VitStatusPill(
              key: PendingDepositsPage.copyKey(deposit.id),
              label: copied ? 'Đã chép' : 'Sao chép',
              icon: copied ? Icons.check_rounded : Icons.content_copy_rounded,
              status: copied
                  ? VitStatusPillStatus.success
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
              onTap: onCopy,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyDeposits extends StatelessWidget {
  const _EmptyDeposits({
    required this.hasAnyDeposits,
    required this.onShowAll,
    required this.onDeposit,
  });

  final bool hasAnyDeposits;
  final VoidCallback onShowAll;
  final VoidCallback onDeposit;

  @override
  Widget build(BuildContext context) {
    if (hasAnyDeposits) {
      return VitEmptyState(
        title: 'Không có giao dịch nạp nào',
        message: 'Bộ lọc hiện tại không có giao dịch cần theo dõi.',
        icon: Icons.inbox_outlined,
        actionLabel: 'Xem tất cả',
        onAction: onShowAll,
      );
    }
    return VitEmptyState(
      title: 'Chưa có nạp đang chờ',
      message: 'Khi bạn gửi tiền vào ví, giao dịch sẽ xuất hiện tại đây.',
      icon: Icons.inbox_outlined,
      actionLabel: 'Nạp tiền',
      onAction: onDeposit,
    );
  }
}

class _InfoNotice extends StatelessWidget {
  const _InfoNotice();

  @override
  Widget build(BuildContext context) {
    return const VitInfoCallout(
      message:
          'Số xác nhận cần thiết phụ thuộc vào mạng blockchain. Nạp dưới mức tối thiểu sẽ không được ghi nhận. Liên hệ hỗ trợ nếu giao dịch chưa xuất hiện sau 1 giờ.',
      icon: Icons.warning_amber_rounded,
      accentColor: AppColors.primary,
      variant: VitCardVariant.standard,
      iconSize: AppSpacing.iconSm,
      padding: AppSpacing.cardTilePadding,
      messageStyle: AppTextStyles.micro,
    );
  }
}

final class _DepositStatusConfig {
  const _DepositStatusConfig({
    required this.label,
    required this.color,
    required this.icon,
    required this.status,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VitStatusPillStatus status;
}

_DepositStatusConfig _statusConfig(String status) {
  return switch (status) {
    'credited' => const _DepositStatusConfig(
      label: 'Đã ghi nhận',
      color: AppColors.buy,
      icon: Icons.check_circle_outline_rounded,
      status: VitStatusPillStatus.success,
    ),
    'failed' => const _DepositStatusConfig(
      label: 'Thất bại',
      color: AppColors.sell,
      icon: Icons.warning_amber_rounded,
      status: VitStatusPillStatus.error,
    ),
    'processing' => const _DepositStatusConfig(
      label: 'Đang xử lý',
      color: AppColors.primary,
      icon: Icons.sync_rounded,
      status: VitStatusPillStatus.info,
    ),
    _ => const _DepositStatusConfig(
      label: 'Đang xác nhận',
      color: AppColors.caution,
      icon: Icons.access_time_rounded,
      status: VitStatusPillStatus.warning,
    ),
  };
}

String _maskPendingAddress(String value) => maskAddress(value);
