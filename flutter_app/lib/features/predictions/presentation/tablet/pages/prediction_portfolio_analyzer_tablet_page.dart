import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_pane_workspace.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'prediction_portfolio_analyzer_tablet_tabs.dart';

/// SC-218: Phân tích danh mục dự đoán trên tablet — workspace 2 cột (redesign
/// Cụm C 2026-09-17): cột chính = 3 tab Tổng quan / Hiệu suất / Rủi ro; panel
/// phải = chỉ số nhanh ghim (đọc được khi đang ở bất kỳ tab nào). Chỉ số suy
/// ra từ snapshot positions + pnlHistory như phone SC-038.
class PredictionPortfolioAnalyzerTabletPage extends ConsumerStatefulWidget {
  const PredictionPortfolioAnalyzerTabletPage({super.key});

  static const contentKey = Key('sc218_tablet_content');
  static const statsPaneKey = Key('sc218_tablet_stats_pane');
  static const overviewTabKey = Key('sc218_tab_overview');
  static const performanceTabKey = Key('sc218_tab_performance');
  static const riskTabKey = Key('sc218_tab_risk');

  @override
  ConsumerState<PredictionPortfolioAnalyzerTabletPage> createState() =>
      _PredictionPortfolioAnalyzerTabletPageState();
}

enum _Sc218Tab { overview, performance, risk }

class _PredictionPortfolioAnalyzerTabletPageState
    extends ConsumerState<PredictionPortfolioAnalyzerTabletPage> {
  _Sc218Tab _activeTab = _Sc218Tab.overview;

  @override
  Widget build(BuildContext context) {
    final analyzerAsync = ref.watch(
      predictionsPortfolioAnalyzerSnapshotProvider,
    );

    return analyzerAsync.when(
      loading: () =>
          _frame(context, body: _statusBody(const [VitSkeletonList(rows: 6)])),
      error: (error, stackTrace) => _frame(
        context,
        body: _statusBody([
          VitErrorState(
            title: 'Không tải được phân tích danh mục',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(predictionsPortfolioAnalyzerSnapshotProvider),
          ),
        ]),
      ),
      data: (snapshot) {
        final tabBar = VitTabBar(
          variant: VitTabBarVariant.segment,
          activeKey: switch (_activeTab) {
            _Sc218Tab.overview => 'overview',
            _Sc218Tab.performance => 'performance',
            _Sc218Tab.risk => 'risk',
          },
          onChanged: (key) => setState(() {
            _activeTab = _Sc218Tab.values.byName(key);
          }),
          tabs: const [
            VitTabItem(
              key: 'overview',
              label: 'Tổng quan',
              widgetKey: PredictionPortfolioAnalyzerTabletPage.overviewTabKey,
            ),
            VitTabItem(
              key: 'performance',
              label: 'Hiệu suất',
              widgetKey:
                  PredictionPortfolioAnalyzerTabletPage.performanceTabKey,
            ),
            VitTabItem(
              key: 'risk',
              label: 'Rủi ro',
              widgetKey: PredictionPortfolioAnalyzerTabletPage.riskTabKey,
            ),
          ],
        );
        final tabContent = switch (_activeTab) {
          _Sc218Tab.overview => _Sc218OverviewTab(snapshot: snapshot),
          _Sc218Tab.performance => _Sc218PerformanceTab(snapshot: snapshot),
          _Sc218Tab.risk => _Sc218RiskTab(snapshot: snapshot),
        };
        return _frame(
          context,
          subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
          body: VitTabletPaneWorkspace(
            contentKey: PredictionPortfolioAnalyzerTabletPage.contentKey,
            secondaryContentKey:
                PredictionPortfolioAnalyzerTabletPage.statsPaneKey,
            primaryChildren: [tabBar, tabContent],
            secondaryChildren: [_Sc218QuickStatsPanel(snapshot: snapshot)],
            narrowChildren: [tabBar, tabContent],
          ),
        );
      },
    );
  }

  Widget _frame(
    BuildContext context, {
    required Widget body,
    String? subtitle,
  }) {
    final showBack = context.canPop();
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích danh mục prediction',
      semanticIdentifier: 'SC-218',
      child: Column(
        children: [
          VitHeader(
            title: 'Phân tích danh mục',
            subtitle: subtitle ?? 'Hiệu suất · Rủi ro · Danh mục',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.marketsPredictionsPortfolio,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  /// Thân một cột cho trạng thái loading/error — recipe cột hẹp workspace.
  Widget _statusBody(List<Widget> children) {
    return SingleChildScrollView(
      key: PredictionPortfolioAnalyzerTabletPage.contentKey,
      padding: const EdgeInsetsDirectional.only(
        bottom: TabletSpacingTokens.pageEndBreathing,
      ),
      child: VitPageContent(
        padding: VitContentPadding.compact,
        fullBleed: true,
        rhythm: VitPageRhythm.standard,
        children: children,
      ),
    );
  }
}
