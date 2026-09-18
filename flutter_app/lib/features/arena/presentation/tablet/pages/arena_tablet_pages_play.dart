part of 'arena_tablet_pages.dart';

// Cụm Play (Đợt 1 redesign tablet Arena 2026-09-19): SC-190 Challenge
// detail, SC-191 Join — re-compose từ phone theo workspace 2 cột.
// ---------------------------------------------------------------------------
// SC-190: Chi tiết thử thách.

const List<(String, String, IconData)> _playChallengeTabs = [
  ('rules', 'Luật chơi', Icons.menu_book_outlined),
  ('evidence', 'Bằng chứng', Icons.camera_alt_outlined),
  ('participants', 'Thành viên', Icons.groups_2_outlined),
  ('activity', 'Hoạt động', Icons.timeline_outlined),
];

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
  String _tab = 'rules';

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
                  activeKey: _tab,
                  onChanged: (key) => setState(() => _tab = key),
                  tabs: [
                    for (final (key, label, icon) in _playChallengeTabs)
                      VitTabItem(key: key, label: label, icon: icon),
                  ],
                ),
                _buildTabPanel(snapshot),
              ],
              secondaryChildren: [
                _PlayInfoCard(
                  title: 'Người tạo thử thách',
                  icon: Icons.person_outline,
                  rows: [
                    _PlayInfoRow(
                      label: 'Tên',
                      value: switch (snapshot.creator) {
                        ArenaChallengeCreatorDraft(:final name) => name,
                      },
                    ),
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
      'rules' => _PlayRuleList(rules: snapshot.rules),
      'evidence' => VitCard(
        radius: VitCardRadius.tight,
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.only(end: TabletSpacingTokens.x3),
              child: Icon(
                Icons.camera_alt_outlined,
                size: TabletSpacingTokens.iconSm,
                color: AppModuleAccents.arena,
              ),
            ),
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
      'participants' => _PlayListSection(
        title: 'Đội tham gia',
        itemCount: snapshot.teams.length,
        emptyMessage: 'Chưa có đội nào vào thử thách.',
        itemBuilder: (context, i) {
          final team = snapshot.teams[i];
          final ArenaTeamDraft(:name) = team;
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
                    name.isEmpty ? '?' : name.characters.first,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.bg,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              name,
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
      _ => _PlayListSection(
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
                      const Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: TabletSpacingTokens.x3,
                        ),
                        child: Icon(
                          Icons.undo_outlined,
                          size: TabletSpacingTokens.iconSm,
                          color: AppColors.warn,
                        ),
                      ),
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
      borderRadius: AppRadii.smRadius,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: TabletSpacingTokens.x2,
            ),
            child: Icon(
              checked
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              size: TabletSpacingTokens.iconSm,
              color: checked ? AppModuleAccents.arena : AppColors.text3,
            ),
          ),
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
