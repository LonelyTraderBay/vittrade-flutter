part of 'arena_tablet_pages.dart';

// Cụm Governance & An toàn (Đợt 3 redesign tablet Arena): SC-192 Resolution,
// SC-199 Trust, SC-203 Blocked users, SC-204 My reports, SC-202 Report case.
// Tách khỏi _play theo vai trò cụm; nội dung placeholder chờ Đợt 3.

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
