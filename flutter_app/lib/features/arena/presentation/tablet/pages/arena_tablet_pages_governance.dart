part of 'arena_tablet_pages.dart';

// Cụm Governance & An toàn (Đợt 3 redesign tablet Arena 2026-09-19):
// SC-192 Resolution, SC-199 Trust, SC-203 Blocked users, SC-204 My reports,
// SC-202 Report case, SC-198 Safety center (dời từ _points theo vai trò).

// ---------------------------------------------------------------------------
// Helper dùng chung cụm governance.

String _govReportStatusLabel(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => 'Đã gửi',
    ArenaReportCaseStatus.underReview => 'Đang xem xét',
    ArenaReportCaseStatus.actionTaken => 'Đã xử lý',
    ArenaReportCaseStatus.closed => 'Đã đóng',
    ArenaReportCaseStatus.appealOpen => 'Đang kháng cáo',
  };
}

VitStatusPillStatus _govReportStatusPill(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => VitStatusPillStatus.info,
    ArenaReportCaseStatus.underReview => VitStatusPillStatus.warning,
    ArenaReportCaseStatus.actionTaken => VitStatusPillStatus.success,
    ArenaReportCaseStatus.closed => VitStatusPillStatus.neutral,
    ArenaReportCaseStatus.appealOpen => VitStatusPillStatus.purple,
  };
}

String _govBlockedSourceLabel(ArenaBlockedUserSource source) {
  return switch (source) {
    ArenaBlockedUserSource.manual => 'Chặn thủ công',
    ArenaBlockedUserSource.reportOutcome => 'Kết quả báo cáo',
    ArenaBlockedUserSource.system => 'Hệ thống',
  };
}

IconData _govSafetyKindIcon(ArenaSafetyKind kind) {
  return switch (kind) {
    ArenaSafetyKind.respect => Icons.handshake_outlined,
    ArenaSafetyKind.offPlatform => Icons.link_off_outlined,
    ArenaSafetyKind.civil => Icons.forum_outlined,
    ArenaSafetyKind.privacy => Icons.privacy_tip_outlined,
    ArenaSafetyKind.report => Icons.flag_outlined,
    ArenaSafetyKind.block => Icons.block_outlined,
    ArenaSafetyKind.process => Icons.account_tree_outlined,
    ArenaSafetyKind.resolution => Icons.gavel_outlined,
    ArenaSafetyKind.points => Icons.stars_outlined,
  };
}

// ---------------------------------------------------------------------------
// SC-192: Trung tâm phân xử.

class ArenaResolutionCenterTabletPage extends ConsumerWidget {
  const ArenaResolutionCenterTabletPage({super.key});

