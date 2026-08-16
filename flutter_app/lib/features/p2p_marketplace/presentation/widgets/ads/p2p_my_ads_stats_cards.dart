part of '../../phone/pages/ads/p2p_my_ads_page.dart';

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.activeCount,
    required this.pausedCount,
    required this.totalVolume,
  });

  final int activeCount;
  final int pausedCount;
  final int totalVolume;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: activeCount.toString(),
            label: 'Đang hoạt động',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: _p2pMyAdsSectionGap),
        Expanded(
          child: _StatCard(
            value: pausedCount.toString(),
            label: 'Tạm dừng',
            color: AppColors.warn,
          ),
        ),
        const SizedBox(width: _p2pMyAdsSectionGap),
        Expanded(
          child: _StatCard(
            value: '\$${_formatCompactUsd(totalVolume)}',
            label: 'KL 30 ngày',
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      height: _p2pMyAdsStatExtent,
      padding: P2PSpacingTokens.p2pMerchantCommerceInnerPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: _p2pMyAdsTightGap),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _MyAdCard extends StatelessWidget {
  const _MyAdCard({
    required this.ad,
    required this.onAnalytics,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final P2PMyAdDraft ad;
  final VoidCallback onAnalytics;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final typeColor = ad.type == P2PTradeType.sell
        ? AppColors.sell
        : AppColors.buy;
    final active = ad.status == P2PMyAdStatus.active;
    final statusColor = active ? AppColors.buy : AppColors.warn;

    return Opacity(
      opacity: active ? 1 : .72,
      child: VitCard(
        padding: P2PSpacingTokens.p2pMerchantCommerceCompactPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                VitAccentPill(
                  label:
                      '${ad.type == P2PTradeType.sell ? 'BÁN' : 'MUA'} ${ad.asset}',
                  accentColor: typeColor,
                ),
                VitAccentPill(
                  label: _statusLabel(ad.status),
                  accentColor: statusColor,
                ),
                if (ad.priceType == 'floating')
                  const VitAccentPill(
                    label: 'Thả nổi',
                    accentColor: AppModuleAccents.p2p,
                  ),
              ],
            ),
            const SizedBox(height: _p2pMyAdsSectionGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    _formatVnd(ad.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  '${ad.currency}/${ad.asset}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                if (ad.priceMargin != null) ...[
                  const SizedBox(width: _p2pMyAdsSectionGap),
                  Text(
                    '${ad.priceMargin! >= 0 ? '+' : ''}${ad.priceMargin!.toStringAsFixed(1)}%',
                    style: AppTextStyles.micro.copyWith(
                      color: ad.priceMargin! >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: _p2pMyAdsSectionGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DetailColumn(
                    label: 'Khả dụng',
                    value: '${_formatAmount(ad.available)} ${ad.asset}',
                  ),
                ),
                Expanded(
                  child: _DetailColumn(
                    label: 'Giới hạn',
                    value:
                        '${_formatVnd(ad.minLimit)}-\n${_formatVnd(ad.maxLimit)}',
                  ),
                ),
                Expanded(
                  child: _DetailColumn(
                    label: 'Thanh toán',
                    value: _formatPaymentMethods(ad.paymentMethods),
                  ),
                ),
              ],
            ),
            if (ad.tradingHours != null) ...[
              const SizedBox(height: _p2pMyAdsSectionGap),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    ad.tradingHours!,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
            const SizedBox(height: _p2pMyAdsSectionGap),
            const Divider(color: AppColors.divider, height: _p2pMyAdsMajorGap),
            const SizedBox(height: _p2pMyAdsSectionGap),
            Row(
              children: [
                Expanded(
                  child: VitCtaButton(
                    key: P2PMyAdsPage.toggleKey(ad.id),
                    onPressed: onToggle,
                    variant: VitCtaButtonVariant.secondary,
                    height: _p2pMyAdsActionExtent,
                    leading: Icon(
                      active ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: AppSpacing.iconSm,
                    ),
                    child: Text(active ? 'Dừng' : 'Bật'),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                PopupMenuButton<String>(
                  key: P2PMyAdsPage.adMenuKey(ad.id),
                  tooltip: 'Tùy chọn quảng cáo',
                  color: AppColors.surface2,
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: AppColors.text2,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'analytics':
                        onAnalytics();
                      case 'edit':
                        onEdit();
                      case 'delete':
                        onDelete();
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'analytics',
                      child: KeyedSubtree(
                        key: P2PMyAdsPage.analyticsKey(ad.id),
                        child: const Text('Phân tích'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: KeyedSubtree(
                        key: P2PMyAdsPage.editKey(ad.id),
                        child: const Text('Sửa'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: KeyedSubtree(
                        key: P2PMyAdsPage.deleteKey(ad.id),
                        child: Text(
                          'Xóa',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.sell,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailColumn extends StatelessWidget {
  const _DetailColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pMerchantCommerceDetailRightPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatPaymentMethods(List<String> methods) {
  if (methods.isEmpty) return '-';
  if (methods.length <= 2) return methods.join(', ');
  return '${methods.take(2).join(', ')} +${methods.length - 2}';
}
