part of 'arena_tablet_pages.dart';

// Cụm Play chi tiết chế độ & người dựng (tách từ _play theo vai trò
// detail): SC-189 Mode detail, SC-193 Creator.

// ---------------------------------------------------------------------------
// SC-189: Chi tiết chế độ đấu.

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
      data: (snapshot) {
        final mode = snapshot.mode;
        final showBack = context.canPop();
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-189',
          semanticLabel: 'Chi tiết chế độ đấu',
          child: Column(
            children: [
              VitHeader(
                title: mode.title,
                subtitle:
                    'Chế độ đấu · ${switch (snapshot.creator) {
                      ArenaModeCreatorDetailDraft(:final name) => name,
                    }}',
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
                  contentKey: ArenaModeDetailTabletPage.contentKey,
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
                                child: Text(
                                  mode.title,
                                  style: AppTextStyles.sectionTitle.copyWith(
                                    fontWeight: AppTextStyles.heavy,
                                    color: AppColors.text1,
                                  ),
                                ),
                              ),
                              if (mode.fairPlay)
                                const VitStatusPill(
                                  label: 'Fair play',
                                  status: VitStatusPillStatus.success,
                                  size: VitStatusPillSize.sm,
                                ),
                            ],
                          ),
                          if (mode.description.isNotEmpty) ...[
                            const SizedBox(height: TabletSpacingTokens.x2),
                            Text(
                              mode.description,
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
                                  label: 'Lượt dùng lại',
                                  value: '${mode.cloneCount}',
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
                                    label: 'Thách đấu đang mở',
                                    value: '${mode.activeChallenges}',
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
                                    label: 'Tỉ lệ hoàn thành',
                                    value: '${mode.completionRate}%',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (mode.tags.isNotEmpty) ...[
                            const SizedBox(height: TabletSpacingTokens.x3),
                            Wrap(
                              spacing: TabletSpacingTokens.x2,
                              runSpacing: TabletSpacingTokens.x2,
                              children: [
                                for (final tag in mode.tags)
                                  VitStatusPill(
                                    label: tag,
                                    status: VitStatusPillStatus.info,
                                    size: VitStatusPillSize.sm,
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (snapshot.ruleRows.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Tóm tắt quy tắc',
                        icon: Icons.menu_book_outlined,
                        rows: [
                          for (final row in snapshot.ruleRows)
                            _PlayInfoRow(label: row.label, value: row.value),
                        ],
                      ),
                    if (snapshot.qualityMetrics.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Chất lượng chế độ',
                        icon: Icons.verified_outlined,
                        rows: [
                          for (final metric in snapshot.qualityMetrics)
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        metric.label,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.text1,
                                          fontWeight: AppTextStyles.bold,
                                        ),
                                      ),
                                      if (metric.description.isNotEmpty) ...[
                                        const SizedBox(
                                          height: TabletSpacingTokens.x1,
                                        ),
                                        Text(
                                          metric.description,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.text3,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: TabletSpacingTokens.x3),
                                VitStatusPill(
                                  label: metric.value,
                                  status: _playMetricPill(metric.status),
                                  size: VitStatusPillSize.sm,
                                ),
                              ],
                            ),
                        ],
                      ),
                    _PlayListSection(
                      title: 'Phòng đấu theo chế độ này',
                      itemCount: snapshot.relatedRooms.length,
                      emptyMessage: 'Chưa có phòng mở theo chế độ này.',
                      itemBuilder: (context, i) {
                        final room = snapshot.relatedRooms[i];
                        return _ArenaRoomTile(
                          room: room,
                          onTap: () => context.push(
                            AppRoutePaths.arenaChallenge(room.id),
                          ),
                        );
                      },
                    ),
                  ],
                  secondaryChildren: [
                    _PlayInfoCard(
                      title: 'Người tạo chế độ',
                      icon: Icons.person_outline,
                      rows: [
                        _PlayInfoRow(
                          label: 'Tên',
                          value: switch (snapshot.creator) {
                            ArenaModeCreatorDetailDraft(:final name) => name,
                          },
                        ),
                        _PlayInfoRow(
                          label: 'Danh hiệu',
                          value: snapshot.creator.badge,
                        ),
                        _PlayInfoRow(
                          label: 'Điểm uy tín',
                          value: '${snapshot.creator.trustScore}',
                        ),
                      ],
                    ),
                    if (snapshot.predictionContext.eventId.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Ngữ cảnh dự đoán',
                        icon: Icons.insights_outlined,
                        rows: [
                          _PlayInfoRow(
                            label: 'Sự kiện',
                            value: snapshot.predictionContext.title,
                          ),
                          _PlayInfoRow(
                            label: 'Kết quả',
                            value: snapshot.predictionContext.outcomeName,
                          ),
                          _PlayInfoRow(
                            label: 'Xác suất',
                            value: '${snapshot.predictionContext.probability}%',
                          ),
                        ],
                      ),
                    if (snapshot.relatedModes.isNotEmpty)
                      _ardQuickLinks(context, [
                        for (final related in snapshot.relatedModes)
                          (related.title, AppRoutePaths.arenaMode(related.id)),
                      ]),
                    VitCtaButton(
                      onPressed: () => context.push(AppRoutePaths.arena),
                      child: const Text('Về hub Open Arena'),
                    ),
                  ],
                  narrowChildren: [
                    // Phone-parity: tổng quan → quy tắc → chất lượng → phòng.
                    VitModuleHeroCard(
                      accentColor: AppModuleAccents.arena,
                      density: VitDensity.compact,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            mode.title,
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontWeight: AppTextStyles.heavy,
                              color: AppColors.text1,
                            ),
                          ),
                          if (mode.description.isNotEmpty) ...[
                            const SizedBox(height: TabletSpacingTokens.x2),
                            Text(
                              mode.description,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _PlayListSection(
                      title: 'Phòng đấu theo chế độ này',
                      itemCount: snapshot.relatedRooms.length,
                      emptyMessage: 'Chưa có phòng mở theo chế độ này.',
                      itemBuilder: (context, i) {
                        final room = snapshot.relatedRooms[i];
                        return _ArenaRoomTile(
                          room: room,
                          onTap: () => context.push(
                            AppRoutePaths.arenaChallenge(room.id),
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
// SC-193: Hồ sơ người dựng (creator).

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
      data: (snapshot) {
        final creator = snapshot.creator;
        final showBack = context.canPop();
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-193',
          semanticLabel: 'Hồ sơ người dựng',
          child: Column(
            children: [
              VitHeader(
                title: switch (creator) {
                  ArenaCreatorProfileDraft(:final name) => name,
                },
                subtitle: 'Người dựng · ${creator.badge}',
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
                  contentKey: ArenaCreatorTabletPage.contentKey,
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
                                    label: 'Chế độ đã tạo',
                                    value: '${creator.modesCreated}',
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
                                    label: 'Phòng hoàn thành',
                                    value: '${creator.completedRooms}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (snapshot.aboutRows.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Thông tin',
                        icon: Icons.info_outline,
                        rows: [
                          for (final row in snapshot.aboutRows)
                            _PlayInfoRow(label: row.label, value: row.value),
                        ],
                      ),
                    _PlayListSection(
                      title: 'Phòng đang mở',
                      itemCount: snapshot.liveRooms.length,
                      emptyMessage: 'Không có phòng nào đang mở.',
                      itemBuilder: (context, i) {
                        final room = snapshot.liveRooms[i];
                        return _ArenaRoomTile(
                          room: room,
                          onTap: () => context.push(
                            AppRoutePaths.arenaChallenge(room.id),
                          ),
                        );
                      },
                    ),
                    _PlayListSection(
                      title: 'Phòng đã kết thúc',
                      itemCount: snapshot.historyRooms.length,
                      emptyMessage: 'Chưa có phòng nào kết thúc.',
                      itemBuilder: (context, i) {
                        final room = snapshot.historyRooms[i];
                        return _ArenaRoomTile(
                          room: room,
                          onTap: () => context.push(
                            AppRoutePaths.arenaChallenge(room.id),
                          ),
                        );
                      },
                    ),
                  ],
                  secondaryChildren: [
                    _PlayInfoCard(
                      title: 'Chỉ số uy tín',
                      icon: Icons.verified_user_outlined,
                      rows: [
                        for (final metric in snapshot.trustMetrics)
                          _PlayInfoRow(
                            label: metric.label,
                            value: metric.value,
                          ),
                      ],
                    ),
                    if (snapshot.modes.isNotEmpty)
                      _ardQuickLinks(context, [
                        for (final mode in snapshot.modes)
                          (mode.title, AppRoutePaths.arenaMode(mode.id)),
                      ]),
                    VitCtaButton(
                      onPressed: () =>
                          context.push(AppRoutePaths.arenaTrust(creator.id)),
                      child: const Text('Xem độ tin cậy'),
                    ),
                    if (snapshot.policyLabel.isNotEmpty)
                      Text(
                        snapshot.policyLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                  ],
                  narrowChildren: [
                    VitModuleHeroCard(
                      accentColor: AppModuleAccents.arena,
                      density: VitDensity.compact,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            switch (creator) {
                              ArenaCreatorProfileDraft(:final name) => name,
                            },
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontWeight: AppTextStyles.heavy,
                              color: AppColors.text1,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x2),
                          Text(
                            'Điểm uy tín ${creator.trustScore} · ${creator.badge}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VitCtaButton(
                      onPressed: () =>
                          context.push(AppRoutePaths.arenaTrust(creator.id)),
                      child: const Text('Xem độ tin cậy'),
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
