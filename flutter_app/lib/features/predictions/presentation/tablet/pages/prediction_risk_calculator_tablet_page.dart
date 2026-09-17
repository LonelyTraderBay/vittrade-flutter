import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

part 'prediction_risk_calculator_tablet_sections.dart';
part 'prediction_risk_calculator_tablet_guide.dart';

/// SC-216: Máy tính rủi ro dự đoán trên tablet — công cụ tính sống như phone
/// SC-036: 3 tab Máy tính / Kịch bản / Hướng dẫn, 5 ô nhập cập nhật chỉ số
/// realtime (max loss/gain, break-even, Kelly) qua state cục bộ.
class PredictionRiskCalculatorTabletPage extends ConsumerStatefulWidget {
  const PredictionRiskCalculatorTabletPage({super.key});

  static const contentKey = Key('sc216_tablet_content');
  static const resultPaneKey = Key('sc216_tablet_result_pane');
  static const calculatorTabKey = Key('sc216_tab_calculator');
  static const scenariosTabKey = Key('sc216_tab_scenarios');
  static const guideTabKey = Key('sc216_tab_guide');
  static const sharesFieldKey = Key('sc216_field_shares');
  static const entryFieldKey = Key('sc216_field_entry');
  static const currentFieldKey = Key('sc216_field_current');
  static const yesKey = Key('sc216_outcome_yes');
  static const noKey = Key('sc216_outcome_no');

  @override
  ConsumerState<PredictionRiskCalculatorTabletPage> createState() =>
      _PredictionRiskCalculatorTabletPageState();
}

enum _Sc216Tab { calculator, scenarios, guide }

