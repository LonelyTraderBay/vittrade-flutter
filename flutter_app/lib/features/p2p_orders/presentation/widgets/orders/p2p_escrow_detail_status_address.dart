part of '../../phone/pages/orders/p2p_escrow_detail_page.dart';

class _EscrowStatusHero extends StatelessWidget {
  const _EscrowStatusHero({required this.snapshot});

  final P2PEscrowDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final order = snapshot.order;
    return VitCard(
      key: P2PEscrowDetailPage.heroKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.warningBorder,
      padding: P2PSpacingTokens.p2pEscrowDetailHeroPadding,
      child: Column(
        children: [
          const SizedBox.square(
            dimension: AppSpacing.x7,
            child: Material(
              color: AppColors.warn15,
              borderRadius: AppRadii.lgRadius,
              child: Icon(
                Icons.lock_outline_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(height: _p2pEscrowTightGap),
          Text(
            snapshot.statusLabel,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppModuleAccents.p2p,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _p2pEscrowTightGap),
          Text(
            '${_formatAmount4(order.escrowAmount)} ${order.asset} (${_formatVnd(order.totalVnd)} ${order.currency})',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _EscrowAddressCard extends StatelessWidget {
  const _EscrowAddressCard({
    required this.snapshot,
    required this.showFullAddress,
    required this.onReveal,
    required this.onCopy,
    required this.onExplorer,
  });

  final P2PEscrowDetailSnapshot snapshot;
  final bool showFullAddress;
  final VoidCallback onReveal;
  final VoidCallback onCopy;
  final VoidCallback onExplorer;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowDetailPage.addressKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pEscrowDetailCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.vpn_key_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Địa chỉ Escrow',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitStatusPill(
                key: P2PEscrowDetailPage.revealKey,
                label: showFullAddress ? 'Ẩn' : 'Hiện',
                status: VitStatusPillStatus.neutral,
                icon: showFullAddress
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: VitStatusPillSize.sm,
                onTap: onReveal,
              ),
            ],
          ),
          const SizedBox(height: _p2pEscrowTightGap),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.large,
            borderColor: AppColors.primary20,
            padding: P2PSpacingTokens.p2pEscrowDetailInnerPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    showFullAddress
                        ? snapshot.escrowAddress
                        : snapshot.maskedAddress,
                    maxLines: showFullAddress ? 3 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                VitIconButton(
                  key: P2PEscrowDetailPage.copyKey,
                  icon: Icons.copy_rounded,
                  tooltip: 'Copy địa chỉ escrow',
                  variant: VitIconButtonVariant.primary,
                  onPressed: onCopy,
                ),
              ],
            ),
          ),
          const SizedBox(height: _p2pEscrowTightGap),
          VitCard(
            key: P2PEscrowDetailPage.explorerKey,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            borderColor: AppColors.primary20,
            padding: P2PSpacingTokens.p2pEscrowDetailExplorerPadding,
            onTap: onExplorer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.open_in_new_rounded,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    'Xem trên Blockchain Explorer',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
