part of '../../phone/pages/tools/market_movers_page.dart';

const double _marketMoverRowExtent = 64;
const double _marketMoverSparklineExtent = 28;

class _MoverRow extends StatelessWidget {
  const _MoverRow({
    super.key,
    required this.rank,
    required this.mover,
    required this.tab,
    required this.change,
    required this.last,
    required this.onTap,
  });

  final int rank;
  final MarketMover mover;
  final String tab;
  final double change;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metric = _metricForTab();
    final metricColor = metric.positive ? AppColors.buy : AppColors.sell;

    return VitCard(
      variant: VitCardVariant.ghost,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: SizedBox(
        height: _marketMoverRowExtent,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: MarketsSpacingTokens.marketMoverRowPadding,
                child: Row(
                  children: [
                    _ListRankBadge(rank: rank),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketMoverRowGap,
                    ),
                    _CoinAvatar(mover: mover),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketMoverHeaderGap,
                    ),
                    Expanded(child: _MoverIdentity(mover: mover)),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketMoverRowGap,
                    ),
                    SizedBox(
                      width: MarketsSpacingTokens.marketMoverSparklineWidth,
                      height: _marketMoverSparklineExtent,
                      child: VitSparkline(
                        values: mover.sparkline,
                        color: metricColor,
                      ),
                    ),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketMoverHeaderGap,
                    ),
                    SizedBox(
                      width: MarketsSpacingTokens.marketMoverPriceColumnWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatMarketPriceAdaptive(mover.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                          const SizedBox(
                            height: MarketsSpacingTokens.marketMoverMetricGap,
                          ),
                          Text(
                            metric.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: metricColor,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!last)
              const Divider(
                color: AppColors.divider,
                height: AppSpacing.dividerHairline,
              ),
          ],
        ),
      ),
    );
  }

  _MoverMetric _metricForTab() {
    if (tab == 'Hoạt động') {
      return _MoverMetric(
        label: formatMarketCompact(mover.volume24h, prefix: r'$'),
        positive: true,
      );
    }
    if (tab == 'KL bất thường') {
      return _MoverMetric(
        label: 'KL ${_formatSignedPercent(mover.volumeChange24h)}',
        positive: mover.volumeChange24h >= 0,
      );
    }
    return _MoverMetric(
      label: _formatSignedPercent(change),
      positive: change >= 0,
    );
  }
}

class _MoverMetric {
  const _MoverMetric({required this.label, required this.positive});

  final String label;
  final bool positive;
}

class _ListRankBadge extends StatelessWidget {
  const _ListRankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MarketsSpacingTokens.marketMoverRankWidth,
      child: Text(
        '$rank',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: mover.symbol,
      accentColor: AppAssetColors.forSymbol(mover.symbol),
      size: MarketsSpacingTokens.marketMoverAvatar,
      radius: AppRadii.pillRadius,
      border: true,
    );
  }
}

class _MoverIdentity extends StatelessWidget {
  const _MoverIdentity({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                mover.symbol,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(
              width: MarketsSpacingTokens.marketMoverIdentityBadgeGap,
            ),
            _MarketCapRankBadge(rank: mover.marketCapRank),
            if (mover.isNew) ...[
              const SizedBox(
                width: MarketsSpacingTokens.marketMoverIdentityBadgeGap,
              ),
              const _NewBadge(),
            ],
          ],
        ),
        const SizedBox(height: MarketsSpacingTokens.marketMoverMetricGap),
        Text(
          mover.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _MarketCapRankBadge extends StatelessWidget {
  const _MarketCapRankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface3,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      child: Padding(
        padding: MarketsSpacingTokens.marketMoverRankBadgePadding,
        child: Text(
          '#$rank',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    return const VitAccentPill(label: 'MỚI', accentColor: _marketPrimary);
  }
}

class _DataRefreshFooter extends StatelessWidget {
  const _DataRefreshFooter();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dữ liệu cập nhật mỗi 30 giây',
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}
