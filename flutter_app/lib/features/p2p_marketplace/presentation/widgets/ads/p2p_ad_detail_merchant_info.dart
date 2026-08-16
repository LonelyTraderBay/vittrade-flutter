part of '../../phone/pages/ads/p2p_ad_detail_page.dart';

class _MerchantCard extends StatelessWidget {
  const _MerchantCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ad = snapshot.ad;
    return VitCard(
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(AppRoutePaths.p2pMerchant(ad.merchantId));
      },
      padding: P2PSpacingTokens.p2pAdDetailCompactCardPadding,
      child: Row(
        children: [
          Stack(
            children: [
              VitAssetAvatar(
                label: ad.merchant,
                accentColor: AppColors.accent,
                size: AppSpacing.x6,
                radius: AppRadii.pillRadius,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox.square(
                  dimension: P2PSpacingTokens.p2pAdDetailOnlineBadgeSize,
                  child: Material(
                    color: ad.isOnline ? AppColors.buy : AppColors.text3,
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: AppColors.surface,
                        width: P2PSpacingTokens.p2pAdDetailOnlineBadgeBorder,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    const Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.accent,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    const _Badge(label: 'Elite'),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      '${ad.completedOrders} đơn',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      '${_fixed(ad.completionRate)}% hoàn thành',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      ad.isOnline ? 'Online' : 'Offline',
                      style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _TrustMarketRow extends StatelessWidget {
  const _TrustMarketRow({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.shield_outlined,
            title: 'Độ tin cậy',
            value: '${snapshot.trustScore}',
            unit: '/100',
            subtitle: snapshot.trustLabel,
            color: AppColors.buy,
            progress: snapshot.trustScore / 100,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _InfoCard(
            icon: Icons.trending_up_rounded,
            title: 'So với thị trường',
            value: '+${snapshot.priceDiffPct.toStringAsFixed(2)}%',
            subtitle: 'Giá hợp lý',
            footnote: 'Thị trường: ${_formatVnd(snapshot.marketPriceVnd)}',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.unit,
    this.footnote,
    this.progress,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final String? unit;
  final String? footnote;
  final double? progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pAdDetailCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.baseMedium.copyWith(
                  color: color,
                  fontFeatures: AppTextStyles.tabularFigures,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: AppSpacing.x1),
                Text(
                  unit!,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ],
          ),
          if (footnote != null)
            Text(
              footnote!,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          if (progress != null) ...[
            const SizedBox(height: AppSpacing.x1),
            ClipRRect(
              borderRadius: AppRadii.smRadius,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: AppSpacing.x2,
                backgroundColor: AppColors.surface2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalChips extends StatelessWidget {
  const _SignalChips({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SignalChip(
          icon: Icons.visibility_outlined,
          label: '${snapshot.viewerCount} đang xem',
          color: AppColors.accent,
        ),
        const SizedBox(width: AppSpacing.x3),
        _SignalChip(
          icon: Icons.bar_chart_rounded,
          label: 'KL 30d: \$${_formatCompactUsd(snapshot.totalVolume30dUsd)}',
          color: AppColors.buy,
        ),
        const SizedBox(width: AppSpacing.x3),
        _SignalChip(
          icon: Icons.star_rounded,
          label:
              '${_fixed(snapshot.ad.merchantRating ?? 4.8)} · ${snapshot.ad.completedOrders} GD',
          color: AppColors.warn,
        ),
      ],
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Material(
        color: color.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: color.withValues(alpha: .16)),
        ),
        child: Padding(
          padding: P2PSpacingTokens.p2pAdDetailSignalChipPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
