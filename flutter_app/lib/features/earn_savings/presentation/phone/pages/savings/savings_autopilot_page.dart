import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_actions.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_formatters.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_hero.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_overview.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_settings.dart';

class SavingsAutoPilotPage extends ConsumerStatefulWidget {
  const SavingsAutoPilotPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc350_summary');
  static const modulesKey = Key('sc350_modules');
  static const actionsKey = Key('sc350_actions');
  static const settingsKey = Key('sc350_settings');
  static const statusButtonKey = Key('sc350_status_button');
  static const approveActionKey = Key('sc350_approve_action');
  static const skipActionKey = Key('sc350_skip_action');

  static Key tabKey(String id) => Key('sc350_tab_$id');
  static Key moduleKey(String id) => Key('sc350_module_$id');
  static Key actionKey(String id) => Key('sc350_action_$id');
  static Key modeKey(SavingsAutoPilotMode mode) =>
      Key('sc350_mode_${mode.name}');
  static Key budgetKey(int amount) => Key('sc350_budget_$amount');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsAutoPilotPage> createState() =>
      _SavingsAutoPilotPageState();
}

class _SavingsAutoPilotPageState extends ConsumerState<SavingsAutoPilotPage> {
  String? _tab;
  SavingsAutoPilotStatus? _status;
  SavingsAutoPilotMode? _mode;
  int? _monthlyBudgetUsd;
  bool? _approvalRequired;
  bool? _notificationsEnabled;
  final Map<String, bool> _moduleStates = {};
  final Map<String, SavingsAutoPilotActionStatus> _actionStates = {};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsAutoPilotSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chế độ tiết kiệm tự động',
      semanticIdentifier: 'SC-350',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(savingsAutoPilotSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _tab ?? snapshot.defaultTab;
            final status = _status ?? snapshot.config.status;
            final selectedMode = _mode ?? snapshot.config.mode;
            final monthlyBudget =
                _monthlyBudgetUsd ?? snapshot.config.monthlyBudgetUsd;
            final mode = modeById(snapshot, selectedMode);
            final pendingCount = _pendingCount(snapshot);
            final executedCount = _executedCount(snapshot);
            final modeRender =
                widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollTailReserve =
                (modeRender.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x3
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollTailReserve,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          AutoPilotHero(
                            snapshot: snapshot,
                            mode: mode,
                            status: status,
                            monthlyBudgetUsd: monthlyBudget,
                            executedCount: executedCount,
                            pendingCount: pendingCount,
                            onToggleStatus: _toggleStatus,
                          ),
                          AutoPilotTabs(
                            tabs: snapshot.tabs,
                            active: activeTab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (activeTab == 'overview')
                            OverviewTab(
                              snapshot: snapshot,
                              moduleStates: _moduleStates,
                              onOpenModule: (route) => context.go(route),
                              onShowActions: () =>
                                  setState(() => _tab = 'actions'),
                              actionStatusFor: _actionStatus,
                              onOpenAction: (action) =>
                                  _showActionDetail(context, action),
                            )
                          else if (activeTab == 'actions')
                            ActionsTab(
                              snapshot: snapshot,
                              actionStatusFor: _actionStatus,
                              onOpenAction: (action) =>
                                  _showActionDetail(context, action),
                              onApprove: _approveAction,
                              onSkip: _skipAction,
                            )
                          else
                            SettingsTab(
                              snapshot: snapshot,
                              mode: selectedMode,
                              monthlyBudgetUsd: monthlyBudget,
                              approvalRequired:
                                  _approvalRequired ??
                                  snapshot.config.approvalRequired,
                              notificationsEnabled:
                                  _notificationsEnabled ??
                                  snapshot.config.notificationsEnabled,
                              moduleEnabled: _moduleEnabled,
                              onModeChanged: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _mode = value);
                              },
                              onBudgetChanged: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _monthlyBudgetUsd = value);
                              },
                              onModuleChanged: (id, enabled) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _moduleStates[id] = enabled);
                              },
                              onApprovalChanged: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _approvalRequired = value);
                              },
                              onNotificationChanged: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _notificationsEnabled = value);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleStatus() {
    unawaited(HapticFeedback.mediumImpact());
    // Bẫy 15 (GD4 playbook): repo trong event handler — đọc lười qua
    // `.value` (đã có sẵn vì nút này chỉ render trong nhánh data:).
    final current =
        _status ??
        ref.read(savingsAutoPilotSnapshotProvider).value?.config.status;
    if (current == null) return;
    setState(() {
      _status = switch (current) {
        SavingsAutoPilotStatus.active => SavingsAutoPilotStatus.paused,
        SavingsAutoPilotStatus.paused => SavingsAutoPilotStatus.active,
        SavingsAutoPilotStatus.inactive => SavingsAutoPilotStatus.active,
      };
    });
  }

  void _approveAction(String id) {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _actionStates[id] = SavingsAutoPilotActionStatus.executed);
  }

  void _skipAction(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _actionStates[id] = SavingsAutoPilotActionStatus.skipped);
  }

  bool _moduleEnabled(SavingsAutoPilotModuleDraft module) {
    return _moduleStates[module.id] ?? module.enabled;
  }

  SavingsAutoPilotActionStatus _actionStatus(
    SavingsAutoPilotActionDraft action,
  ) {
    return _actionStates[action.id] ?? action.status;
  }

  int _pendingCount(SavingsAutoPilotSnapshot snapshot) {
    return snapshot.actions
        .where(
          (action) =>
              _actionStatus(action) ==
              SavingsAutoPilotActionStatus.needsApproval,
        )
        .length;
  }

  int _executedCount(SavingsAutoPilotSnapshot snapshot) {
    return snapshot.actions
        .where(
          (action) =>
              _actionStatus(action) == SavingsAutoPilotActionStatus.executed,
        )
        .length;
  }

  void _showActionDetail(
    BuildContext context,
    SavingsAutoPilotActionDraft action,
  ) {
    unawaited(HapticFeedback.selectionClick());
    final status = _actionStatus(action);
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.transparent,
        builder: (context) => ActionDetailSheet(
          action: action,
          status: status,
          onApprove: status == SavingsAutoPilotActionStatus.needsApproval
              ? () {
                  Navigator.of(context).pop();
                  _approveAction(action.id);
                }
              : null,
          onSkip: status == SavingsAutoPilotActionStatus.needsApproval
              ? () {
                  Navigator.of(context).pop();
                  _skipAction(action.id);
                }
              : null,
        ),
      ),
    );
  }
}
