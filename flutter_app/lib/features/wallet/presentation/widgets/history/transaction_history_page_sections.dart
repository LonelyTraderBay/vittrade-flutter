part of '../../phone/pages/transaction_history_page.dart';

class _HistorySummaryBar extends StatelessWidget {
  const _HistorySummaryBar({required this.count, this.exportNotice});

  final int count;
  final String? exportNotice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$count giao dịch',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        if (exportNotice != null) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: _historyPrimary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  exportNotice!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

final class _TransactionDateGroup {
  const _TransactionDateGroup({required this.date, required this.transactions});

  final String date;
  final List<WalletTransaction> transactions;
}

class _TransactionGroup extends StatelessWidget {
  const _TransactionGroup({
    required this.group,
    required this.onTransactionTap,
  });

  final _TransactionDateGroup group;
  final ValueChanged<WalletTransaction> onTransactionTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: _formatDate(group.date),
      headerIcon: Icons.calendar_today_outlined,
      headerIconColor: AppColors.text2,
      headerVariant: VitSectionHeaderVariant.plain,
      headerDensity: VitDensity.compact,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [
        for (final tx in group.transactions)
          _TransactionRow(tx: tx, onTap: () => onTransactionTap(tx)),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx, required this.onTap});

  final WalletTransaction tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = _TransactionMeta.from(tx);

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: TransactionHistoryPage.transactionKey(tx.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      density: VitDensity.compact,
      constraints: const BoxConstraints(
        minHeight: WalletSpacingTokens.walletHistoryItemMinHeight,
      ),
      borderColor: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _TransactionIcon(meta: meta),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TransactionInfo(tx: tx, meta: meta),
              ),
              const SizedBox(width: AppSpacing.x2),
              _AmountStatus(tx: tx, meta: meta),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const Divider(
            height: WalletSpacingTokens.walletHistoryDividerHeight,
            thickness: WalletSpacingTokens.walletHistoryDividerHeight,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _TransactionIcon extends StatelessWidget {
  const _TransactionIcon({required this.meta});

  final _TransactionMeta meta;

  @override
  Widget build(BuildContext context) {
    if (meta.isTrade) {
      // card-tile: allow-start — fixed surface, not horizontal strip tile
      return VitCard(
        variant: VitCardVariant.inner,
        radius: VitCardRadius.standard,
        width: AppSpacing.buttonCompact,
        height: AppSpacing.buttonCompact,
        alignment: Alignment.center,
        borderColor: meta.color.withValues(alpha: .22),
        child: const Icon(
          Icons.currency_exchange_rounded,
          color: _historyPrimary,
          size: AppSpacing.iconSm,
        ),
      );
    }

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      alignment: Alignment.center,
      borderColor: meta.color.withValues(alpha: .22),
      child: Icon(meta.icon, color: AppColors.text1, size: AppSpacing.iconSm),
    );
  }
}

class _TransactionInfo extends StatelessWidget {
  const _TransactionInfo({required this.tx, required this.meta});

  final WalletTransaction tx;
  final _TransactionMeta meta;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${meta.label} ${tx.asset}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: WalletSpacingTokens.walletHistoryLineSpacing),
        Text(
          _timePart(tx.createdAt),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        if (tx.network != null) ...[
          const SizedBox(height: WalletSpacingTokens.walletHistoryLineSpacing),
          Text(
            'Mạng: ${tx.network}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
        if (tx.txHash != null) ...[
          const SizedBox(height: WalletSpacingTokens.walletHistoryLineSpacing),
          Text(
            _maskTxHash(tx.txHash!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}
