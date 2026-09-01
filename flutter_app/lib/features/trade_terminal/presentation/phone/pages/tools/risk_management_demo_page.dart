import 'dart:async';

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
import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

part '../../../widgets/tools/risk_management_overview.dart';
part '../../../widgets/tools/risk_management_tabs.dart';
part '../../../widgets/tools/risk_management_common.dart';

const _riskPrimary = AppColors.primary;
const _riskSpace = AppSpacing.x2;
const _riskTinySpace = AppSpacing.x1;
const _riskCardSpace = AppSpacing.x3;
const _riskControlExtent = AppSpacing.searchBarCompactHeight;
const _riskTabExtent = AppSpacing.searchBarCompactHeight;

enum _RiskTab { oco, positions, calculator }

class RiskManagementDemoPage extends ConsumerStatefulWidget {
  const RiskManagementDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc060_risk_management_scroll_content');
  static const backKey = Key('sc060_back');
  static const ocoButtonKey = Key('sc060_open_oco');
  static const ocoSubmitKey = Key('sc060_submit_oco');
  static const calculatorButtonKey = Key('sc060_open_calculator');
  static const calculatorApplyKey = Key('sc060_apply_calculator');

  static Key tabKey(String id) => Key('sc060_tab_$id');
  static Key featureKey(String id) => Key('sc060_feature_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RiskManagementDemoPage> createState() =>
      _RiskManagementDemoPageState();
}

class _RiskManagementDemoPageState
    extends ConsumerState<RiskManagementDemoPage> {
  _RiskTab _tab = _RiskTab.oco;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeRiskManagementControllerProvider);

    return VitTradeHubScaffold(
      title: 'Quản lý rủi ro',
      subtitle: 'OCO · Vị thế · Khối lượng',
      semanticLabel: 'Quản lý rủi ro',
      semanticIdentifier: 'SC-060',
      contentKey: RiskManagementDemoPage.contentKey,
      backKey: RiskManagementDemoPage.backKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      children: controllerAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được quản lý rủi ro',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeRiskManagementSnapshotProvider),
          ),
        ],
        data: (controller) {
          final snapshot = controller.state.snapshot;
          return [
            const _IntroCard(),
            const VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.tight,
              padding: TradeSpacingTokens.tradeToolRiskReviewPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    title: 'Xem lại công cụ rủi ro',
                    message:
                        'Lệnh OCO, vị thế bảo vệ, kết quả máy tính khối lượng và phí được xem trước trước khi áp dụng.',
                    contractId: 'risk-management-demo-review',
                    density: VitDensity.tool,
                  ),
                  SizedBox(height: _riskSpace),
                  VitStatusPill(
                    label: 'Xem trước khi thực hiện',
                    status: VitStatusPillStatus.warning,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ),
            for (final feature in snapshot.features) ...[
              _FeatureCard(
                feature: feature,
                onTap: () => _onFeatureTap(feature),
              ),
            ],
            const _BenefitsCard(),
            _StatusCard(items: snapshot.statusItems),
            _RiskTabs(
              active: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            VitPageSection(
              density: VitDensity.tool,
              children: [
                if (_tab == _RiskTab.oco)
                  _OcoTab(onOpen: _openOcoSheet)
                else if (_tab == _RiskTab.positions)
                  _PositionsTab(positions: snapshot.positions)
                else
                  _CalculatorTab(onOpen: _openCalculatorSheet),
              ],
            ),
          ];
        },
      ),
    );
  }

  void _onFeatureTap(TradeRiskFeature feature) {
    if (feature.id == 'positions') {
      setState(() => _tab = _RiskTab.positions);
      return;
    }
    if (feature.id == 'calculator') {
      setState(() => _tab = _RiskTab.calculator);
      unawaited(_openCalculatorSheet());
      return;
    }
    setState(() => _tab = _RiskTab.oco);
    unawaited(_openOcoSheet());
  }

  Future<void> _openOcoSheet() async {
    final submitted = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => const _OcoSheet(),
    );
    if (submitted != true || !mounted) return;
    final controller = ref.read(tradeRiskManagementControllerProvider).value;
    if (controller == null) return;
    final result = await controller.submitOcoOrder(
      const TradeOcoOrderDraft(
        symbol: 'BTC/USDT',
        side: TradeOrderSide.buy,
        quantity: .015,
        limitPrice: 69000,
        takeProfitPrice: 72000,
        stopPrice: 66000,
      ),
    );
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Lệnh OCO đã gửi',
        message: 'Đã đặt ${result.orderId}',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }

  Future<void> _openCalculatorSheet() async {
    final controller = ref.read(tradeRiskManagementControllerProvider).value;
    if (controller == null) return;
    final result = await controller.calculatePositionSize(
      const TradePositionSizeRequest(
        accountBalance: 50000,
        riskPct: 1,
        entryPrice: 69000,
        stopPrice: 67500,
      ),
    );
    if (!mounted) return;
    final applied = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _CalculatorSheet(result: result),
    );
    if (applied != true || !mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Đã áp dụng',
        message: 'Đã áp dụng khối lượng đề xuất',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }
}
