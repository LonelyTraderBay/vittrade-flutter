import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/trade_copy_header_body_card.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/analytics/portfolio_risk_analysis_page_sections.dart';
part '../../../widgets/analytics/portfolio_risk_analysis_page_common.dart';

const _riskPrimary = AppColors.primary;
const _riskWarningBorder = AppColors.warningBorderStrong;
const _riskWarningText = AppColors.caution;
const double _riskSectionSpace = AppSpacing.x2;
const double _riskTinySpace = AppSpacing.x1;
const double _riskSummaryExtent = TradeSpacingTokens.tradeBotControlTall;
const double _riskChartExtent = TradeSpacingTokens.tradeBotCompactChartHeight;
const double _riskRingExtent = TradeSpacingTokens.tradeBotRiskRingInnerSize;
const double _riskAssetRowExtent =
    TradeSpacingTokens.tradeBotDisputeProviderHeight;
const double _riskSwatchExtent = AppSpacing.statusPillIconSizeLg;
const double _riskBodyLineHeight = 1.24;
const double _riskCaptionLineHeight = 1.1;

class PortfolioRiskAnalysisPage extends ConsumerStatefulWidget {
  const PortfolioRiskAnalysisPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc078_portfolio_risk_content');
  static Key tabKey(String id) => Key('sc078_tab_$id');
  static Key assetKey(String asset) => Key('sc078_asset_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PortfolioRiskAnalysisPage> createState() =>
      _PortfolioRiskAnalysisPageState();
}

class _PortfolioRiskAnalysisPageState
    extends ConsumerState<PortfolioRiskAnalysisPage> {
  String _activeTab = 'exposure';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradePortfolioRiskAnalysisProvider);
    return VitTradeHubScaffold(
      title: 'Phân tích rủi ro',
      semanticLabel: 'Phân tích rủi ro',
      semanticIdentifier: 'SC-078',
      contentKey: PortfolioRiskAnalysisPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được dữ liệu rủi ro danh mục',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(tradePortfolioRiskAnalysisProvider),
            ),
          ],
          data: (snapshot) => [
            VitTradeSection(
              title: 'Tóm tắt',
              child: _RiskSummaryGrid(snapshot: snapshot),
            ),
            VitTradeSection(
              title: 'Phân tích',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    title: 'Xem trước rủi ro danh mục',
                    message:
                        'Xem lại mức phơi nhiễm, VaR, tương quan, kịch bản stress, giới hạn và bước tái cân bằng trước khi thay đổi phân bổ copy.',
                    contractId: 'SC-078 risk analysis review',
                    density: VitDensity.tool,
                  ),
                  _RiskWarningPanel(alerts: snapshot.riskAlerts),
                  _RiskTabs(
                    tabs: snapshot.tabs,
                    activeId: _activeTab,
                    onChanged: (id) => setState(() => _activeTab = id),
                  ),
                  if (_activeTab == 'exposure')
                    _ExposureTab(snapshot: snapshot)
                  else if (_activeTab == 'correlation')
                    const _PlaceholderPanel(
                      title: 'Ma trận tương quan provider',
                      description:
                          'Correlation >0.8 nghĩa là 2 providers có xu hướng giống nhau.',
                    )
                  else if (_activeTab == 'var')
                    _VarPanel(snapshot: snapshot)
                  else
                    _StressScenarioPanel(scenarios: snapshot.scenarios),
                ],
              ),
            ),
            VitTradeComplianceSection(
              title: 'Đánh giá rủi ro',
              density: VitDensity.tool,
              statusPill: VitStatusPill(
                label: '${snapshot.riskAlerts.length} cảnh báo',
                status: VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
              items: const [
                VitTradeComplianceItem(
                  label: 'Khung',
                  value: 'Đánh giá rủi ro danh mục copy',
                ),
                VitTradeComplianceItem(
                  label: 'Hành động',
                  value: 'Xem lại trước khi thay đổi phân bổ',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
