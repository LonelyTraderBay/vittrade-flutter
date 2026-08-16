part of '../../phone/pages/provider/trader_profile_page.dart';

class _TraderTab {
  const _TraderTab({required this.id, required this.label});

  final String id;
  final String label;
}

class _SegmentTabs extends StatelessWidget {
  const _SegmentTabs({
    required this.activeId,
    required this.tabs,
    required this.onChanged,
  });

  final String activeId;
  final List<_TraderTab> tabs;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: TraderProfilePage.tabKey(tab.id),
          ),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final TradeTraderProfileSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChartCard(
          title: 'PnL tích lũy (30 ngày)',
          trailing: _signedUsd(snapshot.trader.totalPnl),
          child: AspectRatio(
            aspectRatio: 2.9,
            child: CustomPaint(
              painter: TraderProfileAreaChartPainter(
                points: snapshot.pnlHistory,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        _ChartCard(
          title: 'PnL hằng ngày',
          child: AspectRatio(
            aspectRatio: 3.3,
            child: CustomPaint(
              painter: TraderProfileDailyBarsPainter(
                points: snapshot.pnlHistory.takeLast(14),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        _DetailsCard(trader: snapshot.trader),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AppTextStyles.caption.copyWith(
                    color: _profileGreen,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          child,
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    final details = [
      _DetailItem(
        Icons.bar_chart_rounded,
        'Tổng lệnh',
        _formatInt(trader.totalTrades),
      ),
      _DetailItem(
        Icons.schedule_rounded,
        'TG nắm giữ TB',
        trader.avgHoldingTime,
      ),
      _DetailItem(
        Icons.people_alt_rounded,
        'Copiers hiện tại',
        _formatInt(trader.copiers),
      ),
      _DetailItem(Icons.shield_outlined, 'AUM', _compactUsd(trader.aum)),
      _DetailItem(
        Icons.track_changes_rounded,
        'Max Drawdown',
        '${trader.maxDrawdown.toStringAsFixed(1)}%',
      ),
      _DetailItem(
        Icons.bolt_rounded,
        'Sharpe Ratio',
        trader.sharpeRatio.toStringAsFixed(2),
      ),
    ];

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chi tiết',
            style: AppTextStyles.body.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - AppSpacing.x2) / 2;
              return Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final item in details)
                    SizedBox(
                      width: itemWidth,
                      child: _DetailRow(item: item),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  const _DetailItem(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.item});

  final _DetailItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: AppColors.text3,
          size: TradeSpacingTokens.traderProfileDetailIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                item.value,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.medium,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
