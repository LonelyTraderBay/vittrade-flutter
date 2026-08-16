part of '../../phone/pages/staking/staking_history_page.dart';

class _TransactionDetailCard extends StatelessWidget {
  const _TransactionDetailCard({
    super.key,
    required this.tx,
    required this.onClose,
  });

  final StakingHistoryTransactionDraft tx;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(tx.type);

    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _TypeIcon(type: tx.type),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeLabel(tx.type),
                      style: AppTextStyles.baseMedium.copyWith(color: color),
                    ),
                    Text(
                      tx.product,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: onClose,
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitKeyValueRow(
            label: 'Số lượng',
            value: '${tx.amountLabel} ${tx.asset}',
            labelWidth: EarnSpacingTokens.stakingHistoryDetailLabelWidth,
            padding: EarnSpacingTokens.earnTopPaddingX2,
          ),
          VitKeyValueRow(
            label: 'Giá trị USD',
            value: EarnFormatters.usd(tx.usdValue),
            labelWidth: EarnSpacingTokens.stakingHistoryDetailLabelWidth,
            padding: EarnSpacingTokens.earnTopPaddingX2,
          ),
          VitKeyValueRow(
            label: 'Thời gian',
            value: '${tx.date} ${tx.time}',
            labelWidth: EarnSpacingTokens.stakingHistoryDetailLabelWidth,
            padding: EarnSpacingTokens.earnTopPaddingX2,
          ),
          VitKeyValueRow(
            label: 'Trạng thái',
            value: _statusLabel(tx.status),
            labelWidth: EarnSpacingTokens.stakingHistoryDetailLabelWidth,
            padding: EarnSpacingTokens.earnTopPaddingX2,
          ),
          if (tx.txHash != null)
            VitKeyValueRow(
              label: 'Tx Hash',
              value: tx.txHash!,
              labelWidth: EarnSpacingTokens.stakingHistoryDetailLabelWidth,
              padding: EarnSpacingTokens.earnTopPaddingX2,
            ),
          if (tx.note != null)
            VitKeyValueRow(
              label: 'Ghi chú',
              value: tx.note!,
              labelWidth: EarnSpacingTokens.stakingHistoryDetailLabelWidth,
              padding: EarnSpacingTokens.earnTopPaddingX2,
            ),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList({required this.transactions, required this.onTap});

  final List<StakingHistoryTransactionDraft> transactions;
  final ValueChanged<StakingHistoryTransactionDraft> onTap;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const VitEmptyState(
        icon: Icons.history_rounded,
        title: 'Không tìm thấy giao dịch',
        message: 'Điều chỉnh bộ lọc hoặc từ khóa để xem lịch sử staking.',
      );
    }

    return Column(
      children: [
        for (var i = 0; i < transactions.length; i++) ...[
          _TransactionCard(
            key: i == 0
                ? StakingHistoryPage.firstTransactionKey
                : StakingHistoryPage.transactionKey(transactions[i].id),
            tx: transactions[i],
            onTap: () => onTap(transactions[i]),
          ),
          if (i != transactions.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({super.key, required this.tx, required this.onTap});

  final StakingHistoryTransactionDraft tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final amountColor = switch (tx.type) {
      StakingHistoryTransactionType.claim ||
      StakingHistoryTransactionType.compound ||
      StakingHistoryTransactionType.unstake => AppColors.buy,
      StakingHistoryTransactionType.penalty => AppColors.sell,
      StakingHistoryTransactionType.stake => AppColors.text1,
    };

    return VitCard(
      onTap: onTap,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          _TypeIcon(type: tx.type),
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
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitStatusPill(
                      label: _statusLabel(tx.status),
                      status: switch (tx.status) {
                        StakingHistoryTransactionStatus.completed =>
                          VitStatusPillStatus.success,
                        StakingHistoryTransactionStatus.pending =>
                          VitStatusPillStatus.warning,
                        StakingHistoryTransactionStatus.failed =>
                          VitStatusPillStatus.error,
                      },
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${tx.product} • ${tx.date} ${tx.time}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${tx.amountLabel} ${tx.asset}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: amountColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                EarnFormatters.usd(tx.usdValue),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final StakingHistoryTransactionType type;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(type);

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
      ),
      child: SizedBox(
        width: EarnSpacingTokens.stakingHistoryIconBox,
        height: EarnSpacingTokens.stakingHistoryIconBox,
        child: Icon(
          _typeIcon(type),
          color: color,
          size: EarnSpacingTokens.stakingHistoryIcon,
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          height: EarnSpacingTokens.stakingHistoryFooterLineHeight,
        ),
      ),
    );
  }
}
