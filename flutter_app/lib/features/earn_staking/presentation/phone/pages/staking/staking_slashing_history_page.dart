import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_slashing_history_common.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_slashing_history_history.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_slashing_history_overview.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_slashing_history_prevention.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_slashing_history_statistics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

class StakingSlashingHistoryPage extends ConsumerStatefulWidget {
  const StakingSlashingHistoryPage({super.key, this.shellRenderMode});

  static const infoKey = StakingSlashingHistoryKeys.info;
  static const statsKey = StakingSlashingHistoryKeys.stats;
  static const tabsKey = StakingSlashingHistoryKeys.tabs;
  static const historyKey = StakingSlashingHistoryKeys.history;
  static const statisticsKey = StakingSlashingHistoryKeys.statistics;
  static const trendKey = StakingSlashingHistoryKeys.trend;
  static const preventionKey = StakingSlashingHistoryKeys.prevention;
  static const exportKey = StakingSlashingHistoryKeys.export;
  static const footerKey = StakingSlashingHistoryKeys.footer;

  static Key tabKey(String id) => StakingSlashingHistoryKeys.tab(id);
  static Key eventKey(String id) => StakingSlashingHistoryKeys.event(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingSlashingHistoryPage> createState() =>
      _StakingSlashingHistoryPageState();
}

class _StakingSlashingHistoryPageState
    extends ConsumerState<StakingSlashingHistoryPage> {
  StakingSlashingTab _activeTab = StakingSlashingTab.history;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingSlashingHistorySnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử slashing và thống kê rủi ro validator',
      semanticIdentifier: 'SC-382',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnRiskDashboard),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnRiskDashboard),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingSlashingHistorySnapshotProvider),
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
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Lịch sử slashing — rủi ro validator',
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
                          VitCard(
                            variant: VitCardVariant.standard,
                            radius: VitCardRadius.standard,
                            padding: AppSpacing.zeroInsets,
                            child: StakingSlashingInsuranceBanner(
                              snapshot: snapshot,
                            ),
                          ),
                          StakingSlashingSummaryStats(stats: snapshot.stats),
                          StakingSlashingTabs(
                            active: _activeTab,
                            onChanged: (tab) =>
                                setState(() => _activeTab = tab),
                          ),
                          switch (_activeTab) {
                            StakingSlashingTab.history =>
                              StakingSlashingHistoryTab(snapshot: snapshot),
                            StakingSlashingTab.statistics =>
                              StakingSlashingStatisticsTab(snapshot: snapshot),
                            StakingSlashingTab.prevention =>
                              StakingSlashingPreventionTab(snapshot: snapshot),
                          },
                          StakingSlashingExportButton(
                            label: snapshot.exportLabel,
                          ),
                          StakingSlashingFooterNote(note: snapshot.footerNote),
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
}
