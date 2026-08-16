part of '../../phone/pages/staking/staking_analytics_page.dart';

class _ProductsTab extends StatelessWidget {
  const _ProductsTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final best = snapshot.productPerformance
        .map((product) => product.roi)
        .reduce(math.max);

    return VitPageSection(
      label: 'Hiệu suất theo Sản phẩm',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        KeyedSubtree(
          key: StakingAnalyticsPage.productListKey,
          child: Column(
            children: [
              for (final product in snapshot.productPerformance) ...[
                _ProductPerformanceCard(product: product, maxRoi: best),
                if (product != snapshot.productPerformance.last)
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductPerformanceCard extends StatelessWidget {
  const _ProductPerformanceCard({required this.product, required this.maxRoi});

  final StakingProductPerformanceDraft product;
  final double maxRoi;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(product.colorIndex);
    final progress = maxRoi == 0 ? 0.0 : (product.roi / maxRoi).clamp(0.0, 1.0);

    return VitCard(
      key: StakingAnalyticsPage.productKey(product.asset),
      padding: _stakingAnalyticsCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              _AssetAvatar(asset: product.asset, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'APY: ${product.apy.toStringAsFixed(1)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${product.roi.toStringAsFixed(2)}%',
                    style: AppTextStyles.sectionTitleSm.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'ROI',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SmallStat(
                  label: 'Đầu tư',
                  value: EarnFormatters.usd(product.investedUsd),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SmallStat(
                  label: 'Thu nhập',
                  value: '+${EarnFormatters.usd(product.earnedUsd)}',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: EarnSpacingTokens.earnAnalyticsProgressMinHeight,
              value: progress,
              backgroundColor: AppColors.borderSolid,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: _stakingAnalyticsCardPadding,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: CircleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.45)),
        ),
      ),
      child: SizedBox(
        width: EarnSpacingTokens.earnAnalyticsAvatarBox,
        height: EarnSpacingTokens.earnAnalyticsAvatarBox,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}
