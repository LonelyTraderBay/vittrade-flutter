import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_dashboard_actions.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_dashboard_charts.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_dashboard_positions.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_dashboard_summary.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingDashboardPage extends ConsumerStatefulWidget {
  const StakingDashboardPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc358_summary_card');
  static const performanceKey = Key('sc358_performance_chart');
  static const allocationKey = Key('sc358_allocation_card');
  static const positionsKey = Key('sc358_positions_section');
  static const stakeMoreKey = Key('sc358_stake_more');
  static const analyticsKey = Key('sc358_analytics');
  static const historyKey = Key('sc358_history');
  static const calendarKey = Key('sc358_calendar');
  static const alertKey = Key('sc358_maturity_alert');

  static Key positionKey(String id) => Key('sc358_position_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingDashboardPage> createState() =>
      _StakingDashboardPageState();
}

class _StakingDashboardPageState extends ConsumerState<StakingDashboardPage> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingDashboardSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Bảng điều khiển staking — hiệu suất, phân bổ tài sản và các vị thế đang stake',
      semanticIdentifier: 'SC-358',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(stakingDashboardSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
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
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          StakingDashboardSummaryCard(
                            key: StakingDashboardPage.summaryKey,
                            snapshot: snapshot,
                            isRefreshing: _isRefreshing,
                            onRefresh: _refresh,
                            onExport: _exportReport,
                          ),
                          VitPageSection(
                            label: 'Biểu đồ Hiệu suất (6 tháng)',
                            accentColor: AppColors.primary,
                            children: [
                              StakingPerformanceCard(
                                key: StakingDashboardPage.performanceKey,
                                points: snapshot.performance,
                              ),
                            ],
                          ),
                          VitPageSection(
                            label: 'Phân bổ Tài sản',
                            accentColor: AppColors.primary,
                            children: [
                              StakingAllocationCard(
                                key: StakingDashboardPage.allocationKey,
                                allocations: snapshot.allocations,
                                total: snapshot.totalStakedUsd,
                              ),
                            ],
                          ),
                          StakingPositionsSection(
                            sectionKey: StakingDashboardPage.positionsKey,
                            positionKey: StakingDashboardPage.positionKey,
                            positions: snapshot.positions,
                          ),
                          StakingDashboardQuickActions(
                            stakeMoreKey: StakingDashboardPage.stakeMoreKey,
                            analyticsKey: StakingDashboardPage.analyticsKey,
                            snapshot: snapshot,
                          ),
                          StakingDashboardNavigationCards(
                            historyKey: StakingDashboardPage.historyKey,
                            calendarKey: StakingDashboardPage.calendarKey,
                            snapshot: snapshot,
                          ),
                          if (snapshot.maturingSoon > 0)
                            StakingMaturityAlert(
                              key: StakingDashboardPage.alertKey,
                              snapshot: snapshot,
                            ),
                          const EarnDisclaimerBanner(
                            text:
                                'APY là ước tính tham khảo và có thể thay đổi. '
                                'Giá tài sản và APY có thể biến động; DeFi có rủi ro smart contract.',
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

  void _refresh() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _isRefreshing = true);
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _isRefreshing = false);
    });
  }

  void _exportReport() {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sẽ sớm ra mắt',
        message: 'Xuất báo cáo CSV/PDF sẽ sớm ra mắt',
      ),
    );
  }
}
