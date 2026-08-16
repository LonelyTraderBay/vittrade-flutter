part of '../../phone/pages/hub/p2p_home_page.dart';

const _p2pHomeFilterChipPadding = EdgeInsetsDirectional.symmetric(
  horizontal: AppSpacing.x3,
  vertical: AppSpacing.x2,
);

class _HomeFilterSection extends StatelessWidget {
  const _HomeFilterSection({
    required this.merchantFilter,
    required this.paymentFilter,
    required this.paymentMethods,
    required this.onMerchant,
    required this.onPayment,
    required this.onClear,
  });

  final String merchantFilter;
  final String paymentFilter;
  final List<String> paymentMethods;
  final ValueChanged<String> onMerchant;
  final ValueChanged<String> onPayment;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PHomePage.filterKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pHomeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loại merchant',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitChoicePill(
                label: 'Tất cả',
                selected: merchantFilter == 'all',
                onTap: () => onMerchant('all'),
                padding: _p2pHomeFilterChipPadding,
                accentColor: AppModuleAccents.p2p,
                semanticLabel: 'Bộ lọc P2P Tất cả',
              ),
              VitChoicePill(
                label: 'Elite',
                selected: merchantFilter == 'elite',
                onTap: () => onMerchant('elite'),
                padding: _p2pHomeFilterChipPadding,
                accentColor: AppModuleAccents.p2p,
                semanticLabel: 'Bộ lọc P2P Elite',
              ),
              VitChoicePill(
                label: 'Pro',
                selected: merchantFilter == 'pro',
                onTap: () => onMerchant('pro'),
                padding: _p2pHomeFilterChipPadding,
                accentColor: AppModuleAccents.p2p,
                semanticLabel: 'Bộ lọc P2P Pro',
              ),
              VitChoicePill(
                label: 'Xác minh',
                selected: merchantFilter == 'verified',
                onTap: () => onMerchant('verified'),
                padding: _p2pHomeFilterChipPadding,
                accentColor: AppModuleAccents.p2p,
                semanticLabel: 'Bộ lọc P2P Xác minh',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Thanh toán',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitChoicePill(
                label: 'Tất cả',
                selected: paymentFilter.isEmpty,
                onTap: () => onPayment(''),
                padding: _p2pHomeFilterChipPadding,
                accentColor: AppModuleAccents.p2p,
                semanticLabel: 'Bộ lọc P2P Tất cả',
              ),
              for (final method in paymentMethods)
                VitChoicePill(
                  label: method,
                  selected: paymentFilter == method,
                  onTap: () => onPayment(method),
                  padding: _p2pHomeFilterChipPadding,
                  accentColor: AppModuleAccents.p2p,
                  semanticLabel: 'Bộ lọc P2P $method',
                ),
            ],
          ),
          if (merchantFilter != 'all' || paymentFilter.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitCtaButton(
              onPressed: onClear,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: P2PSpacingTokens.p2pHomeClearFilterPadding,
              leading: const Icon(Icons.close_rounded),
              child: const Text('Xóa bộ lọc'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count offer',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const _EscrowStatusPill(),
      ],
    );
  }
}

class _EscrowStatusPill extends StatelessWidget {
  const _EscrowStatusPill();

  @override
  Widget build(BuildContext context) {
    return const VitStatusPill(
      label: 'Escrow',
      status: VitStatusPillStatus.success,
      icon: Icons.shield_outlined,
      size: VitStatusPillSize.sm,
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.ad,
    required this.tradeType,
    required this.onOpen,
    required this.onMerchant,
    required this.onReport,
  });

