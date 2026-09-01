import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/execution/slippage_monitoring_overview.dart';
part '../../../widgets/execution/slippage_monitoring_events.dart';
part '../../../widgets/execution/slippage_monitoring_tabs.dart';
part '../../../widgets/execution/slippage_monitoring_common.dart';

const _slipBackground = AppColors.bg;
const _slipPanel2 = AppColors.surface2;
const _slipBorder = AppColors.borderSolid;
const _slipGreen = AppColors.buy;
const _slipAmber = AppColors.caution;
const _slipRed = AppColors.sell;
const _slipPrimary = AppColors.primary;

class SlippageMonitoringPage extends ConsumerStatefulWidget {
  const SlippageMonitoringPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc098_slippage_content');
  static Key tabKey(String id) => Key('sc098_slippage_tab_$id');
  static Key eventKey(String id) => Key('sc098_slippage_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SlippageMonitoringPage> createState() =>
      _SlippageMonitoringPageState();
}

class _SlippageMonitoringPageState
    extends ConsumerState<SlippageMonitoringPage> {
  String _tab = 'realtime';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeSlippageMonitoringProvider);
    return Material(
      color: _slipBackground,
      child: VitTradeHubScaffold(
        title: 'Slippage Monitoring',
        subtitle: 'Real-time Tracking · Alerts',
        semanticLabel: 'Theo dõi trượt giá theo thời gian thực và cảnh báo',
        semanticIdentifier: 'SC-098',
        contentKey: SlippageMonitoringPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyTrading,
          mode: BackNavigationMode.historyThenFallback,
        ),
        headerActions: [
          VitHeaderActionItem(
            type: VitHeaderActionType.settings,
            onPressed: () => showVitNoticeSheet(
              context: context,
              title: 'Cài đặt cảnh báo',
              message: 'Đã mở cài đặt cảnh báo.',
              variant: VitBannerVariant.success,
              ctaVariant: VitCtaButtonVariant.success,
            ),
          ),
        ],
        children: async.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được dữ liệu',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeSlippageMonitoringProvider),
            ),
          ],
          data: (snapshot) => [
            VitTradeSection(
              title: 'Alert',
              child: VitTradeComplianceHero(
                title:
                    '${snapshot.summary.critical} Critical Slippage Event Detected',
                description:
                    'Slippage exceeded 1% threshold. Review affected trades and consider provider adjustments.',
                icon: Icons.warning_amber_rounded,
                accentColor: AppColors.text1,
              ),
            ),
            VitTradeComplianceSection(
              title: 'Slippage status',
              statusPill: VitStatusPill(
                label: '${snapshot.summary.critical} critical',
                status: VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Avg slippage',
                  value:
                      '${snapshot.summary.avgSlippage.toStringAsFixed(2)} bps',
                ),
                VitTradeComplianceItem(
                  label: 'Events',
                  value: '${snapshot.events.length} tracked',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Monitoring',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    density: VitDensity.tool,
                    title: 'Slippage risk review',
                    message:
                        'Review critical events, average slippage, provider routing, alert thresholds, fee impact, and next steps before changing copy execution settings.',
                    contractId: 'SC-098 slippage monitoring review',
                  ),
                  _StatsGrid(summary: snapshot.summary),
                  VitSegmentedTabBar(
                    tabs: [
                      VitTabItem(
                        key: 'realtime',
                        label: 'Real-time (${snapshot.summary.total})',
                        widgetKey: SlippageMonitoringPage.tabKey('realtime'),
                      ),
                      VitTabItem(
                        key: 'providers',
                        label: 'By Provider',
                        widgetKey: SlippageMonitoringPage.tabKey('providers'),
                      ),
                      VitTabItem(
                        key: 'history',
                        label: 'History',
                        widgetKey: SlippageMonitoringPage.tabKey('history'),
                      ),
                      VitTabItem(
                        key: 'alerts',
                        label:
                            'Alerts (${snapshot.summary.critical + snapshot.summary.warning})',
                        widgetKey: SlippageMonitoringPage.tabKey('alerts'),
                      ),
                    ],
                    activeKey: _tab,
                    onChanged: (id) => setState(() => _tab = id),
                  ),
                  if (_tab == 'realtime')
                    _RealtimeTab(events: snapshot.events)
                  else if (_tab == 'providers')
                    _ProvidersTab(providers: snapshot.providers)
                  else if (_tab == 'history')
                    _HistoryTab(history: snapshot.history)
                  else
                    const _AlertsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
