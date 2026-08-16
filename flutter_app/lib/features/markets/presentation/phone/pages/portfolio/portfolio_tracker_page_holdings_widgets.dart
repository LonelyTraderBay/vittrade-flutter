part of 'portfolio_tracker_page.dart';

class _TopHoldings extends StatelessWidget {
  const _TopHoldings({
    required this.holdings,
    required this.hidden,
    required this.onTap,
  });

  final List<PortfolioHolding> holdings;
  final bool hidden;
  final ValueChanged<PortfolioHolding> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final holding in holdings) ...[
          _HoldingRow(
            key: PortfolioTrackerPage.holdingKey(holding.id),
            holding: holding,
            hidden: hidden,
            onTap: () => onTap(holding),
          ),
          if (holding != holdings.last)
            const SizedBox(height: _portfolioSectionGap),
        ],
      ],
    );
  }
}

class _HoldingRow extends StatelessWidget {
  const _HoldingRow({
    super.key,
    required this.holding,
    required this.hidden,
    required this.onTap,
  });

  final PortfolioHolding holding;
  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pnlColor = holding.pnlPct >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      onTap: onTap,
      padding: _portfolioHoldingRowPadding,
      child: Row(
        children: [
          _TokenBadge(holding: holding, size: _portfolioHoldingAvatarMd),
          const SizedBox(width: _portfolioHoldingRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${_mask(holding.quantity.toStringAsFixed(4), hidden)} - ${holding.allocation.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          SizedBox(
            width: _portfolioHoldingSparklineWidth,
            height: _portfolioHoldingSparklineHeight,
            child: VitSparkline(
              values: holding.sparkline,
              color: holding.change24h >= 0 ? AppColors.buy : AppColors.sell,
              showFill: false,
              strokeWidth: _portfolioSparklineStroke,
            ),
          ),
          const SizedBox(width: _portfolioHoldingSparklineGap),
          SizedBox(
            width: _portfolioHoldingValueWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _mask(_formatUsd(holding.value), hidden),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  _formatSignedPercent(holding.pnlPct),
                  style: AppTextStyles.micro.copyWith(
                    color: pnlColor,
                    fontWeight: AppTextStyles.bold,
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

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.stats});

  final PortfolioStats stats;

  @override
  Widget build(BuildContext context) {
    final balanced = stats.stableAllocation > 20;
    final color = balanced ? AppColors.buy : AppColors.warn;
    return VitCard(
      padding: _portfolioRiskPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đánh giá rủi ro',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitAccentPill(
                label: balanced ? 'CÃ¢n báº±ng' : 'Rá»§i ro cao',
                accentColor: color,
                semanticStatus: balanced
                    ? VitStatusPillStatus.success
                    : VitStatusPillStatus.warning,
              ),
            ],
          ),
          const SizedBox(height: _portfolioRiskTitleGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Stablecoin',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${stats.stableAllocation.toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _portfolioRiskProgressLabelGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              minHeight: _portfolioRiskProgressHeight,
              value: stats.stableAllocation / 100,
              backgroundColor: AppColors.surface2,
              valueColor: const AlwaysStoppedAnimation(AppColors.buy),
            ),
          ),
          const SizedBox(height: _portfolioRiskCopyGap),
          Text(
            'Danh mục có ${stats.stableAllocation.toStringAsFixed(1)}% stablecoin, giúp giảm biến động. Khuyến nghị duy trì ít nhất 10-20% stablecoin cho quản lý rủi ro.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _portfolioRiskLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({required this.active, required this.onSelected});

  final MarketPortfolioSort active;
  final ValueChanged<MarketPortfolioSort> onSelected;

  @override
  Widget build(BuildContext context) {
    const chips = {
      MarketPortfolioSort.value: 'Giá trị',
      MarketPortfolioSort.pnl: 'Lãi/Lỗ',
      MarketPortfolioSort.change: 'Thay đổi 24h',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in chips.entries) ...[
            VitFilterChip(
              key: PortfolioTrackerPage.sortKey(entry.key),
              label: entry.value,
              active: active == entry.key,
              onTap: () => onSelected(entry.key),
              color: _marketPrimary,
              padding: _portfolioChipPadding,
            ),
            if (entry.key != chips.keys.last)
              const SizedBox(width: _portfolioChipGap),
          ],
        ],
      ),
    );
  }
}

class _HoldingDetailCard extends StatelessWidget {
  const _HoldingDetailCard({
    super.key,
    required this.holding,
    required this.hidden,
    required this.onTap,
  });

  final PortfolioHolding holding;
  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: _portfolioHoldingDetailPadding,
      child: Column(
        children: [
          Row(
            children: [
              _TokenBadge(holding: holding, size: _portfolioHoldingAvatarLg),
              const SizedBox(width: _portfolioHoldingRowGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holding.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      holding.name,
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
                    _mask(_formatUsd(holding.value), hidden),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${holding.allocation.toStringAsFixed(1)}%',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: _portfolioHoldingDetailGap),
          Row(
            children: [
              _HoldingMetric(
                label: 'Số lượng',
                value: _mask(holding.quantity.toStringAsFixed(4), hidden),
              ),
              _HoldingMetric(
                label: 'Giá TB mua',
                value: '\$${_formatPrice(holding.avgBuyPrice)}',
              ),
              _HoldingMetric(
                label: 'Giá hiện tại',
                value: '\$${_formatPrice(holding.currentPrice)}',
              ),
              _HoldingMetric(
                label: 'Lãi/Lỗ',
                value: _mask(_formatSignedPercent(holding.pnlPct), hidden),
                color: holding.pnlPct >= 0 ? AppColors.buy : AppColors.sell,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HoldingMetric extends StatelessWidget {
  const _HoldingMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _portfolioHoldingMetricGap),
          Text(
            value,
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

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard({required this.stats, required this.points});

  final PortfolioStats stats;
  final List<PortfolioPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _portfolioChartCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giá trị danh mục',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                _formatSignedPercent(stats.totalPnlPct),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _portfolioChartTitleGap),
          SizedBox(
            height: _portfolioChartHeight,
            width: double.infinity,
            child: CustomPaint(painter: _PerformancePainter(points: points)),
          ),
        ],
      ),
    );
  }
}
