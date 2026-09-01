import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_withdrawal_policy_timeline.dart';
part '../../../widgets/staking/staking_withdrawal_policy_penalties.dart';
part '../../../widgets/staking/staking_withdrawal_policy_emergency.dart';
part '../../../widgets/staking/staking_withdrawal_policy_calculator.dart';
part '../../../widgets/staking/staking_withdrawal_policy_common.dart';

const double _stakingWithdrawalInfoMinHeight = 88;
const double _stakingWithdrawalBorderWidth = AppSpacing.hairlineStroke;
const double _stakingWithdrawalProcessIconBox = AppSpacing.inputHeight;
const double _stakingWithdrawalProcessIcon = AppSpacing.iconSm;
const double _stakingWithdrawalTimelineMinHeight = 96;
const double _stakingWithdrawalTimelineMinHeightTall = 116;
const double _stakingWithdrawalEmergencyIconBox = AppSpacing.inputHeight;
const double _stakingWithdrawalEmergencyStepBox = AppSpacing.x6;
const double _stakingWithdrawalTimerIcon = AppSpacing.iconSm;
const double _stakingWithdrawalFeeTileWidth = 156;
const double _stakingWithdrawalFeeTileMinHeight = 68;
const double _stakingWithdrawalFormulaIcon = AppSpacing.iconSm;
const double _stakingWithdrawalSheetHandleWidth = AppSpacing.inputHeight;
const double _stakingWithdrawalSheetHandleHeight = AppSpacing.x1;
const double _stakingWithdrawalNoticeIcon = AppSpacing.iconSm;
const double _stakingWithdrawalBulletSize =
    AppSpacing.x1 + AppSpacing.hairlineStroke;
const double _stakingWithdrawalInfoLineHeight = 1.35;
const double _stakingWithdrawalProcessLineHeight = 1.3;
const double _stakingWithdrawalTimelineValueLineHeight = 1.25;
const double _stakingWithdrawalPenaltyBodyLineHeight = 1.4;
const double _stakingWithdrawalEmergencyStepLineHeight = 1.28;
const double _stakingWithdrawalFeeLineHeight = 1.2;
const double _stakingWithdrawalNoticeLineHeight = 1.3;
const double _stakingWithdrawalBulletLineHeight = 1.3;
const double _stakingWithdrawalBadgeLineHeight = 1.15;
const EdgeInsetsDirectional _stakingWithdrawalCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _stakingWithdrawalBulletPadding =
    EdgeInsetsDirectional.only(top: AppSpacing.x2);
const EdgeInsetsDirectional _stakingWithdrawalBadgePadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x2,
      vertical: AppSpacing.x1,
    );

class StakingWithdrawalPolicyPage extends ConsumerStatefulWidget {
  const StakingWithdrawalPolicyPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc355_withdrawal_info');
  static const processKey = Key('sc355_withdrawal_process');
  static const calculatorCtaKey = Key('sc355_withdrawal_calculator_cta');
  static const calculatorResultKey = Key('sc355_withdrawal_calculator_result');
  static const emergencyKey = Key('sc355_withdrawal_emergency');

  static Key tabKey(String id) => Key('sc355_withdrawal_tab_$id');
  static Key timelineKey(String product) =>
      Key('sc355_withdrawal_timeline_$product');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingWithdrawalPolicyPage> createState() =>
      _StakingWithdrawalPolicyPageState();
}

class _StakingWithdrawalPolicyPageState
    extends ConsumerState<StakingWithdrawalPolicyPage> {
  String? _activeTab;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingWithdrawalPolicySnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chính sách rút tiền staking',
      semanticIdentifier: 'SC-355',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
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
                  ref.invalidate(stakingWithdrawalPolicySnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _activeTab ?? snapshot.defaultTab;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollEndPadding =
                (mode.usesVisualQaFrame
                    ? SharedSpacingTokens.bottomNavVisualClearance
                    : SharedSpacingTokens.bottomNavNativeClearance) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Thời gian rút và phí phạt được liệt kê rõ',
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
                        bottom: scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.form,
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: [
                          ConstrainedBox(
                            key: StakingWithdrawalPolicyPage.infoKey,
                            constraints: const BoxConstraints(
                              minHeight: _stakingWithdrawalInfoMinHeight,
                            ),
                            child: VitInfoCallout(
                              title: snapshot.infoTitle,
                              message: snapshot.infoBody,
                              icon: Icons.info_outline_rounded,
                              accentColor: AppModuleAccents.earn,
                              padding: EarnSpacingTokens.earnPaddingX4,
                              radius: VitCardRadius.large,
                            ),
                          ),
                          const VitHighRiskStatePanel(
                            density: VitDensity.compact,
                            state: VitHighRiskUiState.riskReview,
                            title: 'Withdrawal policy review required',
                            message:
                                'Timeline, early fee, emergency limits, preview, confirm and support next steps are reviewed before withdrawal.',
                            contractId: 'staking-withdrawal-policy',
                          ),
                          _PolicyTabs(
                            tabs: snapshot.tabs,
                            active: activeTab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _activeTab = tab);
                            },
                          ),
                          if (activeTab == 'timeline')
                            _TimelineTab(snapshot: snapshot)
                          else if (activeTab == 'penalties')
                            _PenaltiesTab(
                              snapshot: snapshot,
                              onOpenCalculator: () => _openCalculator(snapshot),
                            )
                          else
                            _EmergencyTab(snapshot: snapshot),
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

  Future<void> _openCalculator(StakingWithdrawalPolicySnapshot snapshot) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _PenaltyCalculatorSheet(snapshot: snapshot),
    );
  }
}

class _PolicyTabs extends StatelessWidget {
  const _PolicyTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingRiskDisclosureTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: StakingWithdrawalPolicyPage.tabKey(tab.id),
          ),
      ],
    );
  }
}
