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
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/phone/prediction_enum_tab_bar.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/portfolio/prediction_portfolio_analyzer_overview.dart';
part '../../../widgets/portfolio/prediction_portfolio_analyzer_performance.dart';
part '../../../widgets/portfolio/prediction_portfolio_analyzer_risk.dart';

const _predictionPrimary = AppColors.primary;
const _purple = AppColors.accent;

enum _AnalyzerTab { overview, performance, risk }

class PredictionPortfolioAnalyzerPage extends ConsumerStatefulWidget {
  const PredictionPortfolioAnalyzerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc038_portfolio_analyzer_content');
  static const overviewTabKey = Key('sc038_tab_overview');
  static const performanceTabKey = Key('sc038_tab_performance');
  static const riskTabKey = Key('sc038_tab_risk');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionPortfolioAnalyzerPage> createState() =>
      _PredictionPortfolioAnalyzerPageState();
}

class _PredictionPortfolioAnalyzerPageState
    extends ConsumerState<PredictionPortfolioAnalyzerPage> {
  _AnalyzerTab _activeTab = _AnalyzerTab.overview;

  @override
  Widget build(BuildContext context) {
    final analyzerAsync = ref.watch(
      predictionsPortfolioAnalyzerSnapshotProvider,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final footerPadding =
        footerChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích danh mục dự đoán',
      semanticIdentifier: 'SC-038',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Portfolio Analyzer',
            subtitle: 'Phân tích · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AnalyzerTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionPortfolioAnalyzerPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionAnalyzerScrollPadding(
                          footerPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
                      children: analyzerAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được phân tích danh mục',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsPortfolioAnalyzerSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          ...switch (_activeTab) {
                            _AnalyzerTab.overview => [
                              _PortfolioSummaryCard(snapshot: snapshot),
                              _StatsGrid(snapshot: snapshot),
                              _CategoryCard(snapshot: snapshot),
                            ],
                            _AnalyzerTab.performance => [
                              _PerformanceChartCard(snapshot: snapshot),
                              _TradeStatsSection(snapshot: snapshot),
                              _AttributionSection(snapshot: snapshot),
                            ],
                            _AnalyzerTab.risk => [
                              _RiskMetricsSection(snapshot: snapshot),
                              _CategoryRiskCard(snapshot: snapshot),
                              _DiversificationCard(snapshot: snapshot),
                              const _RiskWarning(),
                            ],
                          },
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Prediction portfolio analyzer review',
                            message:
                                'Portfolio value, category exposure, P/L attribution, probability drift, risk concentration, diversification, and warning states are reviewed before portfolio decisions.',
                            contractId: 'SC-038',
                            density: VitDensity.compact,
                          ),
                        ],
                      ),
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
