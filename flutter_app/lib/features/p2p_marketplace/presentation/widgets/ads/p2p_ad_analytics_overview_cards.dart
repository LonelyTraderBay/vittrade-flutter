part of '../../phone/pages/ads/p2p_ad_analytics_page.dart';

class _AdIdentityCard extends StatelessWidget {
  const _AdIdentityCard({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final typeColor = snapshot.tradeType == P2PTradeType.sell
        ? AppColors.sell
        : AppColors.buy;
    final typeLabel = snapshot.tradeType == P2PTradeType.sell ? 'BÁN' : 'MUA';

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _p2pAdAnalyticsIdentityExtent,
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Row(
        children: [
          VitAccentPill(
            label: '$typeLabel ${snapshot.asset}',
            accentColor: typeColor,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    _formatVnd(snapshot.priceVnd),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  snapshot.currency,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          VitMetricDeltaPill(
            label: '#${snapshot.ranking}/${snapshot.totalActiveAds}',
            tone: VitMetricDeltaTone.warning,
            icon: Icons.emoji_events_outlined,
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiItem(
        icon: Icons.visibility_outlined,
        label: 'Lượt xem',
        value: _formatCount(snapshot.impressions),
        subtitle: '7 ngày qua',
        color: AppColors.accent,
      ),
      _KpiItem(
        icon: Icons.ads_click_rounded,
        label: 'Lượt click',
        value: _formatCount(snapshot.clicks),
        subtitle:
            'CTR ${_fixed(snapshot.clicks / snapshot.impressions * 100)}%',
        color: AppModuleAccents.p2p,
      ),
      _KpiItem(
        icon: Icons.shopping_cart_outlined,
        label: 'Đơn tạo',
        value: _formatCount(snapshot.ordersCreated),
        subtitle: 'CVR ${_fixed(snapshot.conversionRate)}%',
        color: AppColors.warn,
      ),
      _KpiItem(
        icon: Icons.check_circle_outline_rounded,
        label: 'Hoàn thành',
        value: _formatCount(snapshot.ordersCompleted),
        subtitle: '${_fixed(snapshot.completionRate)}% tỷ lệ HT',
        color: AppColors.buy,
      ),
      _KpiItem(
        icon: Icons.trending_up_rounded,
        label: 'Tổng volume',
        value: _formatCompactVnd(snapshot.totalVolume),
        subtitle: 'TB ${_formatCompactVnd(snapshot.avgOrderValue)}/đơn',
        color: AppColors.accent,
      ),
      _KpiItem(
        icon: Icons.bolt_rounded,
        label: 'Doanh thu',
        value: _formatCompactVnd(snapshot.totalRevenue),
        subtitle: 'phí + spread',
        color: AppColors.buy,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < cards.length; i += 2) ...[
          Row(
            children: [
              Expanded(child: _MetricCard(item: cards[i])),
              const SizedBox(width: AppSpacing.x3),
              Expanded(child: _MetricCard(item: cards[i + 1])),
            ],
          ),
          if (i < cards.length - 2) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _KpiItem {
  const _KpiItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.item});

  final _KpiItem item;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _p2pAdAnalyticsMetricCardExtent,
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: item.color.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
                child: SizedBox(
                  width: _p2pAdAnalyticsMetricIconExtent,
                  height: _p2pAdAnalyticsMetricIconExtent,
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickStat(
        Icons.schedule_rounded,
        '${snapshot.avgResponseTimeSeconds}s',
        'Phản hồi',
        AppColors.accent,
      ),
      _QuickStat(
        Icons.monitor_heart_outlined,
        '${snapshot.avgCompletionMinutes}m',
        'HT TB',
        AppColors.buy,
      ),
      _QuickStat(
        Icons.star_border_rounded,
        _fixed(snapshot.rating),
        'Rating',
        AppColors.warn,
      ),
      _QuickStat(
        Icons.group_outlined,
        '${snapshot.reviewsCount}',
        'Reviews',
        AppColors.accent,
      ),
    ];

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _p2pAdAnalyticsQuickStatsExtent,
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(child: _QuickStatView(item: items[i])),
            if (i < items.length - 1) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _QuickStat {
  const _QuickStat(this.icon, this.value, this.label, this.color);

  final IconData icon;
  final String value;
  final String label;
  final Color color;
}

class _QuickStatView extends StatelessWidget {
  const _QuickStatView({required this.item});

  final _QuickStat item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(item.icon, color: item.color, size: AppSpacing.iconSm),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          item.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ConversionFunnel extends StatelessWidget {
  const _ConversionFunnel({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final base = snapshot.impressions;
    final stages = [
      _FunnelStage('Lượt xem', snapshot.impressions, 100, AppColors.accent),
      _FunnelStage(
        'Lượt click',
        snapshot.clicks,
        snapshot.clicks / base * 100,
        AppColors.primary,
      ),
      _FunnelStage(
        'Đơn tạo',
        snapshot.ordersCreated,
        snapshot.ordersCreated / base * 100,
        AppColors.warn,
      ),
      _FunnelStage(
        'Hoàn thành',
        snapshot.ordersCompleted,
        snapshot.ordersCompleted / base * 100,
        AppColors.buy,
      ),
    ];

    return VitCard(
      key: P2PAdAnalyticsPage.funnelKey,
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Phễu chuyển đổi',
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.accent,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (var i = 0; i < stages.length; i++) ...[
            _FunnelBar(stage: stages[i], showPct: i > 0),
            if (i < stages.length - 1)
              const SizedBox(height: AppSpacing.rowGap),
          ],
          const SizedBox(height: AppSpacing.rowGap),
          const Divider(
            height: _p2pAdAnalyticsDividerExtent,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SmallInlineStat(
                  icon: Icons.cancel_outlined,
                  label: 'Hủy: ${snapshot.ordersCancelled}',
                  color: AppColors.sell,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _SmallInlineStat(
                    icon: Icons.warning_amber_rounded,
                    label: 'Tranh chấp: ${snapshot.ordersDisputed}',
                    color: AppColors.warn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FunnelStage {
  const _FunnelStage(this.label, this.value, this.percent, this.color);

  final String label;
  final int value;
  final double percent;
  final Color color;
}

class _FunnelBar extends StatelessWidget {
  const _FunnelBar({required this.stage, required this.showPct});

  final _FunnelStage stage;
  final bool showPct;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                stage.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              _formatCount(stage.value),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            if (showPct) ...[
              const SizedBox(width: AppSpacing.x3),
              Text(
                '${_fixed(stage.percent)}%',
                style: AppTextStyles.micro.copyWith(
                  color: stage.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.smRadius,
          child: LinearProgressIndicator(
            value: stage.percent.clamp(0, 100) / 100,
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(stage.color),
          ),
        ),
      ],
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Hiệu suất 7 ngày',
            icon: Icons.trending_up_rounded,
            iconColor: AppColors.buy,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          Text(
            'Lượt xem & Đơn hàng theo ngày',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: _p2pAdAnalyticsChartLargeExtent,
            child: CustomPaint(
              painter: _PerformanceLinePainter(snapshot.dailyPerformance),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: AppColors.accent, label: 'Lượt xem'),
              SizedBox(width: AppSpacing.x5),
              _LegendDot(color: AppColors.buy, label: 'Đơn hàng'),
            ],
          ),
        ],
      ),
    );
  }
}
