import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/phone/dca_currency_formatters.dart';

part '../../../widgets/portfolio/dca_performance_compare_tabs.dart';
part '../../../widgets/portfolio/dca_performance_compare_charts.dart';
part '../../../widgets/portfolio/dca_performance_compare_analysis.dart';
part '../../../widgets/portfolio/dca_performance_compare_primitives.dart';
part '../../../widgets/portfolio/dca_performance_compare_painters.dart';

enum _CompareTab { compare, scenarios, analysis }

class DCAPerformanceComparePage extends ConsumerStatefulWidget {
  const DCAPerformanceComparePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc178_performance_compare_content');

  static Key tabKey(String tabName) => Key('sc178_tab_$tabName');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAPerformanceComparePage> createState() =>
      _DCAPerformanceComparePageState();
}

class _DCAPerformanceComparePageState
    extends ConsumerState<DCAPerformanceComparePage> {
  _CompareTab _activeTab = _CompareTab.compare;

  @override
  Widget build(BuildContext context) {
    final dcaPerformanceCompareAsync = ref.watch(dcaPerformanceCompareProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'So sánh hiệu suất giữa đầu tư DCA và đầu tư một lần',
      semanticIdentifier: 'SC-178',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'DCA vs Lump Sum',
          subtitle: 'Đầu tư có kỷ luật · so sánh chiến lược',
          showBack: true,
          onBack: _close,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopTabs(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: VitInsetScrollView(
                  key: DCAPerformanceComparePage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  bottomInset: scrollEndPadding,
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      ...dcaPerformanceCompareAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được so sánh hiệu suất',
                            message: 'Thử lại sau hoặc quay lại màn DCA.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(dcaPerformanceCompareProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          if (_activeTab == _CompareTab.compare)
                            ..._buildCompare(snapshot),
                          if (_activeTab == _CompareTab.scenarios)
                            ..._buildScenarios(snapshot),
                          if (_activeTab == _CompareTab.analysis)
                            ..._buildAnalysis(snapshot),
                        ],
                      ),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'So sánh chỉ mang tính tham khảo',
                        message:
                            'Kết quả dựa trên dữ liệu lịch sử; không đảm bảo hiệu suất tương lai. Mọi thay đổi chiến lược DCA cần xem lại trước khi áp dụng.',
                        contractId: 'SC-178',
                        density: VitDensity.compact,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCompare(DcaPerformanceCompareSnapshot snapshot) {
    return [
      Row(
        children: [
          Expanded(
            child: _StrategyCard(
              title: 'DCA Strategy',
              value: _formatUsd(snapshot.dcaFinalValueUsd),
              invested: _formatUsd(snapshot.investedUsd),
              returnPercent: snapshot.dcaReturnPercent,
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _StrategyCard(
              title: 'Lump Sum',
              value: _formatUsd(snapshot.lumpSumFinalValueUsd),
              invested: _formatUsd(snapshot.investedUsd),
              returnPercent: snapshot.lumpSumReturnPercent,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      _WinnerBanner(snapshot: snapshot),
      _ComparisonChartCard(points: snapshot.comparison),
      VitPageSection(
        label: 'Key Metrics',
        children: [
          for (final metric in snapshot.metrics) _MetricCompareCard(metric),
        ],
      ),
    ];
  }

  List<Widget> _buildScenarios(DcaPerformanceCompareSnapshot snapshot) {
    return [
      VitPageSection(
        label: 'Scenarios Analysis',
        children: [
          for (final scenario in snapshot.scenarios)
            _ScenarioCard(scenario: scenario),
        ],
      ),
      const _InfoCard(
        icon: Icons.info_outline_rounded,
        title: 'Recommendation',
        text:
            'DCA is optimal for volatile markets and when you want to reduce timing risk. Lump sum can win in steady bull markets with low volatility.',
      ),
    ];
  }

  List<Widget> _buildAnalysis(DcaPerformanceCompareSnapshot snapshot) {
    return [
      _RadarCard(metrics: snapshot.radar),
      const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _ProsConsCard.dca()),
          SizedBox(width: AppSpacing.x3),
          Expanded(child: _ProsConsCard.lumpSum()),
        ],
      ),
      const _WarningCard(
        text:
            'So sánh dựa trên dữ liệu lịch sử cụ thể. Kết quả có thể khác trong điều kiện thị trường khác. Không đảm bảo hiệu suất tương lai.',
      ),
    ];
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}
