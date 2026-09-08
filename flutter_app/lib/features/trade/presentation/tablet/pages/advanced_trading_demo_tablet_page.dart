import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Giao dịch nâng cao demo (SC-088): chế độ vị thế + tab
/// Vị thế | Lệnh | Phân tích trên cột chính, panel giới hạn demo và chú
/// thích hành động ở cột phụ.
class AdvancedTradingDemoTabletPage extends ConsumerStatefulWidget {
  const AdvancedTradingDemoTabletPage({super.key});

  static const contentKey = Key('sc088_tablet_content');

  static Key modeKey(String id) => Key('sc088_tablet_mode_$id');
  static Key actionKey(String id) => Key('sc088_tablet_action_$id');
  static Key tabKey(String id) => Key('sc088_tablet_tab_$id');

  @override
  ConsumerState<AdvancedTradingDemoTabletPage> createState() =>
      _AdvancedTradingDemoTabletPageState();
}

class _AdvancedTradingDemoTabletPageState
    extends ConsumerState<AdvancedTradingDemoTabletPage> {
  String _tab = 'position';
  String? _positionMode;
  String? _activeActionLabel;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeAdvancedTradingDemoSnapshotProvider);
    final showBack = context.canPop();
    final mode = _positionMode;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giao dịch nâng cao (demo)',
      semanticIdentifier: 'SC-088',
      child: Column(
        children: [
          VitHeader(
            title: 'Giao dịch nâng cao',
            subtitle: 'Vị thế & lệnh · demo',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.tradeMargin,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            backKey: TradeTabletKeys.back,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được giao dịch nâng cao',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeAdvancedTradingDemoSnapshotProvider),
                ),
              ),
              data: (snapshot) {
                final activeMode = mode ?? snapshot.defaultPositionMode;
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeAdvancedTradingDemoSnapshotProvider);
                    await ref.read(
                      tradeAdvancedTradingDemoSnapshotProvider.future,
                    );
                  },
                  primaryChildren: [
                    VitCard(
                      key: AdvancedTradingDemoTabletPage.contentKey,
                      variant: VitCardVariant.inner,
                      radius: VitCardRadius.tight,
                      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chế độ vị thế',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x2),
                          Row(
                            children: [
                              for (final (id, label) in [
                                ('one-way', 'Một chiều'),
                                ('hedge', 'Hai chiều'),
                              ]) ...[
                                VitFilterChip(
                                  key: AdvancedTradingDemoTabletPage.modeKey(
                                    id,
                                  ),
                                  label: label,
                                  active: activeMode == id,
                                  onTap: () =>
                                      setState(() => _positionMode = id),
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: TabletSpacingTokens.x4),
                              ],
                            ],
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          VitSegmentedTabBar(
                            tabs: [
                              VitTabItem(
                                key: 'position',
                                label: 'Vị thế',
                                widgetKey: AdvancedTradingDemoTabletPage.tabKey(
                                  'position',
                                ),
                              ),
                              VitTabItem(
                                key: 'orders',
                                label: 'Lệnh',
                                widgetKey: AdvancedTradingDemoTabletPage.tabKey(
                                  'orders',
                                ),
                              ),
                              VitTabItem(
                                key: 'analytics',
                                label: 'Phân tích',
                                widgetKey: AdvancedTradingDemoTabletPage.tabKey(
                                  'analytics',
                                ),
                              ),
                            ],
                            activeKey: _tab,
                            onChanged: (tab) => setState(() => _tab = tab),
                          ),
                        ],
                      ),
                    ),
                    if (_tab == 'position')
                      _DemoPositionCard(
                        position: snapshot.position,
                        actions: snapshot.positionActions,
                        onAction: (action) =>
                            setState(() => _activeActionLabel = action.label),
                      )
                    else if (_tab == 'orders')
                      _OrdersCard(
                        orderTypes: snapshot.orderTypes,
                        timeInForce: snapshot.timeInForce,
                        summary: snapshot.orderSummary,
                      )
                    else
                      _DemoMetricsCard(
                        title: 'PnL phiên',
                        metrics: snapshot.pnlSummary,
                      ),
                  ],
                  secondaryChildren: [
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      title: 'Giới hạn demo thực thi',
                      message:
                          'Điều khiển lệnh nâng cao chỉ hiển thị ở chế độ demo. Thực thi thật cần xem trước, ký quỹ, phí và rủi ro thanh lý.',
                      contractId: 'SC-088-tablet',
                      density: VitDensity.tool,
                    ),
                    if (_activeActionLabel != null)
                      VitCard(
                        radius: VitCardRadius.tight,
                        borderColor: AppColors.border,
                        padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Đã chọn hành động demo: $_activeActionLabel',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ),
                            const SizedBox(width: TabletSpacingTokens.x3),
                            const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primary,
                              size: TabletSpacingTokens.iconMd,
                            ),
                          ],
                        ),
                      ),
                    if (_tab == 'analytics')
                      _DemoMetricsCard(
                        title: 'Hiệu suất',
                        metrics: snapshot.performanceMetrics,
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
}

class _DemoPositionCard extends StatelessWidget {
  const _DemoPositionCard({
    required this.position,
    required this.actions,
    required this.onAction,
  });

  final TradeAdvancedDemoPosition position;
  final List<TradeAdvancedDemoAction> actions;
  final ValueChanged<TradeAdvancedDemoAction> onAction;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${position.pair} · ${position.side}',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (final (label, value) in [
            ('Khối lượng', position.currentSize.toStringAsFixed(3)),
            ('PnL', position.currentPnl.toStringAsFixed(2)),
            ('Giá mark', position.markPrice.toStringAsFixed(2)),
            ('Giá vào lệnh', position.entryPrice.toStringAsFixed(2)),
            ('Ký quỹ', position.currentMargin.toStringAsFixed(2)),
            ('Khả dụng', position.availableBalance.toStringAsFixed(2)),
            ('Thanh lý', position.liquidationPrice.toStringAsFixed(2)),
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
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x3,
            children: [
              for (final action in actions)
                VitCtaButton(
                  key: AdvancedTradingDemoTabletPage.actionKey(action.id),
                  fullWidth: false,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: () => onAction(action),
                  child: Text(action.label),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrdersCard extends StatelessWidget {
  const _OrdersCard({
    required this.orderTypes,
    required this.timeInForce,
    required this.summary,
  });

  final List<TradeAdvancedDemoAction> orderTypes;
  final List<TradeAdvancedDemoAction> timeInForce;
  final List<TradeAdvancedDemoMetric> summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loại lệnh hỗ trợ',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final type in orderTypes)
                VitStatusPill(
                  label: type.label,
                  status: VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            'Thời gian hiệu lực',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final tif in timeInForce)
                VitStatusPill(
                  label: tif.label,
                  status: VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          for (final metric in summary)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      metric.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    metric.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DemoMetricsCard extends StatelessWidget {
  const _DemoMetricsCard({required this.title, required this.metrics});

  final String title;
  final List<TradeAdvancedDemoMetric> metrics;

  @override
  Widget build(BuildContext context) {
    Color toneColor(TradeAdvancedMetricTone tone) => switch (tone) {
      TradeAdvancedMetricTone.positive => AppColors.buy,
      TradeAdvancedMetricTone.negative => AppColors.sell,
      TradeAdvancedMetricTone.warning => AppColors.caution,
      TradeAdvancedMetricTone.accent => AppColors.accent,
      TradeAdvancedMetricTone.neutral => AppColors.text1,
    };
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final metric in metrics)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      metric.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    metric.value,
                    style: AppTextStyles.caption.copyWith(
                      color: toneColor(metric.tone),
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
