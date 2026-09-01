import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
part '../../../widgets/phone/launchpad_performance_overview.dart';
part '../../../widgets/phone/launchpad_performance_projects.dart';
part '../../../widgets/phone/launchpad_performance_chart_common.dart';

const double _launchpadPerformanceVisualNavClearance =
    DeviceMetrics.bottomChrome + AppSpacing.x3;
const double _launchpadPerformanceNativeNavClearance =
    DeviceMetrics.nativeBottomChrome + AppSpacing.x3;
const double _launchpadPerformanceLineHeightTight =
    LaunchpadSpacingTokens.launchpadLineHeightTight;
const double _launchpadPerformanceLineHeightLabel =
    LaunchpadSpacingTokens.launchpadLineHeightLabel;
const double _launchpadPerformanceLineHeightBody =
    LaunchpadSpacingTokens.launchpadLineHeightReadable;
const double _launchpadPerformanceLineHeightReadable =
    LaunchpadSpacingTokens.launchpadLineHeightReadable;
const double _launchpadPerformanceChartHeight = 176;
const double _launchpadPerformanceSparklineHeight = 164;
const double _launchpadPerformanceAxisLabelWidth = AppSpacing.inputHeight;
const double _launchpadPerformanceProjectIconBox = AppSpacing.inputHeight;
const EdgeInsetsGeometry _launchpadPerformanceCardPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x3,
    );
const EdgeInsetsGeometry _launchpadPerformanceHeroPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x4,
    );

class LaunchpadPerformancePage extends ConsumerStatefulWidget {
  const LaunchpadPerformancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc297_launchpad_performance_content');
  static const heroKey = Key('sc297_launchpad_performance_hero');
  static const tabsKey = Key('sc297_launchpad_performance_tabs');
  static const bestWorstKey = Key('sc297_launchpad_performance_best_worst');
  static const distributionKey = Key(
    'sc297_launchpad_performance_distribution',
  );
  static const disclaimerKey = Key('sc297_launchpad_performance_disclaimer');

  static Key tabKey(String id) => Key('sc297_launchpad_performance_tab_$id');
  static Key projectKey(String id) =>
      Key('sc297_launchpad_performance_project_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPerformancePage> createState() =>
      _LaunchpadPerformancePageState();
}

class _LaunchpadPerformancePageState
    extends ConsumerState<LaunchpadPerformancePage> {
  var _activeTab = _PerformanceTab.overview;

  @override
  Widget build(BuildContext context) {
    final performanceAsync = ref.watch(launchpadPerformanceSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _launchpadPerformanceVisualNavClearance
        : _launchpadPerformanceNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hiệu suất lịch sử các dự án Launchpad',
      semanticIdentifier: 'SC-297',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          semanticLabel: 'Hiệu suất Launchpad – vùng cuộn nội dung',
          semanticIdentifier: 'SC-297',
          header: VitHeader(
            title: 'Hiệu suất Launchpad',
            subtitle: 'Lịch sử · Thống kê',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.launchpad),
          ),
          child: Column(
            children: [
              _PerformanceTabs(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: LaunchpadPerformancePage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        ...performanceAsync.when(
                          loading: () => const [VitSkeletonList()],
                          error: (error, stackTrace) => [
                            VitErrorState(
                              title: 'Không tải được hiệu suất',
                              message: 'Vui lòng kiểm tra kết nối và thử lại.',
                              actionLabel: 'Thử lại',
                              onAction: () => ref.invalidate(
                                launchpadPerformanceSnapshotProvider,
                              ),
                            ),
                          ],
                          data: (snapshot) => [
                            switch (_activeTab) {
                              _PerformanceTab.overview => _OverviewTab(
                                snapshot: snapshot,
                              ),
                              _PerformanceTab.projects => _ProjectsTab(
                                projects: snapshot.projects,
                              ),
                              _PerformanceTab.chart => _ChartTab(
                                points: snapshot.chartPoints,
                              ),
                            },
                            const _PerformanceDisclaimer(),
                          ],
                        ),
                      ],
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
}
