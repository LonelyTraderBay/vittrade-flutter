part of 'arena_tablet_pages.dart';

/// SC-189/190/191/193/192/199/203/205/204/202: lượt chơi + dựng.
class ArenaModeDetailTabletPage extends ConsumerWidget {
  const ArenaModeDetailTabletPage({super.key, required this.modeId});

  static const contentKey = Key('sc189_tablet_content');

  final String modeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaModeDetailSnapshotProvider(modeId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-189',
        semanticLabel: 'Chi tiết chế độ đấu',
        title: 'Chi tiết chế độ',
        subtitle: modeId,
        contentKey: ArenaModeDetailTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được chế độ',
            () => ref.invalidate(arenaModeDetailSnapshotProvider(modeId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-189',
        semanticLabel: 'Chi tiết chế độ đấu',
        title: snapshot.mode.title,
        subtitle: 'Quy tắc · Chất lượng',
        contentKey: ArenaModeDetailTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Tóm tắt quy tắc',
            rows: [
              for (final row in snapshot.ruleRows.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    row.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArenaChallengeDetailTabletPage extends ConsumerWidget {
  const ArenaChallengeDetailTabletPage({super.key, required this.challengeId});

  static const contentKey = Key('sc190_tablet_content');

  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      arenaChallengeDetailSnapshotProvider(challengeId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-190',
        semanticLabel: 'Chi tiết thử thách',
        title: 'Chi tiết thách đấu',
        subtitle: challengeId,
        contentKey: ArenaChallengeDetailTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được thách đấu',
            () => ref.invalidate(
              arenaChallengeDetailSnapshotProvider(challengeId),
            ),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-190',
        semanticLabel: 'Chi tiết thử thách',
        title: snapshot.challenge.id,
        subtitle: '${snapshot.teams.length} đội',
        contentKey: ArenaChallengeDetailTabletPage.contentKey,
        children: [
          _ardSection(title: 'Quy tắc', rows: _ardBullets(snapshot.rules)),

          _ardSection(
            title: 'Bậc thưởng',
            rows: [
              for (final tier in snapshot.rewardTiers.take(6))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    tier.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
              const SizedBox(height: TabletSpacingTokens.x2),
              _ardQuickLinks(context, [
                ('Tham gia thử thách', AppRoutePaths.arenaJoin(challengeId)),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class ArenaJoinTabletPage extends ConsumerWidget {
  const ArenaJoinTabletPage({super.key, required this.challengeId});

  static const contentKey = Key('sc191_tablet_content');

  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaJoinSnapshotProvider(challengeId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-191',
        semanticLabel: 'Vào thử thách',
        title: 'Tham gia',
        subtitle: challengeId,
        contentKey: ArenaJoinTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được thông tin tham gia',
            () => ref.invalidate(arenaJoinSnapshotProvider(challengeId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-191',
        semanticLabel: 'Vào thử thách',
        title: 'Tham gia thách đấu',
        subtitle: 'Số dư ${snapshot.currentBalance} điểm',
        contentKey: ArenaJoinTabletPage.contentKey,
        children: [
          _ardSection(title: 'Quy tắc', rows: _ardBullets(snapshot.rules)),

          _ardSection(
            title: 'Hoàn phí',
            rows: [_ardBody(snapshot.refundNotice)],
          ),
        ],
      ),
    );
  }
}

class ArenaCreatorTabletPage extends ConsumerWidget {
  const ArenaCreatorTabletPage({super.key, required this.creatorId});

  static const contentKey = Key('sc193_tablet_content');

  final String creatorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaCreatorSnapshotProvider(creatorId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-193',
        semanticLabel: 'Hồ sơ người dựng',
        title: 'Nhà tạo lập',
        subtitle: creatorId,
        contentKey: ArenaCreatorTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được hồ sơ',
            () => ref.invalidate(arenaCreatorSnapshotProvider(creatorId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-193',
        semanticLabel: 'Hồ sơ người dựng',
        title: snapshot.creator.id,
        subtitle: '${snapshot.liveRooms.length} phòng live',
        contentKey: ArenaCreatorTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Chỉ số uy tín',
            rows: [
              for (final metric in snapshot.trustMetrics.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    '${metric.label}: ${metric.value}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
              const SizedBox(height: TabletSpacingTokens.x2),
              _ardQuickLinks(context, [
                (
                  'Chi tiết uy tín',
                  AppRoutePaths.arenaTrust(snapshot.creator.id),
                ),
              ]),
            ],
          ),

          _ardSection(
            title: 'Phòng live',
            rows: [
              for (final room in snapshot.liveRooms.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      onTap: () =>
                          context.push(AppRoutePaths.arenaChallenge(room.id)),
                      child: Text(
                        room.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArenaResolutionCenterTabletPage extends ConsumerWidget {
  const ArenaResolutionCenterTabletPage({super.key});

  static const contentKey = Key('sc192_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaResolutionCenterSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-192',
        semanticLabel: 'Trung tâm trọng tài',
        title: 'Phân xử',
        subtitle: 'Khiếu nại',
        contentKey: ArenaResolutionCenterTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được trung tâm phân xử',
            () => ref.invalidate(arenaResolutionCenterSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-192',
        semanticLabel: 'Trung tâm trọng tài',
        title: 'Trung tâm phân xử',
        subtitle: snapshot.emptyTitle,
        contentKey: ArenaResolutionCenterTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Trạng thái',
            rows: [_ardBody(snapshot.emptySubtitle)],
          ),
        ],
      ),
    );
  }
}

class ArenaTrustBreakdownTabletPage extends ConsumerWidget {
  const ArenaTrustBreakdownTabletPage({super.key, required this.userId});

  static const contentKey = Key('sc199_tablet_content');

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      arenaTrustBreakdownSnapshotProvider(userId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-199',
        semanticLabel: 'Độ tin cậy người chơi',
        title: 'Độ tin cậy',
        subtitle: userId,
        contentKey: ArenaTrustBreakdownTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được độ tin cậy',
            () => ref.invalidate(arenaTrustBreakdownSnapshotProvider(userId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-199',
        semanticLabel: 'Độ tin cậy người chơi',
        title: snapshot.safetyTitle,
        subtitle: snapshot.entityId,
        contentKey: ArenaTrustBreakdownTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Chỉ số',
            rows: [
              for (final metric in snapshot.metrics.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    '${metric.label}: ${metric.value}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArenaBlockedUsersTabletPage extends ConsumerWidget {
  const ArenaBlockedUsersTabletPage({super.key});

  static const contentKey = Key('sc203_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaBlockedUsersSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-203',
        semanticLabel: 'Danh sách chặn',
        title: 'Người bị chặn',
        subtitle: 'Chặn · Mở chặn',
        contentKey: ArenaBlockedUsersTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được danh sách chặn',
            () => ref.invalidate(arenaBlockedUsersSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-203',
        semanticLabel: 'Danh sách chặn',
        title: snapshot.bannerTitle,
        subtitle: '${snapshot.users.length} người',
        contentKey: ArenaBlockedUsersTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Danh sách',
            rows: [
              for (final user in snapshot.users.take(10))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    user.id,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyArenaReportsTabletPage extends ConsumerWidget {
  const MyArenaReportsTabletPage({super.key});

  static const contentKey = Key('sc204_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(myArenaReportsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-204',
        semanticLabel: 'Báo cáo đã gửi',
        title: 'Báo cáo của tôi',
        subtitle: 'Trạng thái',
        contentKey: MyArenaReportsTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được báo cáo',
            () => ref.invalidate(myArenaReportsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-204',
        semanticLabel: 'Báo cáo đã gửi',
        title: snapshot.bannerTitle,
        subtitle: snapshot.bannerDescription,
        contentKey: MyArenaReportsTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Báo cáo',
            rows: [
              for (final report in snapshot.reports.take(10))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      onTap: () => context.push(
                        AppRoutePaths.arenaReportCase(report.id),
                      ),
                      child: Text(
                        report.id,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArenaReportCaseTabletPage extends ConsumerWidget {
  const ArenaReportCaseTabletPage({super.key, required this.caseId});

  static const contentKey = Key('sc202_tablet_content');

  final String caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaReportCaseSnapshotProvider(caseId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-202',
        semanticLabel: 'Hồ sơ tố cáo',
        title: 'Hồ sơ báo cáo',
        subtitle: caseId,
        contentKey: ArenaReportCaseTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được hồ sơ',
            () => ref.invalidate(arenaReportCaseSnapshotProvider(caseId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-202',
        semanticLabel: 'Hồ sơ tố cáo',
        title: 'Hồ sơ báo cáo',
        subtitle: snapshot.caseId,
        contentKey: ArenaReportCaseTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Hồ sơ liên quan',
            rows: [
              for (final report in snapshot.relatedReports.take(6))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      onTap: () => context.push(
                        AppRoutePaths.arenaReportCase(report.id),
                      ),
                      child: Text(
                        report.id,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
