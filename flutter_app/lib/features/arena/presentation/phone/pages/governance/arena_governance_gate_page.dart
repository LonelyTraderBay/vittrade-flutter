import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_date_format.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/governance/arena_governance_gate_stepper_title.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_state_cards.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part 'arena_governance_gate_page_tier_style.dart';
part '../../../widgets/governance/arena_governance_gate_models.dart';
part '../../../widgets/governance/arena_governance_gate_privacy_clarity.dart';
part '../../../widgets/governance/arena_governance_gate_setup_fields.dart';
part '../../../widgets/governance/arena_governance_gate_resolution_timing.dart';
part '../../../widgets/governance/arena_governance_gate_suggestions_eligibility.dart';
part '../../../widgets/governance/arena_governance_gate_summary_footer.dart';
part '../../../widgets/governance/arena_governance_gate_field_controls.dart';
part '../../../widgets/governance/arena_governance_gate_status_widgets.dart';
part '../../../widgets/governance/arena_governance_gate_helpers.dart';

const _arenaAccent = AppModuleAccents.arena;
final double _governanceActionExtent = VitDensity.compact.controlHeight;
const _governanceBodyLineRatio =
    ArenaSpacingTokens.arenaGovernanceBodyLineHeight;
const _governanceNoticeLineRatio =
    ArenaSpacingTokens.arenaGovernanceNoticeLineHeight;

class ArenaGovernanceGatePage extends ConsumerStatefulWidget {
  const ArenaGovernanceGatePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc188_governance_content');
  static const titleKey = Key('sc188_title');
  static const compareKey = Key('sc188_compare');
  static const saveKey = Key('sc188_save');
  static const continueKey = Key('sc188_continue');

  static Key privacyKey(String id) => Key('sc188_privacy_$id');

  static Key domainKey(String id) => Key('sc188_domain_$id');

