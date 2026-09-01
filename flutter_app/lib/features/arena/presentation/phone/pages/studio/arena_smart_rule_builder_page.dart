import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_date_format.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/governance/arena_governance_gate_stepper_title.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../../../widgets/studio/arena_smart_rule_builder_page_basics_fields.dart';
part '../../../widgets/studio/arena_smart_rule_builder_page_condition_timing_fields.dart';
part 'arena_smart_rule_builder_page_review_submit.dart';

const _arenaAccent = AppModuleAccents.arena;
final double _smartRuleActionExtent = VitDensity.compact.controlHeight;
const _smartRuleBodyLineRatio = ArenaSpacingTokens.arenaSmartRuleBodyLineHeight;
const _smartRuleSubtitleLineRatio =
    ArenaSpacingTokens.arenaSmartRuleSubtitleLineHeight;

class ArenaSmartRuleBuilderPage extends ConsumerStatefulWidget {
  const ArenaSmartRuleBuilderPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc186_smart_rule_content');
  static const titleKey = Key('sc186_title');
  static const domainKey = Key('sc186_domain');
  static const subjectKey = Key('sc186_subject');
  static const actionKey = Key('sc186_action');
  static const metricKey = Key('sc186_metric');
  static const winTypeKey = Key('sc186_win_type');
  static const deadlineContextKey = Key('sc186_deadline_context');
  static const tieRuleKey = Key('sc186_tie_rule');
  static const voidRuleKey = Key('sc186_void_rule');
  static const resultDeadlineKey = Key('sc186_result_deadline');
  static const continueKey = Key('sc186_continue');
  static const previewKey = Key('sc186_preview_payload');
  static const submitKey = Key('sc186_submit_review');
  static const confirmSubmitKey = Key('sc186_confirm_submit');
  static const saveKey = Key('sc186_save');
  static const resetKey = Key('sc186_reset');
  static const guidanceKey = Key('sc186_guidance');
  static const rulesAckKey = Key('sc186_rules_ack');
  static const pointsAckKey = Key('sc186_points_ack');
  static const moderationAckKey = Key('sc186_moderation_ack');

