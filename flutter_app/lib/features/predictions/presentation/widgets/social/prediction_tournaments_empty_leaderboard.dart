part of '../../phone/pages/social/prediction_tournaments_page.dart';

class _EmptyTournamentsCard extends StatelessWidget {
  const _EmptyTournamentsCard();

  @override
  Widget build(BuildContext context) {
    return const _EmptyStateCard(
      icon: Icons.emoji_events_outlined,
      title: 'Chua tham gia giai dau nao',
      message: 'Xem tab "Dang dien ra" de tham gia',
    );
  }
}

class _NoPastTournamentsCard extends StatelessWidget {
  const _NoPastTournamentsCard();

  @override
  Widget build(BuildContext context) {
    return const _EmptyStateCard(
      icon: Icons.calendar_today_outlined,
      title: 'Chua co giai dau ket thuc',
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.text3,
            size: PredictionsSpacingTokens.predictionTournamentEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.x1),
            Text(
              message!,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}

class _FinalLeaderboard extends StatelessWidget {
  const _FinalLeaderboard({required this.entries});

  final List<PredictionTournamentLeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Final Leaderboard - Macro Economics Pro',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        for (final entry in entries) _LeaderboardEntryCard(entry: entry),
      ],
    );
  }
}

class _LeaderboardEntryCard extends StatelessWidget {
  const _LeaderboardEntryCard({required this.entry});

  final PredictionTournamentLeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final ranked = entry.rank <= 3;
    return VitCard(
      variant: ranked ? VitCardVariant.inner : VitCardVariant.standard,
      borderColor: ranked
          ? AppColors.buy.withValues(alpha: .18)
          : AppColors.border,
      density: VitDensity.compact,
      child: Row(
        children: [
          SizedBox(
            width: PredictionsSpacingTokens
                .predictionTournamentLeaderboardRankWidth,
            child: Icon(
              entry.rank == 1
                  ? Icons.emoji_events_rounded
                  : ranked
                  ? Icons.workspace_premium_rounded
                  : Icons.tag_rounded,
              color: _rankColor(entry.rank),
              size: entry.rank == 1
                  ? PredictionsSpacingTokens
                        .predictionTournamentLeaderboardWinnerIcon
                  : PredictionsSpacingTokens
                        .predictionTournamentLeaderboardIcon,
            ),
          ),
          const SizedBox(
            width: PredictionsSpacingTokens.predictionTournamentLeaderboardGap,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${entry.score} points',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            _formatMoney(entry.prize),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(TournamentStatus status) {
  return switch (status) {
    TournamentStatus.active => AppColors.buy,
    TournamentStatus.upcoming => AppColors.warn,
    TournamentStatus.ended => AppColors.text3,
  };
}

String _statusLabel(TournamentStatus status) {
  return switch (status) {
    TournamentStatus.active => 'ACTIVE',
    TournamentStatus.upcoming => 'UPCOMING',
    TournamentStatus.ended => 'ENDED',
  };
}

Color _rankColor(int rank) {
  return switch (rank) {
    1 => AppColors.warn,
    2 => AppColors.medalSilverMuted,
    3 => AppColors.medalBronzeMuted,
    _ => AppColors.text2,
  };
}

String _formatMoney(int value) => VitFormat.usdWhole(value);
