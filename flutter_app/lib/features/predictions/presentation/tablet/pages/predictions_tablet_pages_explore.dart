part of 'predictions_tablet_pages.dart';

/// SC-214: Bảng xếp hạng trader prediction.
class PredictionsLeaderboardTabletPage extends ConsumerWidget {
  const PredictionsLeaderboardTabletPage({super.key});

  static const contentKey = Key('sc214_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsLeaderboardSnapshotProvider((
        timeFilter: PredictionLeaderboardTimeFilter.allTime,
        metric: PredictionLeaderboardMetric.pnl,
      )),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-214',
        semanticLabel: 'Bảng xếp hạng prediction',
        title: 'Bảng xếp hạng',
        subtitle: 'Theo kỳ · Chỉ số',
        contentKey: PredictionsLeaderboardTabletPage.contentKey,
        child: _pdmError(
          'Không tải được bảng xếp hạng',
          () => ref.invalidate(
            predictionsLeaderboardSnapshotProvider((
              timeFilter: PredictionLeaderboardTimeFilter.allTime,
              metric: PredictionLeaderboardMetric.pnl,
            )),
          ),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-214',
        semanticLabel: 'Bảng xếp hạng prediction',
        title: 'Bảng xếp hạng',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: PredictionsLeaderboardTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Top trader',
              rows: [
                for (final trader in snapshot.traders.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        SizedBox(
                          width: TabletSpacingTokens.x5,
                          child: Text(
                            '#${trader.rank}',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            trader.user,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${_pdmUsdS(trader.pnl)} · thắng ${trader.winRate}%',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: trader.pnl >= 0
                                ? AppColors.buy
                                : AppColors.sell,
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

/// SC-215: Hoạt động toàn cục prediction.
class PredictionsGlobalActivityTabletPage extends ConsumerWidget {
  const PredictionsGlobalActivityTabletPage({super.key});

  static const contentKey = Key('sc215_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsGlobalActivitySnapshotProvider(0),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-215',
        semanticLabel: 'Hoạt động prediction',
        title: 'Hoạt động toàn cục',
        subtitle: 'Mua · Bán',
        contentKey: PredictionsGlobalActivityTabletPage.contentKey,
        child: _pdmError(
          'Không tải được hoạt động',
          () => ref.invalidate(predictionsGlobalActivitySnapshotProvider(0)),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-215',
        semanticLabel: 'Hoạt động prediction',
        title: 'Hoạt động toàn cục',
        subtitle: '${snapshot.buyCount} mua · ${snapshot.sellCount} bán',
        contentKey: PredictionsGlobalActivityTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Luồng hoạt động',
              rows: [
                for (final activity in snapshot.activities.take(12))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${activity.user} · ${activity.action.name} ${activity.outcome}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${_pdmDec(activity.price)} × ${activity.shares}',
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
          ],
        ),
      ),
    );
  }
}

/// SC-216: Máy tính rủi ro prediction.
class PredictionRiskCalculatorTabletPage extends ConsumerWidget {
  const PredictionRiskCalculatorTabletPage({super.key});

  static const contentKey = Key('sc216_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsRiskCalculatorSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-216',
        semanticLabel: 'Máy tính rủi ro prediction',
        title: 'Máy tính rủi ro',
        subtitle: 'Vị thế · Vốn',
        contentKey: PredictionRiskCalculatorTabletPage.contentKey,
        child: _pdmError(
          'Không tải được máy tính rủi ro',
          () => ref.invalidate(predictionsRiskCalculatorSnapshotProvider),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-216',
        semanticLabel: 'Máy tính rủi ro prediction',
        title: 'Máy tính rủi ro',
        subtitle: snapshot.defaultEventName,
        contentKey: PredictionRiskCalculatorTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Tham số mặc định',
              rows: _pdmRows([
                ('Sự kiện', snapshot.defaultEventName),
                ('Kết quả', snapshot.defaultOutcome),
                ('Số cổ phần', _pdmDec(snapshot.defaultShares, 1)),
                ('Giá vào', _pdmDec(snapshot.defaultEntryPrice)),
                ('Giá hiện tại', _pdmDec(snapshot.defaultCurrentPrice)),
                ('Vốn', _pdmUsd(snapshot.defaultBankroll)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-217: Market maker prediction.
class PredictionMarketMakerTabletPage extends ConsumerWidget {
  const PredictionMarketMakerTabletPage({super.key});

  static const contentKey = Key('sc217_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsMarketMakerSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-217',
        semanticLabel: 'Tạo thanh khoản dự đoán',
        title: 'Market maker',
        subtitle: 'Thanh khoản · Phí',
        contentKey: PredictionMarketMakerTabletPage.contentKey,
        child: _pdmError(
          'Không tải được market maker',
          () => ref.invalidate(predictionsMarketMakerSnapshotProvider),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-217',
        semanticLabel: 'Tạo thanh khoản dự đoán',
        title: 'Market maker',
        subtitle: 'Chênh lệch ${snapshot.defaultSpreadBps} bps',
        contentKey: PredictionMarketMakerTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkLikeLiquidity(snapshot.positions),
            const SizedBox(height: TabletSpacingTokens.x3),
            _pdmSection(
              title: 'Thu nhập phí theo ngày',
              rows: [
                for (final point in snapshot.earningsHistory.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            point.date,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          'Phí ${_pdmUsdS(point.fees)} · KL ${_pdmUsd(point.volume)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
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

  Widget _stkLikeLiquidity(List<PredictionLiquidityPositionDraft> positions) {
    return _pdmSection(
      title: 'Vị thế thanh khoản',
      rows: [
        for (final position in positions)
          Padding(
            padding: TabletSpacingTokens.tableCellPaddingV,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.eventName,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        'Cung cấp ${_pdmUsd(position.liquidityProvided)} · APR ${_pdmPct(position.apr)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _pdmUsdS(position.feesEarned),
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.buy,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// SC-218: Phân tích danh mục prediction.
class PredictionPortfolioAnalyzerTabletPage extends ConsumerWidget {
  const PredictionPortfolioAnalyzerTabletPage({super.key});

  static const contentKey = Key('sc218_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsPortfolioAnalyzerSnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-218',
        semanticLabel: 'Phân tích danh mục prediction',
        title: 'Phân tích danh mục',
        subtitle: 'Vị thế · Lịch sử PnL',
        contentKey: PredictionPortfolioAnalyzerTabletPage.contentKey,
        child: _pdmError(
          'Không tải được phân tích',
          () => ref.invalidate(predictionsPortfolioAnalyzerSnapshotProvider),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-218',
        semanticLabel: 'Phân tích danh mục prediction',
        title: 'Phân tích danh mục',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: PredictionPortfolioAnalyzerTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Vị thế',
              rows: [
                for (final position in snapshot.positions)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${position.eventName} · ${position.outcome}',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${_pdmDec(position.shares, 1)} cổ phần · vào ${_pdmDec(position.avgPrice)} → hiện ${_pdmDec(position.currentPrice)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          position.status.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _pdmSection(
              title: 'Lịch sử PnL',
              rows: _pdmRows([
                for (final point in snapshot.pnlHistory.take(8))
                  (point.date, _pdmUsdS(point.value)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-219: Lịch sự kiện prediction.
class PredictionEventCalendarTabletPage extends ConsumerWidget {
  const PredictionEventCalendarTabletPage({super.key});

  static const contentKey = Key('sc219_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsEventCalendarSnapshotProvider(null),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-219',
        semanticLabel: 'Lịch sự kiện prediction',
        title: 'Lịch sự kiện',
        subtitle: 'Ngày phân định',
        contentKey: PredictionEventCalendarTabletPage.contentKey,
        child: _pdmError(
          'Không tải được lịch',
          () => ref.invalidate(predictionsEventCalendarSnapshotProvider(null)),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-219',
        semanticLabel: 'Lịch sự kiện prediction',
        title: 'Lịch sự kiện',
        subtitle: '${snapshot.events.length} sự kiện',
        contentKey: PredictionEventCalendarTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Sự kiện',
              rows: [
                for (final event in snapshot.events.take(12))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${event.category} · xác suất ${event.probability}%',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${event.resolutionDate.year}-${event.resolutionDate.month.toStringAsFixed(0).padLeft(2, '0')}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
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
