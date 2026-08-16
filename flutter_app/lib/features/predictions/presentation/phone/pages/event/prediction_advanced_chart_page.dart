import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/phone/prediction_enum_tab_bar.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

part '../../../widgets/event/prediction_advanced_chart_overview.dart';
part '../../../widgets/event/prediction_advanced_chart_overview_painters.dart';
part '../../../widgets/event/prediction_advanced_chart_indicators.dart';
part '../../../widgets/event/prediction_advanced_chart_analysis.dart';
part '../../../widgets/event/prediction_advanced_chart_painter_utils.dart';

const _predictionPrimary = AppColors.primary;
const _purple = AppColors.accent;

enum _ChartTab { chart, indicators, analysis }

class PredictionAdvancedChartPage extends ConsumerStatefulWidget {
  const PredictionAdvancedChartPage({
    super.key,
    required this.eventId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc041_advanced_chart_content');
  static const chartTabKey = Key('sc041_tab_chart');
  static const indicatorsTabKey = Key('sc041_tab_indicators');
  static const analysisTabKey = Key('sc041_tab_analysis');
  static const timeframe4hKey = Key('sc041_timeframe_4h');
  static const ma7ToggleKey = Key('sc041_toggle_ma7');
  static const ma25ToggleKey = Key('sc041_toggle_ma25');
  static const bbToggleKey = Key('sc041_toggle_bb');
  static const volumeToggleKey = Key('sc041_toggle_volume');

  final String eventId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionAdvancedChartPage> createState() =>
      _PredictionAdvancedChartPageState();
}

class _PredictionAdvancedChartPageState
    extends ConsumerState<PredictionAdvancedChartPage> {
  _ChartTab _activeTab = _ChartTab.chart;
  String _timeframe = '1H';
  bool _showMA7 = true;
  bool _showMA25 = true;
  bool _showBB = true;
  bool _showVolume = true;

  @override
  Widget build(BuildContext context) {
    final chartAsync = ref.watch(
      predictionsAdvancedChartSnapshotProvider(widget.eventId),
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
      semanticLabel:
          'Biểu đồ nâng cao của sự kiện dự đoán: nến giá, chỉ báo kỹ thuật và phân tích',
      semanticIdentifier: 'SC-041',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Advanced Chart',
            subtitle: 'Biểu đồ · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AdvancedChartTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionAdvancedChartPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionAdvancedScrollPadding(
                          footerPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.flush,
                      density: VitDensity.compact,
                      children: chartAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được biểu đồ nâng cao',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsAdvancedChartSnapshotProvider(
                                widget.eventId,
                              ),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          ...switch (_activeTab) {
                            _ChartTab.chart => [
                              _TimeframeSelector(
                                active: _timeframe,
                                onChanged: (value) =>
                                    setState(() => _timeframe = value),
                              ),
                              _ProbabilitySummaryCard(snapshot: snapshot),
                              _ProbabilityChartCard(
                                snapshot: snapshot,
                                showMA7: _showMA7,
                                showMA25: _showMA25,
                                showBB: _showBB,
                              ),
                              if (_showVolume)
                                _VolumeChartCard(snapshot: snapshot),
                              _ChartLayerControls(
                                showMA7: _showMA7,
                                showMA25: _showMA25,
                                showBB: _showBB,
                                showVolume: _showVolume,
                                onMA7: () =>
                                    setState(() => _showMA7 = !_showMA7),
                                onMA25: () =>
                                    setState(() => _showMA25 = !_showMA25),
                                onBB: () => setState(() => _showBB = !_showBB),
                                onVolume: () =>
                                    setState(() => _showVolume = !_showVolume),
                              ),
                            ],
                            _ChartTab.indicators => [
                              _RsiCard(snapshot: snapshot),
                              _IndicatorSummarySection(snapshot: snapshot),
                              const _OverallSignalCard(),
                            ],
                            _ChartTab.analysis => [
                              _OrderFlowCard(snapshot: snapshot),
                              _SupportResistanceSection(snapshot: snapshot),
                              _PatternRecognitionCard(snapshot: snapshot),
                              const _AnalysisDisclaimer(),
                            ],
                          },
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Prediction advanced-chart review',
                            message:
                                'Timeframe, probability movement, volume, indicators, support/resistance, order flow, pattern signals, and disclaimer states are reviewed before acting on chart analysis.',
                            contractId: 'SC-041',
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

class _AdvancedChartTabBar extends StatelessWidget {
  const _AdvancedChartTabBar({
    required this.activeTab,
    required this.onChanged,
  });

  final _ChartTab activeTab;
  final ValueChanged<_ChartTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return PredictionEnumTabBar<_ChartTab>(
      activeTab: activeTab,
      onChanged: onChanged,
      items: const [
        (PredictionAdvancedChartPage.chartTabKey, _ChartTab.chart, 'Bieu do'),
        (
          PredictionAdvancedChartPage.indicatorsTabKey,
          _ChartTab.indicators,
          'Chi bao',
        ),
        (
          PredictionAdvancedChartPage.analysisTabKey,
          _ChartTab.analysis,
          'Phan tich',
        ),
      ],
    );
  }
}
