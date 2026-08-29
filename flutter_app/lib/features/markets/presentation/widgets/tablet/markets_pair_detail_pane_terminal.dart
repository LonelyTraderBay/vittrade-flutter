part of 'markets_pair_detail_pane.dart';

/// Terminal thuần của pane pair (SC-044, hướng C — user duyệt 2026-08-30):
/// GRID CỐ ĐỊNH chiếm toàn bộ chiều cao pane, không cuộn trang — hàng meta
/// dày đặc 1 dòng, lưới [chart/độ sâu | sổ lệnh + giao dịch], mini-tab
/// điều hướng dưới chart. Mỗi miền dữ liệu một PANEL PHẲNG riêng
/// (VitCardRadius.tight 8px, viền hairline, nhãn micro) tách rõ bằng
/// viền + nhãn — không tách bằng khoảng trống to. Chỉ sổ lệnh/giao dịch
/// cuộn nội bộ. Render qua `MarketsPaneScaffold.body` (thay vùng cuộn).
class _PairTerminalShell extends StatelessWidget {
  const _PairTerminalShell({
    required this.snapshot,
    required this.activeView,
    required this.onViewChanged,
    required this.timeframe,
    required this.indicators,
    required this.workspace,
  });

  final MarketPairDetailSnapshot snapshot;
  final MarketsPairView activeView;
  final ValueChanged<MarketsPairView> onViewChanged;
  final String timeframe;
  final Set<String> indicators;
  final Widget workspace;

