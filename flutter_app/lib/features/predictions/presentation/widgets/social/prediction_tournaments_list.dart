part of '../../phone/pages/social/prediction_tournaments_page.dart';

class _TournamentTabBar extends StatelessWidget {
  const _TournamentTabBar({required this.activeTab, required this.onChanged});

  final _TournamentTab activeTab;
  final ValueChanged<_TournamentTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return PredictionEnumTabBar<_TournamentTab>(
      activeTab: activeTab,
      onChanged: onChanged,
      items: const [
        (
          PredictionTournamentsPage.activeTabKey,
          _TournamentTab.active,
          'Dang dien ra',
        ),
        (PredictionTournamentsPage.mineTabKey, _TournamentTab.mine, 'Cua toi'),
        (
          PredictionTournamentsPage.endedTabKey,
          _TournamentTab.ended,
          'Ket thuc',
        ),
      ],
    );
  }
}

class _FeaturedTournamentBlock extends StatelessWidget {
  const _FeaturedTournamentBlock({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.bolt_rounded,
              size: PredictionsSpacingTokens.predictionTournamentFeaturedIcon,
              color: AppColors.warn,
            ),
            const SizedBox(
              width:
                  PredictionsSpacingTokens.predictionTournamentFeaturedIconGap,
            ),
            Text(
              'Featured',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _TournamentCard(tournament: tournament),
      ],
    );
  }
}

class _TournamentSection extends StatelessWidget {
  const _TournamentSection({
    required this.label,
    required this.tournaments,
    this.empty,
  });

  final String label;
  final List<PredictionTournamentDraft> tournaments;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: label,
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        if (tournaments.isEmpty)
          empty ?? const SizedBox.shrink()
        else
          for (final tournament in tournaments)
            _TournamentCard(tournament: tournament),
      ],
    );
  }
}

class _TournamentCard extends StatelessWidget {
  const _TournamentCard({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(tournament.status);
    final isFeatured = tournament.featured;

    return VitCard(
      key: PredictionTournamentsPage.tournamentKey(tournament.id),
      padding: AppSpacing.zeroInsets,
      borderColor: isFeatured
          ? _predictionPrimary.withValues(alpha: .32)
          : AppColors.border,
      onTap: () =>
          context.go(AppRoutePaths.marketsPredictionTournament(tournament.id)),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x3,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isFeatured) ...[
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warn,
                              size: PredictionsSpacingTokens
                                  .predictionTournamentTitleIcon,
                            ),
                            const SizedBox(
                              width: PredictionsSpacingTokens
                                  .predictionTournamentTitleIconGap,
                            ),
                          ],
                          Expanded(
                            child: Text(
                              tournament.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        tournament.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: PredictionsSpacingTokens.predictionTournamentStatusGap,
                ),
                _StatusPill(status: tournament.status, color: statusColor),
              ],
            ),
            if (tournament.isJoined && tournament.myRank != null) ...[
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Material(
                color: AppColors.buy.withValues(alpha: .08),
                borderRadius: AppRadii.cardRadius,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Your rank',
                          style: AppTextStyles.numericMicro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      Text(
                        '#${tournament.myRank} - ${tournament.myScore} pts',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _TournamentStatsGrid(tournament: tournament),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            const Divider(color: AppColors.border, height: AppSpacing.x2),
            const SizedBox(height: AppSpacing.x1),
            Row(
              children: [
                _CategoryTag(label: tournament.category),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    tournament.isJoined ? 'Joined' : 'View Details',
                    textAlign: TextAlign.end,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: tournament.isJoined
                          ? AppColors.buy
                          : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width:
                      PredictionsSpacingTokens.predictionTournamentChevronGap,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: PredictionsSpacingTokens.predictionTournamentChevron,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
