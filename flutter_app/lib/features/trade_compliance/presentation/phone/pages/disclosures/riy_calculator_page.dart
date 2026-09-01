import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/disclosures/riy_calculator_page_sections.dart';
part '../../../widgets/disclosures/riy_calculator_page_common.dart';

const _riyPanel2 = AppColors.surface2;
const _riyBorder = AppColors.borderSolid;
const _riyPrimary = AppColors.primary;
const _riyGreen = AppColors.buy;
const _riyRed = AppColors.sell;
const _riyGrid = AppColors.portfolioBtnGhost;
const double _riyMetricExtent = AppSpacing.buttonCompact + AppSpacing.x3;
const double _riyCostImpactExtent = AppSpacing.buttonStandard + AppSpacing.x6;
const double _riyChartExtent = AppSpacing.buttonStandard * 2 + AppSpacing.x7;

class RIYCalculatorPage extends ConsumerStatefulWidget {
  const RIYCalculatorPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc106_riy_content');
  static const investmentKey = Key('sc106_riy_investment');
  static const expectedReturnKey = Key('sc106_riy_expected_return');
  static const totalCostsKey = Key('sc106_riy_total_costs');
  static const yearsKey = Key('sc106_riy_years');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RIYCalculatorPage> createState() => _RIYCalculatorPageState();
}

class _RIYCalculatorPageState extends ConsumerState<RIYCalculatorPage> {
  late double _investment;
  late double _expectedReturn;
  late double _totalCosts;
  late int _years;
  bool _seeded = false;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeRiyCalculatorProvider);

    return VitTradeHubScaffold(
      title: 'RIY Calculator',
      subtitle: 'Cost Impact Analysis',
      semanticLabel: 'Máy tính mức giảm lợi suất do chi phí (RIY)',
      semanticIdentifier: 'SC-106',
      contentKey: RIYCalculatorPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyExAnteCosts,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeRiyCalculatorProvider),
          ),
        ],
        data: (snapshot) {
          if (!_seeded) {
            _investment = snapshot.investmentAmount;
            _expectedReturn = snapshot.expectedReturnPct;
            _totalCosts = snapshot.totalCostsPct;
            _years = snapshot.holdingPeriodYears;
            _seeded = true;
          }
          final projections = _buildProjections(
            investment: _investment,
            expectedReturn: _expectedReturn,
            totalCosts: _totalCosts,
            years: _years,
          );
          final finalWithoutCosts = projections.last.withoutCosts;
          final finalWithCosts = projections.last.withCosts;
          final difference = finalWithoutCosts - finalWithCosts;
          final lossPct = finalWithoutCosts <= 0
              ? 0.0
              : (difference / finalWithoutCosts) * 100;

          return [
            const VitTradeSection(
              title: 'Review',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại tác động chi phí trước khi tiếp tục',
                message:
                    'Xác nhận phí, giả định rủi ro, thời gian nắm giữ và các bước tiếp theo trước khi sử dụng dự phóng RIY cho sao chép giao dịch.',
                density: VitDensity.tool,
              ),
            ),
            VitTradeComplianceSection(
              title: 'RIY impact',
              statusPill: VitStatusPill(
                label: 'Loss ${lossPct.toStringAsFixed(1)}%',
                status: VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Investment',
                  value: _formatEur(_investment),
                ),
                VitTradeComplianceItem(
                  label: 'Holding period',
                  value: '$_years years',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Investment Parameters',
              child: _InputCard(
                investment: _investment,
                expectedReturn: _expectedReturn,
                totalCosts: _totalCosts,
                years: _years,
                onInvestmentChanged: (value) =>
                    setState(() => _investment = value),
                onExpectedReturnChanged: (value) =>
                    setState(() => _expectedReturn = value),
                onTotalCostsChanged: (value) =>
                    setState(() => _totalCosts = value),
                onYearsChanged: (value) => setState(() => _years = value),
              ),
            ),
            VitTradeSection(
              title: 'Impact Analysis',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ResultMetric(
                          label: 'Without Costs',
                          value: _formatEur(finalWithoutCosts),
                          color: _riyGreen,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _ResultMetric(
                          label: 'With Costs',
                          value: _formatEur(finalWithCosts),
                          color: _riyRed,
                        ),
                      ),
                    ],
                  ),
                  _CostImpactCard(
                    years: _years,
                    difference: difference,
                    lossPct: lossPct,
                  ),
                ],
              ),
            ),
            VitTradeSection(
              title: 'Growth Comparison',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ChartCard(projections: projections),
                  const TradeBodyReviewSection(
                    title: 'Rà soát nội dung RIY',
                    message: 'Nội dung máy tính RIY đã được rà soát',
                    detail:
                        'Các trạng thái khoản đầu tư, lợi suất, chi phí, thời gian nắm giữ, biểu đồ, rỗng và kết quả luôn hiển thị.',
                    primary:
                        'Giả định đầu vào luôn nằm phía trên kết quả tác động chi phí.',
                    secondary:
                        'Giá trị không tính chi phí và có tính chi phí luôn có thể so sánh với nhau.',
                    tertiary:
                        'Nội dung dự phóng chỉ là phân tích chi phí, không phải tư vấn hiệu suất đầu tư.',
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
