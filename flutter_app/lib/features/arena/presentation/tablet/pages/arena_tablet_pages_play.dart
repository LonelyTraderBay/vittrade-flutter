part of 'arena_tablet_pages.dart';

// Cụm Play (Đợt 1 redesign tablet Arena 2026-09-19): SC-189 Mode detail,
// SC-190 Challenge detail, SC-191 Join, SC-193 Creator — re-compose từ nội
// dung phone theo idiom workspace 2 cột (VitTabletPaneWorkspace), đầy đủ dữ
// liệu snapshot (không take-N), nối controller read-model.

// ---------------------------------------------------------------------------
// Helper dùng chung cụm play.

String _playChallengeStateLabel(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => 'Đang mở',
    ArenaChallengeState.full => 'Đã đủ chỗ',
    ArenaChallengeState.live => 'Đang diễn ra',
    ArenaChallengeState.pendingResult => 'Chờ kết quả',
    ArenaChallengeState.resolved => 'Đã phân xử',
    ArenaChallengeState.canceled => 'Đã huỷ',
  };
}

VitStatusPillStatus _playChallengeStatePill(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => VitStatusPillStatus.info,
    ArenaChallengeState.full => VitStatusPillStatus.neutral,
    ArenaChallengeState.live => VitStatusPillStatus.success,
    ArenaChallengeState.pendingResult => VitStatusPillStatus.warning,
    ArenaChallengeState.resolved => VitStatusPillStatus.neutral,
    ArenaChallengeState.canceled => VitStatusPillStatus.error,
  };
}

VitStatusPillStatus _playMetricPill(VitArenaMetricStatus status) {
  return switch (status) {
    VitArenaMetricStatus.success => VitStatusPillStatus.success,
    VitArenaMetricStatus.warning => VitStatusPillStatus.warning,
    VitArenaMetricStatus.info => VitStatusPillStatus.info,
    VitArenaMetricStatus.neutral => VitStatusPillStatus.neutral,
  };
}

/// Dòng label → value dùng trong card thông tin (đủ số liệu, không cắt).
class _PlayInfoRow extends StatelessWidget {
  const _PlayInfoRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x3),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Card danh sách dòng label → value (điều khoản, chỉ số, quy tắc tóm tắt).
class _PlayInfoCard extends StatelessWidget {
  const _PlayInfoCard({required this.title, required this.rows, this.icon});

  final String title;
  final List<Widget> rows;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: TabletSpacingTokens.iconSm,
                  color: AppColors.text2,
                ),
                const SizedBox(width: TabletSpacingTokens.x2),
              ],
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1)
              const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// Danh sách quy tắc đánh số (đủ nội dung, không take).
class _PlayRuleList extends StatelessWidget {
  const _PlayRuleList({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rules.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: TabletSpacingTokens.x5,
                  child: Text(
                    '${i + 1}.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.arena,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rules[i],
                    style: AppTextStyles.body.copyWith(color: AppColors.text1),
                  ),
                ),
              ],
            ),
            if (i < rules.length - 1)
              const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// Tile danh sách phòng/mode bấm được — cùng idiom card zeroInsets + divider