  @override
  Widget build(BuildContext context) {
    final pair = snapshot.pair;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PairMetaStrip(pair: pair),
        const SizedBox(height: MarketsSpacingTokens.pairTerminalGutter),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: activeView == MarketsPairView.depth
                          ? SingleChildScrollView(
                              key: MarketsTabletKeys.pairPaneContent,
                              child: _PairDepthWorkspace(pairId: pair.id),
                            )
                          : workspace,
                    ),
                    const SizedBox(
                      height: MarketsSpacingTokens.pairTerminalGutter,
                    ),
                    _PairMiniTabs(
                      pair: pair,
                      activeView: activeView,
                      onViewChanged: onViewChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: MarketsSpacingTokens.pairTerminalGutter),
              SizedBox(
                width: MarketsSpacingTokens.pairDeskSideWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _PairTerminalBookPanel(snapshot: snapshot)),
                    const SizedBox(
                      height: MarketsSpacingTokens.pairTerminalGutter,
                    ),
                    Expanded(
                      child: _PairTerminalTradesPanel(
                        trades: snapshot.recentTrades,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Hàng meta dày đặc 1 dòng (Bybit-style): giá + biến động + Cao/Thấp/KL
/// 24h, số tabular, ngăn bằng vạch mảnh — thay khối giá 2 dòng kiểu
/// mobile cũ (khối giá lớn vẫn giữ ở khuôn pane hẹp).
class _PairMetaStrip extends StatelessWidget {
  const _PairMetaStrip({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    final accent = positive ? AppColors.buy : AppColors.sell;
    return _PairPanel(
      panelKey: MarketsTabletKeys.pairMetaStrip,
      child: Padding(
        padding: MarketsSpacingTokens.pairMetaStripPadding,
        child: Row(
          children: [
            Flexible(
              child: Text(
                formatMarketPriceFixed2(pair.price),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: accent,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${positive ? '▲' : '▼'}${pair.change24h.abs().toStringAsFixed(2)}%',
              style: AppTextStyles.caption.copyWith(
                color: accent,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            for (final (label, value) in [
              ('Cao', formatMarketPriceFixed2(pair.high24h)),
              ('Thấp', formatMarketPriceFixed2(pair.low24h)),
              ('KL', formatMarketCompact(pair.volume24h, prefix: '\$')),
            ]) ...[
              const SizedBox(width: MarketsSpacingTokens.pairMetaGap),
              const SizedBox(
                height: MarketsSpacingTokens.pairMetaDividerHeight,
                child: VerticalDivider(
                  width: AppSpacing.hairlineStroke,
                  thickness: AppSpacing.hairlineStroke,
                  color: AppColors.divider,
                ),
              ),
              const SizedBox(width: MarketsSpacingTokens.pairMetaGap),
              Text.rich(
                TextSpan(
                  text: '$label ',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  children: [
                    TextSpan(
                      text: value,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Panel phẳng dùng chung của terminal: VitCardRadius.tight (8px), viền
/// hairline, tiêu đề micro nhãn + trailing tuỳ chọn — "nhiều card riêng
/// biệt" nhưng phẳng dày đặc, tách bằng viền + nhãn.
class _PairPanel extends StatelessWidget {
  const _PairPanel({
    required this.child,
    this.label,
    this.trailing,
    this.panelKey,
    this.fill = false,
  });

  final Widget child;
  final String? label;
  final Widget? trailing;
  final Key? panelKey;

  /// true = chiếm hết chiều cao còn lại (book/trades cột phải); false =
  /// co theo nội dung (meta strip, mini-tab — tránh Expanded vô hạn).
  final bool fill;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: panelKey,
      radius: VitCardRadius.tight,
      borderColor: AppColors.border,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label case final labelValue?)
            Padding(
              padding: MarketsSpacingTokens.pairPanelHeaderPadding,
              child: Row(
                children: [
                  Text(
                    labelValue,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const Spacer(),
                  ?trailing,
                ],
              ),
            ),
          if (fill) Expanded(child: child) else child,
        ],
      ),
    );
  }
}

/// Sổ lệnh terminal: 12 MỨC mỗi bên (mock có 25, UI cũ chỉ vẽ 4 — panel
/// từng trống 2/3), mỗi hàng có DEPTH BAR nền theo lũy kế, hàng SPREAD
/// giữa hai bên — mật độ chuẩn Bybit.
class _PairTerminalBookPanel extends StatelessWidget {
  const _PairTerminalBookPanel({required this.snapshot});

  final MarketPairDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final asks = snapshot.depth.asks.take(12).toList();
    final bids = snapshot.depth.bids.take(12).toList();
    final maxCumulative = [
      ...asks,
      ...bids,
    ].map((level) => level.cumulative).reduce((a, b) => a > b ? a : b);
    final spread = asks.first.price - bids.first.price;
    return _PairPanel(
      panelKey: MarketsTabletKeys.pairBookPanel,
      label: 'SỔ LỆNH',
      fill: true,
      trailing: Text(
        'Spread ${spread.toStringAsFixed(2)}',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
      child: Padding(
        padding: MarketsSpacingTokens.pairPanelHeaderPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var i = asks.length - 1; i >= 0; i--)
                _PairBookRow(
                  key: MarketsTabletKeys.pairBookRow('ask', i),
                  level: asks[i],
                  side: MarketOrderSide.sell,
                  maxCumulative: maxCumulative,
                ),
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
              for (var i = 0; i < bids.length; i++)
                _PairBookRow(
                  key: MarketsTabletKeys.pairBookRow('bid', i),
                  level: bids[i],
                  side: MarketOrderSide.buy,
                  maxCumulative: maxCumulative,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Một mức giá của sổ lệnh terminal: depth bar nền (ColoredBox +
/// FractionallySizedBox — không BoxDecoration) + giá/mức/lũy kế tabular.
class _PairBookRow extends StatelessWidget {
  const _PairBookRow({
    super.key,
    required this.level,
    required this.side,
    required this.maxCumulative,
  });

  final MarketDepthLevel level;
  final MarketOrderSide side;
  final double maxCumulative;

  @override
  Widget build(BuildContext context) {
    final color = side == MarketOrderSide.buy ? AppColors.buy : AppColors.sell;
    final widthFactor = (level.cumulative / (maxCumulative + 1e-9)).clamp(
      0.0,
      1.0,
    );
    return SizedBox(
      height: MarketsSpacingTokens.pairBookRowExtent,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          FractionallySizedBox(
            widthFactor: widthFactor,
            child: ColoredBox(color: color.withValues(alpha: .10)),
          ),
          Padding(
            padding: MarketsSpacingTokens.pairBookRowPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formatMarketPriceFixed2(level.price),
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    level.quantity.toStringAsFixed(3),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    level.cumulative.toStringAsFixed(2),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
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

/// Bảng giao dịch gần đây terminal: cuộn NỘI BỘ, 24 dòng (fixture sinh
/// theo khuôn deterministic) — mật độ chuẩn sàn lớn.
class _PairTerminalTradesPanel extends StatelessWidget {
  const _PairTerminalTradesPanel({required this.trades});

  final List<MarketRecentTrade> trades;

  @override
  Widget build(BuildContext context) {
    return _PairPanel(
      panelKey: MarketsTabletKeys.pairTradesPanel,
      label: 'GIAO DỊCH',
      fill: true,
      child: Padding(
        padding: MarketsSpacingTokens.pairPanelHeaderPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _TradeHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: trades.length,
                itemExtent: MarketsSpacingTokens.pairTradeRowExtent,
                itemBuilder: (context, index) => _TradeRow(
                  key: MarketsTabletKeys.pairTradeRow(index),
                  trade: trades[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mini-tab điều hướng dưới chart: Độ sâu (đổi workspace trái) · Thông tin
/// coin · Mua định kỳ (push route) — thay banner + thẻ link kiểu web cũ.
class _PairMiniTabs extends StatelessWidget {
  const _PairMiniTabs({
    required this.pair,
    required this.activeView,
    required this.onViewChanged,
  });

  final MarketPair pair;
  final MarketsPairView activeView;
  final ValueChanged<MarketsPairView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    return _PairPanel(
      child: Padding(
        padding: MarketsSpacingTokens.pairChartToolbarPadding,
        child: Row(
          children: [
            _PairIntervalButton(
              key: MarketsTabletKeys.pairMiniTab('depth'),
              label: 'Độ sâu',
              active: activeView == MarketsPairView.depth,
              onTap: () => onViewChanged(
                activeView == MarketsPairView.depth
                    ? MarketsPairView.chart
                    : MarketsPairView.depth,
              ),
            ),
            const SizedBox(width: MarketsSpacingTokens.pairIntervalGap),
            _PairIntervalButton(
              key: MarketsTabletKeys.pairMiniTab('info'),
              label: 'Thông tin',
              active: false,
              onTap: () => openMarketsDetailRoute(
                context,
                AppRoutePaths.pairInfo(pair.id),
              ),
            ),
            const SizedBox(width: MarketsSpacingTokens.pairIntervalGap),
            _PairIntervalButton(
              key: MarketsTabletKeys.pairMiniTab('dca'),
              label: 'Mua định kỳ',
              active: false,
              onTap: () => unawaited(context.push(AppRoutePaths.dca)),
            ),
          ],
        ),
      ),
    );
  }
}
