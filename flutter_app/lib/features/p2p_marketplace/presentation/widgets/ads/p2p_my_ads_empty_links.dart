part of '../../phone/pages/ads/p2p_my_ads_page.dart';

class _EmptyMyAds extends StatelessWidget {
  const _EmptyMyAds({required this.snapshot});

  final P2PMyAdsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pMerchantCommerceCardPadding,
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: _p2pMyAdsSectionGap),
          Text(
            snapshot.emptyTitle,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: _p2pMyAdsMajorGap),
          VitCtaButton(
            onPressed: () => context.go(AppRoutePaths.p2pCreate),
            variant: VitCtaButtonVariant.primary,
            child: Text(snapshot.emptyActionLabel),
          ),
        ],
      ),
    );
  }
}

class _QuickLinksCard extends StatelessWidget {
  const _QuickLinksCard({required this.links});

  final List<P2PQuickLinkDraft> links;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pMerchantCommerceCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIÊN KẾT NHANH',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
              letterSpacing: .5,
            ),
          ),
          const SizedBox(height: _p2pMyAdsSectionGap),
          for (var i = 0; i < links.length; i++) ...[
            _QuickLinkTile(link: links[i]),
            if (i < links.length - 1)
              const Divider(
                color: AppColors.divider,
                height: _p2pMyAdsMajorGap,
              ),
          ],
        ],
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({required this.link});

  final P2PQuickLinkDraft link;

  @override
  Widget build(BuildContext context) {
    final icon = switch (link.iconKey) {
      'settings' => Icons.settings_outlined,
      'block' => Icons.person_off_outlined,
      'guide' => Icons.menu_book_rounded,
      _ => Icons.chevron_right_rounded,
    };
    final color = switch (link.iconKey) {
      'block' => AppColors.sell,
      'guide' => AppModuleAccents.p2p,
      _ => AppColors.text2,
    };

    return VitCard(
      key: P2PMyAdsPage.quickLinkKey(link.id),
      onTap: () => context.go(link.route),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pMerchantCommerceQuickLinkPadding,
      child: Row(
        children: [
          Material(
            color: color.withValues(alpha: .10),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox.square(
              dimension: _p2pMyAdsQuickIconBox,
              child: Icon(icon, color: color, size: AppSpacing.iconSm),
            ),
          ),
          const SizedBox(width: _p2pMyAdsMajorGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  link.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

_MyAdsFilter _filterFromKey(String key) {
  return _MyAdsFilter.values.firstWhere(
    (filter) => filter.name == key,
    orElse: () => _MyAdsFilter.all,
  );
}

String _statusLabel(P2PMyAdStatus status) {
  return switch (status) {
    P2PMyAdStatus.active => 'Hoạt động',
    P2PMyAdStatus.paused => 'Tạm dừng',
    P2PMyAdStatus.expired => 'Hết hạn',
  };
}

String _formatVnd(num value) => formatP2PVnd(value);

String _formatAmount(num value) {
  final parts = value.toStringAsFixed(2).split('.');
  return '${_formatCount(parts.first)}.${parts.last}';
}

String _formatCount(String raw) => VitFormat.thousands(raw);

String _formatCompactUsd(int value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).round()}K';
  return value.toString();
}