/// như section "Phòng đang mở" của hub home.
class _PlayListSection extends StatelessWidget {
  const _PlayListSection({
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.emptyMessage,
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return emptyMessage == null
          ? const SizedBox.shrink()
          : VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Text(
                emptyMessage!,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            );
    }
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
                Text(
                  '$itemCount',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          for (var i = 0; i < itemCount; i++) ...[
            itemBuilder(context, i),
            if (i < itemCount - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

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
                subtitle: 'Chế độ đấu · ${snapshot.creator.name}',
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
                                  VitFilterChip(
                                    label: tag,
                                    active: false,
                                    color: AppModuleAccents.arena,
                                    onTap: () {},
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
                          value: snapshot.creator.name,
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
                      _PlayListSection(
                        title: 'Chế độ liên quan',
                        itemCount: snapshot.relatedModes.length,
                        itemBuilder: (context, i) {
                          final related = snapshot.relatedModes[i];
                          return ListTile(
                            dense: true,
                            title: Text(
                              related.title,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                              ),
                            ),
                            subtitle: Text(
                              'bởi ${related.creatorName}',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_outlined,
                              color: AppColors.text3,
                            ),
                            onTap: () => context.push(
                              AppRoutePaths.arenaMode(related.id),
                            ),
                          );
                        },
                      ),
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
                    if (snapshot.ruleRows.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Tóm tắt quy tắc',
                        rows: [
                          for (final row in snapshot.ruleRows)
                            _PlayInfoRow(label: row.label, value: row.value),
                        ],
                      ),
                    if (snapshot.qualityMetrics.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Chất lượng chế độ',
                        rows: [
                          for (final metric in snapshot.qualityMetrics)
                            _PlayInfoRow(
                              label: metric.label,
                              value: metric.value,
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
// SC-190: Chi tiết thử thách.

enum _PlayChallengeTab { rules, evidence, participants, activity }

class ArenaChallengeDetailTabletPage extends ConsumerStatefulWidget {
  const ArenaChallengeDetailTabletPage({super.key, required this.challengeId});

  static const contentKey = Key('sc190_tablet_content');
  static const joinCtaKey = Key('sc190_tablet_join');

  final String challengeId;

  @override
  ConsumerState<ArenaChallengeDetailTabletPage> createState() =>
      _ArenaChallengeDetailTabletPageState();
}

class _ArenaChallengeDetailTabletPageState
    extends ConsumerState<ArenaChallengeDetailTabletPage> {
  _PlayChallengeTab _tab = _PlayChallengeTab.rules;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      arenaChallengeDetailControllerProvider(widget.challengeId),
    );

    return controllerAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-190',
        semanticLabel: 'Chi tiết thử thách',
        title: 'Chi tiết thách đấu',
        subtitle: widget.challengeId,
        contentKey: ArenaChallengeDetailTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được thách đấu',
            () => ref.invalidate(
              arenaChallengeDetailSnapshotProvider(widget.challengeId),
            ),
          ),
        ],
      ),
      data: (controller) => _buildBody(context, controller.state.snapshot),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ArenaChallengeDetailSnapshot snapshot,
  ) {
    final challenge = snapshot.challenge;
    final showBack = context.canPop();
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticIdentifier: 'SC-190',
      semanticLabel: 'Chi tiết thử thách',
      child: Column(
        children: [
          VitHeader(
            title: challenge.title,
            subtitle: '${challenge.modeName} · ${challenge.statusLabel}',
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
              contentKey: ArenaChallengeDetailTabletPage.contentKey,
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
                              challenge.title,
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontWeight: AppTextStyles.heavy,
                                color: AppColors.text1,
                              ),
                            ),
                          ),
                          VitStatusPill(
                            label: _playChallengeStateLabel(challenge.state),
                            status: _playChallengeStatePill(challenge.state),
                            size: VitStatusPillSize.sm,
                            pulse: challenge.state == ArenaChallengeState.live,
                          ),
                        ],
                      ),
                      if (challenge.description.isNotEmpty) ...[
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          challenge.description,
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
                              label: 'Điểm vào',
                              value: '${challenge.entryPoints}',
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
                                label: 'Tổng điểm giải',
                                value: '${challenge.prizePool}',
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
                                label: 'Cho đội thắng',
                                value: '${challenge.teamWinnerPool}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TabletSpacingTokens.x4),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Slot: ${challenge.slotsFilled}/${challenge.slotsTotal} · ${challenge.countdownLabel}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text2,
                                  ),
                                ),
                                const SizedBox(height: TabletSpacingTokens.x2),
                                LinearProgressIndicator(
                                  minHeight: TabletSpacingTokens.x2,
                                  value: (challenge.fillPercent / 100).clamp(
                                    0.0,
                                    1.0,
                                  ),
                                  backgroundColor: AppColors.border,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        AppModuleAccents.arena,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _PlayInfoCard(
                  title: 'Điều khoản',
                  icon: Icons.gavel_outlined,
                  rows: [
                    _PlayInfoRow(
                      label: 'Điều kiện thắng',
                      value: challenge.winCondition,
                    ),
                    _PlayInfoRow(
                      label: 'Cách phân xử',
                      value: challenge.resolutionMethod,
                    ),
                    _PlayInfoRow(
                      label: 'Yêu cầu bằng chứng',
                      value: challenge.evidenceRequirement,
                    ),
                    _PlayInfoRow(label: 'Luật huỷ', value: challenge.voidRule),
                    _PlayInfoRow(
                      label: 'Chính sách hoàn',
                      value: challenge.refundPolicy,
                    ),
                    _PlayInfoRow(
                      label: 'Phí nền tảng',
                      value: '${challenge.platformFeePercent}%',
                    ),
                    _PlayInfoRow(
                      label: 'Hưởng của người tạo',
                      value: '${challenge.creatorCutPercent}%',
                    ),
                  ],
                ),
                VitSegmentedTabBar(
                  activeKey: _tab.name,
                  onChanged: (key) => setState(
                    () => _tab = _PlayChallengeTab.values.byName(key),
                  ),
                  tabs: [
                    for (final entry in const [
                      (
                        _PlayChallengeTab.rules,
                        'Luật chơi',
                        Icons.menu_book_outlined,
                      ),
                      (
                        _PlayChallengeTab.evidence,
                        'Bằng chứng',
                        Icons.camera_alt_outlined,
                      ),
                      (
                        _PlayChallengeTab.participants,
                        'Thành viên',
                        Icons.groups_2_outlined,
                      ),
                      (
                        _PlayChallengeTab.activity,
                        'Hoạt động',
                        Icons.timeline_outlined,
                      ),
                    ])
                      VitTabItem(
                        key: entry.$1.name,
                        label: entry.$2,
                        icon: entry.$3,
                      ),
                  ],
                ),
                _buildTabPanel(snapshot),
              ],
              secondaryChildren: [
                _PlayInfoCard(
                  title: 'Người tạo thử thách',
                  icon: Icons.person_outline,
                  rows: [
                    _PlayInfoRow(label: 'Tên', value: snapshot.creator.name),
                    _PlayInfoRow(
                      label: 'Vai trò',
                      value: snapshot.creator.role,
                    ),
                    _PlayInfoRow(
                      label: 'Điểm uy tín',
                      value: '${snapshot.creator.trustScore}',
                    ),
                    if (snapshot.creator.fairPlayBadge)
                      const VitStatusPill(
                        label: 'Fair play',
                        status: VitStatusPillStatus.success,
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
                if (snapshot.rewardTiers.isNotEmpty)
                  _PlayInfoCard(
                    title: 'Bậc thưởng',
                    icon: Icons.emoji_events_outlined,
                    rows: [
                      for (final tier in snapshot.rewardTiers)
                        _PlayInfoRow(label: tier.label, value: tier.value),
                    ],
                  ),
                _PlayInfoCard(
                  title: 'Minh bạch',
                  icon: Icons.shield_outlined,
                  rows: [
                    _PlayInfoRow(
                      label: 'Điểm rõ ràng',
                      value: '${challenge.clarityScore}',
                    ),
                    _PlayInfoRow(
                      label: 'Rủi ro tin cậy',
                      value: challenge.trustRiskLabel,
                    ),
                    _PlayInfoRow(
                      label: 'Phiên bản chính sách',
                      value: challenge.policyVersion,
                    ),
                  ],
                ),
                VitCtaButton(
                  key: ArenaChallengeDetailTabletPage.joinCtaKey,
                  onPressed: () =>
                      context.push(AppRoutePaths.arenaJoin(widget.challengeId)),
                  child: const Text('Tham gia thử thách'),
                ),
                _ardQuickLinks(context, [
                  (
                    'Độ tin cậy người tạo',
                    AppRoutePaths.arenaTrust(snapshot.creator.id),
                  ),
                  ('Trung tâm phân xử', AppRoutePaths.arenaResolution),
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
                        challenge.title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontWeight: AppTextStyles.heavy,
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x2),
                      Text(
                        'Điểm vào ${challenge.entryPoints} · Tổng điểm giải ${challenge.prizePool}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                _PlayRuleList(rules: snapshot.rules),
                if (snapshot.rewardTiers.isNotEmpty)
                  _PlayInfoCard(
                    title: 'Bậc thưởng',
                    rows: [
                      for (final tier in snapshot.rewardTiers)
                        _PlayInfoRow(label: tier.label, value: tier.value),
                    ],
                  ),
                VitCtaButton(
                  key: ArenaChallengeDetailTabletPage.joinCtaKey,
                  onPressed: () =>
                      context.push(AppRoutePaths.arenaJoin(widget.challengeId)),
                  child: const Text('Tham gia thử thách'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPanel(ArenaChallengeDetailSnapshot snapshot) {
    return switch (_tab) {
      _PlayChallengeTab.rules => _PlayRuleList(rules: snapshot.rules),
      _PlayChallengeTab.evidence => VitCard(
        radius: VitCardRadius.tight,
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: TabletSpacingTokens.iconSm,
              color: AppModuleAccents.arena,
            ),
            const SizedBox(width: TabletSpacingTokens.x3),
            Expanded(
              child: Text(
                'Chưa có bằng chứng gửi từ thiết bị này. Kết quả chính dùng '
                'nguồn dữ liệu đối soát tự động và được ghi vào hồ sơ thử thách.',
                style: AppTextStyles.body.copyWith(color: AppColors.text1),
              ),
            ),
          ],
        ),
      ),
      _PlayChallengeTab.participants => _PlayListSection(
        title: 'Đội tham gia',
        itemCount: snapshot.teams.length,
        emptyMessage: 'Chưa có đội nào vào thử thách.',
        itemBuilder: (context, i) {
          final team = snapshot.teams[i];
          final color = team.accent == VitArenaTeamAccent.sol
              ? AppModuleAccents.arena
              : AppColors.sell;
          return ListTile(
            dense: true,
            leading: SizedBox(
              width: TabletSpacingTokens.iconMd,
              height: TabletSpacingTokens.iconMd,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color,
                  shape: const OvalBorder(),
                ),
                child: Center(
                  child: Text(
                    team.name.isEmpty ? '?' : team.name.characters.first,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.bg,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              team.name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            subtitle: Text(
              '${team.members.length} thành viên',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          );
        },
      ),
      _PlayChallengeTab.activity => _PlayListSection(
        title: 'Hoạt động gần đây',
        itemCount: snapshot.activity.length,
        emptyMessage: 'Chưa có hoạt động nào được ghi lại.',
        itemBuilder: (context, i) => ListTile(
          dense: true,
          leading: const Icon(Icons.timeline_outlined, color: AppColors.text3),
          title: Text(
            snapshot.activity[i],
            style: AppTextStyles.caption.copyWith(color: AppColors.text1),
          ),
        ),
      ),
    };
  }
}

// ---------------------------------------------------------------------------
// SC-191: Tham gia thử thách (luồng điểm — Financial Safety: preview đủ điều
// kiện + 2 lần xác nhận + sheet xác nhận trước khi vào).

class ArenaJoinTabletPage extends ConsumerStatefulWidget {
  const ArenaJoinTabletPage({super.key, required this.challengeId});

  static const contentKey = Key('sc191_tablet_content');
  static const rulesCheckboxKey = Key('sc191_tablet_rules_checkbox');
  static const pointsCheckboxKey = Key('sc191_tablet_points_checkbox');
  static const confirmKey = Key('sc191_tablet_confirm');
  static const declineKey = Key('sc191_tablet_decline');

  final String challengeId;

  @override
  ConsumerState<ArenaJoinTabletPage> createState() =>
      _ArenaJoinTabletPageState();
}

class _ArenaJoinTabletPageState extends ConsumerState<ArenaJoinTabletPage> {
  bool _readRules = false;
  bool _understandPoints = false;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      arenaJoinControllerProvider(widget.challengeId),
    );

    return controllerAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-191',
        semanticLabel: 'Vào thử thách',
        title: 'Tham gia',
        subtitle: widget.challengeId,
        contentKey: ArenaJoinTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được thông tin tham gia',
            () => ref.invalidate(arenaJoinSnapshotProvider(widget.challengeId)),
          ),
        ],
      ),
      data: (controller) => _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, ArenaJoinController controller) {
    final snapshot = controller.state.snapshot;
    final challenge = snapshot.challenge;
    final hasEnough = snapshot.currentBalance >= challenge.entryPoints;
    final remaining = snapshot.currentBalance - challenge.entryPoints;
    final canJoin = controller.canJoin(
      readRules: _readRules,
      understandPoints: _understandPoints,
    );
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticIdentifier: 'SC-191',
      semanticLabel: 'Xác nhận tham gia thử thách trong Open Arena',
      child: Column(
        children: [
          VitHeader(
            title: 'Tham gia thách đấu',
            subtitle: 'Xác nhận · Điểm Arena',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.arenaChallenge(
                      widget.challengeId,
                    ),
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: VitTabletPaneWorkspace(
              contentKey: ArenaJoinTabletPage.contentKey,
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
                              challenge.title,
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontWeight: AppTextStyles.heavy,
                                color: AppColors.text1,
                              ),
                            ),
                          ),
                          VitStatusPill(
                            label: _playChallengeStateLabel(challenge.state),
                            status: _playChallengeStatePill(challenge.state),
                            size: VitStatusPillSize.sm,
                          ),
                        ],
                      ),
                      if (challenge.description.isNotEmpty) ...[
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          challenge.description,
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
                              label: 'Điểm vào',
                              value: '${challenge.entryPoints}',
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
                                label: 'Tổng điểm giải',
                                value: '${challenge.prizePool}',
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
                                label: 'Đến lúc đóng',
                                value: challenge.countdownLabel,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _PlayRuleList(rules: snapshot.rules),
                VitCard(
                  radius: VitCardRadius.tight,
                  padding: TabletSpacingTokens.cardPaddingCompact,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.undo_outlined,
                        size: TabletSpacingTokens.iconSm,
                        color: AppColors.warn,
                      ),
                      const SizedBox(width: TabletSpacingTokens.x3),
                      Expanded(
                        child: Text(
                          snapshot.refundNotice,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _ardQuickLinks(context, [
                  ('Chính sách an toàn', AppRoutePaths.arenaSafety),
                ]),
              ],
              secondaryChildren: [
                _PlayInfoCard(
                  title: 'Số dư điểm',
                  icon: Icons.stars_outlined,
                  rows: [
                    _PlayInfoRow(
                      label: 'Điểm hiện có',
                      value: '${snapshot.currentBalance}',
                    ),
                    _PlayInfoRow(
                      label: 'Điểm vào',
                      value: '${challenge.entryPoints}',
                    ),
                    _PlayInfoRow(
                      label: 'Còn lại sau khi vào',
                      value: '$remaining',
                      color: hasEnough ? AppColors.text1 : AppColors.sell,
                    ),
                    if (!hasEnough)
                      const VitStatusPill(
                        label: 'Không đủ Điểm Arena',
                        status: VitStatusPillStatus.error,
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
                _PlayInfoCard(
                  title: 'Xác nhận bắt buộc',
                  icon: Icons.task_alt_outlined,
                  rows: [
                    _JoinAckRow(
                      key: ArenaJoinTabletPage.rulesCheckboxKey,
                      checked: _readRules,
                      label:
                          'Tôi đã đọc luật chơi và hiểu điều kiện của thử '
                          'thách này',
                      onTap: () => setState(() => _readRules = !_readRules),
                    ),
                    _JoinAckRow(
                      key: ArenaJoinTabletPage.pointsCheckboxKey,
                      checked: _understandPoints,
                      label:
                          'Tôi hiểu đây là Điểm Arena — không phải tài sản '
                          'tài chính và không thể rút ra ngoài',
                      onTap: () => setState(
                        () => _understandPoints = !_understandPoints,
                      ),
                    ),
                    Text(
                      _joinValidationMessage(
                        controller: controller,
                        hasEnough: hasEnough,
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: canJoin ? AppColors.text3 : AppColors.warn,
                      ),
                    ),
                  ],
                ),
                VitCtaButton(
                  key: ArenaJoinTabletPage.confirmKey,
                  onPressed: canJoin ? () => _confirmJoin(snapshot) : null,
                  child: const Text('Xác nhận tham gia'),
                ),
                VitCtaButton(
                  key: ArenaJoinTabletPage.declineKey,
                  onPressed: () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.arenaChallenge(
                      widget.challengeId,
                    ),
                    mode: BackNavigationMode.historyThenFallback,
                  ),
                  variant: VitCtaButtonVariant.secondary,
                  child: const Text('Quay lại'),
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
                        challenge.title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontWeight: AppTextStyles.heavy,
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x2),
                      Text(
                        'Điểm vào ${challenge.entryPoints} · Tổng điểm giải ${challenge.prizePool}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                _PlayInfoCard(
                  title: 'Số dư điểm',
                  rows: [
                    _PlayInfoRow(
                      label: 'Điểm hiện có',
                      value: '${snapshot.currentBalance}',
                    ),
                    _PlayInfoRow(
                      label: 'Điểm vào',
                      value: '${challenge.entryPoints}',
                    ),
                    _PlayInfoRow(
                      label: 'Còn lại sau khi vào',
                      value: '$remaining',
                      color: hasEnough ? AppColors.text1 : AppColors.sell,
                    ),
                  ],
                ),
                _PlayInfoCard(
                  title: 'Xác nhận bắt buộc',
                  rows: [
                    _JoinAckRow(
                      key: ArenaJoinTabletPage.rulesCheckboxKey,
                      checked: _readRules,
                      label:
                          'Tôi đã đọc luật chơi và hiểu điều kiện của thử '
                          'thách này',
                      onTap: () => setState(() => _readRules = !_readRules),
                    ),
                    _JoinAckRow(
                      key: ArenaJoinTabletPage.pointsCheckboxKey,
                      checked: _understandPoints,
                      label:
                          'Tôi hiểu đây là Điểm Arena — không phải tài sản '
                          'tài chính và không thể rút ra ngoài',
                      onTap: () => setState(
                        () => _understandPoints = !_understandPoints,
                      ),
                    ),
                  ],
                ),
                _PlayRuleList(rules: snapshot.rules),
                VitCard(
                  radius: VitCardRadius.tight,
                  padding: TabletSpacingTokens.cardPaddingCompact,
                  child: Text(
                    snapshot.refundNotice,
                    style: AppTextStyles.body.copyWith(color: AppColors.text1),
                  ),
                ),
                VitCtaButton(
                  key: ArenaJoinTabletPage.confirmKey,
                  onPressed: canJoin ? () => _confirmJoin(snapshot) : null,
                  child: const Text('Xác nhận tham gia'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _joinValidationMessage({
    required ArenaJoinController controller,
    required bool hasEnough,
  }) {
    if (controller.state.status.isBusy) {
      return 'Đang xử lý xác nhận trước đó — vui lòng đợi.';
    }
    if (!hasEnough) {
      return 'Không đủ Điểm Arena cho lượt vào này. Hoàn thành nhiệm vụ nhận '
          'điểm rồi quay lại.';
    }
    if (!_readRules) {
      return 'Vui lòng xác nhận đã đọc luật chơi.';
    }
    if (!_understandPoints) {
      return 'Vui lòng xác nhận hiểu về Điểm Arena.';
    }
    return 'Đã đủ điều kiện tham gia — bấm xác nhận để xem lại tổng kết.';
  }

  /// Bước xác nhận Financial Safety: sheet tổng kết điểm/hoàn phí/bước tiếp
  /// theo trước khi vào thử thách (cùng idiom `showVitConfirmSheet` của
  /// predictions SC-211).
  Future<void> _confirmJoin(ArenaJoinSnapshot snapshot) async {
    final challenge = snapshot.challenge;
    final remaining = snapshot.currentBalance - challenge.entryPoints;
    final confirmed = await showVitConfirmSheet(
      context: context,
      title: 'Xác nhận tham gia thử thách',
      rows: [
        VitConfirmDialogRow(label: 'Thử thách', value: challenge.title),
        VitConfirmDialogRow(
          label: 'Điểm vào',
          value: '${challenge.entryPoints}',
        ),
        VitConfirmDialogRow(
          label: 'Điểm hiện có',
          value: '${snapshot.currentBalance}',
        ),
        VitConfirmDialogRow(label: 'Còn lại sau khi vào', value: '$remaining'),
        VitConfirmDialogRow(
          label: 'Tổng điểm giải',
          value: '${challenge.prizePool}',
        ),
      ],
      message:
          'Điểm vào bị trừ ngay khi tham gia; huỷ trước hạn được hoàn theo '
          'chính sách. Điểm Arena không phải tài sản tài chính và không thể '
          'rút ra ngoài.',
      confirmLabel: 'Xác nhận vào thử thách',
      confirmKey: ArenaJoinTabletPage.confirmKey,
    );
    if (!confirmed || !mounted) return;
    unawaited(HapticFeedback.selectionClick());
    context.go(AppRoutePaths.arenaChallenge(widget.challengeId));
  }
}

class _JoinAckRow extends StatelessWidget {
  const _JoinAckRow({
    super.key,
    required this.checked,
    required this.label,
    required this.onTap,
  });

  final bool checked;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.xsRadius,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked ? Icons.check_box_outlined : Icons.check_box_outline_blank,
            size: TabletSpacingTokens.iconSm,
            color: checked ? AppModuleAccents.arena : AppColors.text3,
          ),
          const SizedBox(width: TabletSpacingTokens.x2),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
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
                title: creator.name,
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
                                  creator.name,
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
                      _PlayListSection(
                        title: 'Chế độ của người dựng',
                        itemCount: snapshot.modes.length,
                        itemBuilder: (context, i) {
                          final mode = snapshot.modes[i];
                          return ListTile(
                            dense: true,
                            title: Text(
                              mode.title,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                              ),
                            ),
                            subtitle: Text(
                              '${mode.activeChallenges} thách đấu đang mở',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_outlined,
                              color: AppColors.text3,
                            ),
                            onTap: () =>
                                context.push(AppRoutePaths.arenaMode(mode.id)),
                          );
                        },
                      ),
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
                            creator.name,
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
                    if (snapshot.aboutRows.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Thông tin',
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
