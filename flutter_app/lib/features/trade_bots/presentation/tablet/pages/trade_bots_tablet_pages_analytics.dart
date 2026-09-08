part of 'trade_bots_tablet_pages.dart';

/// SC-133: Backtesting bot.
class BotBacktestingTabletPage extends ConsumerWidget {
  const BotBacktestingTabletPage({super.key});

  static const contentKey = Key('sc133_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotBacktestingProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-133',
        semanticLabel: 'Kiểm thử lịch sử bot',
        title: 'Backtesting',
        subtitle: 'Chiến lược · Vốn',
        contentKey: BotBacktestingTabletPage.contentKey,
        child: _tbpError(
          'Không tải được backtesting',
          () => ref.invalidate(tradeBotBacktestingProvider),
        ),
      ),
      data: (snapshot) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-133',
        semanticLabel: 'Kiểm thử lịch sử bot',
        title: 'Backtesting',
        subtitle:
            'Vốn mặc định ${VitFormat.usd(snapshot.defaultCapital)} · ${snapshot.pairs.length} cặp',
        contentKey: BotBacktestingTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tbpSection(
              title: 'Chiến lược kiểm thử',
              rows: _tbpBullets([
                for (final strategy in snapshot.strategies) strategy.name,
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Cặp giao dịch',
              rows: _tbpBullets(snapshot.pairs),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Khoảng thời gian',
              rows: _tbpRows([
                for (final range in snapshot.dateRanges)
                  (range.id, range.label),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-134: So sánh chiến lược bot.
class BotStrategyCompareTabletPage extends ConsumerWidget {
  const BotStrategyCompareTabletPage({super.key});

  static const contentKey = Key('sc134_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotStrategyCompareProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-134',
        semanticLabel: 'So sánh chiến lược bot',
        title: 'So sánh chiến lược',
        subtitle: snapshotAsync.value?.analysisPeriod ?? 'Kỳ phân tích',
        contentKey: BotStrategyCompareTabletPage.contentKey,
        child: _tbpError(
          'Không tải được so sánh chiến lược',
          () => ref.invalidate(tradeBotStrategyCompareProvider),
        ),
      ),
      data: (snapshot) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-134',
        semanticLabel: 'So sánh chiến lược bot',
        title: 'So sánh chiến lược',
        subtitle: snapshot.analysisPeriod,
        contentKey: BotStrategyCompareTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tbpSection(
              title: 'Chiến lược',
              rows: [
                for (final strategy in snapshot.strategies)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      strategy.name,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Đường vốn theo ngày',
              rows: [
                for (final point in snapshot.equityPoints.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        SizedBox(
                          width: TabletSpacingTokens.x7,
                          child: Text(
                            point.date,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'DCA ${_tbpDec(point.dca)} · Grid ${_tbpDec(point.grid)} · Momentum ${_tbpDec(point.momentum)} · Martingale ${_tbpDec(point.martingale)}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Khuyến nghị',
              rows: [
                for (final recommendation in snapshot.recommendations)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          recommendation.reason,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-135: Tối ưu tham số bot.
class BotOptimizationTabletPage extends ConsumerWidget {
  const BotOptimizationTabletPage({super.key});

  static const contentKey = Key('sc135_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotOptimizationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-135',
        semanticLabel: 'Tối ưu bot',
        title: 'Tối ưu tham số',
        subtitle: 'Mục tiêu · Khoảng giá trị',
        contentKey: BotOptimizationTabletPage.contentKey,
        child: _tbpError(
          'Không tải được tối ưu',
          () => ref.invalidate(tradeBotOptimizationProvider),
        ),
      ),
      data: (snapshot) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-135',
        semanticLabel: 'Tối ưu bot',
        title: 'Tối ưu tham số',
        subtitle: 'Mục tiêu · Khoảng giá trị',
        contentKey: BotOptimizationTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tbpSection(
              title: 'Mục tiêu tối ưu',
              rows: [
                for (final target in snapshot.targets)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          target.label,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          target.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Khoảng tham số',
              rows: _tbpRows([
                for (final range in snapshot.parameterRanges)
                  (
                    range.label,
                    '${_tbpDec(range.min)} → ${_tbpDec(range.max)} (bước ${_tbpDec(range.step)}) ${range.unit}',
                  ),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Các bước thực hiện',
              rows: _tbpBullets(snapshot.steps),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-136: Tổng quan danh mục bot.
class BotPortfolioDashboardTabletPage extends ConsumerWidget {
  const BotPortfolioDashboardTabletPage({super.key});

  static const contentKey = Key('sc136_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotPortfolioDashboardProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-136',
        semanticLabel: 'Danh mục bot',
        title: 'Danh mục bot',
        subtitle: 'Tổng quan · Phân bổ',
        contentKey: BotPortfolioDashboardTabletPage.contentKey,
        child: _tbpError(
          'Không tải được danh mục bot',
          () => ref.invalidate(tradeBotPortfolioDashboardProvider),
        ),
      ),
      data: (snapshot) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-136',
        semanticLabel: 'Danh mục bot',
        title: 'Danh mục bot',
        subtitle:
            '${snapshot.summary.activeBots} bot · ${snapshot.summary.totalTrades} lệnh',
        contentKey: BotPortfolioDashboardTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tbpSection(
              title: 'Tổng quan',
              rows: _tbpRows([
                ('Tổng vốn', VitFormat.usd(snapshot.summary.totalEquity)),
                ('Đã đầu tư', VitFormat.usd(snapshot.summary.totalInvestment)),
                ('Lợi nhuận', VitFormat.usdSigned(snapshot.summary.totalPnl)),
                ('Tỷ suất', _tbpPct(snapshot.summary.pnlPercent, 2)),
                ('Sharpe danh mục', _tbpDec(snapshot.summary.portfolioSharpe)),
                (
                  'Điểm đa dạng hóa',
                  '${snapshot.summary.diversificationScore}/100',
                ),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Phân bổ',
              rows: [
                for (final allocation in snapshot.allocations)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            allocation.strategy,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${VitFormat.usd(allocation.value)} · ${VitFormat.usdSigned(allocation.pnl)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Tình trạng sức khỏe',
              rows: _tbpBullets(snapshot.healthItems),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-137: Phân tích sụt giảm bot.
class BotDrawdownAnalyzerTabletPage extends ConsumerWidget {
  const BotDrawdownAnalyzerTabletPage({super.key});

  static const contentKey = Key('sc137_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotDrawdownAnalyzerProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-137',
        semanticLabel: 'Phân tích sụt giảm bot',
        title: 'Phân tích sụt giảm',
        subtitle: 'Mức độ · Thời gian phục hồi',
        contentKey: BotDrawdownAnalyzerTabletPage.contentKey,
        child: _tbpError(
          'Không tải được phân tích sụt giảm',
          () => ref.invalidate(tradeBotDrawdownAnalyzerProvider),
        ),
      ),
      data: (snapshot) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-137',
        semanticLabel: 'Phân tích sụt giảm bot',
        title: 'Phân tích sụt giảm',
        subtitle:
            'Sụt giảm tối đa ${_tbpPct(snapshot.summary.maxDrawdownPct, 2)}',
        contentKey: BotDrawdownAnalyzerTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tbpSection(
              title: 'Tổng quan',
              rows: _tbpRows([
                (
                  'Sụt giảm tối đa',
                  _tbpPct(snapshot.summary.maxDrawdownPct, 2),
                ),
                ('Sụt giảm TB', _tbpPct(snapshot.summary.avgDrawdownPct, 2)),
                (
                  'Ngày trong sụt giảm',
                  '${snapshot.summary.drawdownDays}/${snapshot.summary.totalDays}',
                ),
                ('Số lần sụt giảm', '${snapshot.summary.frequency}'),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Sự kiện sụt giảm',
              rows: [
                for (final event in snapshot.events)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '#${event.id} · ${event.startLabel} · ${event.duration}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${_tbpPct(event.depthPct, 2)} · phục hồi ${event.recovery}',
                          style: AppTextStyles.caption.copyWith(
                            color: event.severe
                                ? AppColors.sell
                                : AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Phân bố thời gian phục hồi',
              rows: _tbpRows([
                for (final bucket in snapshot.durationBuckets)
                  (bucket.range, '${bucket.count} lần'),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Nhận định',
              rows: [
                for (final insight in snapshot.insights)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${insight.symbol} ',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            insight.text,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
