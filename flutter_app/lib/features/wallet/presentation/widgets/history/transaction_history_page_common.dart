part of '../../phone/pages/transaction_history_page.dart';

class _AmountStatus extends StatelessWidget {
  const _AmountStatus({required this.tx, required this.meta});

  final WalletTransaction tx;
  final _TransactionMeta meta;

  @override
  Widget build(BuildContext context) {
    final status = _StatusMeta.from(tx.status);

    return SizedBox(
      width: WalletSpacingTokens.walletHistoryAmountColumnWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${meta.isDebit ? '-' : '+'}${_formatAmount(tx)} ${tx.asset}',
            maxLines: 1,
            overflow: TextOverflow.visible,
            softWrap: false,
            style: AppTextStyles.caption.copyWith(
              color: meta.color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: WalletSpacingTokens.walletHistoryLineSpacing),
          VitStatusPill(
            label: status.label,
            status: _pillStatus(tx.status),
            size: VitStatusPillSize.sm,
          ),
          if (tx.fee != null && tx.fee! > 0) ...[
            const SizedBox(
              height: WalletSpacingTokens.walletHistoryLineSpacing,
            ),
            Text(
              'Phí: \$${tx.fee!.toStringAsFixed(2)}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}

class _EndOfList extends StatelessWidget {
  const _EndOfList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: WalletSpacingTokens.walletHistoryEndListTopPad),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: WalletSpacingTokens.walletHistoryDividerWidth,
              child: Divider(
                height: WalletSpacingTokens.walletHistoryDividerHeight,
                thickness: WalletSpacingTokens.walletHistoryDividerHeight,
                color: AppColors.borderSolid,
              ),
            ),
            const SizedBox(width: WalletSpacingTokens.walletHistoryEndListGap),
            Text(
              'Đã tải hết',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(width: WalletSpacingTokens.walletHistoryEndListGap),
            const SizedBox(
              width: WalletSpacingTokens.walletHistoryDividerWidth,
              child: Divider(
                height: WalletSpacingTokens.walletHistoryDividerHeight,
                thickness: WalletSpacingTokens.walletHistoryDividerHeight,
                color: AppColors.borderSolid,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: WalletSpacingTokens.walletHistoryEndListBottomPad,
        ),
      ],
    );
  }
}

final class _TransactionMeta {
  const _TransactionMeta({
    required this.label,
    required this.color,
    required this.icon,
    required this.isDebit,
    required this.isTrade,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isDebit;
  final bool isTrade;

  factory _TransactionMeta.from(WalletTransaction tx) {
    return switch (tx.type) {
      WalletTransactionType.deposit => const _TransactionMeta(
        label: 'Nạp',
        color: _historyGreen,
        icon: Icons.arrow_downward_rounded,
        isDebit: false,
        isTrade: false,
      ),
      WalletTransactionType.withdraw => const _TransactionMeta(
        label: 'Rút',
        color: _historyRed,
        icon: Icons.arrow_upward_rounded,
        isDebit: true,
        isTrade: false,
      ),
      WalletTransactionType.tradeBuy => const _TransactionMeta(
        label: 'Mua',
        color: _historyGreen,
        icon: Icons.currency_exchange_rounded,
        isDebit: false,
        isTrade: true,
      ),
      WalletTransactionType.tradeSell => const _TransactionMeta(
        label: 'Bán',
        color: _historyRed,
        icon: Icons.currency_exchange_rounded,
        isDebit: true,
        isTrade: true,
      ),
      WalletTransactionType.p2pBuy => const _TransactionMeta(
        label: 'P2P Mua',
        color: _historyGreen,
        icon: Icons.handshake_rounded,
        isDebit: false,
        isTrade: false,
      ),
      WalletTransactionType.p2pSell => const _TransactionMeta(
        label: 'P2P Bán',
        color: _historyRed,
        icon: Icons.handshake_rounded,
        isDebit: true,
        isTrade: false,
      ),
    };
  }
}

final class _StatusMeta {
  const _StatusMeta({required this.label});

  final String label;

  factory _StatusMeta.from(WalletTransactionStatus status) {
    return switch (status) {
      WalletTransactionStatus.completed => const _StatusMeta(
        label: 'Hoàn thành',
      ),
      WalletTransactionStatus.pending => const _StatusMeta(label: 'Đang xử lý'),
      WalletTransactionStatus.failed => const _StatusMeta(label: 'Thất bại'),
    };
  }
}

VitStatusPillStatus _pillStatus(WalletTransactionStatus status) {
  return switch (status) {
    WalletTransactionStatus.completed => VitStatusPillStatus.success,
    WalletTransactionStatus.pending => VitStatusPillStatus.warning,
    WalletTransactionStatus.failed => VitStatusPillStatus.error,
  };
}

String _formatDate(String rawDate) {
  final parts = rawDate.split('-');
  if (parts.length != 3) return rawDate;
  return '${parts[2]}/${parts[1]}/${parts[0]}';
}

String _timePart(String raw) {
  final parts = raw.split(' ');
  return parts.length > 1 ? parts[1] : raw;
}

String _formatAmount(WalletTransaction tx) {
  if (tx.asset == 'BTC') return tx.amount.toStringAsFixed(6);
  if (tx.asset == 'ETH') return tx.amount.toStringAsFixed(4);
  return _formatNumber(tx.amount, fractionDigits: 2);
}

String _formatNumber(double value, {required int fractionDigits}) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (fractionDigits == 0) return buffer.toString();
  return '${buffer.toString()}.${parts[1]}';
}

String _maskTxHash(String value) => maskAddress(value);
