import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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

part '../../../widgets/savings/savings_analytics_summary_range.dart';
part '../../../widgets/savings/savings_analytics_charts_metrics.dart';
part '../../../widgets/savings/savings_analytics_secondary_painters.dart';

class SavingsAnalyticsPage extends ConsumerStatefulWidget {
  const SavingsAnalyticsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc343_summary');
  static const yieldChartKey = Key('sc343_yield_chart');
  static const monthlyChartKey = Key('sc343_monthly_chart');
  static const metricsKey = Key('sc343_metrics');

  static Key tabKey(String tab) => Key('sc343_tab_$tab');
  static Key rangeKey(String range) => Key('sc343_range_$range');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsAnalyticsPage> createState() =>
      _SavingsAnalyticsPageState();
}

class _SavingsAnalyticsPageState extends ConsumerState<SavingsAnalyticsPage> {
  String? _tab;
  String? _range;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsAnalyticsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích Tiết kiệm',
      semanticIdentifier: 'SC-343',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnDashboard),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnDashboard),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(savingsAnalyticsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _tab ?? snapshot.defaultTab;
            final activeRange = _range ?? snapshot.defaultTimeRange;
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
                          _SummaryHero(summary: snapshot.summary),
                          VitTabBar(
                            variant: VitTabBarVariant.segment,
                            activeKey: activeTab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                            tabs: [
                              for (final tab in snapshot.tabs)
                                VitTabItem(key: tab, label: tab),
                            ],
                          ),
                          if (activeTab == 'Yield') ...[
                            _TimeRangeSelector(
                              ranges: snapshot.timeRanges,
                              activeRange: activeRange,
                              onChanged: (range) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _range = range);
                              },
                            ),
                            _YieldChartCard(
                              summary: snapshot.summary,
                              points: snapshot.yieldHistory,
                            ),
                            _MonthlyIncomeCard(
                              points: snapshot.monthlyEarnings,
                            ),
                            _MetricRow(summary: snapshot.summary),
                          ] else
                            _SecondaryTabContent(
                              tab: activeTab,
                              summary: snapshot.summary,
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
}
