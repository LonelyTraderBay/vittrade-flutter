part of '../../phone/pages/social/prediction_tournaments_page.dart';

class _TournamentStatsGrid extends StatelessWidget {
  const _TournamentStatsGrid({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: PredictionsSpacingTokens.predictionTournamentStatsColumns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing:
          PredictionsSpacingTokens.predictionTournamentStatsMainGap,
      crossAxisSpacing:
          PredictionsSpacingTokens.predictionTournamentStatsCrossGap,
      childAspectRatio:
          PredictionsSpacingTokens.predictionTournamentStatsAspect,
      children: [
        _StatCell(
          icon: Icons.attach_money_rounded,
          label: 'Prize Pool',
          value: _formatMoney(tournament.prizePool),
          valueColor: AppColors.buy,
        ),
        _StatCell(
          icon: Icons.groups_2_outlined,
          label: 'Participants',
          value: '${tournament.participants}/${tournament.maxParticipants}',
        ),
        _StatCell(
          icon: Icons.schedule_rounded,
          label: 'Duration',
          value: tournament.timeLabel,
        ),
        _StatCell(
          icon: Icons.track_changes_rounded,
          label: 'Entry Fee',
          value: tournament.entryFee == 0 ? 'Free' : '\$${tournament.entryFee}',
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.text3,
              size: PredictionsSpacingTokens.predictionTournamentStatIcon,
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionTournamentStatIconGap,
            ),
            Text(
              label,
              style: AppTextStyles.numericMicro.copyWith(
                color: AppColors.text3,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Center(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.control.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.color});

  final TournamentStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionTournamentPillPadding,
        child: Text(
          _statusLabel(status),
          style: AppTextStyles.numericMicro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionTournamentPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }
}

class _TournamentInfoCard extends StatelessWidget {
  const _TournamentInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: _predictionPrimary.withValues(alpha: .18),
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: PredictionsSpacingTokens.predictionTournamentInfoIcon,
          ),
          const SizedBox(
            width: PredictionsSpacingTokens.predictionTournamentInfoGap,
          ),
          Expanded(
            child: Text(
              'Tournaments are skill-based competitions. Prizes distributed based on prediction accuracy. Read rules carefully before joining.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyTournamentStats extends StatelessWidget {
  const _MyTournamentStats({required this.snapshot});

  final PredictionTournamentsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final bestRank = snapshot.myTournaments
        .map((item) => item.myRank ?? 999)
        .reduce((a, b) => a < b ? a : b);
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tournament Stats',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _CenteredMetric(
                  label: 'Joined',
                  value: '${snapshot.myTournaments.length}',
                ),
              ),
              Expanded(
                child: _CenteredMetric(
                  label: 'Best Rank',
                  value: '#$bestRank',
                  color: AppColors.buy,
                ),
              ),
              const Expanded(
                child: _CenteredMetric(
                  label: 'Total Prizes',
                  value: '\$2,400',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CenteredMetric extends StatelessWidget {
  const _CenteredMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(value, style: AppTextStyles.sectionTitle.copyWith(color: color)),
      ],
    );
  }
}