  static Key challengeTypeKey(String id) => Key('sc186_type_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaSmartRuleBuilderPage> createState() =>
      _ArenaSmartRuleBuilderPageState();
}

class _ArenaSmartRuleBuilderPageState
    extends ConsumerState<ArenaSmartRuleBuilderPage> {
  final _titleController = TextEditingController();
  final _customWinController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _endDateController = TextEditingController();

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
  late String _endDate;
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
  void initState() {
    super.initState();
    _endDate = _defaultArenaRuleEndDate();
    _endDateController.text = formatArenaDateInput(_endDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _customWinController.dispose();
    _descriptionController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaSmartRulesSnapshotProvider);
    final creationState = ref.watch(arenaCreationProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x7 + AppSpacing.x7,
      nativeExtra: AppSpacing.x7 + AppSpacing.x7,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Đặt luật thử thách - bước xây dựng luật trong Arena Studio',
      semanticIdentifier: 'SC-186',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Arena Studio',
            subtitle: 'Đặt luật · Points only',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ArenaSmartRuleBuilderPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                    footerPadding,
                  ),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.tight,
                    children: snapshotAsync.when(
                      loading: () => const [VitSkeletonList()],
                      error: (error, stackTrace) => [
                        VitErrorState(
                          title: 'Không tải được Smart Rule Builder',
                          message: 'Vui lòng kiểm tra kết nối và thử lại.',
                          actionLabel: 'Thử lại',
                          onAction: () =>
                              ref.invalidate(arenaSmartRulesSnapshotProvider),
                        ),
                      ],
                      data: (snapshot) {
                        _endDate = _endDate.isEmpty
                            ? snapshot.defaultEndDate
                            : _endDate;
                        if (_endDateController.text.isEmpty &&
                            _endDate.isNotEmpty) {
                          _endDateController.text = formatArenaDateInput(
                            _endDate,
                          );
                        }
                        final ruleController = ArenaSmartRuleBuilderController(
                          state: ArenaSmartRuleBuilderViewState(
                            snapshot: snapshot,
                          ),
                        );
                        final form = _formDraft();
                        final clarity = _ClarityResult(
                          ruleController.clarityScore(form),
                        );
                        final canProceed = ruleController.canProceed(form);

                        return [
                          ArenaWizardStepper(
                            steps: snapshot.steps,
                            activeStep: 3,
                            style: ArenaWizardStepperStyle.smartRule,
                          ),
                          _TitleField(
                            controller: _titleController,
                            suggestions: snapshot.titleSuggestions,
                            onChanged: (value) =>
                                setState(() => _title = value),
                            onSuggestion: _setTitle,
                          ),
                          _DomainField(
                            domain: ruleController.selectedDomain(form),
                            onTap: () => _selectDomain(snapshot),
                          ),
                          _ChallengeTypeGrid(
                            types: snapshot.challengeTypes,
                            selectedId: _challengeTypeId,
                            onSelected: (id) =>
                                setState(() => _challengeTypeId = id),
                          ),
                          _IntroSection(),
                          _ClarityScoreCard(score: clarity.score),
                          _GuidanceLink(onTap: _showGuidance),
                          _ConditionBuilder(
                            subject: _subject,
                            action: _action,
                            metric: _metric,
                            winType: _winType,
                            deadlineContext: _deadlineContext,
                            customWinController: _customWinController,
                            onSubject: () => _selectTextOption(
                              title: 'Chọn chủ thể',
                              options: snapshot.subjects,
                              selectedValue: _subject,
                              onSelected: (value) => _subject = value,
                            ),
                            onAction: () => _selectTextOption(
                              title: 'Chọn hành động',
                              options: snapshot.actions,
                              selectedValue: _action,
                              onSelected: (value) => _action = value,
                            ),
                            onMetric: () => _selectTextOption(
                              title: 'Chọn chỉ số / đối tượng',
                              options: snapshot.metrics,
                              selectedValue: _metric,
                              onSelected: (value) => _metric = value,
                            ),
                            onWinType: () => _selectTextOption(
                              title: 'Chọn kiểu thắng',
                              options: snapshot.winTypes,
                              selectedValue: _winType,
                              onSelected: (value) => _winType = value,
                            ),
                            onDeadlineContext: () => _selectTextOption(
                              title: 'Chọn thời điểm kết quả',
                              options: snapshot.deadlineContexts,
                              selectedValue: _deadlineContext,
                              onSelected: (value) => _deadlineContext = value,
                            ),
                            onCustomWinChanged: (value) =>
                                setState(() => _customWinCondition = value),
                          ),
                          _DescriptionField(
                            controller: _descriptionController,
                            onChanged: (value) =>
                                setState(() => _description = value),
                          ),
                          _QuickSuggestions(
                            suggestions: ruleController.quickSuggestions(form),
                            onTap: (value) => setState(() {
                              if (_title.isEmpty) {
                                _setTitle(value);
                              } else {
                                _setCustomWinCondition(value);
                              }
                            }),
                          ),
                          _TimingRulesCard(
                            snapshot: snapshot,
                            endDateController: _endDateController,
                            tieRule: _tieRule,
                            voidRule: _voidRule,
                            resultDeadline: _resultDeadline,
                            rematchEnabled: _rematchEnabled,
                            saveAsMode: _saveAsMode,
                            onDate: (value) => setState(() => _endDate = value),
                            onTieRule: () => _selectTextOption(
                              title: 'Chọn luật hòa',
                              options: snapshot.tieRules,
                              selectedValue: _tieRule,
                              onSelected: (value) => _tieRule = value,
                            ),
                            onVoidRule: () => _selectTextOption(
                              title: 'Chọn luật hủy bỏ',
                              options: snapshot.voidRules,
                              selectedValue: _voidRule,
                              onSelected: (value) => _voidRule = value,
                            ),
                            onResultDeadline: () => _selectTextOption(
                              title: 'Chọn hạn chốt kết quả',
                              options: snapshot.resultDeadlines,
                              selectedValue: _resultDeadline,
                              onSelected: (value) => _resultDeadline = value,
                            ),
                            onRematch: () => setState(
                              () => _rematchEnabled = !_rematchEnabled,
                            ),
                            onSaveAsMode: () =>
                                setState(() => _saveAsMode = !_saveAsMode),
                          ),
                          _RuleSummaryCard(
                            domain: ruleController.selectedDomain(form)?.label,
                            challengeType: ruleController
                                .selectedChallengeType(form)
                                ?.label,
                            winCondition: ruleController.generatedWinCondition(
                              form,
                            ),
                            endDate: _endDate,
                            tieRule: _tieRule,
                            voidRule: _voidRule,
                            resultDeadline: _resultDeadline,
                          ),
                          const _ModerationNote(),
                          _BackendPayloadPreviewCard(
                            creationState: creationState,
                            draft: ruleController.buildCreationDraft(
                              form,
                              clarity.score,
                            ),
                          ),
                          _CreationSafetyChecklist(
                            ruleReviewAccepted: _ruleReviewAccepted,
                            pointsBoundaryAccepted: _pointsBoundaryAccepted,
                            moderationAccepted: _moderationAccepted,
                            onRuleReview: () => setState(
                              () => _ruleReviewAccepted = !_ruleReviewAccepted,
                            ),
                            onPointsBoundary: () => setState(
                              () => _pointsBoundaryAccepted =
                                  !_pointsBoundaryAccepted,
                            ),
                            onModeration: () => setState(
                              () => _moderationAccepted = !_moderationAccepted,
                            ),
                          ),
                          _FooterActions(
                            canProceed: canProceed,
                            canSubmit: ruleController.canSubmit(
                              form,
                              clarity.score,
                            ),
                            clarityScore: clarity.score,
                            statusLabel: _statusLabel,
                            commandStatusLabel: creationState.statusLabel,
                            onBack: _close,
                            onContinue: () => _continue(snapshot),
                            onPreview: () =>
                                _previewBackendPayload(snapshot, clarity),
                            onSave: () =>
                                _saveDraftForBackend(snapshot, clarity),
                            onSubmit: () => _submitForReview(snapshot, clarity),
                            onReset: _resetForm,
                          ),
                        ];
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ArenaSmartRuleFormDraft _formDraft() {
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
      endDate: _endDate,
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

  Future<void> _selectDomain(ArenaSmartRulesSnapshot snapshot) async {
    unawaited(HapticFeedback.selectionClick());
    FocusScope.of(context).unfocus();
    final selected = await showVitBottomSheet<ArenaSmartOptionDraft>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) => _SmartOptionSheet(
        title: 'Chọn lĩnh vực',
        options: snapshot.domains,
        selectedId: _domainId,
      ),
    );
    if (!mounted || selected == null) return;
    setState(() => _domainId = selected.id);
  }

  Future<void> _selectTextOption({
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    unawaited(HapticFeedback.selectionClick());
    FocusScope.of(context).unfocus();
    final selected = await showVitBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) => _TextOptionSheet(
        title: title,
        options: options,
        selectedValue: selectedValue,
      ),
    );
    if (!mounted || selected == null) return;
    setState(() => onSelected(selected));
  }

  void _setTitle(String value) {
    _titleController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    setState(() => _title = value);
  }

  void _setCustomWinCondition(String value) {
    _customWinController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    setState(() => _customWinCondition = value);
  }

  void _showGuidance() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _statusLabel = 'Public room cần rule rõ ràng hơn');
  }

