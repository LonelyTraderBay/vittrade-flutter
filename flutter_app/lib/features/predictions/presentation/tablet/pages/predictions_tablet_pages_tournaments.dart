part of 'predictions_tablet_pages.dart';

// ---------------------------------------------------------------------------
// SC-222: Giải đấu prediction — tab Đang diễn ra / Đã kết thúc + khối nổi
// bật + thẻ giải đấu, state cục bộ như phone SC-042.
// ---------------------------------------------------------------------------

class PredictionTournamentsTabletPage extends ConsumerStatefulWidget {
  const PredictionTournamentsTabletPage({super.key});

  static const contentKey = Key('sc222_tablet_content');
  static const activeTabKey = Key('sc222_tab_active');
  static const endedTabKey = Key('sc222_tab_ended');

  static Key tournamentKey(String id) => Key('sc222_tournament_$id');

  @override
  ConsumerState<PredictionTournamentsTabletPage> createState() =>
      _PredictionTournamentsTabletPageState();
}

enum _Sc222Tab { active, ended }

class _PredictionTournamentsTabletPageState
    extends ConsumerState<PredictionTournamentsTabletPage> {
  _Sc222Tab _activeTab = _Sc222Tab.active;

  @override
  Widget build(BuildContext context) {
    final tournamentsAsync = ref.watch(predictionsTournamentsSnapshotProvider);

    return tournamentsAsync.when(
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          _pdmError(
            'Không tải được giải đấu',
            () => ref.invalidate(predictionsTournamentsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final tournaments = _activeTab == _Sc222Tab.active
            ? snapshot.activeTournaments
            : snapshot.tournaments
                  .where(
                    (tournament) => tournament.status == TournamentStatus.ended,
                  )
                  .toList();
        final featured = snapshot.activeTournaments
            .where((tournament) => tournament.featured)
            .toList();
        return _frame(
          subtitle: '${snapshot.activeTournaments.length} giải đang diễn ra',
          children: [
            VitTabBar(
              variant: VitTabBarVariant.segment,
              activeKey: _activeTab == _Sc222Tab.active ? 'active' : 'ended',
              onChanged: (key) => setState(() {
                _activeTab = _Sc222Tab.values.byName(key);
              }),
              tabs: const [
                VitTabItem(
                  key: 'active',
                  label: 'Đang diễn ra',
                  widgetKey: PredictionTournamentsTabletPage.activeTabKey,
                ),
                VitTabItem(
                  key: 'ended',
                  label: 'Đã kết thúc',
                  widgetKey: PredictionTournamentsTabletPage.endedTabKey,
                ),
              ],
            ),
            if (_activeTab == _Sc222Tab.active)
              for (final tournament in featured)
                _Sc222FeaturedBlock(tournament: tournament),
            if (tournaments.isEmpty)
              const VitEmptyState(
                title: 'Chưa có giải đấu',
                message: 'Giải đấu mới sẽ xuất hiện ở đây',
                icon: Icons.emoji_events_outlined,
              )
            else
              for (final tournament in tournaments)
                _Sc222TournamentCard(tournament: tournament),
            VitPageSection(
              label: 'Thống kê nhanh',
              accentColor: AppColors.accent,
              innerGap: TabletSpacingTokens.x4,
              children: [
                VitCard(
                  density: VitDensity.compact,
                  child: Row(
                    children: [
                      Expanded(
                        child: _Sc222Stat(
                          label: 'Tổng giải',
                          value: VitFormat.count(snapshot.tournaments.length),
                        ),
                      ),
                      Expanded(
                        child: _Sc222Stat(
                          label: 'Đang diễn ra',
                          value: VitFormat.count(
                            snapshot.activeTournaments.length,
                          ),
                          valueColor: AppColors.buy,
                        ),
                      ),
                      Expanded(
                        child: _Sc222Stat(
                          label: 'Tổng người tham gia',
                          value: VitFormat.count(
                            snapshot.tournaments.fold(
                              0,
                              (sum, tournament) =>
                                  sum + tournament.participants,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-222',
      semanticLabel: 'Giải đấu prediction',
      title: 'Giải đấu',
      subtitle: subtitle ?? 'Giải đấu · Prediction',
      contentKey: PredictionTournamentsTabletPage.contentKey,
      backFallback: AppRoutePaths.marketsPredictions,
      children: children,
    );
  }
}

class _Sc222Stat extends StatelessWidget {
  const _Sc222Stat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _Sc222FeaturedBlock extends StatelessWidget {
  const _Sc222FeaturedBlock({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionTournamentsTabletPage.tournamentKey(tournament.id),
      onTap: () => context.push(
        AppRoutePaths.marketsPredictionTournament(tournament.id),
      ),
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: TabletSpacingTokens.cardPaddingHero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: TabletSpacingTokens.x2,
            runSpacing: TabletSpacingTokens.x1,
            children: [
              _pdmTinyBadge(
                label: 'Nổi bật',
                color: AppColors.warn,
                background: AppColors.warn10,
              ),
              _pdmTinyBadge(
                label: tournament.category,
                color: AppColors.primary,
                background: AppColors.primary.withValues(alpha: .12),
              ),
              if (tournament.isJoined) const _Sc222JoinedBadge(),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Text(
            tournament.name,
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            tournament.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          _Sc222TournamentMeta(tournament: tournament),
        ],
      ),
    );
  }
}

class _Sc222JoinedBadge extends StatelessWidget {
  const _Sc222JoinedBadge();

  @override
  Widget build(BuildContext context) {
    return _pdmTinyBadge(
      label: 'Đã tham gia',
      color: AppColors.buy,
      background: AppColors.buy10,
    );
  }
}

class _Sc222TournamentCard extends StatelessWidget {
  const _Sc222TournamentCard({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionTournamentsTabletPage.tournamentKey(tournament.id),
      onTap: () => context.push(
        AppRoutePaths.marketsPredictionTournament(tournament.id),
      ),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tournament.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _pdmTinyBadge(
                label: switch (tournament.status) {
                  TournamentStatus.upcoming => 'Sắp mở',
                  TournamentStatus.active => 'Đang diễn ra',
                  TournamentStatus.ended => 'Đã kết thúc',
                },
                color: switch (tournament.status) {
                  TournamentStatus.active => AppColors.buy,
                  TournamentStatus.upcoming => AppColors.text3,
                  TournamentStatus.ended => AppColors.text3,
                },
                background: switch (tournament.status) {
                  TournamentStatus.active => AppColors.buy10,
                  TournamentStatus.upcoming => AppColors.surface2,
                  TournamentStatus.ended => AppColors.surface2,
                },
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            '${tournament.participants}/${tournament.maxParticipants} người · '
            'phí vào ${VitFormat.usd(tournament.entryFee.toDouble())} · '
            '${tournament.timeLabel}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          _Sc222TournamentMeta(tournament: tournament),
        ],
      ),
    );
  }
}

class _Sc222TournamentMeta extends StatelessWidget {
  const _Sc222TournamentMeta({required this.tournament});

  final PredictionTournamentDraft tournament;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Sc222Stat(
            label: 'Giải thưởng',
            value: VitFormat.usd(tournament.prizePool.toDouble()),
            valueColor: AppColors.warn,
          ),
        ),
        Expanded(
          child: _Sc222Stat(
            label: 'Xếp hạng của tôi',
            value: tournament.myRank == null ? '—' : '#${tournament.myRank}',
          ),
        ),
        Expanded(
          child: _Sc222Stat(
            label: 'Điểm của tôi',
            value: tournament.myScore == null
                ? '—'
                : VitFormat.count(tournament.myScore!),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// SC-223: Chi tiết giải đấu prediction — hero giải đấu + bảng xếp hạng +
// nút tham gia (coming-soon sheet), như phone.
// ---------------------------------------------------------------------------

class PredictionTournamentDetailTabletPage extends ConsumerWidget {
  const PredictionTournamentDetailTabletPage({
    super.key,
    required this.tournamentId,
  });

  static const contentKey = Key('sc223_tablet_content');
  static const joinKey = Key('sc223_join');

  final String tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(predictionsTournamentsSnapshotProvider);

    return tournamentsAsync.when(
      loading: () => const VitTabletSectionFrame(
        semanticIdentifier: 'SC-223',
        semanticLabel: 'Chi tiết giải đấu prediction',
        title: 'Chi tiết giải đấu',
        children: [VitSkeletonList(rows: 6)],
      ),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-223',
        semanticLabel: 'Chi tiết giải đấu prediction',
        title: 'Chi tiết giải đấu',
        children: [
          _pdmError(
            'Không tải được giải đấu',
            () => ref.invalidate(predictionsTournamentsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final tournament = snapshot.tournaments.firstWhere(
          (item) => item.id == tournamentId,
          orElse: () => snapshot.tournaments.first,
        );
        return VitTabletSectionFrame(
          semanticIdentifier: 'SC-223',
          semanticLabel: 'Chi tiết giải đấu prediction',
          title: tournament.name,
          subtitle: tournament.category,
          contentKey: PredictionTournamentDetailTabletPage.contentKey,
          backFallback: AppRoutePaths.marketsPredictionsTournaments,
          children: [
            VitCard(
              variant: VitCardVariant.hero,
              radius: VitCardRadius.large,
              padding: TabletSpacingTokens.cardPaddingHero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x3),
                  _Sc222TournamentMeta(tournament: tournament),
                ],
              ),
            ),
            VitPageSection(
              label: 'Bảng xếp hạng giải đấu',
              accentColor: AppColors.primary,
              innerGap: TabletSpacingTokens.x4,
              children: [
                VitCard(
                  density: VitDensity.compact,
                  child: Column(
                    children: [
                      for (final entry in snapshot.leaderboard)
                        Padding(
                          padding: TabletSpacingTokens.tableCellPaddingV,
                          child: Row(
                            children: [
                              SizedBox(
                                width: TabletSpacingTokens.x5,
                                child: Text(
                                  '#${entry.rank}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: entry.rank == 1
                                        ? AppColors.warn
                                        : AppColors.text3,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: TabletSpacingTokens.x2),
                              Expanded(
                                child: Text(
                                  entry.name,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '${VitFormat.count(entry.score)} điểm · '
                                '${VitFormat.usd(entry.prize.toDouble())}',
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
                ),
              ],
            ),
            if (tournament.status == TournamentStatus.active)
              VitCtaButton(
                key: PredictionTournamentDetailTabletPage.joinKey,
                onPressed: () {
                  unawaited(
                    showVitNoticeSheet(
                      context: context,
                      title: 'Sắp ra mắt',
                      message: 'Tham gia giải đấu sẽ sớm ra mắt.',
                    ),
                  );
                },
                child: const Text('Tham gia giải đấu'),
              ),
          ],
        );
      },
    );
  }
}