  static const contentKey = Key('sc192_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaResolutionCenterSnapshotProvider);
    final showBack = context.canPop();

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
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticIdentifier: 'SC-192',
        semanticLabel: 'Trung tâm trọng tài',
        child: Column(
          children: [
            VitHeader(
              title: 'Trung tâm phân xử',
              subtitle: 'Khiếu nại · Trọng tài · Fair play',
              showBack: showBack,
              onBack: showBack
                  ? () => goBackOrFallback(
                      context,
                      fallbackPath: AppRoutePaths.arena,
                      mode: BackNavigationMode.historyThenFallback,
                    )
                  : null,
            ),
            Expanded(
              child: VitTabletPaneWorkspace(
                contentKey: ArenaResolutionCenterTabletPage.contentKey,
                primaryChildren: [
                  VitModuleHeroCard(
                    accentColor: AppModuleAccents.arena,
                    density: VitDensity.compact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          snapshot.emptyTitle,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: AppTextStyles.heavy,
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          snapshot.emptySubtitle,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _PlayRuleList(
                    rules: [
                      'Gửi khiếu nại kèm bằng chứng từ trang thử thách hoặc hồ sơ người chơi.',
                      'Trọng tài Arena xem xét luật, tiến độ hoàn thành và fair play.',
                      'Kết quả phân xử ghi vào hồ sơ; hai bên đều xem được lý do.',
                      'Không đồng ý với kết quả: mở kháng cáo trong hồ sơ báo cáo.',
                    ],
                  ),
                ],
                secondaryChildren: [
                  const _PlayInfoCard(
                    title: 'Việc của bạn',
                    icon: Icons.assignment_outlined,
                    rows: [
                      _PlayInfoRow(
                        label: 'Hồ sơ đã gửi',
                        value: 'Xem trong Báo cáo của tôi',
                      ),
                      _PlayInfoRow(
                        label: 'Phạm vi',
                        value: 'Luật · hoàn thành · fair play · Điểm Arena',
                      ),
                    ],
                  ),
                  VitCtaButton(
                    onPressed: () => context.push(AppRoutePaths.arenaMyReports),
                    child: const Text('Báo cáo của tôi'),
                  ),
                  _ardQuickLinks(context, [
                    ('Trung tâm an toàn', AppRoutePaths.arenaSafety),
                    ('Sổ điểm Arena', AppRoutePaths.arenaLedger),
                  ]),
                ],
                narrowChildren: [
                  VitModuleHeroCard(
                    accentColor: AppModuleAccents.arena,
                    density: VitDensity.compact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          snapshot.emptyTitle,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: AppTextStyles.heavy,
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          snapshot.emptySubtitle,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VitCtaButton(
                    onPressed: () => context.push(AppRoutePaths.arenaMyReports),
                    child: const Text('Báo cáo của tôi'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SC-199: Độ tin cậy người chơi / người dựng.

class ArenaTrustBreakdownTabletPage extends ConsumerWidget {
  const ArenaTrustBreakdownTabletPage({super.key, required this.userId});

  static const contentKey = Key('sc199_tablet_content');

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      arenaTrustBreakdownSnapshotProvider(userId),
    );
    final showBack = context.canPop();

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
      data: (snapshot) {
        final creator = snapshot.creator;
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-199',
          semanticLabel: 'Độ tin cậy người chơi',
          child: Column(
            children: [
              VitHeader(
                title: 'Độ tin cậy',
                subtitle: switch (creator) {
                  ArenaCreatorProfileDraft(:final name) => name,
                  null => snapshot.entityId,
                },
                showBack: showBack,
                onBack: showBack
                    ? () => goBackOrFallback(
                        context,
                        fallbackPath: AppRoutePaths.arena,
                        mode: BackNavigationMode.historyThenFallback,
                      )
                    : null,
              ),
              Expanded(
                child: VitTabletPaneWorkspace(
                  contentKey: ArenaTrustBreakdownTabletPage.contentKey,
                  primaryChildren: [
                    if (creator != null)
                      VitModuleHeroCard(
                        accentColor: AppModuleAccents.arena,
                        density: VitDensity.compact,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    switch (creator) {
                                      ArenaCreatorProfileDraft(:final name) =>
                                        name,
                                    },
                                    style: AppTextStyles.sectionTitle.copyWith(
                                      fontWeight: AppTextStyles.heavy,
                                      color: AppColors.text1,
                                    ),
                                  ),
                                ),
                                if (creator.fairPlayBadge)
                                  const VitStatusPill(
                                    label: 'Fair play',
                                    status: VitStatusPillStatus.success,
                                    size: VitStatusPillSize.sm,
                                  ),
                              ],
                            ),
                            if (creator.bio.isNotEmpty) ...[
                              const SizedBox(height: TabletSpacingTokens.x2),
                              Text(
                                creator.bio,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                            const SizedBox(height: TabletSpacingTokens.x4),
                            Row(
                              children: [
                                Expanded(
                                  child: _ArenaHeroKpi(
                                    label: 'Điểm uy tín',
                                    value: '${creator.trustScore}',
                                  ),
                                ),
                                const SizedBox(
                                  width: TabletSpacingTokens.x4,
                                  height: TabletSpacingTokens.x6,
                                  child: ColoredBox(color: AppColors.border),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      start: TabletSpacingTokens.x4,
                                    ),
                                    child: _ArenaHeroKpi(
                                      label: 'Phòng hoàn thành',
                                      value: '${creator.completedRooms}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      VitModuleHeroCard(
                        accentColor: AppModuleAccents.arena,
                        density: VitDensity.compact,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              snapshot.emptyTitle,
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontWeight: AppTextStyles.heavy,
                                color: AppColors.text1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (snapshot.metrics.isNotEmpty)
                      _PlayListSection(
                        title: 'Chỉ số độ tin cậy',
                        itemCount: snapshot.metrics.length,
                        itemBuilder: (context, i) {
                          final metric = snapshot.metrics[i];
                          return ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.insights_outlined,
                              color: AppModuleAccents.arena,
                            ),
                            title: Text(
                              metric.label,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            trailing: Text(
                              metric.value,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                  secondaryChildren: [
                    _PlayInfoCard(
                      title: 'Đối chiếu',
                      icon: Icons.fact_check_outlined,
                      rows: [
                        _PlayInfoRow(
                          label: 'Định danh',
                          value: snapshot.entityId,
                        ),
                        _PlayInfoRow(
                          label: 'Số chỉ số',
                          value: '${snapshot.metrics.length}',
                        ),
                      ],
                    ),
                    VitCtaButton(
                      onPressed: () => context.push(AppRoutePaths.arenaSafety),
                      child: const Text('Báo cáo vi phạm'),
                    ),
                    if (creator != null)
                      VitCtaButton(
                        variant: VitCtaButtonVariant.secondary,
                        onPressed: () => context.push(
                          AppRoutePaths.arenaCreator(creator.id),
                        ),
                        child: const Text('Xem hồ sơ người dựng'),
                      ),
                  ],
                  narrowChildren: [
                    if (snapshot.metrics.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Chỉ số độ tin cậy',
                        rows: [
                          for (final metric in snapshot.metrics)
                            _PlayInfoRow(
                              label: metric.label,
                              value: metric.value,
                            ),
                        ],
                      ),
                    VitCtaButton(
                      onPressed: () => context.push(AppRoutePaths.arenaSafety),
                      child: const Text('Báo cáo vi phạm'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// SC-203: Người đã chặn — mở chặn thật qua state controller.

class ArenaBlockedUsersTabletPage extends ConsumerWidget {
  const ArenaBlockedUsersTabletPage({super.key});

  static const contentKey = Key('sc203_tablet_content');
  static Key unblockKey(String id) => Key('sc203_tablet_unblock_$id');

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
      // Gate qua snapshot provider trước khi đọc Notifier (bẫy 21 STATE-S23):
      // trong UI thật `.value` không null vì khi() đã chặn nhánh.loading/error.
      data: (snapshot) => const _ArenaBlockedUsersBody(),
    );
  }
}

class _ArenaBlockedUsersBody extends ConsumerWidget {
  const _ArenaBlockedUsersBody();

  Future<void> _unblock(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showVitConfirmSheet(
      context: context,
      title: 'Mở chặn người chơi',
      rows: [VitConfirmDialogRow(label: 'Người chơi', value: id)],
      message:
          'Sau khi mở chặn, người chơi này có thể nhìn thấy và tương tác với '
          'bạn trong Open Arena.',
      confirmLabel: 'Mở chặn',
      confirmKey: ArenaBlockedUsersTabletPage.unblockKey(id),
    );
    if (!confirmed) return;
    unawaited(HapticFeedback.selectionClick());
    ref.read(arenaBlockedUsersStateControllerProvider.notifier).unblockUser(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arenaBlockedUsersStateControllerProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticIdentifier: 'SC-203',
      semanticLabel: 'Danh sách chặn',
      child: Column(
        children: [
          VitHeader(
            title: 'Người đã chặn',
            subtitle: '${state.users.length} người · Mở chặn bất cứ lúc nào',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.arenaSafety,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: VitTabletPaneWorkspace(
              contentKey: ArenaBlockedUsersTabletPage.contentKey,
              primaryChildren: [
                if (state.users.isEmpty)
                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Text(
                      'Bạn chưa chặn ai trong Open Arena.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  )
                else
                  _PlayListSection(
                    title: 'Danh sách người bị chặn',
                    itemCount: state.users.length,
                    itemBuilder: (context, i) {
                      final user = state.users[i];
                      return ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.block_outlined,
                          color: AppColors.sell,
                        ),
                        title: Text(
                          switch (user) {
                            ArenaBlockedUserDraft(:final name) => name,
                          },
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${user.reason} · ${_govBlockedSourceLabel(user.source)} · ${user.blockedAt}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        trailing: SizedBox(
                          width: TabletSpacingTokens.x7,
                          child: VitCtaButton(
                            key: ArenaBlockedUsersTabletPage.unblockKey(
                              user.id,
                            ),
                            onPressed: () => _unblock(context, ref, user.id),
                            variant: VitCtaButtonVariant.secondary,
                            child: const Text('Mở chặn'),
                          ),
                        ),
                      );
                    },
                  ),
              ],
              secondaryChildren: [
                const _PlayInfoCard(
                  title: 'Chặn trong Arena',
                  icon: Icons.block_outlined,
                  rows: [
                    _PlayInfoRow(
                      label: 'Hiệu lực',
                      value: 'Không thấy nhau trong phòng và bảng xếp hạng',
                    ),
                    _PlayInfoRow(
                      label: 'Điểm Arena',
                      value: 'Không bị ảnh hưởng khi chặn',
                    ),
                  ],
                ),
                _ardQuickLinks(context, [
                  ('Trung tâm an toàn', AppRoutePaths.arenaSafety),
                  ('Trung tâm phân xử', AppRoutePaths.arenaResolution),
                ]),
              ],
              narrowChildren: [
                if (state.users.isEmpty)
                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Text(
                      'Bạn chưa chặn ai trong Open Arena.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  )
                else
                  _PlayListSection(
                    title: 'Danh sách người bị chặn',
                    itemCount: state.users.length,
                    itemBuilder: (context, i) {
                      final user = state.users[i];
                      return ListTile(
                        dense: true,
                        title: Text(
                          switch (user) {
                            ArenaBlockedUserDraft(:final name) => name,
                          },
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        subtitle: Text(
                          user.reason,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        trailing: SizedBox(
                          width: TabletSpacingTokens.x7,
                          child: VitCtaButton(
                            key: ArenaBlockedUsersTabletPage.unblockKey(
                              user.id,
                            ),
                            onPressed: () => _unblock(context, ref, user.id),
                            variant: VitCtaButtonVariant.secondary,
                            child: const Text('Mở chặn'),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SC-204: Báo cáo của tôi.

class MyArenaReportsTabletPage extends ConsumerStatefulWidget {
  const MyArenaReportsTabletPage({super.key});

  static const contentKey = Key('sc204_tablet_content');

  @override
  ConsumerState<MyArenaReportsTabletPage> createState() =>
      _MyArenaReportsTabletPageState();
}

class _MyArenaReportsTabletPageState
    extends ConsumerState<MyArenaReportsTabletPage> {
  String? _filterId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(myArenaReportsSnapshotProvider);
    final showBack = context.canPop();

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
      data: (snapshot) {
        final activeFilter = snapshot.filters.firstWhere(
          (f) => f.id == _filterId,
          orElse: () => snapshot.filters.first,
        );
        final reports = activeFilter.status == null
            ? snapshot.reports
            : snapshot.reports
                  .where((r) => r.status == activeFilter.status)
                  .toList();
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-204',
          semanticLabel: 'Báo cáo đã gửi',
          child: Column(
            children: [
              VitHeader(
                title: 'Báo cáo của tôi',
                subtitle: 'Đã gửi · Đang xem xét · Đã xử lý',
                showBack: showBack,
                onBack: showBack
                    ? () => goBackOrFallback(
                        context,
                        fallbackPath: AppRoutePaths.arena,
                        mode: BackNavigationMode.historyThenFallback,
                      )
                    : null,
              ),
              Expanded(
                child: VitTabletPaneWorkspace(
                  contentKey: MyArenaReportsTabletPage.contentKey,
                  primaryChildren: [
                    VitModuleHeroCard(
                      accentColor: AppModuleAccents.arena,
                      density: VitDensity.compact,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _ArenaHeroKpi(
                                  label: 'Tổng báo cáo',
                                  value: '${snapshot.summary.total}',
                                ),
                              ),
                              const SizedBox(
                                width: TabletSpacingTokens.x4,
                                height: TabletSpacingTokens.x6,
                                child: ColoredBox(color: AppColors.border),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: TabletSpacingTokens.x4,
                                  ),
                                  child: _ArenaHeroKpi(
                                    label: 'Đang xem xét',
                                    value: '${snapshot.summary.inReview}',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: TabletSpacingTokens.x4,
                                height: TabletSpacingTokens.x6,
                                child: ColoredBox(color: AppColors.border),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: TabletSpacingTokens.x4,
                                  ),
                                  child: _ArenaHeroKpi(
                                    label: 'Đã xử lý',
                                    value: '${snapshot.summary.resolved}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _StudioChipGroup(
                      label: 'Lọc theo trạng thái',
                      options: [
                        for (final filter in snapshot.filters)
                          '${filter.label} (${filter.count})',
                      ],
                      selected: '${activeFilter.label} (${activeFilter.count})',
                      onSelect: (value) => setState(() {
                        final label = value.substring(
                          0,
                          value.lastIndexOf(' ('),
                        );
                        _filterId = snapshot.filters
                            .firstWhere((f) => f.label == label)
                            .id;
                      }),
                    ),
                    _PlayListSection(
                      title: 'Hồ sơ báo cáo',
                      itemCount: reports.length,
                      emptyMessage: 'Không có báo cáo ở trạng thái này.',
                      itemBuilder: (context, i) {
                        final report = reports[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.flag_outlined,
                            color: AppColors.warn,
                          ),
                          title: Text(
                            '${report.reason} · ${report.targetName}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Cập nhật ${report.updatedAt}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          trailing: VitStatusPill(
                            label: _govReportStatusLabel(report.status),
                            status: _govReportStatusPill(report.status),
                            size: VitStatusPillSize.sm,
                          ),
                          onTap: () => context.push(
                            AppRoutePaths.arenaReportCase(report.id),
                          ),
                        );
                      },
                    ),
                  ],
                  secondaryChildren: [
                    const _PlayInfoCard(
                      title: 'Phạm vi xem xét',
                      icon: Icons.shield_outlined,
                      rows: [
                        _PlayInfoRow(
                          label: 'Trọng tài xem',
                          value: 'Luật · hoàn thành · fair play · Điểm Arena',
                        ),
                        _PlayInfoRow(
                          label: 'Không xem',
                          value: 'Giao dịch tài chính ngoài hệ thống',
                        ),
                      ],
                    ),
                    VitCtaButton(
                      onPressed: () => context.push(AppRoutePaths.arenaSafety),
                      child: const Text('Báo cáo vi phạm mới'),
                    ),
                    _ardQuickLinks(context, [
                      ('Trung tâm phân xử', AppRoutePaths.arenaResolution),
                    ]),
                  ],
                  narrowChildren: [
                    _StudioChipGroup(
                      label: 'Lọc theo trạng thái',
                      options: [
                        for (final filter in snapshot.filters)
                          '${filter.label} (${filter.count})',
                      ],
                      selected: '${activeFilter.label} (${activeFilter.count})',
                      onSelect: (value) => setState(() {
                        final label = value.substring(
                          0,
                          value.lastIndexOf(' ('),
                        );
                        _filterId = snapshot.filters
                            .firstWhere((f) => f.label == label)
                            .id;
                      }),
                    ),
                    _PlayListSection(
                      title: 'Hồ sơ báo cáo',
                      itemCount: reports.length,
                      emptyMessage: 'Không có báo cáo ở trạng thái này.',
                      itemBuilder: (context, i) {
                        final report = reports[i];
                        return ListTile(
                          dense: true,
                          title: Text(
                            '${report.reason} · ${report.targetName}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                          trailing: VitStatusPill(
                            label: _govReportStatusLabel(report.status),
                            status: _govReportStatusPill(report.status),
                            size: VitStatusPillSize.sm,
                          ),
                          onTap: () => context.push(
                            AppRoutePaths.arenaReportCase(report.id),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// SC-202: Hồ sơ báo cáo (timeline + kháng cáo qua reviewState).

class ArenaReportCaseTabletPage extends ConsumerStatefulWidget {
  const ArenaReportCaseTabletPage({super.key, required this.caseId});

  static const contentKey = Key('sc202_tablet_content');
  static const appealKey = Key('sc202_tablet_appeal');

  final String caseId;

  @override
  ConsumerState<ArenaReportCaseTabletPage> createState() =>
      _ArenaReportCaseTabletPageState();
}

class _ArenaReportCaseTabletPageState
    extends ConsumerState<ArenaReportCaseTabletPage> {
  bool _appealSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      arenaReportCaseControllerProvider(widget.caseId),
    );
    final showBack = context.canPop();

    return controllerAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-202',
        semanticLabel: 'Hồ sơ tố cáo',
        title: 'Hồ sơ báo cáo',
        subtitle: widget.caseId,
        contentKey: ArenaReportCaseTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được hồ sơ',
            () =>
                ref.invalidate(arenaReportCaseSnapshotProvider(widget.caseId)),
          ),
        ],
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final reportCase = snapshot.reportCase;
        final review = controller.reviewState(
          appealSubmitted: _appealSubmitted,
        );
        final related = snapshot.relatedReports
            .where((r) => r.id != snapshot.caseId)
            .toList();
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-202',
          semanticLabel: 'Hồ sơ tố cáo',
          child: Column(
            children: [
              VitHeader(
                title: 'Hồ sơ báo cáo',
                subtitle: reportCase == null
                    ? widget.caseId
                    : '${reportCase.reason} · ${_govReportStatusLabel(reportCase.status)}',
                showBack: showBack,
                onBack: showBack
                    ? () => goBackOrFallback(
                        context,
                        fallbackPath: AppRoutePaths.arenaMyReports,
                        mode: BackNavigationMode.historyThenFallback,
                      )
                    : null,
              ),
              Expanded(
                child: VitTabletPaneWorkspace(
                  contentKey: ArenaReportCaseTabletPage.contentKey,
                  primaryChildren: [
                    if (reportCase != null) ...[
                      _PlayInfoCard(
                        title: 'Nội dung báo cáo',
                        icon: Icons.flag_outlined,
                        rows: [
                          _PlayInfoRow(
                            label: 'Lý do',
                            value: reportCase.reason,
                          ),
                          _PlayInfoRow(
                            label: 'Đối tượng',
                            value:
                                '${reportCase.targetName} (${switch (reportCase.targetType) {
                                  ArenaReportTargetType.user => 'người chơi',
                                  ArenaReportTargetType.challenge => 'thử thách',
                                  ArenaReportTargetType.mode => 'chế độ',
                                }})',
                          ),
                          _PlayInfoRow(
                            label: 'Ngày gửi',
                            value: reportCase.createdAt,
                          ),
                          _PlayInfoRow(
                            label: 'Cập nhật',
                            value: reportCase.updatedAt,
                          ),
                          if (reportCase.actionTaken != null)
                            _PlayInfoRow(
                              label: 'Đã xử lý',
                              value: reportCase.actionTaken!,
                            ),
                          if (reportCase.systemNote != null)
                            _PlayInfoRow(
                              label: 'Ghi chú hệ thống',
                              value: reportCase.systemNote!,
                            ),
                        ],
                      ),
                      if (reportCase.timeline.isNotEmpty)
                        _PlayListSection(
                          title: 'Timeline xử lý',
                          itemCount: reportCase.timeline.length,
                          itemBuilder: (context, i) {
                            final step = reportCase.timeline[i];
                            return ListTile(
                              dense: true,
                              leading: Icon(
                                step.done
                                    ? Icons.check_circle_outline
                                    : Icons.radio_button_unchecked,
                                color: step.done
                                    ? AppColors.buy
                                    : AppColors.text3,
                              ),
                              title: Text(
                                step.label,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              trailing: Text(
                                step.date,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            );
                          },
                        ),
                      if (reportCase.relatedChallengeId != null)
                        VitCtaButton(
                          variant: VitCtaButtonVariant.secondary,
                          onPressed: () => context.push(
                            AppRoutePaths.arenaChallenge(
                              reportCase.relatedChallengeId!,
                            ),
                          ),
                          child: const Text('Xem thử thách liên quan'),
                        ),
                    ] else
                      VitCard(
                        radius: VitCardRadius.tight,
                        padding: TabletSpacingTokens.cardPaddingCompact,
                        child: Text(
                          snapshot.emptyTitle,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    if (related.isNotEmpty)
                      _PlayListSection(
                        title: 'Hồ sơ liên quan',
                        itemCount: related.length,
                        itemBuilder: (context, i) {
                          final rel = related[i];
                          return ListTile(
                            dense: true,
                            title: Text(
                              '${rel.reason} · ${rel.targetName}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                              ),
                            ),
                            trailing: VitStatusPill(
                              label: _govReportStatusLabel(rel.status),
                              status: _govReportStatusPill(rel.status),
                              size: VitStatusPillSize.sm,
                            ),
                            onTap: () => context.push(
                              AppRoutePaths.arenaReportCase(rel.id),
                            ),
                          );
                        },
                      ),
                  ],
                  secondaryChildren: [
                    _PlayInfoCard(
                      title: 'Trạng thái xem xét',
                      icon: Icons.gavel_outlined,
                      rows: [
                        VitStatusPill(
                          label: review.statusLabel,
                          status: _govReportStatusPill(
                            reportCase?.status ??
                                ArenaReportCaseStatus.submitted,
                          ),
                          size: VitStatusPillSize.sm,
                        ),
                        _PlayInfoRow(label: 'Giai đoạn', value: review.title),
                        _ardBody(review.description),
                      ],
                    ),
                    VitCtaButton(
                      key: ArenaReportCaseTabletPage.appealKey,
                      onPressed: review.canAppeal
                          ? () => _submitAppeal(review.statusLabel)
                          : null,
                      child: Text(
                        _appealSubmitted
                            ? 'Đã ghi nhận kháng cáo'
                            : 'Gửi kháng cáo',
                      ),
                    ),
                    if (snapshot.disclaimer.isNotEmpty)
                      Text(
                        snapshot.disclaimer,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    _ardQuickLinks(context, [
                      ('Tất cả báo cáo', AppRoutePaths.arenaMyReports),
                    ]),
                  ],
                  narrowChildren: [
                    if (reportCase != null)
                      _PlayInfoCard(
                        title: 'Nội dung báo cáo',
                        rows: [
                          _PlayInfoRow(
                            label: 'Lý do',
                            value: reportCase.reason,
                          ),
                          _PlayInfoRow(
                            label: 'Đối tượng',
                            value: reportCase.targetName,
                          ),
                          _PlayInfoRow(
                            label: 'Trạng thái',
                            value: _govReportStatusLabel(reportCase.status),
                          ),
                        ],
                      ),
                    VitCtaButton(
                      key: ArenaReportCaseTabletPage.appealKey,
                      onPressed: review.canAppeal
                          ? () => _submitAppeal(review.statusLabel)
                          : null,
                      child: Text(
                        _appealSubmitted
                            ? 'Đã ghi nhận kháng cáo'
                            : 'Gửi kháng cáo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitAppeal(String statusLabel) async {
    final confirmed = await showVitConfirmSheet(
      context: context,
      title: 'Gửi kháng cáo',
      rows: [VitConfirmDialogRow(label: 'Hồ sơ', value: widget.caseId)],
      message:
          'Kháng cáo mở một yêu cầu xem xét lại dành cho ghi chú trọng tài và '
          'bằng chứng theo luật. Phạm vi vẫn là an toàn, độ rõ ràng luật và '
          'fair play.',
      confirmLabel: 'Gửi kháng cáo',
      confirmKey: ArenaReportCaseTabletPage.appealKey,
    );
    if (!confirmed || !mounted) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _appealSubmitted = true);
  }
}
