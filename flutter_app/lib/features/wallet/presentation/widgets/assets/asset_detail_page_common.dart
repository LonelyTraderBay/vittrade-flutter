part of '../../phone/pages/assets/asset_detail_page.dart';

class _AssetTransactions extends StatelessWidget {
  const _AssetTransactions({
    required this.transactions,
    required this.onNavigate,
  });

  final List<WalletAssetDetailTransaction> transactions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const VitEmptyState(
        title: 'Chưa có giao dịch',
        message: 'Nạp, rút, chuyển và giao dịch gần đây sẽ hiển thị tại đây.',
        icon: Icons.receipt_long_outlined,
      );
    }

    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.overlayStroke,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final tx in transactions)
            _AssetTransactionRow(tx: tx, onTap: () => onNavigate(tx.route)),
        ],
      ),
    );
  }
}

class _AssetTransactionRow extends StatelessWidget {
  const _AssetTransactionRow({required this.tx, required this.onTap});

  final WalletAssetDetailTransaction tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = tx.isIncoming ? _assetGreen : _assetRed;
    return VitCard(
      key: AssetDetailPage.transactionKey(tx.id),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: VitDensity.compact.cardPadding,
      onTap: onTap,
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            width: WalletSpacingTokens.walletAssetTransactionIcon,
            height: WalletSpacingTokens.walletAssetTransactionIcon,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .20),
            child: Icon(
              tx.isIncoming
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: color,
              size: WalletSpacingTokens.walletAssetTransactionGlyph,
            ),
          ),
          const SizedBox(width: WalletSpacingTokens.walletAssetTransactionsGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: WalletSpacingTokens.walletAssetSmallGap),
                Text(
                  tx.createdAt,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${tx.isIncoming ? '+' : '-'}${_formatFixed(tx.amount, 6)} ${tx.asset}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: WalletSpacingTokens.walletAssetSmallGap),
                VitStatusPill(
                  label: tx.status,
                  status: tx.isIncoming
                      ? VitStatusPillStatus.success
                      : VitStatusPillStatus.error,
                  size: VitStatusPillSize.sm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatUsd(double value) => formatWalletUsdGrouped(value);

String _formatFixed(double value, int decimals) {
  return walletGroupThousands(value.toStringAsFixed(decimals));
}

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
