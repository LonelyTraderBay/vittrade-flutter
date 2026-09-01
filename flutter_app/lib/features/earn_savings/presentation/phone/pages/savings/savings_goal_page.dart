import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_formatters.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/savings/savings_goal_summary_card.dart';
part '../../../widgets/savings/savings_goal_card.dart';
part '../../../widgets/savings/savings_goal_create_sheet.dart';
part '../../../widgets/savings/savings_goal_detail_sheet.dart';
part '../../../widgets/savings/savings_goal_visuals.dart';
part '../../../widgets/savings/savings_goal_sheet_common.dart';

class SavingsGoalPage extends ConsumerStatefulWidget {
  const SavingsGoalPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc342_summary');
  static const createButtonKey = Key('sc342_create_goal_button');
  static const createSheetKey = Key('sc342_create_goal_sheet');
  static const detailSheetKey = Key('sc342_goal_detail_sheet');

  static Key goalKey(String id) => Key('sc342_goal_$id');
  static Key templateKey(String id) => Key('sc342_template_$id');
  static Key tipKey(String title) => Key('sc342_tip_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsGoalPage> createState() => _SavingsGoalPageState();
}

class _SavingsGoalPageState extends ConsumerState<SavingsGoalPage> {
  String? _selectedTemplateId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsGoalsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Mục tiêu tiết kiệm',
      semanticIdentifier: 'SC-342',
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
              onAction: () => ref.invalidate(savingsGoalsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeGoals = snapshot.goals
                .where((goal) => goal.status == SavingsGoalStatus.active)
                .toList();
            final completedGoals = snapshot.goals
                .where((goal) => goal.status == SavingsGoalStatus.completed)
                .toList();
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: kSavingsToolsHeaderSubtitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _GoalSummaryCard(goals: snapshot.goals),
                          VitCtaButton(
                            key: SavingsGoalPage.createButtonKey,
                            leading: const Icon(Icons.add_rounded),
                            onPressed: () => _openCreateSheet(snapshot),
                            child: const Text('Tạo mục tiêu mới'),
                          ),
                          VitPageSection(
                            label: 'Đang thực hiện',
                            accentColor: AppColors.primary,
                            children: [
                              for (final goal in activeGoals)
                                _GoalCard(
                                  goal: goal,
                                  onTap: () => _openGoalDetail(goal),
                                ),
                            ],
                          ),
                          VitPageSection(
                            label: 'Đã hoàn thành',
                            accentColor: AppColors.buy,
                            children: [
                              for (final goal in completedGoals)
                                _GoalCard(
                                  goal: goal,
                                  onTap: () => _openGoalDetail(goal),
                                ),
                            ],
                          ),
                          VitPageSection(
                            label: 'Mẹo tiết kiệm',
                            accentColor: AppColors.accent,
                            children: [
                              for (final tip in snapshot.tips)
                                _TipCard(tip: tip),
                            ],
                          ),
                          const SavingsToolsYieldFooter(),
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

  Future<void> _openCreateSheet(SavingsGoalsSnapshot snapshot) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        final selected = _selectedTemplateId ?? snapshot.templates.first.id;
        return _SheetFrame(
          heightFactor: 0.82,
          child: _CreateGoalSheet(
            snapshot: snapshot,
            selectedTemplateId: selected,
            onTemplate: (id) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _selectedTemplateId = id);
              Navigator.of(context).pop();
              unawaited(_openCreateSheet(snapshot));
            },
          ),
        );
      },
    );
  }

  Future<void> _openGoalDetail(SavingsGoalDraft goal) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return _SheetFrame(
          heightFactor: 0.9,
          child: _GoalDetailSheet(goal: goal),
        );
      },
    );
  }
}
