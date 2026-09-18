part of 'arena_tablet_pages.dart';

// Cụm Points/utility (Đợt 4 redesign tablet Arena 2026-09-19): SC-201 Sổ
// điểm, SC-200 Chi tiết biến động, SC-197 Flow map, SC-206 Production ready,
// SC-207 Cầu nối Dự đoán, SC-208 Hệ sinh thái liên kết.

// ---------------------------------------------------------------------------
// SC-201: Sổ điểm Arena.

class ArenaPointsLedgerTabletPage extends ConsumerStatefulWidget {
  const ArenaPointsLedgerTabletPage({super.key});

  static const contentKey = Key('sc201_tablet_content');

  @override
  ConsumerState<ArenaPointsLedgerTabletPage> createState() =>
      _ArenaPointsLedgerTabletPageState();
}

class _ArenaPointsLedgerTabletPageState
    extends ConsumerState<ArenaPointsLedgerTabletPage> {
  String? _filterId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaPointsLedgerSnapshotProvider);
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-201',
        semanticLabel: 'Sổ điểm Arena',
        title: 'Sổ điểm',
        subtitle: 'Biến động điểm',
        contentKey: ArenaPointsLedgerTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được sổ điểm',
            () => ref.invalidate(arenaPointsLedgerSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final activeFilter = snapshot.filters.firstWhere(
          (f) => f.id == _filterId,
          orElse: () => snapshot.filters.first,
        );
        final entries = activeFilter.id == snapshot.filters.first.id
            ? snapshot.entries
            : snapshot.entries
                  .where(
                    (e) =>
                        e.typeId == activeFilter.id ||
                        e.typeLabel == activeFilter.label,
                  )
                  .toList();
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-201',
          semanticLabel: 'Sổ điểm Arena',
          child: Column(
            children: [
              VitHeader(
                title: 'Sổ điểm Arena',
                subtitle: 'Số dư · Nhận · Tiêu',
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
                  contentKey: ArenaPointsLedgerTabletPage.contentKey,
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
                                  label: 'Điểm hiện có',
                                  value: '${snapshot.summary.currentBalance}',
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
                                    label: 'Đã nhận',
                                    value: '${snapshot.summary.pointsEarned}',
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
                                    label: 'Đã tiêu',
                                    value: '${snapshot.summary.pointsSpent}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _StudioChipGroup(
                      label: 'Lọc theo loại biến động',
                      options: [
                        for (final filter in snapshot.filters) filter.label,
                      ],
                      selected: activeFilter.label,
                      onSelect: (label) => setState(() {
                        _filterId = snapshot.filters
                            .firstWhere((f) => f.label == label)
                            .id;
                      }),
                    ),
                    _PlayListSection(
                      title: 'Biến động điểm',
                      itemCount: entries.length,
                      emptyMessage: snapshot.emptyTitle,
                      itemBuilder: (context, i) {
                        final entry = entries[i];
                        final positive = entry.amount >= 0;
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            positive
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                            color: positive ? AppColors.buy : AppColors.sell,
                          ),
                          title: Text(
                            entry.typeLabel,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${entry.time} · ${entry.title}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          trailing: Text(
                            '${positive ? '+' : ''}${entry.amount}',
                            style: AppTextStyles.control.copyWith(
                              color: positive ? AppColors.buy : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          onTap: () => context.push(
                            AppRoutePaths.arenaLedgerEntry(entry.id),
                          ),
                        );
                      },
                    ),
                  ],
                  secondaryChildren: [
                    _PlayInfoCard(
                      title: 'Sổ điểm Arena',
                      icon: Icons.stars_outlined,
                      rows: [
                        _PlayInfoRow(
                          label: 'Bản ghi',
                          value: '${snapshot.entries.length}',
                        ),
                        _PlayInfoRow(
                          label: 'Bộ lọc',
                          value: '${snapshot.filters.length}',
                        ),
                      ],
                    ),
                    VitCtaButton(
                      onPressed: () =>
                          context.push('${AppRoutePaths.rewards}?tab=arena'),
                      child: const Text('Nhiệm vụ nhận điểm'),
                    ),
                    if (snapshot.disclaimer.isNotEmpty)
                      Text(
                        snapshot.disclaimer,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                  ],
                  narrowChildren: [
                    _PlayListSection(
                      title: 'Biến động điểm',
                      itemCount: entries.length,
                      emptyMessage: snapshot.emptyTitle,
                      itemBuilder: (context, i) {
                        final entry = entries[i];
                        final positive = entry.amount >= 0;
                        return ListTile(
                          dense: true,
                          title: Text(
                            entry.typeLabel,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                          trailing: Text(
                            '${positive ? '+' : ''}${entry.amount}',
                            style: AppTextStyles.caption.copyWith(
                              color: positive ? AppColors.buy : AppColors.sell,
                            ),
                          ),
                          onTap: () => context.push(
                            AppRoutePaths.arenaLedgerEntry(entry.id),
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
// SC-200: Chi tiết một biến động điểm.

class ArenaPointsEntryDetailTabletPage extends ConsumerWidget {
  const ArenaPointsEntryDetailTabletPage({super.key, required this.entryId});

  static const contentKey = Key('sc200_tablet_content');

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      arenaPointsEntryDetailSnapshotProvider(entryId),
    );
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-200',
        semanticLabel: 'Chi tiết biến động điểm',
        title: 'Biến động',
        subtitle: entryId,
        contentKey: ArenaPointsEntryDetailTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được biến động',
            () =>
                ref.invalidate(arenaPointsEntryDetailSnapshotProvider(entryId)),
          ),
        ],
      ),
      data: (snapshot) {
        final entry = snapshot.entry;
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-200',
          semanticLabel: 'Chi tiết biến động điểm',
          child: Column(
            children: [
              VitHeader(
                title: 'Chi tiết biến động',
                subtitle: entry?.typeLabel ?? entryId,
                showBack: showBack,
                onBack: showBack
                    ? () => goBackOrFallback(
                        context,
                        fallbackPath: AppRoutePaths.arenaLedger,
                        mode: BackNavigationMode.historyThenFallback,
                      )
                    : null,
              ),
              Expanded(
                child: VitTabletPaneWorkspace(
                  contentKey: ArenaPointsEntryDetailTabletPage.contentKey,
                  primaryChildren: [
                    if (entry != null) ...[
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
                                    '${entry.amount >= 0 ? '+' : ''}${entry.amount} điểm',
                                    style: AppTextStyles.pageTitle.copyWith(
                                      fontWeight: AppTextStyles.heavy,
                                      color: entry.amount >= 0
                                          ? AppColors.buy
                                          : AppColors.sell,
                                    ),
                                  ),
                                ),
                                VitStatusPill(
                                  label: entry.statusLabel,
                                  status: switch (entry.statusKind) {
                                    ArenaPointsEntryStatus.completed =>
                                      VitStatusPillStatus.success,
                                    ArenaPointsEntryStatus.pending =>
                                      VitStatusPillStatus.warning,
                                    ArenaPointsEntryStatus.reversed =>
                                      VitStatusPillStatus.neutral,
                                  },
                                  size: VitStatusPillSize.sm,
                                ),
                              ],
                            ),
                            if (entry.note.isNotEmpty) ...[
                              const SizedBox(height: TabletSpacingTokens.x2),
                              Text(
                                entry.note,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      _PlayInfoCard(
                        title: 'Thông tin biến động',
                        icon: Icons.receipt_long_outlined,
                        rows: [
                          _PlayInfoRow(label: 'Loại', value: entry.typeLabel),
                          _PlayInfoRow(label: 'Thời điểm', value: entry.time),
                          _PlayInfoRow(
                            label: 'Mã tham chiếu',
                            value: entry.refId,
                          ),
                          if (entry.reasonCode.isNotEmpty)
                            _PlayInfoRow(
                              label: 'Lý do',
                              value: entry.reasonCode,
                            ),
                          _PlayInfoRow(
                            label: 'Số dư trước',
                            value: '${entry.balanceBefore}',
                          ),
                          _PlayInfoRow(
                            label: 'Số dư sau',
                            value: '${entry.balanceAfter}',
                          ),
                        ],
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
                  ],
                  secondaryChildren: [
                    _PlayInfoCard(
                      title: 'Ngữ cảnh liên quan',
                      icon: Icons.link_outlined,
                      rows: [
                        _PlayInfoRow(
                          label: 'Thử thách',
                          value: entry?.linkedChallengeName ?? '—',
                        ),
                        _PlayInfoRow(
                          label: 'Chế độ',
                          value: entry?.linkedModeName ?? '—',
                        ),
                      ],
                    ),
                    if (entry?.linkedChallengeId != null)
                      VitCtaButton(
                        variant: VitCtaButtonVariant.secondary,
                        onPressed: () => context.push(
                          AppRoutePaths.arenaChallenge(
                            entry!.linkedChallengeId!,
                          ),
                        ),
                        child: const Text('Xem thử thách liên quan'),
                      ),
                    VitCtaButton(
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () => context.push(AppRoutePaths.arenaLedger),
                      child: const Text('Về sổ điểm'),
                    ),
                    if (snapshot.disclaimer.isNotEmpty)
                      Text(
                        snapshot.disclaimer,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                  ],
                  narrowChildren: [
                    if (entry != null)
                      _PlayInfoCard(
                        title: 'Thông tin biến động',
                        rows: [
                          _PlayInfoRow(
                            label: 'Số điểm',
                            value: '${entry.amount}',
                          ),
                          _PlayInfoRow(
                            label: 'Trạng thái',
                            value: entry.statusLabel,
                          ),
                          _PlayInfoRow(label: 'Thời điểm', value: entry.time),
                        ],
                      ),
                    VitCtaButton(
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () => context.push(AppRoutePaths.arenaLedger),
                      child: const Text('Về sổ điểm'),
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
// SC-197: Bản đồ luồng Arena (tham chiếu nội bộ).

class ArenaFlowMapTabletPage extends ConsumerWidget {
  const ArenaFlowMapTabletPage({super.key});

  static const contentKey = Key('sc197_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaFlowMapSnapshotProvider);
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-197',
        semanticLabel: 'Bản đồ luồng Arena',
        title: 'Bản đồ luồng',
        subtitle: 'Tham chiếu nội bộ',
        contentKey: ArenaFlowMapTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được bản đồ luồng',
            () => ref.invalidate(arenaFlowMapSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticIdentifier: 'SC-197',
        semanticLabel: 'Bản đồ luồng Arena',
        child: Column(
          children: [
            VitHeader(
              title: 'Bản đồ luồng Arena',
              subtitle: 'Luồng chính · Trang · Bàn giao',
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
                contentKey: ArenaFlowMapTabletPage.contentKey,
                primaryChildren: [
                  if (snapshot.stats.isNotEmpty)
                    VitModuleHeroCard(
                      accentColor: AppModuleAccents.arena,
                      density: VitDensity.compact,
                      child: Row(
                        children: [
                          for (var i = 0; i < snapshot.stats.length; i++) ...[
                            if (i > 0) ...[
                              const SizedBox(
                                width: TabletSpacingTokens.x4,
                                height: TabletSpacingTokens.x6,
                                child: ColoredBox(color: AppColors.border),
                              ),
                              const SizedBox(width: TabletSpacingTokens.x4),
                            ],
                            Expanded(
                              child: _ArenaHeroKpi(
                                label: snapshot.stats[i].label,
                                value: snapshot.stats[i].value,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  if (snapshot.routes.isNotEmpty)
                    _PlayListSection(
                      title: 'Tuyến trang',
                      itemCount: snapshot.routes.length,
                      itemBuilder: (context, i) {
                        final route = snapshot.routes[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.alt_route_outlined,
                            color: AppModuleAccents.arena,
                          ),
                          title: Text(
                            route.page,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            route.path,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          trailing: Text(
                            route.status,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        );
                      },
                    ),
                  if (snapshot.groups.isNotEmpty)
                    _PlayListSection(
                      title: 'Nhóm luồng',
                      itemCount: snapshot.groups.length,
                      itemBuilder: (context, i) {
                        final group = snapshot.groups[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.account_tree_outlined,
                            color: AppColors.text2,
                          ),
                          title: Text(
                            group.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            group.subtitle,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        );
                      },
                    ),
                ],
                secondaryChildren: [
                  if (snapshot.handoffNotes.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Ghi chú bàn giao',
                      icon: Icons.assignment_outlined,
                      rows: [
                        for (final note in snapshot.handoffNotes)
                          VitBulletRow(text: '${note.title}: ${note.detail}'),
                      ],
                    ),
                  if (snapshot.qaItems.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Mục QA',
                      icon: Icons.checklist_outlined,
                      rows: [
                        for (final qa in snapshot.qaItems)
                          VitBulletRow(text: '${qa.category}: ${qa.label}'),
                      ],
                    ),
                  if (snapshot.components.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Thành phần dùng lại',
                      icon: Icons.widgets_outlined,
                      rows: [
                        for (final component in snapshot.components)
                          _PlayInfoRow(
                            label: component.file,
                            value: '${component.exports.length} export',
                          ),
                      ],
                    ),
                  if (snapshot.disclaimer.isNotEmpty)
                    Text(
                      snapshot.disclaimer,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                ],
                narrowChildren: [
                  if (snapshot.groups.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Nhóm luồng',
                      rows: [
                        for (final group in snapshot.groups)
                          _PlayInfoRow(
                            label: group.title,
                            value: group.subtitle,
                          ),
                      ],
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
// SC-206: Sẵn sàng production (tham chiếu nội bộ).

class ArenaProductionReadyTabletPage extends ConsumerWidget {
  const ArenaProductionReadyTabletPage({super.key});

  static const contentKey = Key('sc206_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaProductionReadySnapshotProvider);
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-206',
        semanticLabel: 'Sẵn sàng production Arena',
        title: 'Sẵn sàng production',
        subtitle: 'Tham chiếu nội bộ',
        contentKey: ArenaProductionReadyTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được trạng thái production',
            () => ref.invalidate(arenaProductionReadySnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticIdentifier: 'SC-206',
        semanticLabel: 'Sẵn sàng production Arena',
        child: Column(
          children: [
            VitHeader(
              title: 'Sẵn sàng production',
              subtitle:
                  '${snapshot.canonicalScreens.length} màn chính · ${snapshot.flows.length} luồng',
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
                contentKey: ArenaProductionReadyTabletPage.contentKey,
                primaryChildren: [
                  if (snapshot.canonicalScreens.isNotEmpty)
                    _PlayListSection(
                      title: 'Màn chuẩn (canonical)',
                      itemCount: snapshot.canonicalScreens.length,
                      itemBuilder: (context, i) {
                        final screen = snapshot.canonicalScreens[i];
                        return _productionScreenTile(screen);
                      },
                    ),
                  if (snapshot.supportingScreens.isNotEmpty)
                    _PlayListSection(
                      title: 'Màn hỗ trợ',
                      itemCount: snapshot.supportingScreens.length,
                      itemBuilder: (context, i) =>
                          _productionScreenTile(snapshot.supportingScreens[i]),
                    ),
                ],
                secondaryChildren: [
                  _PlayInfoCard(
                    title: 'Luồng đã đóng',
                    icon: Icons.account_tree_outlined,
                    rows: [
                      for (final flow in snapshot.flows)
                        _PlayInfoRow(
                          label: switch (flow) {
                            ArenaProductionFlowDraft(:final name) => name,
                          },
                          value: '${flow.steps.length} bước',
                        ),
                    ],
                  ),
                  if (snapshot.qaItems.isNotEmpty)
                    _PlayInfoCard(
                      title: 'QA',
                      icon: Icons.checklist_outlined,
                      rows: [
                        for (final qa in snapshot.qaItems)
                          VitBulletRow(text: qa),
                      ],
                    ),
                  if (snapshot.disclaimer.isNotEmpty)
                    Text(
                      snapshot.disclaimer,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                ],
                narrowChildren: [
                  if (snapshot.canonicalScreens.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Màn chuẩn',
                      rows: [
                        for (final screen in snapshot.canonicalScreens)
                          _PlayInfoRow(
                            label: switch (screen) {
                              ArenaProductionScreenDraft(:final name) => name,
                            },
                            value: screen.route,
                          ),
                      ],
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

Widget _productionScreenTile(ArenaProductionScreenDraft screen) {
  return ListTile(
    dense: true,
    leading: const Icon(Icons.webhook_outlined, color: AppModuleAccents.arena),
    title: Text(
      switch (screen) {
        ArenaProductionScreenDraft(:final name) => name,
      },
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    ),
    subtitle: Text(
      '${screen.route} · ${screen.version}',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    ),
    // Trailing cần ràng buộc rộng: Text trần nuốt cả tile (bẫy ListTile).
    trailing: SizedBox(
      width: TabletSpacingTokens.x7 + TabletSpacingTokens.x6,
      child: Text(
        screen.notes,
        maxLines: 1,
        style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// SC-207: Cầu nối Dự đoán ↔ Arena.

class ArenaPredictionBridgeTabletPage extends ConsumerWidget {
  const ArenaPredictionBridgeTabletPage({super.key});

  static const contentKey = Key('sc207_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaPredictionBridgeSnapshotProvider);
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-207',
        semanticLabel: 'Cầu nối Dự đoán và Arena',
        title: 'Cầu nối Dự đoán',
        subtitle: 'Ranh giới · Chủ đề chung',
        contentKey: ArenaPredictionBridgeTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được cầu nối dự đoán',
            () => ref.invalidate(arenaPredictionBridgeSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticIdentifier: 'SC-207',
        semanticLabel: 'Cầu nối Dự đoán và Arena',
        child: Column(
          children: [
            VitHeader(
              title: 'Cầu nối Dự đoán ↔ Arena',
              subtitle: 'Chủ đề dùng chung · Ranh giới rõ ràng',
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
                contentKey: ArenaPredictionBridgeTabletPage.contentKey,
                primaryChildren: [
                  if (snapshot.principles.isNotEmpty)
                    _PlayRuleList(
                      rules: [
                        for (final principle in snapshot.principles)
                          '${principle.number}. ${principle.title} — ${principle.description}',
                      ],
                    ),
                  if (snapshot.topics.isNotEmpty)
                    _PlayListSection(
                      title: 'Chủ đề dùng chung hai hệ',
                      itemCount: snapshot.topics.length,
                      itemBuilder: (context, i) {
                        final topic = snapshot.topics[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.compare_arrows_outlined,
                            color: AppModuleAccents.arena,
                          ),
                          title: Text(
                            topic.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Dự đoán: ${topic.predictionUsage}\n'
                            'Arena: ${topic.arenaUsage}\n'
                            'Cầu nối: ${topic.bridgeUsage}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: 1.4,
                            ),
                          ),
                        );
                      },
                    ),
                ],
                secondaryChildren: [
                  if (snapshot.allowedItems.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Được phép cầu nối',
                      icon: Icons.check_circle_outline,
                      rows: [
                        for (final item in snapshot.allowedItems)
                          VitBulletRow(text: item.label),
                      ],
                    ),
                  if (snapshot.notAllowedItems.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Không được cầu nối',
                      icon: Icons.cancel_outlined,
                      rows: [
                        for (final item in snapshot.notAllowedItems)
                          VitBulletRow(text: item.label),
                      ],
                    ),
                  if (snapshot.boundaryBanners.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Ranh giới sản phẩm',
                      icon: Icons.fence_outlined,
                      rows: [
                        for (final banner in snapshot.boundaryBanners)
                          _PlayInfoRow(
                            label: banner.title,
                            value: banner.description,
                          ),
                      ],
                    ),
                ],
                narrowChildren: [
                  if (snapshot.principles.isNotEmpty)
                    _PlayRuleList(
                      rules: [
                        for (final principle in snapshot.principles)
                          '${principle.number}. ${principle.title}',
                      ],
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
// SC-208: Hệ sinh thái liên kết (tham chiếu nội bộ).

class ArenaEcosystemTabletPage extends ConsumerWidget {
  const ArenaEcosystemTabletPage({super.key});

  static const contentKey = Key('sc208_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      connectedEcosystemProductionSnapshotProvider,
    );
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-208',
        semanticLabel: 'Hệ sinh thái liên kết',
        title: 'Hệ sinh thái',
        subtitle: 'Tham chiếu nội bộ',
        contentKey: ArenaEcosystemTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được hệ sinh thái',
            () => ref.invalidate(connectedEcosystemProductionSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticIdentifier: 'SC-208',
        semanticLabel: 'Hệ sinh thái liên kết',
        child: Column(
          children: [
            VitHeader(
              title: 'Hệ sinh thái liên kết',
              subtitle:
                  '${snapshot.canonicalScreens.length} màn · ${snapshot.bridgeStates.length} trạng thái cầu nối',
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
                contentKey: ArenaEcosystemTabletPage.contentKey,
                primaryChildren: [
                  if (snapshot.canonicalScreens.isNotEmpty)
                    _PlayListSection(
                      title: 'Màn chuẩn hệ sinh thái',
                      itemCount: snapshot.canonicalScreens.length,
                      itemBuilder: (context, i) {
                        final screen = snapshot.canonicalScreens[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.hub_outlined,
                            color: AppModuleAccents.arena,
                          ),
                          title: Text(
                            switch (screen) {
                              ConnectedScreenDraft(:final name) => name,
                            },
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${screen.route} · ${screen.source}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        );
                      },
                    ),
                  if (snapshot.bridgeStates.isNotEmpty)
                    _PlayListSection(
                      title: 'Trạng thái cầu nối',
                      itemCount: snapshot.bridgeStates.length,
                      itemBuilder: (context, i) {
                        final state = snapshot.bridgeStates[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.compare_arrows_outlined,
                            color: AppColors.text2,
                          ),
                          title: Text(
                            state.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${state.description}\n'
                            'Hành vi: ${state.behavior} · ảnh hưởng '
                            '${state.affectedScreens.length} màn',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: 1.4,
                            ),
                          ),
                        );
                      },
                    ),
                ],
                secondaryChildren: [
                  if (snapshot.connectedFlows.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Luồng liên kết',
                      icon: Icons.account_tree_outlined,
                      rows: [
                        for (final flow in snapshot.connectedFlows)
                          _PlayInfoRow(
                            label: switch (flow) {
                              ConnectedFlowDraft(:final name) => name,
                            },
                            value: '${flow.steps.length} bước',
                          ),
                      ],
                    ),
                  if (snapshot.sharedItems.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Dùng chung',
                      icon: Icons.compare_arrows_outlined,
                      rows: [
                        for (final item in snapshot.sharedItems)
                          VitBulletRow(
                            text: switch (item) {
                              ConnectedRegistryItemDraft(:final name) => name,
                            },
                          ),
                      ],
                    ),
                  if (snapshot.separateItems.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Tách riêng',
                      icon: Icons.call_split_outlined,
                      rows: [
                        for (final item in snapshot.separateItems)
                          VitBulletRow(
                            text: switch (item) {
                              ConnectedRegistryItemDraft(:final name) => name,
                            },
                          ),
                      ],
                    ),
                ],
                narrowChildren: [
                  if (snapshot.canonicalScreens.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Màn chuẩn hệ sinh thái',
                      rows: [
                        for (final screen in snapshot.canonicalScreens)
                          _PlayInfoRow(
                            label: switch (screen) {
                              ConnectedScreenDraft(:final name) => name,
                            },
                            value: screen.route,
                          ),
                      ],
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
