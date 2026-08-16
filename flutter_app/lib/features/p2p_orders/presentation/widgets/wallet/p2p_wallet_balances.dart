part of '../../phone/pages/wallet/p2p_wallet_page.dart';

class _BalanceSection extends StatelessWidget {
  const _BalanceSection({
    required this.snapshot,
    required this.expandedAsset,
    required this.onToggle,
  });

  final P2PWalletSnapshot snapshot;
  final String? expandedAsset;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: P2PWalletPage.balancesKey,
      label: 'Tài sản',
      accentColor: AppModuleAccents.p2p,
      density: VitDensity.compact,
      children: [
        for (final balance in snapshot.balances)
          _BalanceCard(
            snapshot: snapshot,
            balance: balance,
            expanded: expandedAsset == balance.asset,
            onToggle: () => onToggle(balance.asset),
          ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.snapshot,
    required this.balance,
    required this.expanded,
    required this.onToggle,
  });

  final P2PWalletSnapshot snapshot;
  final P2PWalletBalanceDraft balance;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PWalletPage.balanceKey(balance.asset),
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onToggle,
              borderRadius: AppRadii.cardLargeRadius,
              child: Padding(
                padding: _p2pWalletCardPadding,
                child: Row(
                  children: [
                    _AssetMark(symbol: balance.asset),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                balance.asset,
                                style: AppTextStyles.baseMedium.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              Flexible(
                                child: Text(
                                  '≈ \$${_formatComma(balance.usdValue, 2)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            _formatAssetTotal(balance),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    AnimatedRotation(
                      turns: expanded ? .5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(
              height: _p2pWalletDividerExtent,
              color: AppColors.borderSolid,
            ),
            Padding(
              padding: _p2pWalletCardPadding,
              child: Column(
                children: [
                  _BalanceBreakdown(balance: balance),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Row(
                    children: [
                      Expanded(
                        child: _InlineActionButton(
                          key: P2PWalletPage.depositKey(balance.asset),
                          label: 'Chuyển vào',
                          icon: Icons.add_rounded,
                          color: AppColors.buy,
                          onTap: () => context.go(
                            '${snapshot.transferRoute}?asset=${balance.asset}&type=deposit',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _InlineActionButton(
                          key: P2PWalletPage.withdrawKey(balance.asset),
                          label: 'Chuyển ra',
                          icon: Icons.remove_rounded,
                          color: AppModuleAccents.p2p,
                          onTap: () => context.go(
                            '${snapshot.transferRoute}?asset=${balance.asset}&type=withdraw',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (balance.inEscrow > 0) ...[
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    _EscrowDetailButton(
                      asset: balance.asset,
                      onTap: () => context.go(
                        '${snapshot.escrowBalanceRoute}?asset=${balance.asset}',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetMark extends StatelessWidget {
  const _AssetMark({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(symbol);
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.smRadius,
      child: SizedBox(
        width: _p2pWalletIconBoxExtent,
        height: _p2pWalletIconBoxExtent,
        child: Icon(_assetIcon(symbol), color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _BalanceBreakdown extends StatelessWidget {
  const _BalanceBreakdown({required this.balance});

  final P2PWalletBalanceDraft balance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BreakdownItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Khả dụng',
            value: _formatBalancePart(balance.available, balance.asset),
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _BreakdownItem(
            icon: Icons.lock_outline_rounded,
            label: 'Escrow',
            value: _formatBalancePart(balance.inEscrow, balance.asset),
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _BreakdownItem(
            icon: Icons.shield_outlined,
            label: 'Locked',
            value: _formatBalancePart(balance.locked, balance.asset),
            color: AppColors.text2,
          ),
        ),
      ],
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  const _BreakdownItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.text3, size: 11),
            const SizedBox(width: AppSpacing.x1),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