class _PredictionRiskCalculatorTabletPageState
    extends ConsumerState<PredictionRiskCalculatorTabletPage> {
  _Sc216Tab _activeTab = _Sc216Tab.calculator;
  String _outcome = 'yes';

  // Controller dựng lười trong nhánh `data:` (GD4-F5 bẫy 14) — chỉ seed 1
  // lần, không ghi đè khi user đã chỉnh.
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
      text: _sc216FormatInput(snapshot.defaultShares),
    );
    _entryPriceController = TextEditingController(
      text: snapshot.defaultEntryPrice.toStringAsFixed(2),
    );
    _currentPriceController = TextEditingController(
      text: snapshot.defaultCurrentPrice.toStringAsFixed(2),
    );
    _riskBudgetController = TextEditingController(
      text: _sc216FormatInput(snapshot.defaultBankroll),
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

    return riskCalculatorAsync.when(
      loading: () =>
          _frame(context, body: _statusBody(const [VitSkeletonList(rows: 6)])),
      error: (error, stackTrace) => _frame(
        context,
        body: _statusBody([
          VitErrorState(
            title: 'Không tải được máy tính rủi ro',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(predictionsRiskCalculatorSnapshotProvider),
          ),
        ]),
      ),
      data: (snapshot) {
        _ensureControllers(snapshot);
        final inputs = _Sc216RiskInputs(
          shares: _sc216Parse(_sharesController!.text),
          entryPrice: _sc216Parse(_entryPriceController!.text),
          currentPrice: _sc216Parse(_currentPriceController!.text),
          riskBudget: _sc216Parse(_riskBudgetController!.text, fallback: 1),
        );
        final metrics = _sc216Calculate(inputs);
        final tabBar = VitTabBar(
          variant: VitTabBarVariant.segment,
          activeKey: switch (_activeTab) {
            _Sc216Tab.calculator => 'calculator',
            _Sc216Tab.scenarios => 'scenarios',
            _Sc216Tab.guide => 'guide',
          },
          onChanged: (key) => setState(() {
            _activeTab = _Sc216Tab.values.byName(key);
          }),
          tabs: const [
            VitTabItem(
              key: 'calculator',
              label: 'Máy tính',
              widgetKey: PredictionRiskCalculatorTabletPage.calculatorTabKey,
            ),
            VitTabItem(
              key: 'scenarios',
              label: 'Kịch bản',
              widgetKey: PredictionRiskCalculatorTabletPage.scenariosTabKey,
            ),
            VitTabItem(
              key: 'guide',
              label: 'Hướng dẫn',
              widgetKey: PredictionRiskCalculatorTabletPage.guideTabKey,
            ),
          ],
        );
        final formCard = _Sc216PositionInfoCard(
          eventController: _eventController!,
          sharesController: _sharesController!,
          entryPriceController: _entryPriceController!,
          currentPriceController: _currentPriceController!,
          riskBudgetController: _riskBudgetController!,
          outcome: _outcome,
          onOutcomeChanged: (value) => setState(() => _outcome = value),
        );
        final highRiskPanel = const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Xem lại rủi ro máy tính dự đoán',
          message:
              'Bên kết quả, cổ phần, xác suất vào/hiện tại, ngân sách rủi ro, '
              'tối đa mất, khoảng kết quả, bảng kịch bản và hướng dẫn được xem '
              'trước khi định cỡ vị thế dự đoán.',
          contractId: 'SC-216',
        );
        return _frame(
          context,
          body: VitTabletPaneWorkspace(
            contentKey: PredictionRiskCalculatorTabletPage.contentKey,
            secondaryContentKey:
                PredictionRiskCalculatorTabletPage.resultPaneKey,
            // Khuôn Cụm D "form trái — kết quả phải": bảng nhập cột chính,
            // kết quả live cập nhật từng keystroke ghim panel phải.
            primaryChildren: [
              tabBar,
              if (_activeTab == _Sc216Tab.calculator)
                formCard
              else if (_activeTab == _Sc216Tab.scenarios)
                _Sc216ScenariosTab(inputs: inputs, metrics: metrics)
              else
                const _Sc216GuideTab(),
              highRiskPanel,
            ],
            secondaryChildren: [
              _Sc216PositionSummary(inputs: inputs),
              _Sc216RiskAnalysis(metrics: metrics),
              _Sc216KellyRecommendation(
                metrics: metrics,
                riskBudget: inputs.riskBudget,
              ),
              const _Sc216RiskWarning(),
            ],
            narrowChildren: [
              tabBar,
              if (_activeTab == _Sc216Tab.calculator) ...[
                formCard,
                _Sc216PositionSummary(inputs: inputs),
                _Sc216RiskAnalysis(metrics: metrics),
                _Sc216KellyRecommendation(
                  metrics: metrics,
                  riskBudget: inputs.riskBudget,
                ),
                const _Sc216RiskWarning(),
              ] else if (_activeTab == _Sc216Tab.scenarios)
                _Sc216ScenariosTab(inputs: inputs, metrics: metrics)
              else
                const _Sc216GuideTab(),
              highRiskPanel,
            ],
          ),
        );
      },
    );
  }

  Widget _frame(BuildContext context, {required Widget body}) {
    final showBack = context.canPop();
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Máy tính rủi ro prediction',
      semanticIdentifier: 'SC-216',
      child: Column(
        children: [
          VitHeader(
            title: 'Máy tính rủi ro',
            subtitle: 'Rủi ro · Prediction',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.marketsPredictions,
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
      key: PredictionRiskCalculatorTabletPage.contentKey,
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

// --- Toán phân tích rủi ro (bản sao trung thành của phone SC-036) ---------

class _Sc216RiskInputs {
  const _Sc216RiskInputs({
    required this.shares,
    required this.entryPrice,
    required this.currentPrice,
    required this.riskBudget,
  });

  final double shares;
  final double entryPrice;
  final double currentPrice;
  final double riskBudget;

  double get cost => shares * entryPrice;
  double get currentValue => shares * currentPrice;
}

class _Sc216RiskMetrics {
  const _Sc216RiskMetrics({
    required this.maxLoss,
    required this.maxGain,
    required this.breakEvenPrice,
    required this.probabilityOfProfit,
    required this.expectedValue,
    required this.riskRewardRatio,
    required this.suggestedExposure,
  });

  final double maxLoss;
  final double maxGain;
  final double breakEvenPrice;
  final double probabilityOfProfit;
  final double expectedValue;
  final double riskRewardRatio;
  final double suggestedExposure;
}

_Sc216RiskMetrics _sc216Calculate(_Sc216RiskInputs inputs) {
  final maxLoss = inputs.cost;
  final maxGain = inputs.shares * (1 - inputs.entryPrice);
  final ratio = maxLoss > 0 ? maxGain / maxLoss : 0.0;
  final expectedValue =
      (inputs.currentPrice * maxGain) - ((1 - inputs.currentPrice) * maxLoss);
  final kellyFraction = ratio > 0
      ? ((inputs.currentPrice * ratio) - (1 - inputs.currentPrice)) / ratio
      : 0.0;
  final safeKellyFraction = kellyFraction.clamp(0.0, 1.0).toDouble();

  return _Sc216RiskMetrics(
    maxLoss: maxLoss,
    maxGain: maxGain,
    breakEvenPrice: inputs.entryPrice,
    probabilityOfProfit: inputs.currentPrice * 100,
    expectedValue: expectedValue,
    riskRewardRatio: ratio,
    suggestedExposure: safeKellyFraction * inputs.riskBudget,
  );
}

double _sc216Parse(String value, {double fallback = 0}) {
  return double.tryParse(value) ?? fallback;
}

String _sc216FormatInput(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toString();
}
