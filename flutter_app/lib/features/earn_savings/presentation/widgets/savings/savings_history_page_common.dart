part of '../../phone/pages/savings/savings_history_page.dart';

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    super.key,
    required this.tx,
    required this.receiptRoute,
  });

  final SavingsHistoryTransactionDraft tx;
  final String receiptRoute;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(tx.type);
    final amountColor = _amountColor(tx.type);
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(receiptRoute);
      },
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3,
        child: Row(
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                color: typeColor.withValues(alpha: 0.16),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: SizedBox(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                child: Icon(
                  _typeIcon(tx.type),
                  color: typeColor,
                  size: EarnSpacingTokens.savingsHistoryTransactionIcon,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _typeLabel(tx.type),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (tx.status == SavingsHistoryTransactionStatus.pending)
                        Padding(
                          padding: EarnSpacingTokens.earnLeftPaddingX2(true),
                          child: const VitStatusPill(
                            label: 'Đang xử lý',
                            status: VitStatusPillStatus.warning,
                            size: VitStatusPillSize.sm,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '${tx.product} · ${tx.time}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tx.amount,
                  style: AppTextStyles.caption.copyWith(
                    color: amountColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tx.usdValue,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _TransactionGroup {
  const _TransactionGroup({required this.date, required this.transactions});

  final String date;
  final List<SavingsHistoryTransactionDraft> transactions;
}

List<_TransactionGroup> _groupTransactions(
  List<SavingsHistoryTransactionDraft> transactions,
) {
  final groups = <String, List<SavingsHistoryTransactionDraft>>{};
  for (final tx in transactions) {
    groups.putIfAbsent(tx.date, () => []).add(tx);
  }
  return [
    for (final entry in groups.entries)
      _TransactionGroup(date: entry.key, transactions: entry.value),
  ];
}

List<SavingsHistoryTransactionDraft> _filteredTransactions(
  List<SavingsHistoryTransactionDraft> transactions,
  _HistoryTypeFilter filter,
) {
  return transactions.where((tx) {
    return switch (filter) {
      _HistoryTypeFilter.all => true,
      _HistoryTypeFilter.subscribe =>
        tx.type == SavingsHistoryTransactionType.subscribe,
      _HistoryTypeFilter.redeem =>
        tx.type == SavingsHistoryTransactionType.redeem,
      _HistoryTypeFilter.interest =>
        tx.type == SavingsHistoryTransactionType.interest,
      _HistoryTypeFilter.compound =>
        tx.type == SavingsHistoryTransactionType.compound,
      _HistoryTypeFilter.early =>
        tx.type == SavingsHistoryTransactionType.earlyRedeem,
    };
  }).toList();
}

String _typeFilterLabel(_HistoryTypeFilter filter) {
  return switch (filter) {
    _HistoryTypeFilter.all => 'Tất cả',
    _HistoryTypeFilter.subscribe => 'Gửi',
    _HistoryTypeFilter.redeem => 'Rút',
    _HistoryTypeFilter.interest => 'Lãi',
    _HistoryTypeFilter.compound => 'Tái ĐT',
    _HistoryTypeFilter.early => 'Rút sớm',
  };
}

String _dateFilterLabel(_HistoryDateFilter filter) {
  return switch (filter) {
    _HistoryDateFilter.d7 => '7N',
    _HistoryDateFilter.d30 => '30N',
    _HistoryDateFilter.d90 => '90N',
    _HistoryDateFilter.all => 'Tất cả',
  };
}

String _typeLabel(SavingsHistoryTransactionType type) {
  return switch (type) {
    SavingsHistoryTransactionType.subscribe => 'Gửi tiết kiệm',
    SavingsHistoryTransactionType.redeem => 'Rút tiết kiệm',
    SavingsHistoryTransactionType.interest => 'Nhận lãi',
    SavingsHistoryTransactionType.compound => 'Tái đầu tư',
    SavingsHistoryTransactionType.earlyRedeem => 'Rút sớm',
  };
}

IconData _typeIcon(SavingsHistoryTransactionType type) {
  return switch (type) {
    SavingsHistoryTransactionType.subscribe => Icons.arrow_downward_rounded,
    SavingsHistoryTransactionType.redeem => Icons.arrow_upward_rounded,
    SavingsHistoryTransactionType.interest => Icons.trending_up_rounded,
    SavingsHistoryTransactionType.compound => Icons.bolt_rounded,
    SavingsHistoryTransactionType.earlyRedeem => Icons.warning_amber_rounded,
  };
}

Color _typeColor(SavingsHistoryTransactionType type) {
  return switch (type) {
    SavingsHistoryTransactionType.subscribe => AppColors.buy,
    SavingsHistoryTransactionType.redeem => AppColors.primary,
    SavingsHistoryTransactionType.interest => AppColors.accent,
    SavingsHistoryTransactionType.compound => AppColors.primarySoft,
    SavingsHistoryTransactionType.earlyRedeem => AppColors.sell,
  };
}

Color _amountColor(SavingsHistoryTransactionType type) {
  return switch (type) {
    SavingsHistoryTransactionType.interest ||
    SavingsHistoryTransactionType.compound => AppColors.buy,
    SavingsHistoryTransactionType.earlyRedeem ||
    SavingsHistoryTransactionType.redeem => AppColors.sell,
    SavingsHistoryTransactionType.subscribe => AppColors.text1,
  };
}
