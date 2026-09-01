import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/disclosures/performance_scenarios_intro_widgets.dart';
part '../../../widgets/disclosures/performance_scenarios_outcome_widgets.dart';

const _scenarioBorder = AppColors.borderSolid;
const _scenarioPrimary = AppColors.primary;
const _scenarioRed = AppColors.sell;
const _scenarioAmber = AppColors.caution;
const _scenarioGreen = AppColors.buy;
const _scenarioSpace = AppSpacing.x2;
const _scenarioTinySpace = AppSpacing.x1;
const _scenarioIconTile = AppSpacing.iconLg;
const _scenarioLineTight = 1.2;

class PerformanceScenariosPage extends ConsumerStatefulWidget {
  const PerformanceScenariosPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc109_performance_scenarios_content');
  static Key periodKey(int years) => Key('sc109_period_$years');
  static Key scenarioKey(String label) =>
      Key('sc109_scenario_${label.toLowerCase()}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PerformanceScenariosPage> createState() =>
      _PerformanceScenariosPageState();
}

class _PerformanceScenariosPageState
    extends ConsumerState<PerformanceScenariosPage> {
  int? _holdingPeriod;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradePerformanceScenariosProvider);
    return VitTradeHubScaffold(
      title: 'Performance Scenarios',
      subtitle: 'Potential Outcomes',
      semanticLabel: 'Các kịch bản hiệu suất đầu tư có thể xảy ra',
      semanticIdentifier: 'SC-109',
      contentKey: PerformanceScenariosPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradePerformanceScenariosProvider),
          ),
        ],
        data: (snapshot) {
          final selectedPeriod =
              _holdingPeriod ?? snapshot.defaultHoldingPeriod;
          return [
            const VitTradeSection(
              title: 'Review',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Review performance scenario risk',
                message:
                    'Confirm fees, loss limits, assumptions, and next steps before relying on modeled copy-trading outcomes.',
                density: VitDensity.tool,
              ),
            ),
            VitTradeComplianceSection(
              title: 'Scenario status',
              statusPill: VitStatusPill(
                label: '$selectedPeriod year hold',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Investment',
                  value: '€${snapshot.investment.toStringAsFixed(0)}',
                ),
                VitTradeComplianceItem(
                  label: 'Scenarios',
                  value: '${snapshot.scenarios.length} modeled',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Outcomes',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _WarningNotice(),
                  _InvestmentCard(investment: snapshot.investment),
                  _HoldingPeriodSelector(
                    periods: snapshot.holdingPeriods,
                    selectedPeriod: selectedPeriod,
                    onChanged: (value) =>
                        setState(() => _holdingPeriod = value),
                  ),
                  VitPageSection(
                    label: 'Potential Outcomes',
                    accentColor: _scenarioPrimary,
                    density: VitDensity.tool,
                    children: [
                      for (final scenario in snapshot.scenarios)
                        _ScenarioCard(
                          scenario: scenario,
                          investment: snapshot.investment,
                          holdingPeriod: selectedPeriod,
                        ),
                    ],
                  ),
                  const _InfoNote(),
                  const TradeBodyReviewSection(
                    title: 'Rà soát nội dung kịch bản',
                    message: 'Đã rà soát nội dung kịch bản hiệu suất',
                    detail:
                        'Kỳ hạn nắm giữ, kết quả mô phỏng, cảnh báo, giả định, trạng thái rỗng và trạng thái kết quả luôn hiển thị.',
                    primary:
                        'Cảnh báo rủi ro và tổng quan khoản đầu tư luôn hiển thị trước các kết quả mô phỏng.',
                    secondary:
                        'Các thẻ kịch bản vẫn là giả định, không phải cam kết lợi nhuận.',
                    tertiary:
                        'Bộ điều khiển kỳ hạn nắm giữ luôn gắn liền với các phép tính kết quả hiển thị.',
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