  final P2PAdDraft ad;
  final P2PTradeType tradeType;
  final VoidCallback onOpen;
  final VoidCallback onMerchant;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final actionColor = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    final badge = ad.merchantBadge;
    return VitCard(
      key: P2PHomePage.adKey(ad.id),
      radius: VitCardRadius.large,
      onTap: onOpen,
      padding: P2PSpacingTokens.p2pHomeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _MerchantAvatar(ad: ad),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ad.merchant,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (ad.merchantVerified) ...[
                          const SizedBox(width: AppSpacing.x1),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppModuleAccents.p2p,
                            size: AppSpacing.iconSm,
                          ),
                        ],
                        if (badge != null) ...[
                          const SizedBox(width: AppSpacing.x2),
                          _Badge(label: badge == 'elite' ? 'Elite' : 'Pro'),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${ad.completedOrders} đơn · '
                      '${ad.completionRate.toStringAsFixed(1)}% · '
                      '${ad.merchantRating?.toStringAsFixed(1) ?? '-'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                key: P2PHomePage.adMenuKey(ad.id),
                tooltip: 'Tùy chọn offer',
                color: AppColors.surface2,
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.text2,
                ),
                onSelected: (value) {
                  if (value == 'merchant') onMerchant();
                  if (value == 'report') onReport();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'merchant', child: Text('Xem merchant')),
                  PopupMenuItem(value: 'report', child: Text('Báo cáo offer')),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
              Padding(
                padding: const EdgeInsetsDirectional.only(top: AppSpacing.x1),
                child: Text(
                  ad.currency,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (ad.priceType == 'floating') ...[
                const SizedBox(width: AppSpacing.x2),
                const _Badge(label: 'Thả nổi', color: AppColors.accent),
              ],
              const Spacer(),
              Flexible(
                child: Text(
                  '${_formatAmount(ad.available)} ${ad.asset}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Giới hạn ${_formatVnd(ad.minLimit)} - ${_formatVnd(ad.maxLimit)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final method in ad.paymentMethods.take(3))
                      _PaymentPill(label: method),
                    if (ad.paymentMethods.length > 3)
                      _PaymentPill(
                        label: '+${ad.paymentMethods.length - 3} phương thức',
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                ad.avgResponseTime,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          if (ad.isNewMerchant) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            const VitBanner(
              variant: VitBannerVariant.warning,
              icon: Icons.warning_amber_rounded,
              message: 'Merchant mới - kiểm tra kỹ trước khi giao dịch',
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ActionButton(
            label: tradeType == P2PTradeType.buy ? 'Mua' : 'Bán',
            color: actionColor,
            onTap: onOpen,
          ),
        ],
      ),
    );
  }
}

class _EmptyOffers extends StatelessWidget {
  const _EmptyOffers({required this.snapshot});

  final P2PHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      key: P2PHomePage.emptyKey,
      icon: Icons.search_off_rounded,
      title: snapshot.emptyTitle,
      message: snapshot.emptySubtitle,
      actionLabel: 'Xem hướng dẫn P2P',
      actionKey: P2PHomePage.guideLinkKey,
      onAction: () => context.go(AppRoutePaths.p2pGuide),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: color == AppColors.buy
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.danger,
      fullWidth: true,
      height: AppSpacing.buttonCompact,
      child: Text(label),
    );
  }
}

class _MerchantAvatar extends StatelessWidget {
  const _MerchantAvatar({required this.ad});

  final P2PAdDraft ad;

  @override
  Widget build(BuildContext context) {
    final color = ad.merchantBadge == 'elite'
        ? AppColors.warn
        : ad.merchantBadge == 'pro'
        ? AppColors.accent
        : AppModuleAccents.p2p;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        VitAssetAvatar(
          label: ad.merchant,
          accentColor: color,
          size: AppSpacing.buttonCompact,
          radius: AppRadii.pillRadius,
          border: true,
        ),
        Positioned(
          right: -AppSpacing.x1,
          bottom: -AppSpacing.x1,
          child: SizedBox(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            child: Material(
              color: ad.isOnline ? AppColors.buy : AppColors.text3,
              shape: const CircleBorder(
                side: BorderSide(
                  color: AppColors.surface,
                  width: AppSpacing.dividerHairline,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
