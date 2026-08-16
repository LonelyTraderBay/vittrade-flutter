part of '../../phone/pages/ads/p2p_order_book_page.dart';

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({
    required this.snapshot,
    required this.selectedAsset,
    required this.onChanged,
  });

  final P2POrderBookSnapshot snapshot;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: P2POrderBookPage.assetRailKey,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final market in snapshot.markets) ...[
            _AssetChip(
              market: market,
              selected: market.asset == selectedAsset,
              onTap: () => onChanged(market.asset),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _AssetChip extends StatelessWidget {
  const _AssetChip({
    required this.market,
    required this.selected,
    required this.onTap,
  });

  final P2POrderBookMarketDraft market;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: P2POrderBookPage.assetKey(market.asset),
      width: _p2pOrderBookAssetChipMinWidth,
      child: VitChoicePill(
        label: '${market.asset} ${_formatChange(market.changePct)}',
        selected: selected,
        onTap: onTap,
        fullWidth: true,
        accentColor: AppModuleAccents.p2p,
        padding: P2PSpacingTokens.p2pOrderBookSelectorPadding,
        semanticLabel:
            'Giá ${market.asset} VND, biến động ${_formatChange(market.changePct)}',
      ),
    );
  }
}

class _MarketTicker extends StatelessWidget {
  const _MarketTicker({
    required this.snapshot,
    required this.isRefreshing,
    required this.onRefresh,
  });

  final P2POrderBookSnapshot snapshot;
  final bool isRefreshing;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final market = snapshot.selectedAsset;
    final tone = market.changePct >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: P2POrderBookPage.tickerKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pOrderBookCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '${market.asset}/VND',
                style: AppTextStyles.numericDisplaySm,
              ),
              const SizedBox(width: AppSpacing.x2),
              VitMetricDeltaPill(
                label: _formatChange(market.changePct),
                tone: market.changePct >= 0
                    ? VitMetricDeltaTone.positive
                    : VitMetricDeltaTone.negative,
                icon: market.changePct >= 0
                    ? Icons.arrow_outward_rounded
                    : Icons.south_east_rounded,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    key: P2POrderBookPage.refreshKey,
                    width: _p2pOrderBookRefreshExtent,
                    height: _p2pOrderBookRefreshExtent,
                    child: Center(
                      child: AnimatedRotation(
                        turns: isRefreshing ? 1 : 0,
                        duration: const Duration(milliseconds: 600),
                        child: VitIconButton(
                          icon: Icons.refresh_rounded,
                          tooltip: 'Làm mới sổ lệnh',
                          onPressed: onRefresh,
                          variant: VitIconButtonVariant.ghost,
                          size: VitIconButtonSize.sm,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pOrderBookSectionGap),
          Row(
            children: [
              Expanded(
                child: _TickerMetric(
                  label: 'Giá hiện tại',
                  value: _formatVnd(market.lastPriceVnd),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: '24h High',
                  value: _formatVnd(market.high24hVnd),
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: '24h Low',
                  value: _formatVnd(market.low24hVnd),
                  color: AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pOrderBookSectionGap),
          Row(
            children: [
              Expanded(
                child: _TickerMetric(
                  label: 'Volume 24h',
                  value: market.volume24hLabel,
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: 'Lệnh 24h',
                  value: _formatWhole(market.trades24h),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: 'Spread',
                  value: '${snapshot.spreadPercent.toStringAsFixed(3)}%',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              market.changePct >= 0
                  ? 'Thanh khoản đang tăng nhẹ'
                  : 'Biến động cần theo dõi',
              style: AppTextStyles.micro.copyWith(color: tone),
            ),
          ),
        ],
      ),
    );
  }
}

class _TickerMetric extends StatelessWidget {
  const _TickerMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
