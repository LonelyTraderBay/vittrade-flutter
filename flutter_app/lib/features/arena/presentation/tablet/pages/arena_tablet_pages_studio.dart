part of 'arena_tablet_pages.dart';

// Cụm Studio (Đợt 2): SC-186 Smart rules form builder, SC-187 Preset
// library — workspace 2 cột gắn arenaCreationProvider.

// Cụm Studio (Đợt 2 redesign tablet Arena 2026-09-19): SC-186 Smart rules
// (form builder 2 cột gắn arenaCreationProvider), SC-187 Preset library,
// SC-188 Governance gate, SC-195 Verified challenges.

// ---------------------------------------------------------------------------
// Helper dùng chung cụm studio.

class _StudioCard extends StatelessWidget {
  const _StudioCard({required this.title, required this.child, this.icon});

  final String title;
  final Widget child;
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
              if (icon != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: TabletSpacingTokens.x2,
                  ),
                  child: Icon(
                    icon,
                    size: TabletSpacingTokens.iconSm,
                    color: AppColors.text2,
                  ),
                ),
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
          child,
        ],
      ),
    );
  }
}

class _StudioChipGroup extends StatelessWidget {
  const _StudioChipGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        Wrap(
          spacing: TabletSpacingTokens.x2,
          runSpacing: TabletSpacingTokens.x2,
          children: [
            for (final option in options)
              VitFilterChip(
                label: option,
                active: option == selected,
                color: AppModuleAccents.arena,
                onTap: () => onSelect(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _StudioOptionChips extends StatelessWidget {
  const _StudioOptionChips({
    required this.label,
    required this.options,
    required this.selectedId,
    required this.onSelect,
  });

  final String label;
  final List<ArenaSmartOptionDraft> options;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        Wrap(
          spacing: TabletSpacingTokens.x2,
          runSpacing: TabletSpacingTokens.x2,
          children: [
            for (final option in options)
              VitFilterChip(
                label: option.label,
                active: option.id == selectedId,
                color: AppModuleAccents.arena,
                onTap: () => onSelect(option.id),
              ),
          ],
        ),
      ],
    );
  }
}

class _StudioToggleRow extends StatelessWidget {
  const _StudioToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text1),
          ),
        ),
        VitTogglePill(
          enabled: value,
          onChanged: (_) => onChanged(!value),
          semanticLabel: label,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// SC-186: Đặt luật thông minh — form builder workspace.

class ArenaSmartRulesTabletPage extends ConsumerStatefulWidget {
  const ArenaSmartRulesTabletPage({super.key});

  static const contentKey = Key('sc186_tablet_content');
  static const submitKey = Key('sc186_tablet_submit');
  static const rulesAckKey = Key('sc186_tablet_rules_ack');

  @override
  ConsumerState<ArenaSmartRulesTabletPage> createState() =>
      _ArenaSmartRulesTabletPageState();
}

class _ArenaSmartRulesTabletPageState
    extends ConsumerState<ArenaSmartRulesTabletPage> {
  final _titleController = TextEditingController();
  final _customWinController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _title = '';
  String _domainId = '';
  String _challengeTypeId = '';
  String _subject = '';
  String _action = '';
  String _metric = '';
  String _winType = '';
  String _deadlineContext = '';
  String _customWinCondition = '';
  String _description = '';
  String _tieRule = '';
  String _voidRule = '';
  String _resultDeadline = '';
  bool _rematchEnabled = false;
  bool _saveAsMode = false;
  bool _ruleReviewAccepted = false;
  bool _pointsBoundaryAccepted = false;
  bool _moderationAccepted = false;
  String? _statusLabel;

  @override
  void dispose() {
    _titleController.dispose();
    _customWinController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  ArenaSmartRuleFormDraft _formDraft(String endDate) {
    return ArenaSmartRuleFormDraft(
      title: _title,
      domainId: _domainId,
      challengeTypeId: _challengeTypeId,
      subject: _subject,
      action: _action,
      metric: _metric,
      winType: _winType,
      deadlineContext: _deadlineContext,
      customWinCondition: _customWinCondition,
      description: _description,
      endDate: endDate,
      tieRule: _tieRule,
      voidRule: _voidRule,
      resultDeadline: _resultDeadline,
      rematchEnabled: _rematchEnabled,
      saveAsMode: _saveAsMode,
      ruleReviewAccepted: _ruleReviewAccepted,
      pointsBoundaryAccepted: _pointsBoundaryAccepted,
      moderationAccepted: _moderationAccepted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaSmartRulesSnapshotProvider);
    final creationState = ref.watch(arenaCreationProvider);
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 8)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-186',
        semanticLabel: 'Đặt luật thông minh trong Arena Studio',
        title: 'Đặt luật thông minh',
        subtitle: 'Arena Studio',
        contentKey: ArenaSmartRulesTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được trình đặt luật',
            () => ref.invalidate(arenaSmartRulesSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final ruleController = ArenaSmartRuleBuilderController(
          state: ArenaSmartRuleBuilderViewState(snapshot: snapshot),
        );
        final form = _formDraft(snapshot.defaultEndDate);
        final clarity = ruleController.clarityScore(form);
        final canProceed = ruleController.canProceed(form);
        final canSubmit = ruleController.canSubmit(form, clarity);

        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-186',
          semanticLabel: 'Đặt luật thông minh trong Arena Studio',
          child: Column(
            children: [
              VitHeader(
                title: 'Đặt luật thông minh',
                subtitle: 'Arena Studio · Điểm Arena',
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
                  contentKey: ArenaSmartRulesTabletPage.contentKey,
                  primaryChildren: [
                    _StudioCard(
                      title: 'Tên thử thách',
                      icon: Icons.label_outline,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          VitInput(
                            controller: _titleController,
                            label: 'Tên thử thách',
                            hintText: 'Tối thiểu 3 ký tự',
                            onChanged: (value) =>
                                setState(() => _title = value),
                          ),
                          if (snapshot.titleSuggestions.isNotEmpty) ...[
                            const SizedBox(height: TabletSpacingTokens.x3),
                            _StudioChipGroup(
                              label: 'Gợi ý tên',
                              options: snapshot.titleSuggestions,
                              selected: _title,
                              onSelect: (value) {
                                _titleController.value = TextEditingValue(
                                  text: value,
                                  selection: TextSelection.collapsed(
                                    offset: value.length,
                                  ),
                                );
                                setState(() => _title = value);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    _StudioCard(
                      title: 'Lĩnh vực & loại thử thách',
                      icon: Icons.category_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StudioOptionChips(
                            label: 'Lĩnh vực',
                            options: snapshot.domains,
                            selectedId: _domainId,
                            onSelect: (id) => setState(() => _domainId = id),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioOptionChips(
                            label: 'Loại thử thách',
                            options: snapshot.challengeTypes,
                            selectedId: _challengeTypeId,
                            onSelect: (id) =>
                                setState(() => _challengeTypeId = id),
                          ),
                        ],
                      ),
                    ),
                    _StudioCard(
                      title: 'Điều kiện thắng',
                      icon: Icons.rule_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StudioChipGroup(
                            label: 'Chủ thể',
                            options: snapshot.subjects,
                            selected: _subject,
                            onSelect: (v) => setState(() => _subject = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioChipGroup(
                            label: 'Hành động',
                            options: snapshot.actions,
                            selected: _action,
                            onSelect: (v) => setState(() => _action = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioChipGroup(
                            label: 'Chỉ số / đối tượng',
                            options: snapshot.metrics,
                            selected: _metric,
                            onSelect: (v) => setState(() => _metric = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioChipGroup(
                            label: 'Kiểu thắng',
                            options: snapshot.winTypes,
                            selected: _winType,
                            onSelect: (v) => setState(() => _winType = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioChipGroup(
                            label: 'Thời điểm kết quả',
                            options: snapshot.deadlineContexts,
                            selected: _deadlineContext,
                            onSelect: (v) =>
                                setState(() => _deadlineContext = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          VitInput(
                            controller: _customWinController,
                            label: 'Luật thắng tự viết (tuỳ chọn)',
                            hintText: 'Thay cho điều kiện có sẵn ở trên',
                            onChanged: (value) =>
                                setState(() => _customWinCondition = value),
                          ),
                          if (ruleController
                              .quickSuggestions(form)
                              .isNotEmpty) ...[
                            const SizedBox(height: TabletSpacingTokens.x3),
                            _StudioChipGroup(
                              label: 'Gợi ý nhanh theo lựa chọn',
                              options: ruleController.quickSuggestions(form),
                              selected: _customWinCondition,
                              onSelect: (value) {
                                _customWinController.value = TextEditingValue(
                                  text: value,
                                  selection: TextSelection.collapsed(
                                    offset: value.length,
                                  ),
                                );
                                setState(() => _customWinCondition = value);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    _StudioCard(
                      title: 'Mô tả & thời gian',
                      icon: Icons.schedule_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VitInput(
                            controller: _descriptionController,
                            label: 'Mô tả',
                            hintText: 'Ngữ cảnh cho người tham gia',
                            onChanged: (value) =>
                                setState(() => _description = value),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _PlayInfoRow(
                            label: 'Ngày kết thúc',
                            value: snapshot.defaultEndDate,
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioChipGroup(
                            label: 'Luật hoà',
                            options: snapshot.tieRules,
                            selected: _tieRule,
                            onSelect: (v) => setState(() => _tieRule = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioChipGroup(
                            label: 'Luật huỷ',
                            options: snapshot.voidRules,
                            selected: _voidRule,
                            onSelect: (v) => setState(() => _voidRule = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioChipGroup(
                            label: 'Hạn chốt kết quả',
                            options: snapshot.resultDeadlines,
                            selected: _resultDeadline,
                            onSelect: (v) =>
                                setState(() => _resultDeadline = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioToggleRow(
                            label: 'Bật tái đấu (rematch)',
                            value: _rematchEnabled,
                            onChanged: (v) =>
                                setState(() => _rematchEnabled = v),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x2),
                          _StudioToggleRow(
                            label: 'Lưu thành chế độ dùng lại',
                            value: _saveAsMode,
                            onChanged: (v) => setState(() => _saveAsMode = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                  secondaryChildren: [
                    _PlayInfoCard(
                      title: 'Điểm rõ ràng',
                      icon: Icons.speed_outlined,
                      rows: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$clarity/100',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  fontWeight: AppTextStyles.heavy,
                                  color: clarity >= 35
                                      ? AppColors.buy
                                      : AppColors.warn,
                                ),
                              ),
                            ),
                            VitStatusPill(
                              label: canSubmit
                                  ? 'Sẵn sàng gửi duyệt'
                                  : (canProceed
                                        ? 'Đủ điều kiện tiếp tục'
                                        : 'Chưa đủ lõi'),
                              status: canSubmit
                                  ? VitStatusPillStatus.success
                                  : (canProceed
                                        ? VitStatusPillStatus.info
                                        : VitStatusPillStatus.warning),
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ],
                    ),
                    _PlayInfoCard(
                      title: 'Tóm tắt luật',
                      icon: Icons.summarize_outlined,
                      rows: [
                        _PlayInfoRow(
                          label: 'Lĩnh vực',
                          value:
                              ruleController.selectedDomain(form)?.label ?? '—',
                        ),
                        _PlayInfoRow(
                          label: 'Loại',
                          value:
                              ruleController
                                  .selectedChallengeType(form)
                                  ?.label ??
                              '—',
                        ),
                        _PlayInfoRow(
                          label: 'Điều kiện thắng',
                          value: ruleController.generatedWinCondition(form),
                        ),
                        _PlayInfoRow(
                          label: 'Kết thúc',
                          value: snapshot.defaultEndDate,
                        ),
                        _PlayInfoRow(
                          label: 'Luật hoà',
                          value: _tieRule.isEmpty ? '—' : _tieRule,
                        ),
                        _PlayInfoRow(
                          label: 'Luật huỷ',
                          value: _voidRule.isEmpty ? '—' : _voidRule,
                        ),
                      ],
                    ),
                    _PlayInfoCard(
                      title: 'Xác nhận bắt buộc trước gửi',
                      icon: Icons.task_alt_outlined,
                      rows: [
                        _JoinAckRow(
                          key: ArenaSmartRulesTabletPage.rulesAckKey,
                          checked: _ruleReviewAccepted,
                          label: 'Tôi đã rà soát luật và điều kiện thắng',
                          onTap: () => setState(
                            () => _ruleReviewAccepted = !_ruleReviewAccepted,
                          ),
                        ),
                        _JoinAckRow(
                          checked: _pointsBoundaryAccepted,
                          label:
                              'Tôi hiểu thử thách chỉ dùng Điểm Arena, '
                              'không phải tài sản tài chính',
                          onTap: () => setState(
                            () => _pointsBoundaryAccepted =
                                !_pointsBoundaryAccepted,
                          ),
                        ),
                        _JoinAckRow(
                          checked: _moderationAccepted,
                          label:
                              'Tôi chấp nhận quy trình kiểm duyệt và phân '
                              'xử của Arena',
                          onTap: () => setState(
                            () => _moderationAccepted = !_moderationAccepted,
                          ),
                        ),
                      ],
                    ),
                    _PlayInfoCard(
                      title: 'Trạng thái máy tạo thử thách',
                      icon: Icons.sync_outlined,
                      rows: [
                        _PlayInfoRow(
                          label: 'Giai đoạn',
                          value: creationState.phase.name,
                        ),
                        if (creationState.statusLabel != null)
                          _PlayInfoRow(
                            label: 'Thông báo',
                            value: creationState.statusLabel!,
                          ),
                        if (_statusLabel != null)
                          _PlayInfoRow(label: 'Form', value: _statusLabel!),
                        if (creationState.previewDraft != null)
                          _PlayInfoRow(
                            label: 'Payload xem trước',
                            value: creationState.previewDraft!.winCondition,
                          ),
                      ],
                    ),
                    VitCtaButton(
                      key: ArenaSmartRulesTabletPage.submitKey,
                      onPressed: canSubmit
                          ? () => _submitForReview(ruleController, form)
                          : null,
                      child: const Text('Gửi duyệt thử thách'),
                    ),
                    VitCtaButton(
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () => _previewPayload(ruleController, form),
                      child: const Text('Xem trước payload'),
                    ),
                    VitCtaButton(
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () => _saveDraft(ruleController, form),
                      child: const Text('Lưu bản nháp'),
                    ),
                    VitCtaButton(
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () {
                        setState(() {
                          _statusLabel = canProceed
                              ? 'Luật đã hoàn chỉnh'
                              : ruleController.missingCoreRequirement(form);
                        });
                      },
                      child: const Text('Kiểm tra luật'),
                    ),
                    VitCtaButton(
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: _resetForm,
                      child: const Text('Làm mới form'),
                    ),
                  ],
                  narrowChildren: [
                    _StudioCard(
                      title: 'Tên thử thách',
                      child: VitInput(
                        controller: _titleController,
                        label: 'Tên thử thách',
                        hintText: 'Tối thiểu 3 ký tự',
                        onChanged: (value) => setState(() => _title = value),
                      ),
                    ),
                    _StudioCard(
                      title: 'Lĩnh vực & loại thử thách',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StudioOptionChips(
                            label: 'Lĩnh vực',
                            options: snapshot.domains,
                            selectedId: _domainId,
                            onSelect: (id) => setState(() => _domainId = id),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          _StudioOptionChips(
                            label: 'Loại thử thách',
                            options: snapshot.challengeTypes,
                            selectedId: _challengeTypeId,
                            onSelect: (id) =>
                                setState(() => _challengeTypeId = id),
                          ),
                        ],
                      ),
                    ),
                    _PlayRuleList(
                      rules: [
                        'Chủ thể: ${_subject.isEmpty ? '—' : _subject}',
                        'Hành động: ${_action.isEmpty ? '—' : _action}',
                        'Chỉ số: ${_metric.isEmpty ? '—' : _metric}',
                        'Điều kiện thắng: ${ruleController.generatedWinCondition(form)}',
                      ],
                    ),
                    VitCtaButton(
                      key: ArenaSmartRulesTabletPage.submitKey,
                      onPressed: canSubmit
                          ? () => _submitForReview(ruleController, form)
                          : null,
                      child: const Text('Gửi duyệt thử thách'),
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

  void _previewPayload(
    ArenaSmartRuleBuilderController ruleController,
    ArenaSmartRuleFormDraft form,
  ) {
    final draft = ruleController.buildCreationDraft(
      form,
      ruleController.clarityScore(form),
    );
    final result = ref.read(arenaCreationProvider.notifier).preview(draft);
    setState(() => _statusLabel = result.statusLabel);
  }

  void _saveDraft(
    ArenaSmartRuleBuilderController ruleController,
    ArenaSmartRuleFormDraft form,
  ) {
    final draft = ruleController.buildCreationDraft(
      form,
      ruleController.clarityScore(form),
    );
    final result = ref.read(arenaCreationProvider.notifier).saveDraft(draft);
    setState(() => _statusLabel = result.statusLabel);
  }

  Future<void> _submitForReview(
    ArenaSmartRuleBuilderController ruleController,
    ArenaSmartRuleFormDraft form,
  ) async {
    final draft = ruleController.buildCreationDraft(
      form,
      ruleController.clarityScore(form),
    );
    final errors = draft.submitValidationErrors();
    if (errors.isNotEmpty) {
      setState(() => _statusLabel = errors.first);
      return;
    }
    final confirmed = await showVitConfirmSheet(
      context: context,
      title: 'Gửi duyệt thử thách',
      rows: [
        VitConfirmDialogRow(label: 'Tên', value: draft.title),
        VitConfirmDialogRow(label: 'Lĩnh vực', value: draft.domainLabel),
        VitConfirmDialogRow(label: 'Loại', value: draft.challengeTypeLabel),
        VitConfirmDialogRow(
          label: 'Điều kiện thắng',
          value: draft.winCondition,
        ),
        VitConfirmDialogRow(label: 'Kết thúc', value: draft.endDate),
        VitConfirmDialogRow(
          label: 'Điểm rõ ràng',
          value: '${draft.clarityScore}',
        ),
      ],
      message:
          'Sau khi gửi duyệt, thử thách vào hàng chờ kiểm duyệt của Arena. '
          'Thử thách chỉ dùng Điểm Arena — không phải tài sản tài chính.',
      confirmLabel: 'Gửi duyệt',
      confirmKey: ArenaSmartRulesTabletPage.submitKey,
    );
    if (!confirmed || !mounted) return;
    unawaited(HapticFeedback.selectionClick());
    final result = ref
        .read(arenaCreationProvider.notifier)
        .submitForReview(draft);
    setState(() => _statusLabel = result.statusLabel);
    if (result.ok) {
      context.go(AppRoutePaths.arenaMy);
    }
  }

  void _resetForm() {
    _titleController.clear();
    _customWinController.clear();
    _descriptionController.clear();
    setState(() {
      _title = '';
      _domainId = '';
      _challengeTypeId = '';
      _subject = '';
      _action = '';
      _metric = '';
      _winType = '';
      _deadlineContext = '';
      _customWinCondition = '';
      _description = '';
      _tieRule = '';
      _voidRule = '';
      _resultDeadline = '';
      _rematchEnabled = false;
      _saveAsMode = false;
      _ruleReviewAccepted = false;
      _pointsBoundaryAccepted = false;
      _moderationAccepted = false;
      _statusLabel = 'Đã làm mới form';
    });
  }
}

// ---------------------------------------------------------------------------
// SC-187: Thư viện preset dùng lại.

class ArenaPresetLibraryTabletPage extends ConsumerStatefulWidget {
  const ArenaPresetLibraryTabletPage({super.key});

  static const contentKey = Key('sc187_tablet_content');

  @override
  ConsumerState<ArenaPresetLibraryTabletPage> createState() =>
      _ArenaPresetLibraryTabletPageState();
}

class _ArenaPresetLibraryTabletPageState
    extends ConsumerState<ArenaPresetLibraryTabletPage> {
  String? _selectedPackId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaPresetLibrarySnapshotProvider);
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-187',
        semanticLabel: 'Thư viện preset dùng lại',
        title: 'Thư viện preset',
        subtitle: 'Arena Studio',
        contentKey: ArenaPresetLibraryTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được thư viện preset',
            () => ref.invalidate(arenaPresetLibrarySnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final selectedId = snapshot.domainPacks.isNotEmpty
            ? (_selectedPackId ?? snapshot.domainPacks.first.id)
            : '';
        final pack = snapshot.domainPacks.firstWhere(
          (p) => p.id == selectedId,
          orElse: () => snapshot.domainPacks.first,
        );
        final suggestions = snapshot.suggestionsByDomain[pack.id] ?? const [];
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticIdentifier: 'SC-187',
          semanticLabel: 'Thư viện preset dùng lại',
          child: Column(
            children: [
              VitHeader(
                title: 'Thư viện preset',
                subtitle: 'Chuẩn hoá theo lĩnh vực · Arena Studio',
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
                  contentKey: ArenaPresetLibraryTabletPage.contentKey,
                  primaryChildren: [
                    _StudioCard(
                      title: 'Gói preset theo lĩnh vực',
                      icon: Icons.folder_special_outlined,
                      child: Wrap(
                        spacing: TabletSpacingTokens.x2,
                        runSpacing: TabletSpacingTokens.x2,
                        children: [
                          for (final p in snapshot.domainPacks)
                            VitFilterChip(
                              label: p.title,
                              active: p.id == selectedId,
                              color: AppModuleAccents.arena,
                              onTap: () =>
                                  setState(() => _selectedPackId = p.id),
                            ),
                        ],
                      ),
                    ),
                    _StudioCard(
                      title: pack.title,
                      icon: Icons.auto_awesome_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pack.description,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          Text(
                            'Loại thử thách hỗ trợ',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x2),
                          Wrap(
                            spacing: TabletSpacingTokens.x2,
                            runSpacing: TabletSpacingTokens.x2,
                            children: [
                              for (final type in pack.supportedTypes)
                                VitStatusPill(
                                  label: type,
                                  status: VitStatusPillStatus.info,
                                  size: VitStatusPillSize.sm,
                                ),
                            ],
                          ),
                          if (pack.examples.isNotEmpty) ...[
                            const SizedBox(height: TabletSpacingTokens.x3),
                            Text(
                              'Ví dụ:',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                            const SizedBox(height: TabletSpacingTokens.x2),
                            for (final example in pack.examples)
                              Padding(
                                padding: TabletSpacingTokens.tableCellPaddingV,
                                child: VitBulletRow(text: example),
                              ),
                          ],
                        ],
                      ),
                    ),
                    if (snapshot.demoFlows.isNotEmpty)
                      _PlayListSection(
                        title: 'Luật mẫu theo lĩnh vực',
                        itemCount: snapshot.demoFlows.length,
                        itemBuilder: (context, i) {
                          final flow = snapshot.demoFlows[i];
                          return ListTile(
                            dense: true,
                            title: Text(
                              '${flow.domainLabel} · ${flow.typeLabel}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            subtitle: Text(
                              flow.generatedRule,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                  secondaryChildren: [
                    if (suggestions.isNotEmpty)
                      _StudioCard(
                        title: 'Gợi ý preset · ${pack.title}',
                        icon: Icons.lightbulb_outline,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < suggestions.length; i++) ...[
                              Text(
                                suggestions[i].text,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                ),
                              ),
                              if (i < suggestions.length - 1)
                                const SizedBox(height: TabletSpacingTokens.x2),
                            ],
                          ],
                        ),
                      ),
                    if (snapshot.sections.isNotEmpty)
                      _PlayInfoCard(
                        title: 'Nhóm preset chuẩn',
                        icon: Icons.category_outlined,
                        rows: [
                          for (final section in snapshot.sections)
                            _PlayInfoRow(label: section.label, value: ''),
                        ],
                      ),
                    VitCtaButton(
                      onPressed: () =>
                          context.push(AppRoutePaths.arenaStudioSmartRules),
                      child: const Text('Dùng preset trong Studio'),
                    ),
                  ],
                  narrowChildren: [
                    _StudioCard(
                      title: 'Gói preset theo lĩnh vực',
                      child: Wrap(
                        spacing: TabletSpacingTokens.x2,
                        runSpacing: TabletSpacingTokens.x2,
                        children: [
                          for (final p in snapshot.domainPacks)
                            VitFilterChip(
                              label: p.title,
                              active: p.id == selectedId,
                              color: AppModuleAccents.arena,
                              onTap: () =>
                                  setState(() => _selectedPackId = p.id),
                            ),
                        ],
                      ),
                    ),
                    _StudioCard(
                      title: pack.title,
                      child: Text(
                        pack.description,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                    VitCtaButton(
                      onPressed: () =>
                          context.push(AppRoutePaths.arenaStudioSmartRules),
                      child: const Text('Dùng preset trong Studio'),
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
