import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'prediction_portfolio_analyzer_tablet_tabs.dart';

/// SC-218: Phân tích danh mục dự đoán trên tablet — như phone SC-038: 3 tab
/// Tổng quan / Hiệu suất / Rủi ro; chỉ số suy ra từ snapshot positions +
/// pnlHistory (drawdown, volatility, concentration, sharpe).
class PredictionPortfolioAnalyzerTabletPage extends ConsumerStatefulWidget {
  const PredictionPortfolioAnalyzerTabletPage({super.key});

  static const contentKey = Key('sc218_tablet_content');
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
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          VitErrorState(
            title: 'Không tải được phân tích danh mục',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(predictionsPortfolioAnalyzerSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => _frame(
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        children: [
          VitTabBar(
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
          ),
          if (_activeTab == _Sc218Tab.overview)
            _Sc218OverviewTab(snapshot: snapshot)
          else if (_activeTab == _Sc218Tab.performance)
            _Sc218PerformanceTab(snapshot: snapshot)
          else
            _Sc218RiskTab(snapshot: snapshot),
        ],
      ),
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-218',
      semanticLabel: 'Phân tích danh mục prediction',
      title: 'Phân tích danh mục',
      subtitle: subtitle ?? 'Hiệu suất · Rủi ro · Danh mục',
      contentKey: PredictionPortfolioAnalyzerTabletPage.contentKey,
      children: children,
    );
  }
}