  void _continue(ArenaSmartRulesSnapshot snapshot) {
    final ruleController = ArenaSmartRuleBuilderController(
      state: ArenaSmartRuleBuilderViewState(snapshot: snapshot),
    );
    final form = _formDraft();
    if (!ruleController.canProceed(form)) {
      setState(
        () => _statusLabel = ruleController.missingCoreRequirement(form),
      );
      return;
    }
    unawaited(HapticFeedback.selectionClick());
    setState(() => _statusLabel = 'Rule đã hoàn chỉnh');
  }

  void _previewBackendPayload(
    ArenaSmartRulesSnapshot snapshot,
    _ClarityResult clarity,
  ) {
    unawaited(HapticFeedback.selectionClick());
    final draft = ArenaSmartRuleBuilderController(
      state: ArenaSmartRuleBuilderViewState(snapshot: snapshot),
    ).buildCreationDraft(_formDraft(), clarity.score);
    final result = ref.read(arenaCreationProvider.notifier).preview(draft);
    setState(() => _statusLabel = result.statusLabel);
  }

  void _saveDraftForBackend(
    ArenaSmartRulesSnapshot snapshot,
    _ClarityResult clarity,
  ) {
    unawaited(HapticFeedback.selectionClick());
    final draft = ArenaSmartRuleBuilderController(
      state: ArenaSmartRuleBuilderViewState(snapshot: snapshot),
    ).buildCreationDraft(_formDraft(), clarity.score);
    final result = ref.read(arenaCreationProvider.notifier).saveDraft(draft);
    setState(() => _statusLabel = result.statusLabel);
  }

  Future<void> _submitForReview(
    ArenaSmartRulesSnapshot snapshot,
    _ClarityResult clarity,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    FocusScope.of(context).unfocus();
    final draft = ArenaSmartRuleBuilderController(
      state: ArenaSmartRuleBuilderViewState(snapshot: snapshot),
    ).buildCreationDraft(_formDraft(), clarity.score);
    final errors = draft.submitValidationErrors();
    if (errors.isNotEmpty) {
      setState(() => _statusLabel = errors.first);
      return;
    }

    final confirmed = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopRadius,
      ),
      builder: (context) => _SubmitChallengeSheet(draft: draft),
    );
    if (!mounted || confirmed != true) return;

    final result = ref
        .read(arenaCreationProvider.notifier)
        .submitForReview(draft);
    setState(() => _statusLabel = result.statusLabel);
    if (result.ok) {
      context.go(AppRoutePaths.arenaMy);
    }
  }

  void _resetForm() {
    unawaited(HapticFeedback.selectionClick());
    _titleController.clear();
    _customWinController.clear();
    _descriptionController.clear();
    _endDate = _defaultArenaRuleEndDate();
    _endDateController.text = formatArenaDateInput(_endDate);
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

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.arenaStudio,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}

String _defaultArenaRuleEndDate() {
  final date = DateTime.now().add(const Duration(days: 7));
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