  static Key challengeTypeKey(String id) => Key('sc188_type_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaGovernanceGatePage> createState() =>
      _ArenaGovernanceGatePageState();
}

class _ArenaGovernanceGatePageState
    extends ConsumerState<ArenaGovernanceGatePage> {
  String _privacy = 'public';
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
  String _resolutionSource = '';
  late String _endDate;
  String _tieRule = '';
  String _voidRule = '';
  String _resultDeadline = '';
  bool _rematchEnabled = false;
  bool _saveAsMode = false;
  String? _statusLabel;

  @override
  void initState() {
    super.initState();
    _endDate = '2026-03-15';
  }

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(arenaGovernanceControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );
    final result = _governanceResult();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Xác nhận và publish thử thách - bước cuối trong Arena Studio',
      semanticIdentifier: 'SC-188',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Arena Studio',
            subtitle: 'Xác nhận trước publish · Points only',
            showBack: true,
            onBack: _close,
          ),
          child: controllerAsync.when(
            loading: () => const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Expanded(child: VitSkeletonList())],
            ),
            error: (error, stackTrace) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: VitErrorState(
                    title: 'Không tải được Governance Gate',
                    message: 'Vui lòng kiểm tra kết nối và thử lại.',
                    actionLabel: 'Thử lại',
                    onAction: () =>
                        ref.invalidate(arenaGovernanceControllerProvider),
                  ),
                ),
              ],
            ),
            data: (controller) {
              final snapshot = controller.state.snapshot;
              final actionState = controller.actionState(
                canProceed: result.canProceed,
                nextAction: result.nextAction,
                statusLabel: _statusLabel,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: ArenaGovernanceGatePage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                          footerPadding,
                        ),
                        child: Column(
                          children: [
                            VitPageContent(
                              rhythm: VitPageRhythm.form,
                              padding: VitContentPadding.compact,
                              gap: VitContentGap.tight,
                              children: [
                                ArenaWizardStepper(
                                  steps: snapshot.steps,
                                  activeStep: 3,
                                  style: ArenaWizardStepperStyle.governance,
                                ),
                                const ArenaGovernanceGateHeader(),
                                ArenaGovernanceStateBanner(state: actionState),
                                _PrivacyCard(
                                  options: snapshot.privacyOptions,
                                  privacy: _privacy,
                                  onSelected: _setPrivacy,
                                  onCompare: _showGuidance,
                                ),
                                _ClarityScoreCard(result: result),
                                _TitleField(
                                  title: _title,
                                  onChanged: (value) =>
                                      setState(() => _title = value),
                                ),
                                _DomainGrid(
                                  domains: snapshot.domains,
                                  selectedId: _domainId,
                                  publicRoom: _privacy == 'public',
                                  onSelected: _selectDomain,
                                ),
                                _ChallengeTypeGrid(
                                  types: snapshot.challengeTypes,
                                  selectedId: _challengeTypeId,
                                  publicRoom: _privacy == 'public',
                                  onSelected: _selectChallengeType,
                                ),
                                _WinConditionCard(
                                  snapshot: snapshot,
                                  subject: _subject,
                                  action: _action,
                                  metric: _metric,
                                  winType: _winType,
                                  deadlineContext: _deadlineContext,
                                  customWinCondition: _customWinCondition,
                                  publicRoom: _privacy == 'public',
                                  onSubject: () => setState(
                                    () => _subject = snapshot.subjects.first,
                                  ),
                                  onAction: () => setState(
                                    () => _action = snapshot.actions.first,
                                  ),
                                  onMetric: () => setState(
                                    () => _metric = snapshot.metrics.first,
                                  ),
                                  onWinType: () => setState(
                                    () => _winType = snapshot.winTypes.first,
                                  ),
                                  onDeadlineContext: () => setState(
                                    () => _deadlineContext =
                                        snapshot.deadlineContexts.first,
                                  ),
                                  onCustomWinChanged: (value) => setState(
                                    () => _customWinCondition = value,
                                  ),
                                ),
                                _DescriptionField(
                                  value: _description,
                                  onChanged: (value) =>
                                      setState(() => _description = value),
                                ),
                                _ResolutionSourceField(
                                  publicRoom: _privacy == 'public',
                                  value: _resolutionSource,
                                  options: snapshot.resolutionSources,
                                  onTap: () => setState(
                                    () => _resolutionSource =
                                        snapshot.resolutionSources.first,
                                  ),
                                ),
                                _TimingRulesCard(
                                  snapshot: snapshot,
                                  endDate: _endDate,
                                  tieRule: _tieRule,
                                  voidRule: _voidRule,
                                  resultDeadline: _resultDeadline,
                                  rematchEnabled: _rematchEnabled,
                                  saveAsMode: _saveAsMode,
                                  publicRoom: _privacy == 'public',
                                  onDate: (value) =>
                                      setState(() => _endDate = value),
                                  onTieRule: () => setState(
                                    () => _tieRule = snapshot.tieRules.first,
                                  ),
                                  onVoidRule: () => setState(
                                    () => _voidRule = snapshot.voidRules.first,
                                  ),
                                  onResultDeadline: () => setState(
                                    () => _resultDeadline =
                                        snapshot.resultDeadlines.first,
                                  ),
                                  onRematch: () => setState(
                                    () => _rematchEnabled = !_rematchEnabled,
                                  ),
                                  onSaveAsMode: () => setState(
                                    () => _saveAsMode = !_saveAsMode,
                                  ),
                                ),
                                _WarningStack(result: result),
                                _SuggestedFallbackCard(
                                  suggestions: snapshot.suggestionActions,
                                  onTap: _applySuggestion,
                                ),
                                _EligibilityPanel(result: result),
                                _GovernanceSummary(
                                  result: result,
                                  privacy: _privacy,
                                  resolutionSource: _resolutionSource,
                                ),
                                const _ModerationNote(),
                              ],
                            ),
                            _GovernanceFooter(
                              canContinue: actionState.canContinue,
                              result: result,
                              statusLabel: actionState.footerLabel,
                              onBack: _close,
                              onSave: _saveDraft,
                              onContinue: _continue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _GovernanceResult _governanceResult() {
    var score = 5;
    if (_title.length >= 5) score += 10;
    if (_domainId.isNotEmpty) score += _domainId == 'other' ? 4 : 10;
    if (_challengeTypeId.isNotEmpty) score += 10;
    if (_subject.isNotEmpty) score += 7;
    if (_action.isNotEmpty) score += 7;
    if (_metric.isNotEmpty) score += 5;
    if (_winType.isNotEmpty) score += 4;
    if (_deadlineContext.isNotEmpty) score += 4;
    if (_customWinCondition.length >= 10) score += 10;
    if (_description.length >= 15) score += 6;
    if (_resolutionSource.isNotEmpty) score += 8;
    if (_tieRule.isNotEmpty) score += 8;
    if (_voidRule.isNotEmpty) score += 8;
    if (_resultDeadline.isNotEmpty) score += 8;
    score = score.clamp(0, 100);

    final hasWin =
        (_subject.isNotEmpty && _action.isNotEmpty) ||
        _customWinCondition.length >= 10;
    final checks = [
      _GovernanceCheck('Lĩnh vực đã chọn', _domainId.isNotEmpty),
      _GovernanceCheck('Loại challenge đã chọn', _challengeTypeId.isNotEmpty),
      _GovernanceCheck('Cách thắng rõ ràng', hasWin),
      _GovernanceCheck('Cách chốt kết quả rõ', _resolutionSource.isNotEmpty),
      _GovernanceCheck('Luật hòa (tie rule)', _tieRule.isNotEmpty),
      _GovernanceCheck('Luật hủy bỏ (void rule)', _voidRule.isNotEmpty),
      _GovernanceCheck('Deadline kết quả', _resultDeadline.isNotEmpty),
    ];
    final passed = checks.where((item) => item.passed).length;
    final allPassed = checks.every((item) => item.passed);
    final publicRoom = _privacy == 'public';
    final level = score >= 85
        ? 'Public-ready'
        : score >= 60
        ? 'Cao'
        : score >= 35
        ? 'Trung bình'
        : 'Thấp';
    final tier = publicRoom
        ? allPassed && score >= 60
              ? _EligibilityTier.green
              : passed >= 4
              ? _EligibilityTier.amber
              : _EligibilityTier.red
        : hasWin && passed >= 3
        ? _EligibilityTier.green
        : passed > 0
        ? _EligibilityTier.amber
        : _EligibilityTier.red;
    final warnings = <String>[
      if (publicRoom && !allPassed)
        'Room public nhưng chưa đủ thông tin bắt buộc. Hoàn thành checklist hoặc chuyển sang Private.',
      if (_tieRule.isEmpty && _voidRule.isEmpty)
        'Thiếu luật hòa và luật hủy bỏ. Bổ sung để tránh tranh chấp khi có tình huống đặc biệt.',
      if (_domainId == 'other' && publicRoom)
        'Custom domain trên room Public cần rule rất rõ. Cân nhắc Invite Only nếu rule phức tạp.',
    ];
    final nextAction = _domainId.isEmpty
        ? 'Chọn lĩnh vực'
        : _challengeTypeId.isEmpty
        ? 'Chọn loại challenge'
        : !hasWin
        ? 'Thiết lập điều kiện thắng'
        : _resolutionSource.isEmpty
        ? 'Chọn cách chốt kết quả'
        : _tieRule.isEmpty
        ? 'Bổ sung luật hòa'
        : _voidRule.isEmpty
        ? 'Bổ sung luật hủy bỏ'
        : _resultDeadline.isEmpty
        ? 'Bổ sung deadline kết quả'
        : 'Sẵn sàng tiếp tục';

    return _GovernanceResult(
      clarity: score,
      level: level,
      tier: tier,
      checks: checks,
      warnings: warnings,
      risk: _domainId == 'other' && publicRoom ? 'Cao' : 'Thấp',
      nextAction: nextAction,
      canProceed:
          tier == _EligibilityTier.green ||
          (_privacy != 'public' && tier == _EligibilityTier.amber),
    );
  }

  void _setPrivacy(String value) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _privacy = value;
      _statusLabel = null;
    });
  }

  void _selectDomain(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _domainId = id);
  }

  void _selectChallengeType(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _challengeTypeId = id);
  }

  void _showGuidance() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _statusLabel = 'Public room cần checklist đầy đủ');
  }

  void _applySuggestion(ArenaGovernanceSuggestionDraft suggestion) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (suggestion.id == 'closest_guess') {
        _challengeTypeId = 'closest_guess';
      } else if (suggestion.id == 'proof_challenge') {
        _challengeTypeId = 'proof_challenge';
      } else if (suggestion.id == 'invite_only') {
        _privacy = 'private';
      } else if (suggestion.id == 'add_rules') {
        _tieRule = 'Chia đều pool';
        _voidRule = 'Không đủ bằng chứng -> hủy';
      }
      _statusLabel = 'Đã áp dụng gợi ý';
    });
  }

  void _saveDraft() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _statusLabel = 'Đã lưu nháp');
  }

  void _continue() {
    unawaited(HapticFeedback.selectionClick());
    final result = _governanceResult();
    setState(() {
      _statusLabel = result.canProceed
          ? 'Governance Gate passed'
          : result.nextAction;
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
