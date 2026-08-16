part of '../../phone/pages/social/predictions_leaderboard_page.dart';

class _RankingRow extends StatelessWidget {
  const _RankingRow({
    super.key,
    required this.trader,
    required this.metric,
    required this.last,
  });

  final PredictionLeaderboardTraderDraft trader;
  final PredictionLeaderboardMetric metric;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _boardRankRowExtent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: _boardSpace,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: _boardRankSlot,
                  child: _RankBadge(rank: trader.rank),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(trader.avatar, style: AppTextStyles.avatarMd),
                      const SizedBox(width: _boardSpace),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trader.user,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            Text(
                              '${trader.trades} trades',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: _boardMetricSlot,
                  child: Text(
                    metric == PredictionLeaderboardMetric.pnl
                        ? _formatSignedCompact(trader.pnl)
                        : _formatCurrencyCompact(trader.volume),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: metric == PredictionLeaderboardMetric.pnl
                          ? AppColors.buy
                          : AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                SizedBox(
                  width: _boardWinRateSlot,
                  child: Text(
                    '${trader.winRate}%',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: _winRateColor(trader.winRate),
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!last) const _LeaderboardDivider(),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    if (rank > 3) {
      return Text(
        '$rank',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      );
    }
    final color = rank == 1
        ? AppColors.medalGold
        : rank == 2
        ? AppColors.medalSilver
        : AppColors.medalBronze;
    return Material(
      color: color.withValues(alpha: .15),
      shape: const CircleBorder(),
      child: SizedBox.square(
        dimension: _boardBadgeExtent,
        child: Center(
          child: Text(
            '$rank',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardDivider extends StatelessWidget {
  const _LeaderboardDivider();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: AppSpacing.hairlineStroke,
        child: ColoredBox(color: AppColors.divider),
      ),
    );
  }
}

class _BiggestWins extends StatelessWidget {
  const _BiggestWins({required this.snapshot});

  final PredictionLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.biggestWins.isEmpty) return const SizedBox.shrink();
    return VitPageSection(
      label: 'Biggest Wins',
      accentColor: AppColors.buy,
      density: VitDensity.compact,
      children: [
        Text(
          'Top single-trade profits this period',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: _boardLineTight,
          ),
        ),
        for (final trader in snapshot.biggestWins)
          _BiggestWinCard(snapshot: snapshot, trader: trader),
      ],
    );
  }
}

class _BiggestWinCard extends StatelessWidget {
  const _BiggestWinCard({required this.snapshot, required this.trader});

  final PredictionLeaderboardSnapshot snapshot;
  final PredictionLeaderboardTraderDraft trader;

  @override
  Widget build(BuildContext context) {
    final event = snapshot.eventForWin(trader);
    return VitCard(
      key: PredictionsLeaderboardPage.biggestWinKey(trader.user),
      variant: VitCardVariant.inner,
      onTap: event == null
          ? null
          : () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      borderColor: AppColors.transparent,
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          const Material(
            color: AppColors.buy10,
            borderRadius: AppRadii.cardRadius,
            child: SizedBox.square(
              dimension: _boardWinTile,
              child: Icon(
                Icons.emoji_events_outlined,
                color: AppColors.buy,
                size: AppSpacing.x4,
              ),
            ),
          ),
          const SizedBox(width: _boardSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(trader.avatar, style: AppTextStyles.avatarSm),
                    const SizedBox(width: _boardTinySpace),
                    Flexible(
                      child: Text(
                        trader.user,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _boardTinySpace),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        trader.biggestWinMarket ?? 'Prediction market',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: event == null
                              ? AppColors.text3
                              : _predictionPrimary,
                        ),
                      ),
                    ),
                    if (event != null) ...[
                      const SizedBox(width: _boardTinySpace),
                      const Icon(
                        Icons.arrow_outward_rounded,
                        color: _predictionPrimary,
                        size: AppSpacing.x3,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            _formatSignedCompact(trader.biggestWin ?? 0),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

Color _winRateColor(int winRate) {
  if (winRate >= 70) return AppColors.buy;
  if (winRate >= 50) return AppColors.warn;
  return AppColors.sell;
}

String _formatSignedCompact(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatCurrencyCompact(value.abs())}';
}

String _formatCurrencyCompact(double value) =>
    VitFormat.compactSuffix(value, prefix: r'$');
