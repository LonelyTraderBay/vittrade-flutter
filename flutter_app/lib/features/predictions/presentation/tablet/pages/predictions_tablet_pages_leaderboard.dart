part of 'predictions_tablet_pages.dart';

// ---------------------------------------------------------------------------
// SC-214: Bảng xếp hạng trader prediction — lọc thời gian + chỉ số
// (P/L / Khối lượng) + podium top 3 + bảng xếp hạng + thắng lớn nhất,
// state cục bộ như phone SC-033.
// ---------------------------------------------------------------------------

class PredictionsLeaderboardTabletPage extends ConsumerStatefulWidget {
  const PredictionsLeaderboardTabletPage({super.key});

  static const contentKey = Key('sc214_tablet_content');
  static const pnlMetricKey = Key('sc214_metric_pnl');
  static const volumeMetricKey = Key('sc214_metric_volume');
  static const infoKey = Key('sc214_pnl_info');

  static Key traderKey(String user) => Key('sc214_trader_$user');

  @override
  ConsumerState<PredictionsLeaderboardTabletPage> createState() =>
      _PredictionsLeaderboardTabletPageState();
}

class _PredictionsLeaderboardTabletPageState
    extends ConsumerState<PredictionsLeaderboardTabletPage> {
  PredictionLeaderboardTimeFilter _timeFilter =
      PredictionLeaderboardTimeFilter.weekly;
  PredictionLeaderboardMetric _metric = PredictionLeaderboardMetric.pnl;

  void _showPnlInfo() {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        // Tier của panel chỉ hiệu lực khi modal không bị kẹp 9/16 màn hình.
        isScrollControlled: true,
        builder: (sheetContext) => VitSheetPanel(
          title: 'P/L là gì?',
          child: Text(
            'P/L (Profit/Loss) cho biết trader lãi hay lỗ. P/L dương nghĩa '
            'là lãi, âm nghĩa là lỗ.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardQuery = (timeFilter: _timeFilter, metric: _metric);
    final leaderboardAsync = ref.watch(
      predictionsLeaderboardSnapshotProvider(leaderboardQuery),
    );

    return leaderboardAsync.when(
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          _pdmError(
            'Không tải được bảng xếp hạng',
            () => ref.invalidate(
              predictionsLeaderboardSnapshotProvider(leaderboardQuery),
            ),
          ),
        ],
      ),
      data: (snapshot) => _frame(
        subtitle: switch (_metric) {
          PredictionLeaderboardMetric.pnl => 'Xếp theo P/L',
          PredictionLeaderboardMetric.volume => 'Xếp theo khối lượng',
        },
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (
                  var index = 0;
                  index < PredictionLeaderboardTimeFilter.values.length;
                  index += 1
                ) ...[
                  VitChoicePill(
                    label: _sc214TimeLabel(
                      PredictionLeaderboardTimeFilter.values[index],
                    ),
                    selected:
                        _timeFilter ==
                        PredictionLeaderboardTimeFilter.values[index],
                    onTap: () => setState(() {
                      _timeFilter =
                          PredictionLeaderboardTimeFilter.values[index];
                    }),
                    accentColor: AppColors.primary,
                  ),
                  if (index !=
                      PredictionLeaderboardTimeFilter.values.length - 1)
                    const SizedBox(width: TabletSpacingTokens.x1),
                ],
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: VitSegmentedChoice<PredictionLeaderboardMetric>(
                  selected: _metric,
                  onChanged: (value) => setState(() {
                    _metric = value;
                  }),
                  options: const [
                    VitSegmentedChoiceOption(
                      value: PredictionLeaderboardMetric.pnl,
                      label: 'P/L',
                      key: PredictionsLeaderboardTabletPage.pnlMetricKey,
                    ),
                    VitSegmentedChoiceOption(
                      value: PredictionLeaderboardMetric.volume,
                      label: 'Khối lượng',
                      key: PredictionsLeaderboardTabletPage.volumeMetricKey,
                    ),
                  ],
                ),
              ),
              SizedBox.square(
                dimension: TabletSpacingTokens.minTapTarget,
                child: IconButton(
                  key: PredictionsLeaderboardTabletPage.infoKey,
                  onPressed: _showPnlInfo,
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
          _Sc214Podium(traders: snapshot.traders.take(3).toList()),
          VitPageSection(
            label: 'Xếp hạng',
            accentColor: AppColors.primary,
            innerGap: TabletSpacingTokens.x4,
            children: [
              VitCard(
                density: VitDensity.compact,
                child: Column(
                  children: [
                    for (final trader in snapshot.traders)
                      _Sc214TraderRow(trader: trader, metric: _metric),
                  ],
                ),
              ),
            ],
          ),
          VitPageSection(
            label: 'Thắng lớn nhất',
            accentColor: AppColors.accent,
            innerGap: TabletSpacingTokens.x4,
            children: [
              for (final trader in snapshot.biggestWins)
                VitCard(
                  key: Key('sc214_biggest_win_${trader.user}'),
                  density: VitDensity.compact,
                  child: Row(
                    children: [
                      const SizedBox.square(
                        dimension: TabletSpacingTokens.iconSm,
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: AppColors.warn,
                          size: TabletSpacingTokens.iconSm,
                        ),
                      ),
                      const SizedBox(width: TabletSpacingTokens.x2),
                      Expanded(
                        child: Text(
                          trader.user,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      Text(
                        VitFormat.usdSigned(trader.pnl),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
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
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      gutterFlush: true,
      semanticIdentifier: 'SC-214',
      semanticLabel: 'Bảng xếp hạng prediction',
      title: 'Bảng xếp hạng',
      subtitle: subtitle ?? 'Trader · Prediction',
      contentKey: PredictionsLeaderboardTabletPage.contentKey,
      backFallback: AppRoutePaths.marketsPredictions,
      children: children,
    );
  }
}

String _sc214TimeLabel(PredictionLeaderboardTimeFilter filter) {
  return switch (filter) {
    PredictionLeaderboardTimeFilter.today => 'Hôm nay',
    PredictionLeaderboardTimeFilter.weekly => 'Tuần',
    PredictionLeaderboardTimeFilter.monthly => 'Tháng',
    PredictionLeaderboardTimeFilter.allTime => 'Mọi lúc',
  };
}

class _Sc214Podium extends StatelessWidget {
  const _Sc214Podium({required this.traders});

  final List<PredictionLeaderboardTraderDraft> traders;

  @override
  Widget build(BuildContext context) {
    if (traders.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < traders.length; index += 1) ...[
          Expanded(
            child: _Sc214PodiumTile(
              trader: traders[index],
              height: switch (traders[index].rank) {
                1 => TabletSpacingTokens.x7 + TabletSpacingTokens.x5,
                2 => TabletSpacingTokens.x7,
                _ => TabletSpacingTokens.x5 + TabletSpacingTokens.x3,
              },
              medalColor: switch (traders[index].rank) {
                1 => AppColors.warn,
                2 => AppColors.medalSilverBlue,
                _ => AppColors.medalBronze,
              },
            ),
          ),
          if (index != traders.length - 1)
            const SizedBox(width: TabletSpacingTokens.x4),
        ],
      ],
    );
  }
}

class _Sc214PodiumTile extends StatelessWidget {
  const _Sc214PodiumTile({
    required this.trader,
    required this.height,
    required this.medalColor,
  });

  final PredictionLeaderboardTraderDraft trader;
  final double height;
  final Color medalColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: medalColor.withValues(alpha: .34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: TabletSpacingTokens.x5,
            child: CircleAvatar(
              backgroundColor: medalColor.withValues(alpha: .14),
              child: Text(
                trader.avatar,
                style: AppTextStyles.caption.copyWith(
                  color: medalColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            '#${trader.rank}',
            style: AppTextStyles.body.copyWith(
              color: medalColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            trader.user,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            VitFormat.usdSigned(trader.pnl),
            style: AppTextStyles.caption.copyWith(
              color: trader.pnl >= 0 ? AppColors.buy : AppColors.sell,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          SizedBox(
            height: height,
            child: ColoredBox(
              color: medalColor.withValues(alpha: .18),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc214TraderRow extends StatelessWidget {
  const _Sc214TraderRow({required this.trader, required this.metric});

  final PredictionLeaderboardTraderDraft trader;
  final PredictionLeaderboardMetric metric;

  @override
  Widget build(BuildContext context) {
    final value = metric == PredictionLeaderboardMetric.pnl
        ? VitFormat.usdSigned(trader.pnl)
        : VitFormat.compactSuffix(trader.volume, prefix: r'$');
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        children: [
          SizedBox(
            width: TabletSpacingTokens.x5,
            child: Text(
              '#${trader.rank}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x2),
          CircleAvatar(
            radius: TabletSpacingTokens.iconSm,
            backgroundColor: AppColors.surface2,
            child: Text(
              trader.avatar,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trader.user,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  '${VitFormat.count(trader.trades)} lệnh · '
                  '${VitFormat.compactSuffix(trader.volume, prefix: r'$')}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: metric == PredictionLeaderboardMetric.pnl
                      ? (trader.pnl >= 0 ? AppColors.buy : AppColors.sell)
                      : AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              if (metric == PredictionLeaderboardMetric.pnl)
                Text(
                  VitFormat.signedPercent(trader.pnlPct),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
