part of '../../phone/pages/social/predictions_leaderboard_page.dart';

class _Podium extends StatelessWidget {
  const _Podium({required this.traders});

  final List<PredictionLeaderboardTraderDraft> traders;

  @override
  Widget build(BuildContext context) {
    final ordered = [
      if (traders.length > 1) traders[1],
      if (traders.isNotEmpty) traders[0],
      if (traders.length > 2) traders[2],
    ];
    const colors = [
      AppColors.medalSilver,
      AppColors.medalGold,
      AppColors.medalBronze,
    ];
    const labels = ['2nd', '1st', '3rd'];

    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: SizedBox(
        height: _boardPodiumExtent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var index = 0; index < ordered.length; index += 1)
              Expanded(
                child: _PodiumColumn(
                  trader: ordered[index],
                  extent: _boardPodiumColumns[index],
                  color: colors[index],
                  label: labels[index],
                  winner: index == 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({
    required this.trader,
    required this.extent,
    required this.color,
    required this.label,
    required this.winner,
  });

  final PredictionLeaderboardTraderDraft trader;
  final double extent;
  final Color color;
  final String label;
  final bool winner;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(trader.avatar, style: AppTextStyles.avatarLg),
        const SizedBox(height: _boardTinySpace),
        Text(
          trader.user,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _boardTinySpace),
        Text(
          _formatSignedCompact(trader.pnl),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: _boardSpace),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: _boardTinySpace,
          ),
          child: Material(
            color: color.withValues(alpha: .10),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.vertical(
                top: AppRadii.inputCorner,
              ),
              side: BorderSide(color: color.withValues(alpha: .28)),
            ),
            child: SizedBox(
              height: extent,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: _boardTinySpace,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (winner) ...[
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: AppColors.medalGold,
                          size: AppSpacing.x3,
                        ),
                        const SizedBox(width: _boardTinySpace),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.caption.copyWith(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Rankings extends StatelessWidget {
  const _Rankings({required this.snapshot});

  final PredictionLeaderboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Rankings',
      accentColor: AppColors.warn,
      density: VitDensity.compact,
      children: [
        VitCard(
          density: VitDensity.compact,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              _RankingHeader(metric: snapshot.metric),
              for (var index = 0; index < snapshot.traders.length; index += 1)
                _RankingRow(
                  key: PredictionsLeaderboardPage.traderKey(
                    snapshot.traders[index].user,
                  ),
                  trader: snapshot.traders[index],
                  metric: snapshot.metric,
                  last: index == snapshot.traders.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankingHeader extends StatelessWidget {
  const _RankingHeader({required this.metric});

  final PredictionLeaderboardMetric metric;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _boardRankHeaderExtent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: _boardSpace,
            ),
            child: Row(
              children: [
                const SizedBox(width: _boardRankSlot, child: _HeaderLabel('#')),
                const Expanded(child: _HeaderLabel('TRADER')),
                SizedBox(
                  width: _boardMetricSlot,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _HeaderLabel(
                      metric == PredictionLeaderboardMetric.pnl
                          ? 'P/L'
                          : 'VOLUME',
                    ),
                  ),
                ),
                const SizedBox(
                  width: _boardWinRateSlot,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _HeaderLabel('WIN %'),
                  ),
                ),
              ],
            ),
          ),
          const _LeaderboardDivider(),
        ],
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}
