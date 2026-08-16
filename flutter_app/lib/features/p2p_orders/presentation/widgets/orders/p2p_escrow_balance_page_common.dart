part of '../../phone/pages/orders/p2p_escrow_balance_page.dart';

class _EscrowHelpCard extends StatelessWidget {
  const _EscrowHelpCard({required this.snapshot});

  final P2PEscrowBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowBalancePage.helpKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pEscrowBalanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.article_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.helpTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final bullet in snapshot.helpBullets) ...[
            P2PHelpBullet(text: bullet),
            if (bullet != snapshot.helpBullets.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _EscrowEmptyState extends StatelessWidget {
  const _EscrowEmptyState({required this.snapshot});

  final P2PEscrowBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowBalancePage.emptyKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pEscrowBalanceLargePadding,
      child: Column(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          const VitCard(
            width: _p2pEscrowBalanceEmptyIconBox,
            height: _p2pEscrowBalanceEmptyIconBox,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.large,
            child: Icon(
              Icons.lock_open_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.emptyTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            snapshot.emptySubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

VitStatusPillStatus _statusPill(P2PEscrowOrderStatus status) {
  return switch (status) {
    P2PEscrowOrderStatus.pendingPayment => VitStatusPillStatus.warning,
    P2PEscrowOrderStatus.paid => VitStatusPillStatus.info,
    P2PEscrowOrderStatus.pendingRelease => VitStatusPillStatus.success,
    P2PEscrowOrderStatus.dispute => VitStatusPillStatus.error,
  };
}

IconData _statusIcon(P2PEscrowOrderStatus status) {
  return switch (status) {
    P2PEscrowOrderStatus.pendingPayment => Icons.schedule_rounded,
    P2PEscrowOrderStatus.paid => Icons.verified_user_outlined,
    P2PEscrowOrderStatus.pendingRelease => Icons.lock_outline_rounded,
    P2PEscrowOrderStatus.dispute => Icons.error_outline_rounded,
  };
}

Color _statusColor(P2PEscrowOrderStatus status) {
  return switch (status) {
    P2PEscrowOrderStatus.pendingPayment => AppColors.warn,
    P2PEscrowOrderStatus.paid => AppColors.primary,
    P2PEscrowOrderStatus.pendingRelease => AppColors.buy,
    P2PEscrowOrderStatus.dispute => AppColors.sell,
  };
}

String _formatAssetAmount(
  double value,
  String asset, {
  bool compactVnd = true,
}) {
  if (asset == 'BTC') {
    return '${value.toStringAsFixed(8)} BTC';
  }
  if (asset == 'VND') {
    return '${_formatVnd(value.round())}${compactVnd ? '' : ' VND'}';
  }
  return '${value.toStringAsFixed(2)} $asset';
}

String _formatVnd(int value) => formatP2PVnd(value);
