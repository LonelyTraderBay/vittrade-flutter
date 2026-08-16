import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingEmergencyActionsPage extends ConsumerWidget {
  const StakingEmergencyActionsPage({super.key, this.shellRenderMode});

  static const warningKey = Key('sc385_warning');
  static const actionsKey = Key('sc385_actions');
  static const useCasesKey = Key('sc385_use_cases');
  static const statusKey = Key('sc385_status');
  static const footerKey = Key('sc385_footer');
  static const pauseSheetKey = Key('sc385_pause_sheet');
  static const withdrawSheetKey = Key('sc385_withdraw_sheet');

  static Key actionKey(String id) => Key('sc385_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAsync = ref.watch(
      stakingEmergencyActionsControllerProvider,
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hành động khẩn cấp cần xác nhận',
      semanticIdentifier: 'SC-385',
      child: Material(
        color: AppColors.bg,
        child: controllerAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingEmergencyActionsSnapshotProvider),
            ),
          ),
          data: (controller) {
            final snapshot = controller.state.snapshot;
            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Hành động khẩn cấp cần xác nhận',
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
                        gap: VitContentGap.tight,
                        children: [
                          _WarningBanner(snapshot: snapshot),
                          _EmergencyActionsSection(
                            actions: snapshot.actions,
                            onTap: (action) =>
                                _handleActionTap(context, controller, action),
                          ),
                          _UseCasesSection(useCases: snapshot.useCases),
                          _CurrentStatusSection(
                            statusCards: snapshot.statusCards,
                          ),
                          _FooterNote(note: snapshot.footerNote),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xác nhận hành động khẩn cấp',
                            message:
                                'Tạm dừng, rút khẩn cấp, phí phạt, trạng thái hiện tại, giám sát và bước hỗ trợ được xem xét trước khi thực thi.',
                            contractId: 'SC-385',
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

  void _handleActionTap(
    BuildContext context,
    StakingEmergencyActionsController controller,
    StakingEmergencyActionDraft action,
  ) {
    unawaited(HapticFeedback.selectionClick());
    final sheet = controller.sheetForAction(action);
    if (sheet == null) return;
    final sheetKey = action.id == 'pause' ? pauseSheetKey : withdrawSheetKey;
    _showActionSheet(context, sheet, sheetKey);
  }

  void _showActionSheet(
    BuildContext context,
    StakingEmergencySheetDraft sheet,
    Key sheetKey,
  ) {
    final navInset = DeviceMetrics.nativeBottomChrome;
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        barrierColor: AppColors.bg.withValues(alpha: 0.72),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (sheetContext) {
          final color = _toneColor(sheet.tone);
          return SafeArea(
            top: false,
            child: Padding(
              padding: EarnSpacingTokens.earnSheetPadding(navInset),
              child: Column(
                key: sheetKey,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(sheet.title, style: AppTextStyles.sectionTitle),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitCard(
                    variant: VitCardVariant.inner,
                    borderColor: color.withValues(alpha: 0.28),
                    padding: EarnSpacingTokens.earnCardPaddingX4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          sheet.body,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: AppTextStyles.caption.height,
                          ),
                        ),
                        if (sheet.bullets.isNotEmpty) ...[
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardInnerGap,
                          ),
                          for (final bullet in sheet.bullets)
                            Padding(
                              padding: EarnSpacingTokens.earnBottomPaddingX1,
                              child: Text(
                                '- $bullet',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                  height: AppTextStyles.micro.height,
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitCtaButton(
                    variant: sheet.tone == 'danger'
                        ? VitCtaButtonVariant.destructive
                        : VitCtaButtonVariant.warning,
                    height: AppSpacing.buttonStandard,
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                    },
                    child: Text(sheet.confirmLabel),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.snapshot});

  final StakingEmergencyActionsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEmergencyActionsPage.warningKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.sell.withValues(alpha: 0.35),
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(snapshot.warningTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.warningBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppTextStyles.caption.height,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyActionsSection extends StatelessWidget {
  const _EmergencyActionsSection({required this.actions, required this.onTap});

  final List<StakingEmergencyActionDraft> actions;
  final ValueChanged<StakingEmergencyActionDraft> onTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingEmergencyActionsPage.actionsKey,
      label: 'Available Actions',
      accentColor: AppModuleAccents.earn,
      children: [
        for (final action in actions)
          _EmergencyActionCard(action: action, onTap: () => onTap(action)),
      ],
    );
  }
}

class _EmergencyActionCard extends StatelessWidget {
  const _EmergencyActionCard({required this.action, required this.onTap});

  final StakingEmergencyActionDraft action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(action.tone);
    return VitCard(
      key: StakingEmergencyActionsPage.actionKey(action.id),
      radius: VitCardRadius.large,
      onTap: action.id == 'rebalance' ? null : onTap,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withValues(alpha: 0.16),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.lgRadius,
                ),
              ),
              child: Icon(_actionIcon(action.id), color: color),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(action.title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  action.body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: AppTextStyles.caption.height,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  action.impact,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UseCasesSection extends StatelessWidget {
  const _UseCasesSection({required this.useCases});

  final List<StakingEmergencyUseCaseDraft> useCases;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingEmergencyActionsPage.useCasesKey,
      label: 'When to Use Emergency Actions',
      accentColor: AppModuleAccents.earn,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Column(
            children: [
              for (var i = 0; i < useCases.length; i++)
                _UseCaseRow(
                  useCase: useCases[i],
                  showDivider: i != useCases.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UseCaseRow extends StatelessWidget {
  const _UseCaseRow({required this.useCase, required this.showDivider});

  final StakingEmergencyUseCaseDraft useCase;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(useCase.severity);
    return Column(
      children: [
        Padding(
          padding: EarnSpacingTokens.earnVerticalPaddingX2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: color,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      useCase.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      useCase.description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: AppTextStyles.micro.height,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            color: AppColors.borderSolid,
            height: AppSpacing.dividerHairline,
          ),
      ],
    );
  }
}

class _CurrentStatusSection extends StatelessWidget {
  const _CurrentStatusSection({required this.statusCards});

  final List<StakingEmergencyStatusDraft> statusCards;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingEmergencyActionsPage.statusKey,
      label: 'Current Status',
      accentColor: AppModuleAccents.earn,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Row(
            children: [
              for (var i = 0; i < statusCards.length; i++) ...[
                Expanded(child: _StatusTile(status: statusCards[i])),
                if (i != statusCards.length - 1)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.status});

  final StakingEmergencyStatusDraft status;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(status.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: status.tone == 'success' ? AppColors.buy20 : null,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            status.tone == 'success'
                ? Icons.shield_outlined
                : Icons.history_rounded,
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            status.value,
            style: AppTextStyles.baseMedium.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            status.body,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEmergencyActionsPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: VitRiskDisclaimerNote(message: note),
    );
  }
}

Color _toneColor(String tone) {
  return switch (tone) {
    'danger' || 'critical' => AppColors.sell,
    'warning' || 'high' => AppColors.warn,
    'success' => AppColors.buy,
    'neutral' => AppColors.text2,
    _ => AppModuleAccents.earn,
  };
}

IconData _actionIcon(String id) {
  return switch (id) {
    'pause' => Icons.pause_rounded,
    'withdraw' => Icons.arrow_downward_rounded,
    'rebalance' => Icons.sync_rounded,
    _ => Icons.shield_outlined,
  };
}
