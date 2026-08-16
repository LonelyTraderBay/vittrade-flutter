part of '../../phone/pages/tools/portfolio_analytics_page.dart';

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.metrics});

  final List<WalletPortfolioMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final metric in metrics)
            VitInfoRow(
              label: metric.label,
              value: metric.value,
              valueColor: Color(metric.colorHex),
              density: VitDensity.compact,
              showDivider: metric != metrics.last,
            ),
        ],
      ),
    );
  }
}

class _AssetsCard extends StatelessWidget {
  const _AssetsCard({required this.assets, required this.totalUsd});

  final List<WalletAsset> assets;
  final double totalUsd;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < assets.length; i++)
            _AssetRow(
              asset: assets[i],
              totalUsd: totalUsd,
              isLast: i == assets.length - 1,
            ),
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.asset,
    required this.totalUsd,
    required this.isLast,
  });

  final WalletAsset asset;
  final double totalUsd;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    final pct = totalUsd == 0 ? 0.0 : (asset.usdValue / totalUsd) * 100;
    final trendTone = asset.change24h >= 0
        ? VitMetricDeltaTone.positive
        : VitMetricDeltaTone.negative;

    return Column(
      children: [
        Padding(
          padding: WalletSpacingTokens.walletAnalyticsAssetRowPadding,
          child: Row(
            children: [
              _AssetAvatar(asset: asset, color: color),
              const SizedBox(
                width: WalletSpacingTokens.walletAnalyticsAssetGap,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            asset.symbol,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width:
                              WalletSpacingTokens.walletAnalyticsAssetValueGap,
                        ),
                        Flexible(
                          child: Text(
                            _formatUsd(asset.usdValue),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadii.xsRadius,
                            child: LinearProgressIndicator(
                              value: math.min(1, pct / 100),
                              minHeight: WalletSpacingTokens
                                  .walletAnalyticsAssetProgressHeight,
                              backgroundColor: AppColors.surface3,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width:
                              WalletSpacingTokens.walletAnalyticsAssetValueGap,
                        ),
                        VitMetricDeltaPill(
                          label:
                              '${asset.change24h >= 0 ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%',
                          tone: trendTone,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${pct.toStringAsFixed(1)}% danh m\u1EE5c',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.asset, required this.color});

  final WalletAsset asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: WalletSpacingTokens.walletAnalyticsAssetAvatar,
      height: WalletSpacingTokens.walletAnalyticsAssetAvatar,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      borderColor: color.withValues(alpha: .56),
      background: ColoredBox(color: color.withValues(alpha: .18)),
      clip: true,
      alignment: Alignment.center,
      child: Text(
        asset.symbol.length <= 3 ? asset.symbol : asset.symbol.substring(0, 3),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
