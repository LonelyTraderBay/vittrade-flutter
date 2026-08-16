part of 'portfolio_tracker_page.dart';

class _PortfolioTrackerPageState extends ConsumerState<PortfolioTrackerPage> {
  String _tab = 'overview';
  String _timeFilter = '30d';
  bool _hideBalance = false;
  MarketPortfolioSort _sortBy = MarketPortfolioSort.value;

  @override
  Widget build(BuildContext context) {
    final portfolioAsync = ref.watch(marketPortfolioSnapshotProvider(_sortBy));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _portfolioVisualScrollClearance
            : _portfolioNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Theo dõi danh mục',
      semanticIdentifier: 'SC-021',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Danh mục',
            subtitle: 'Theo dõi danh mục · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PortfolioTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PortfolioTrackerPage.contentKey,
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: portfolioAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được danh mục',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketPortfolioSnapshotProvider(_sortBy),
                            ),
                          ),
                        ],
                        data: (snapshot) {
                          final overviewHoldings = _overviewHoldings(
                            snapshot.holdings,
                          );
                          return [
                            if (_tab == 'overview') ...[
                              _TotalValueHero(
                                stats: snapshot.stats,
                                hidden: _hideBalance,
                                onToggleHidden: () => setState(() {
                                  _hideBalance = !_hideBalance;
                                }),
                              ),
                              _QuickStats(
                                stats: snapshot.stats,
                                hidden: _hideBalance,
                              ),
                              _AllocationCard(holdings: overviewHoldings),
                              const VitSectionHeader(
                                title: 'Tài sản chính',
                                accentColor: _marketPrimary,
                                bottomGap:
                                    AppSpacing.pageRhythmStandardInnerGap,
                                variant: VitSectionHeaderVariant.accentBar,
                              ),
                              _TopHoldings(
                                holdings: overviewHoldings.take(4).toList(),
                                hidden: _hideBalance,
                                onTap: (holding) => context.go(
                                  AppRoutePaths.pairDetail('${holding.id}usdt'),
                                ),
                              ),
                              _RiskCard(stats: snapshot.stats),
                            ] else if (_tab == 'assets') ...[
                              _SortChips(
                                active: _sortBy,
                                onSelected: (value) => setState(() {
                                  _sortBy = value;
                                }),
                              ),
                              for (final holding in snapshot.holdings)
                                _HoldingDetailCard(
                                  key: PortfolioTrackerPage.holdingKey(
                                    holding.id,
                                  ),
                                  holding: holding,
                                  hidden: _hideBalance,
                                  onTap: () => context.go(
                                    AppRoutePaths.pairDetail(
                                      '${holding.id}usdt',
                                    ),
                                  ),
                                ),
                            ] else ...[
                              Row(
                                children: [
                                  for (final filter in const [
                                    '24h',
                                    '7d',
                                    '30d',
                                    'Tất cả',
                                  ]) ...[
                                    VitFilterChip(
                                      label: filter,
                                      active: _timeFilter == filter,
                                      onTap: () => setState(() {
                                        _timeFilter = filter;
                                      }),
                                      color: _marketPrimary,
                                      padding: _portfolioChipPadding,
                                    ),
                                    if (filter != 'Tất cả')
                                      const SizedBox(width: _portfolioChipGap),
                                  ],
                                ],
                              ),
                              _PerformanceChartCard(
                                stats: snapshot.stats,
                                points: snapshot.performance,
                              ),
                              const VitSectionHeader(
                                title: 'Lãi/Lỗ theo tài sản',
                                accentColor: AppColors.buy,
                                bottomGap:
                                    AppSpacing.pageRhythmStandardInnerGap,
                                variant: VitSectionHeaderVariant.accentBar,
                              ),
                              _PnlBreakdown(
                                holdings: overviewHoldings
                                    .where(
                                      (holding) => holding.symbol != 'USDT',
                                    )
                                    .toList(),
                                hidden: _hideBalance,
                              ),
                              _SummaryStats(
                                stats: snapshot.stats,
                                hidden: _hideBalance,
                              ),
                            ],
                            const VitBanner(
                              variant: VitBannerVariant.info,
                              icon: Icons.info_outline_rounded,
                              message:
                                  'Giá trị danh mục chỉ mang tính tham khảo',
                              detail:
                                  'PnL và phân bổ dựa trên dữ liệu mock. Không phải khuyến nghị đầu tư.',
                            ),
                          ];
                        },
                      ),
                    ),
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

