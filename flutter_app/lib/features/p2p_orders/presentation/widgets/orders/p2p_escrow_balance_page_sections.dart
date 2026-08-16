part of '../../phone/pages/orders/p2p_escrow_balance_page.dart';

class _EscrowHeroCard extends StatelessWidget {
  const _EscrowHeroCard({required this.balance});

  final P2PEscrowAssetBalanceDraft balance;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowBalancePage.heroKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.warningBorder,
      padding: P2PSpacingTokens.p2pEscrowBalanceLargePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox.square(
                dimension: _p2pEscrowBalanceIconBox,
                child: Material(
                  color: AppColors.warn15,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                    side: BorderSide(color: AppColors.warningBorder),
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng đang escrow',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Text(
                      _formatAssetAmount(
                        balance.totalAmount,
                        balance.asset,
                        compactVnd: false,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppModuleAccents.p2p,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pEscrowBalanceTightGap),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            borderColor: AppColors.cardBorder,
            padding: P2PSpacingTokens.p2pEscrowBalanceInnerPadding,
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    '${balance.orderCount} đơn hàng đang giữ tiền',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.medium,
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

class _EscrowInfoCard extends StatelessWidget {
  const _EscrowInfoCard({required this.snapshot});

  final P2PEscrowBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return P2PNoticeCard(
      key: P2PEscrowBalancePage.infoKey,
      icon: Icons.info_outline_rounded,
      title: snapshot.infoTitle,
      message: snapshot.infoBody,
      titleColor: AppModuleAccents.p2p,
      borderColor: AppColors.primary20,
    );
  }
}

class _AssetTabs extends StatelessWidget {
  const _AssetTabs({
    required this.assets,
    required this.selectedAsset,
    required this.onChanged,
  });

  final List<P2PEscrowAssetBalanceDraft> assets;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: P2PEscrowBalancePage.tabsKey,
      activeKey: selectedAsset,
      onChanged: onChanged,
      tabs: [
        for (final asset in assets)
          VitTabItem(
            key: asset.asset,
            label: '${asset.asset} ${asset.orderCount}',
            icon: Icons.lock_outline_rounded,
          ),
      ],
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});

  final List<P2PEscrowOrderDraft> orders;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PEscrowBalancePage.ordersKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < orders.length; i++) ...[
          _EscrowOrderCard(order: orders[i]),
          if (i != orders.length - 1) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _EscrowOrderCard extends StatelessWidget {
  const _EscrowOrderCard({required this.order});

  final P2PEscrowOrderDraft order;

  @override
  Widget build(BuildContext context) {
    final status = _statusPill(order.status);
    final statusColor = _statusColor(order.status);
    final typeColor = order.type == P2PEscrowOrderType.buy
        ? AppColors.buy
        : AppColors.sell;

    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pEscrowBalanceCardPadding,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(AppRoutePaths.p2pOrder(order.canonicalOrderId));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          order.orderId,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        VitStatusPill(
                          label: order.typeLabel,
                          status: order.type == P2PEscrowOrderType.buy
                              ? VitStatusPillStatus.success
                              : VitStatusPillStatus.error,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.text3,
                          size: 12,
                        ),
                        const SizedBox(
                          width: AppSpacing.pageRhythmStandardInnerGap,
                        ),
                        Flexible(
                          child: Text(
                            order.counterparty,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: order.statusLabel,
                status: status,
                icon: _statusIcon(order.status),
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: _p2pEscrowBalanceSectionGap),
          Row(
            children: [
              Expanded(
                child: _OrderMetric(
                  label: 'Số tiền escrow',
                  value: _formatAssetAmount(order.amount, order.asset),
                  valueColor: AppModuleAccents.p2p,
                ),
              ),
              const SizedBox(width: _p2pEscrowBalanceTightGap),
              Expanded(
                child: _OrderMetric(
                  label: 'Giá trị',
                  value:
                      '${_formatVnd(order.fiatAmount)} ${order.fiatCurrency}',
                  valueColor: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.pageRhythmStandardInnerGap),
              Expanded(
                child: Text(
                  'Khóa lúc: ${order.lockedAt}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
          if (order.warning != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.standard,
              borderColor: AppColors.sell20,
              padding: P2PSpacingTokens.p2pEscrowBalanceInnerPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: statusColor,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      order.warning!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: _p2pEscrowBalanceBodyLineHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Align(
            alignment: Alignment.centerLeft,
            // card-tile: allow-start — fixed surface, not horizontal strip tile
            child: VitCard(
              width: _p2pEscrowBalanceAccentLineWidth,
              height: _p2pEscrowBalanceAccentLineHeight,
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.standard,
              background: ColoredBox(color: typeColor),
              clip: true,
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderMetric extends StatelessWidget {
  const _OrderMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
