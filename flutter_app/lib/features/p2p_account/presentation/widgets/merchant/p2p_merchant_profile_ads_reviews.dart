part of '../../phone/pages/merchant/p2p_merchant_profile_page.dart';

class _AdsList extends StatelessWidget {
  const _AdsList({required this.snapshot});

  final P2PMerchantProfileSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.ads.isEmpty) {
      return VitEmptyState(
        title: snapshot.emptyAdsTitle,
        message: 'Merchant chưa có offer đang hoạt động.',
      );
    }

    return Column(
      key: const ValueKey('merchant_ads'),
      children: [
        for (final ad in snapshot.ads) ...[
          _MerchantAdCard(ad: ad),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _MerchantAdCard extends StatelessWidget {
  const _MerchantAdCard({required this.ad});

  final P2PMerchantProfileAdDraft ad;

  @override
  Widget build(BuildContext context) {
    final isSellAd = ad.type == P2PTradeType.sell;
    final actionColor = isSellAd ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: P2PMerchantProfilePage.adKey(ad.id),
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pMerchantCommerceCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitStatusPill(
                label: isSellAd ? 'BÁN' : 'MUA',
                status: isSellAd
                    ? VitStatusPillStatus.error
                    : VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                ad.asset,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                _formatVnd(ad.price),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Khả dụng: ${_formatAmount(ad.available)} ${ad.asset}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                flex: 5,
                child: Text(
                  'Giới hạn: ${_formatVnd(ad.minLimit)} - ${_formatVnd(ad.maxLimit)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            children: [
              for (final method in ad.paymentMethods)
                Text(
                  method,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ),
          const SizedBox(height: _p2pMerchantTightGap),
          _OutlineActionButton(
            label: isSellAd ? 'Mua ngay' : 'Bán ngay',
            color: actionColor,
            onTap: () => context.go(AppRoutePaths.p2pAd(ad.id)),
          ),
        ],
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _p2pMerchantActionHeight,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: color.withValues(alpha: .25),
      background: ColoredBox(color: color.withValues(alpha: .10)),
      onTap: onTap,
      clip: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Icon(
            Icons.chevron_right_rounded,
            color: color,
            size: P2PSpacingTokens.p2pMerchantCommerceSmallIcon,
          ),
        ],
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  const _ReviewsList({required this.snapshot});

  final P2PMerchantProfileSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.reviews.isEmpty) {
      return VitEmptyState(
        title: snapshot.emptyReviewsTitle,
        message: 'Merchant chưa có phản hồi từ giao dịch hoàn tất.',
      );
    }

    return Column(
      key: const ValueKey('merchant_reviews'),
      children: [
        for (final review in snapshot.reviews) ...[
          _ReviewCard(review: review),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final P2PMerchantProfileReviewDraft review;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pMerchantCommerceCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VitAssetAvatar(
                label: review.fromUser,
                accentColor: AppColors.accent,
                size: P2PSpacingTokens.p2pMerchantCommerceAvatarSize,
                radius: AppRadii.pillRadius,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.fromUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    Text(
                      review.createdAt,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              for (var i = 0; i < review.rating; i++)
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warn,
                  size: P2PSpacingTokens.p2pMerchantCommerceSmallIcon,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            review.comment,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _p2pMerchantBodyLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitStatusPill(
            label: review.positive ? 'Tích cực' : 'Tiêu cực',
            status: review.positive
                ? VitStatusPillStatus.success
                : VitStatusPillStatus.error,
            icon: review.positive
                ? Icons.thumb_up_alt_outlined
                : Icons.thumb_down_alt_outlined,
            size: VitStatusPillSize.sm,
          ),
        ],
      ),
    );
  }
}

String _formatInt(int value) {
  final chars = value.toString().split('');
  final buffer = StringBuffer();
  for (var i = 0; i < chars.length; i++) {
    final fromRight = chars.length - i;
    buffer.write(chars[i]);
    if (fromRight > 1 && fromRight % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _formatVnd(int value) => formatP2PVnd(value);

String _formatCompactUsd(int value) {
  if (value >= 1000000) {
    final compact = value / 1000000;
    return '${compact.toStringAsFixed(compact >= 10 ? 0 : 1)}M';
  }
  if (value >= 1000) {
    final compact = value / 1000;
    return '${compact.toStringAsFixed(compact >= 10 ? 0 : 1)}K';
  }
  return value.toString();
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(4);
  }
  return value.toStringAsFixed(4);
}