class _PortfolioTabs extends StatelessWidget {
  const _PortfolioTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: MarketsSpacingTokens.marketDepthTabsHeight,
        child: Column(
          children: [
            Expanded(
              child: VitTabBar(
                activeKey: activeTab,
                variant: VitTabBarVariant.underline,
                onChanged: onChanged,
                tabs: const [
                  VitTabItem(
                    key: 'overview',
                    label: 'Tổng quan',
                    widgetKey: PortfolioTrackerPage.overviewTabKey,
                  ),
                  VitTabItem(
                    key: 'assets',
                    label: 'Tài sản',
                    widgetKey: PortfolioTrackerPage.assetsTabKey,
                  ),
                  VitTabItem(
                    key: 'performance',
                    label: 'Hiệu suất',
                    widgetKey: PortfolioTrackerPage.performanceTabKey,
                  ),
                ],
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalValueHero extends StatelessWidget {
  const _TotalValueHero({
    required this.stats,
    required this.hidden,
    required this.onToggleHidden,
  });

  final PortfolioStats stats;
  final bool hidden;
  final VoidCallback onToggleHidden;

  @override
  Widget build(BuildContext context) {
    final pnlColor = stats.totalPnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      variant: VitCardVariant.hero,
      padding: _portfolioHeroPadding,
      borderColor: _marketPrimary.withValues(alpha: .22),
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng giá trị',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              VitInlineIconAction(
                key: PortfolioTrackerPage.hideBalanceKey,
                icon: hidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                tooltip: hidden ? 'Hiá»‡n sá»‘ dÆ°' : 'áº¨n sá»‘ dÆ°',
                onPressed: onToggleHidden,
                color: AppColors.text3,
                size: _portfolioHeroToggleIcon,
                padding: AppSpacing.x1,
              ),
            ],
          ),
          const SizedBox(height: _portfolioHeroTitleGap),
          Text(
            _mask(_formatUsd(stats.totalValue), hidden, long: true),
            style: AppTextStyles.amountMd,
          ),
          const SizedBox(height: _portfolioHeroPnlGap),
          Row(
            children: [
              Icon(
                stats.totalPnl >= 0
                    ? Icons.north_east_rounded
                    : Icons.south_east_rounded,
                size: _portfolioHeroPnlIcon,
                color: pnlColor,
              ),
              const SizedBox(width: _portfolioHeroPnlIconGap),
              Text(
                _mask(
                  '${_formatUsd(stats.totalPnl.abs())} (${_formatSignedPercent(stats.totalPnlPct)})',
                  hidden,
                  long: true,
                ),
                style: AppTextStyles.caption.copyWith(
                  color: pnlColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats, required this.hidden});

  final PortfolioStats stats;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            label: 'Vốn đầu tư',
            value: _mask(_formatCompact(stats.totalCost, prefix: r'$'), hidden),
            color: AppColors.text1,
          ),
        ),
        const SizedBox(width: _portfolioQuickStatGap),
        Expanded(
          child: _MiniStatCard(
            label: 'Tốt nhất 24h',
            value:
                '${stats.best24hSymbol} ${_formatSignedPercent(stats.best24hChange)}',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: _portfolioQuickStatGap),
        Expanded(
          child: _MiniStatCard(
            label: 'Kém nhất 24h',
            value:
                '${stats.worst24hSymbol} ${_formatSignedPercent(stats.worst24hChange)}',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _portfolioMiniStatPadding,
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _portfolioMiniStatValueGap),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.holdings});

  final List<PortfolioHolding> holdings;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _portfolioAllocationPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ tài sản',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _portfolioAllocationTitleGap),
          Row(
            children: [
              SizedBox(
                width: _portfolioDonutSize,
                height: _portfolioDonutSize,
                child: CustomPaint(
                  painter: _AllocationDonutPainter(holdings: holdings),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${holdings.length}',
                          style: AppTextStyles.caption.copyWith(
                            color: _marketPrimary,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'tài sản',
                          style: AppTextStyles.micro.copyWith(
                            color: _marketPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: _portfolioDonutGap),
              Expanded(
                child: Column(
                  children: [
                    for (final holding in holdings.take(5)) ...[
                      _AllocationLegendRow(holding: holding),
                      if (holding != holdings.take(5).last)
                        const SizedBox(height: _portfolioLegendGap),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationLegendRow extends StatelessWidget {
  const _AllocationLegendRow({required this.holding});

  final PortfolioHolding holding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: _portfolioLegendDot,
          color: AppAssetColors.forSymbol(holding.symbol),
        ),
        const SizedBox(width: _portfolioLegendGap),
        Expanded(
          child: Text(
            holding.symbol,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          '${holding.allocation.toStringAsFixed(1)}%',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
