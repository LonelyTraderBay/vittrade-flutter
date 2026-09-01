import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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

part '../../../widgets/portfolio/prediction_risk_calculator_form.dart';
part '../../../widgets/portfolio/prediction_risk_calculator_analysis.dart';
part '../../../widgets/portfolio/prediction_risk_calculator_scenarios_guide.dart';

const _predictionPrimary = AppColors.primary;

enum _RiskTab { calculator, scenarios, guide }

class PredictionRiskCalculatorPage extends ConsumerStatefulWidget {
  const PredictionRiskCalculatorPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc036_risk_calculator_content');
  static const calculatorTabKey = Key('sc036_tab_calculator');
  static const scenariosTabKey = Key('sc036_tab_scenarios');
  static const guideTabKey = Key('sc036_tab_guide');
  static const yesKey = Key('sc036_outcome_yes');
  static const noKey = Key('sc036_outcome_no');
  static const sharesFieldKey = Key('sc036_shares_field');
  static const entryFieldKey = Key('sc036_entry_field');
  static const currentFieldKey = Key('sc036_current_field');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionRiskCalculatorPage> createState() =>
      _PredictionRiskCalculatorPageState();
}

class _PredictionRiskCalculatorPageState
    extends ConsumerState<PredictionRiskCalculatorPage> {
  _RiskTab _activeTab = _RiskTab.calculator;
  String _outcome = 'yes';
  // GD4-F5 (bẫy 14): controller giờ dựng lười trong nhánh `data:` (thay
  // initState đọc repo giờ đã async) — nullable, `_ensureControllers` chỉ
  // seed 1 lần, không ghi đè khi user đã chỉnh.
  TextEditingController? _eventController;
  TextEditingController? _sharesController;
  TextEditingController? _entryPriceController;
  TextEditingController? _currentPriceController;
  TextEditingController? _riskBudgetController;

  void _ensureControllers(PredictionRiskCalculatorSnapshot snapshot) {
    if (_eventController != null) return;
    _outcome = snapshot.defaultOutcome;
    _eventController = TextEditingController(text: snapshot.defaultEventName);
    _sharesController = TextEditingController(
      text: _formatInput(snapshot.defaultShares),
    );
    _entryPriceController = TextEditingController(
      text: snapshot.defaultEntryPrice.toStringAsFixed(2),
    );
    _currentPriceController = TextEditingController(
      text: snapshot.defaultCurrentPrice.toStringAsFixed(2),
    );
    _riskBudgetController = TextEditingController(
      text: _formatInput(snapshot.defaultBankroll),
    );

    for (final controller in [
      _eventController!,
      _sharesController!,
      _entryPriceController!,
      _currentPriceController!,
      _riskBudgetController!,
    ]) {
      controller.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _eventController,
      _sharesController,
      _entryPriceController,
      _currentPriceController,
      _riskBudgetController,
    ]) {
      controller?.removeListener(_refresh);
      controller?.dispose();
    }
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final riskCalculatorAsync = ref.watch(
      predictionsRiskCalculatorSnapshotProvider,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Máy tính rủi ro dự đoán',
      semanticIdentifier: 'SC-036',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Risk Calculator',
            subtitle: 'Rủi ro · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _RiskTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionRiskCalculatorPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionRiskScrollPadding(
                          scrollEndPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      children: riskCalculatorAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được máy tính rủi ro',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsRiskCalculatorSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) {
                          _ensureControllers(snapshot);
                          final inputs = _RiskInputs(
                            shares: _parse(_sharesController!.text),
                            entryPrice: _parse(_entryPriceController!.text),
                            currentPrice: _parse(_currentPriceController!.text),
                            riskBudget: _parse(
                              _riskBudgetController!.text,
                              fallback: 1,
                            ),
                          );
                          final metrics = _calculate(inputs);
                          return [
                            ...(_activeTab == _RiskTab.calculator
                                ? [
                                    _PositionInfoCard(
                                      eventController: _eventController!,
                                      sharesController: _sharesController!,
                                      entryPriceController:
                                          _entryPriceController!,
                                      currentPriceController:
                                          _currentPriceController!,
                                      riskBudgetController:
                                          _riskBudgetController!,
                                      outcome: _outcome,
                                      onOutcomeChanged: (value) =>
                                          setState(() => _outcome = value),
                                    ),
                                    _PositionSummary(inputs: inputs),
                                    _RiskAnalysis(metrics: metrics),
                                    _KellyRecommendation(
                                      metrics: metrics,
                                      riskBudget: inputs.riskBudget,
                                    ),
                                    const _RiskWarning(),
                                  ]
                                : _activeTab == _RiskTab.scenarios
                                ? [
                                    _ScenariosTab(
                                      inputs: inputs,
                                      metrics: metrics,
                                    ),
                                  ]
                                : const [_GuideTab()]),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Prediction risk-calculator review',
                              message:
                                  'Outcome side, shares, entry/current probability, risk budget, max loss, result range, scenario table, and guidance states are reviewed before sizing a prediction position.',
                              contractId: 'SC-036',
                            ),
                          ];
                        },
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
