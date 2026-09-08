import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'risk_management_tablet_page_widgets.dart';

/// Bố cục tablet của Quản lý rủi ro (SC-060): màn rộng cho phép tab
/// OCO/Vị thế/Máy tính hiện nội dung inline (không phải sheet như phone),
/// cột phụ là thẻ tính năng + số dư tài khoản + checklist trạng thái.
class RiskManagementTabletPage extends ConsumerStatefulWidget {
  const RiskManagementTabletPage({super.key});

  static const contentKey = Key('sc060_tablet_content');

  static Key tabKey(String id) => Key('sc060_tablet_tab_$id');

  @override
  ConsumerState<RiskManagementTabletPage> createState() =>
      _RiskManagementTabletPageState();
}

class _RiskManagementTabletPageState
    extends ConsumerState<RiskManagementTabletPage> {
  String _tab = 'oco';

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeRiskManagementControllerProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quản lý rủi ro',
      semanticIdentifier: 'SC-060',
      child: Column(
        children: [
          VitHeader(
            title: 'Quản lý rủi ro',
            subtitle: 'OCO · Vị thế · Khối lượng',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.trade,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            backKey: TradeTabletKeys.back,
          ),
          Expanded(
            child: controllerAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được quản lý rủi ro',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeRiskManagementSnapshotProvider),
                ),
              ),
              data: (controller) {
                final snapshot = controller.state.snapshot;
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeRiskManagementSnapshotProvider);
                    await ref.read(tradeRiskManagementSnapshotProvider.future);
                  },
                  primaryChildren: [
                    VitCard(
                      key: RiskManagementTabletPage.contentKey,
                      variant: VitCardVariant.inner,
                      radius: VitCardRadius.tight,
                      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại công cụ rủi ro',
                            message:
                                'Lệnh OCO, vị thế bảo vệ, kết quả máy tính khối lượng và phí được xem trước trước khi áp dụng.',
                            contractId: 'risk-management-tablet-review',
                            density: VitDensity.tool,
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          const VitStatusPill(
                            label: 'Xem trước khi thực hiện',
                            status: VitStatusPillStatus.warning,
                            size: VitStatusPillSize.sm,
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          VitSegmentedTabBar(
                            tabs: [
                              VitTabItem(
                                key: 'oco',
                                label: 'Lệnh OCO',
                                widgetKey: RiskManagementTabletPage.tabKey(
                                  'oco',
                                ),
                              ),
                              VitTabItem(
                                key: 'positions',
                                label:
                                    'Vị thế bảo vệ (${snapshot.positions.length})',
                                widgetKey: RiskManagementTabletPage.tabKey(
                                  'positions',
                                ),
                              ),
                              VitTabItem(
                                key: 'calculator',
                                label: 'Máy tính khối lượng',
                                widgetKey: RiskManagementTabletPage.tabKey(
                                  'calculator',
                                ),
                              ),
                            ],
                            activeKey: _tab,
                            onChanged: (tab) => setState(() => _tab = tab),
                          ),
                        ],
                      ),
                    ),
                    if (_tab == 'oco')
                      _OcoCard(onSubmit: _submitOco)
                    else if (_tab == 'positions')
                      _PositionsCard(positions: snapshot.positions)
                    else
                      _CalculatorCard(onApply: _applyCalculator),
                  ],
                  secondaryChildren: [
                    for (final feature in snapshot.features)
                      VitCard(
                        radius: VitCardRadius.tight,
                        padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                        child: _RiskFeatureRow(
                          icon: _featureIcon(feature.iconName),
                          color: Color(feature.colorHex),
                          title: feature.title,
                          description: feature.description,
                          onTap: () => _onFeatureTap(feature.id),
                        ),
                      ),
                    VitCard(
                      radius: VitCardRadius.tight,
                      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final (label, value) in [
                            (
                              'Số dư tài khoản',
                              formatTradeUsd(snapshot.accountBalance),
                            ),
                            (
                              'Khả dụng',
                              formatTradeUsd(snapshot.availableBalance),
                            ),
                            (
                              'Giá hiện tại',
                              formatTradePrice(snapshot.currentPrice),
                            ),
                          ])
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: TabletSpacingTokens.x2,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      label,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.text2,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    value,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text1,
                                      fontWeight: AppTextStyles.bold,
                                      fontFeatures:
                                          AppTextStyles.tabularFigures,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(
                            height: TabletSpacingTokens.dividerHairline,
                            thickness: TabletSpacingTokens.dividerHairline,
                            color: AppColors.divider,
                          ),
                          for (final item in snapshot.statusItems)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: TabletSpacingTokens.x2,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.text2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: TabletSpacingTokens.x2),
                                  Icon(
                                    item.complete
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    size: TabletSpacingTokens.iconSm,
                                    color: item.complete
                                        ? AppColors.buy
                                        : AppColors.text3,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onFeatureTap(String id) {
    setState(
      () => _tab = switch (id) {
        'positions' => 'positions',
        'calculator' => 'calculator',
        _ => 'oco',
      },
    );
  }

  IconData _featureIcon(String iconName) => switch (iconName) {
    'shield' || 'security' => Icons.shield_outlined,
    'calculate' => Icons.calculate_outlined,
    'layers' => Icons.layers_outlined,
    _ => Icons.tune_rounded,
  };

  Future<void> _submitOco() async {
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

  Future<void> _applyCalculator() async {
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
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Đã áp dụng',
        message: 'Khối lượng đề xuất: ${result.suggestedAmount}',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }
}
