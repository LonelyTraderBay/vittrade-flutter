part of 'arena_tablet_pages.dart';

// Cổng quản trị & thử thách đã xác minh (tách từ _studio theo vai trò
// gate): SC-188 Governance gate, SC-195 Verified.

// ---------------------------------------------------------------------------
// SC-188: Cổng quản trị (governance gate).

class ArenaGovernanceGateTabletPage extends ConsumerStatefulWidget {
  const ArenaGovernanceGateTabletPage({super.key});

  static const contentKey = Key('sc188_tablet_content');
  static const actionKey = Key('sc188_tablet_action');

  @override
  ConsumerState<ArenaGovernanceGateTabletPage> createState() =>
      _ArenaGovernanceGateTabletPageState();
}

class _ArenaGovernanceGateTabletPageState
    extends ConsumerState<ArenaGovernanceGateTabletPage> {
  String _privacyId = '';
  String _resolutionSource = '';
  String _statusLabel = '';

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(arenaGovernanceControllerProvider);
    final showBack = context.canPop();

    return controllerAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-188',
        semanticLabel: 'Cổng quản trị thử thách',
        title: 'Cổng quản trị',
        subtitle: 'Quyền riêng tư · Đối soát',
        contentKey: ArenaGovernanceGateTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được cổng quản trị',
            () => ref.invalidate(arenaGovernanceSnapshotProvider),
          ),
        ],
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final canProceed =
            _privacyId.isNotEmpty && _resolutionSource.isNotEmpty;
        final action = controller.actionState(
          canProceed: canProceed,
          nextAction: 'Gửi duyệt quản trị',
        );
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-188',
          semanticLabel: 'Cổng quản trị thử thách',
          child: Column(
            children: [
              VitHeader(
                title: 'Cổng quản trị',
                subtitle: 'Quyền riêng tư · Nguồn đối soát · Xuất bản',
                showBack: showBack,
                onBack: showBack
                    ? () => goBackOrFallback(
                        context,
                        fallbackPath: AppRoutePaths.arenaStudio,
                        mode: BackNavigationMode.historyThenFallback,
                      )
                    : null,
              ),
              Expanded(
                child: VitTabletPaneWorkspace(
                  contentKey: ArenaGovernanceGateTabletPage.contentKey,
                  primaryChildren: [
                    _StudioCard(
                      title: 'Quyền riêng tư của thử thách',
                      icon: Icons.lock_outline,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (
                            var i = 0;
                            i < snapshot.privacyOptions.length;
                            i++
                          ) ...[
                            InkWell(
                              borderRadius: AppRadii.smRadius,
                              onTap: () => setState(
                                () =>
                                    _privacyId = snapshot.privacyOptions[i].id,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      end: TabletSpacingTokens.x2,
                                    ),
                                    child: Icon(
                                      _privacyId ==
                                              snapshot.privacyOptions[i].id
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      size: TabletSpacingTokens.iconSm,
                                      color:
                                          _privacyId ==
                                              snapshot.privacyOptions[i].id
                                          ? AppModuleAccents.arena
                                          : AppColors.text3,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.privacyOptions[i].label,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.text1,
                                            fontWeight: AppTextStyles.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: TabletSpacingTokens.x1,
                                        ),
                                        Text(
                                          snapshot
                                              .privacyOptions[i]
                                              .description,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.text3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i < snapshot.privacyOptions.length - 1)
                              const SizedBox(height: TabletSpacingTokens.x3),
                          ],
                        ],
                      ),
                    ),
                    _StudioCard(
                      title: 'Nguồn đối soát kết quả',
                      icon: Icons.fact_check_outlined,
                      child: _StudioChipGroup(
                        label: 'Chọn nguồn chính',
                        options: snapshot.resolutionSources,
                        selected: _resolutionSource,
                        onSelect: (v) => setState(() => _resolutionSource = v),
                      ),
                    ),
                    _PlayInfoCard(
                      title: 'Bộ quy tắc quản trị hiện hành',
                      icon: Icons.policy_outlined,
                      rows: [
                        _PlayInfoRow(
                          label: 'Lĩnh vực',
                          value: '${snapshot.domains.length} lựa chọn',
                        ),
                        _PlayInfoRow(
                          label: 'Loại thử thách',
                          value: '${snapshot.challengeTypes.length} lựa chọn',
                        ),
                        _PlayInfoRow(
                          label: 'Luật hoà / huỷ',
                          value:
                              '${snapshot.tieRules.length} / ${snapshot.voidRules.length} phương án',
                        ),
                        _PlayInfoRow(
                          label: 'Hạn kết quả',
                          value: '${snapshot.resultDeadlines.length} phương án',
                        ),
                        _PlayInfoRow(
                          label: 'Ngày kết thúc mặc định',
                          value: snapshot.defaultEndDate,
                        ),
                      ],
                    ),
                  ],
                  secondaryChildren: [
                    _PlayInfoCard(
                      title: 'Trạng thái cổng',
                      icon: Icons.verified_outlined,
                      rows: [
                        _PlayInfoRow(
                          label: 'Quyền riêng tư',
                          value: _privacyId.isEmpty
                              ? 'Chưa chọn'
                              : snapshot.privacyOptions
                                    .firstWhere((o) => o.id == _privacyId)
                                    .label,
                        ),
                        _PlayInfoRow(
                          label: 'Nguồn đối soát',
                          value: _resolutionSource.isEmpty
                              ? 'Chưa chọn'
                              : _resolutionSource,
                        ),
                        VitStatusPill(
                          label: action.footerLabel,
                          status: canProceed
                              ? VitStatusPillStatus.success
                              : VitStatusPillStatus.warning,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    Text(
                      action.boundaryNote,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    if (_statusLabel.isNotEmpty)
                      Text(
                        _statusLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    VitCtaButton(
                      key: ArenaGovernanceGateTabletPage.actionKey,
                      onPressed: canProceed
                          ? () => _submitGovernance(controller, canProceed)
                          : null,
                      child: const Text('Gửi duyệt quản trị'),
                    ),
                  ],
                  narrowChildren: [
                    _StudioCard(
                      title: 'Quyền riêng tư của thử thách',
                      child: _StudioChipGroup(
                        label: 'Chọn quyền riêng tư',
                        options: [
                          for (final option in snapshot.privacyOptions)
                            option.label,
                        ],
                        selected: _privacyId.isEmpty
                            ? ''
                            : snapshot.privacyOptions
                                  .firstWhere((o) => o.id == _privacyId)
                                  .label,
                        onSelect: (label) => setState(
                          () => _privacyId = snapshot.privacyOptions
                              .firstWhere((o) => o.label == label)
                              .id,
                        ),
                      ),
                    ),
                    _StudioCard(
                      title: 'Nguồn đối soát kết quả',
                      child: _StudioChipGroup(
                        label: 'Chọn nguồn chính',
                        options: snapshot.resolutionSources,
                        selected: _resolutionSource,
                        onSelect: (v) => setState(() => _resolutionSource = v),
                      ),
                    ),
                    VitCtaButton(
                      key: ArenaGovernanceGateTabletPage.actionKey,
                      onPressed: canProceed
                          ? () => _submitGovernance(controller, canProceed)
                          : null,
                      child: const Text('Gửi duyệt quản trị'),
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

  Future<void> _submitGovernance(
    ArenaGovernanceController controller,
    bool canProceed,
  ) async {
    final message = controller.validationMessage(canProceed: canProceed);
    if (message != null) {
      setState(() => _statusLabel = 'Cần hoàn thành: $message');
      return;
    }
    final confirmed = await showVitConfirmSheet(
      context: context,
      title: 'Gửi duyệt quản trị',
      rows: [
        VitConfirmDialogRow(
          label: 'Quyền riêng tư',
          value: _privacyId.isEmpty ? '—' : _privacyId,
        ),
        VitConfirmDialogRow(
          label: 'Nguồn đối soát',
          value: _resolutionSource.isEmpty ? '—' : _resolutionSource,
        ),
      ],
      message:
          'Quản trị Arena chỉ xem xét luật, tiến độ hoàn thành, fair play và '
          'Điểm Arena.',
      confirmLabel: 'Xác nhận gửi',
      confirmKey: ArenaGovernanceGateTabletPage.actionKey,
    );
    if (!confirmed || !mounted) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _statusLabel = 'Đã gửi duyệt quản trị');
  }
}

// ---------------------------------------------------------------------------
// SC-195: Thử thách đã xác minh.

class VerifiedChallengesTabletPage extends ConsumerWidget {
  const VerifiedChallengesTabletPage({super.key});

  static const contentKey = Key('sc195_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(verifiedChallengesSnapshotProvider);
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-195',
        semanticLabel: 'Thử thách đã xác minh',
        title: 'Đã xác minh',
        subtitle: 'Open Arena',
        contentKey: VerifiedChallengesTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được thử thách đã xác minh',
            () => ref.invalidate(verifiedChallengesSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticIdentifier: 'SC-195',
        semanticLabel: 'Thử thách đã xác minh',
        child: Column(
          children: [
            VitHeader(
              title: 'Thử thách đã xác minh',
              subtitle: snapshot.subtitle,
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
                contentKey: VerifiedChallengesTabletPage.contentKey,
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
                                snapshot.title,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  fontWeight: AppTextStyles.heavy,
                                  color: AppColors.text1,
                                ),
                              ),
                            ),
                            VitStatusPill(
                              label: snapshot.statusLabel,
                              status: VitStatusPillStatus.success,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          snapshot.infoTitle,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _PlayListSection(
                    title: 'Đặc điểm xác minh',
                    itemCount: snapshot.features.length,
                    itemBuilder: (context, i) {
                      final feature = snapshot.features[i];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          _verifiedFeatureIcon(feature.kind),
                          color: AppModuleAccents.arena,
                        ),
                        title: Text(
                          feature.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        subtitle: Text(
                          _verifiedFeatureLabel(feature.kind),
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                secondaryChildren: [
                  _PlayInfoCard(
                    title: 'Vì sao quan trọng',
                    icon: Icons.help_outline,
                    rows: [
                      _PlayInfoRow(
                        label: 'Trạng thái',
                        value: snapshot.statusLabel,
                      ),
                      _PlayInfoRow(
                        label: 'Số đặc điểm',
                        value: '${snapshot.features.length}',
                      ),
                    ],
                  ),
                  _ardQuickLinks(context, [
                    ('Bảng xếp hạng', AppRoutePaths.arenaLeaderboard),
                    ('Về hub Open Arena', AppRoutePaths.arena),
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
                          snapshot.title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: AppTextStyles.heavy,
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          snapshot.infoTitle,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _PlayListSection(
                    title: 'Đặc điểm xác minh',
                    itemCount: snapshot.features.length,
                    itemBuilder: (context, i) {
                      final feature = snapshot.features[i];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          _verifiedFeatureIcon(feature.kind),
                          color: AppModuleAccents.arena,
                        ),
                        title: Text(
                          feature.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
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
      ),
    );
  }
}

IconData _verifiedFeatureIcon(VerifiedChallengeFeatureKind kind) {
  return switch (kind) {
    VerifiedChallengeFeatureKind.oracle => Icons.fact_check_outlined,
    VerifiedChallengeFeatureKind.escrow =>
      Icons.account_balance_wallet_outlined,
    VerifiedChallengeFeatureKind.leaderboard => Icons.leaderboard_outlined,
    VerifiedChallengeFeatureKind.trust => Icons.verified_user_outlined,
  };
}

String _verifiedFeatureLabel(VerifiedChallengeFeatureKind kind) {
  return switch (kind) {
    VerifiedChallengeFeatureKind.oracle => 'Nguồn đối soát',
    VerifiedChallengeFeatureKind.escrow => 'Ky quỹ điểm',
    VerifiedChallengeFeatureKind.leaderboard => 'Bảng xếp hạng',
    VerifiedChallengeFeatureKind.trust => 'Uy tín',
  };
}
