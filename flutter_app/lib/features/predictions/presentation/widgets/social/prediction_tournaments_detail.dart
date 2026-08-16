part of '../../phone/pages/social/prediction_tournaments_page.dart';

class PredictionTournamentDetailPage extends ConsumerWidget {
  const PredictionTournamentDetailPage({
    super.key,
    required this.tournamentId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc414_tournament_detail_content');
  static const missingKey = Key('sc414_tournament_detail_missing');

  final String tournamentId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(predictionsTournamentsSnapshotProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final footerPadding =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    // GD4-F5 (mục 5, biến thể 2): tiêu đề header = tên giải đấu, suy ra từ
    // snapshot chứ không phải chỉ từ tham số trang — bọc TOÀN BỘ scaffold
    // trong `.when()`, mỗi nhánh dựng header fallback hợp lý riêng.
    return tournamentsAsync.when(
      loading: () => const _TournamentDetailScaffold(
        title: 'Tournament',
        child: VitSkeletonList(),
      ),
      error: (error, stackTrace) => _TournamentDetailScaffold(
        title: 'Tournament',
        child: VitErrorState(
          title: 'Không tải được giải đấu',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () =>
              ref.invalidate(predictionsTournamentsSnapshotProvider),
        ),
      ),
      data: (snapshot) {
        final tournament = _findTournament(snapshot.tournaments, tournamentId);
        return _TournamentDetailScaffold(
          title: tournament?.name ?? 'Tournament',
          child: SingleChildScrollView(
            key: contentKey,
            physics: const ClampingScrollPhysics(),
            padding: PredictionsSpacingTokens.predictionTournamentScrollPadding(
              footerPadding,
            ),
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              density: VitDensity.compact,
              children: [
                if (tournament == null)
                  const _EmptyStateCard(
                    key: missingKey,
                    icon: Icons.emoji_events_outlined,
                    title: 'Tournament not found',
                    message: 'Return to the tournament list to continue.',
                  )
                else ...[
                  _TournamentDetailHero(tournament: tournament),
                  _TournamentStatsGrid(tournament: tournament),
                  const _TournamentInfoCard(),
                  if (tournament.isJoined)
                    _FinalLeaderboard(entries: snapshot.leaderboard),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TournamentDetailScaffold extends StatelessWidget {
  const _TournamentDetailScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết giải đấu dự đoán',
      semanticIdentifier: 'SC-414',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.marketsPredictionsTournaments),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Expanded(child: child)],
          ),
        ),
      ),
    );
  }
}

PredictionTournamentDraft? _findTournament(
  List<PredictionTournamentDraft> tournaments,
  String tournamentId,
) {
  for (final tournament in tournaments) {
    if (tournament.id == tournamentId) return tournament;
  }
  return null;
}

class _TournamentDetailHero extends StatelessWidget {
  const _TournamentDetailHero({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _predictionPrimary.withValues(alpha: .28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusPill(
                status: tournament.status,
                color: _statusColor(tournament.status),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _CategoryTag(label: tournament.category),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            tournament.name,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            tournament.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          if (tournament.isJoined && tournament.myRank != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            VitAnnouncementBanner(
              message:
                  'Hạng #${tournament.myRank} · ${tournament.myScore} điểm — '
                  'P/L và vị thế tách biệt khỏi Arena Points.',
              icon: Icons.emoji_events_outlined,
              accentColor: AppColors.buy,
              variant: VitAnnouncementBannerVariant.compact,
            ),
          ],
        ],
      ),
    );
  }
}
