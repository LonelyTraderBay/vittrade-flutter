import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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

part '../../../widgets/phone/regulatory_reports_dashboard_kpis.dart';
part '../../../widgets/phone/regulatory_reports_dashboard_controls.dart';
part '../../../widgets/phone/regulatory_reports_dashboard_overview.dart';
part '../../../widgets/phone/regulatory_reports_dashboard_painters.dart';
part '../../../widgets/phone/regulatory_reports_dashboard_queue_compliance.dart';
part '../../../widgets/phone/regulatory_reports_dashboard_exports.dart';

const _dashBackground = AppColors.bg;
const _dashPanel2 = AppColors.surface2;
const _dashBorder = AppColors.borderSolid;
const _dashGreen = AppColors.buy;
const _dashRed = AppColors.sell;
const _dashAmber = AppColors.caution;
const _dashPrimary = AppColors.primary;

class RegulatoryReportsDashboardPage extends ConsumerStatefulWidget {
  const RegulatoryReportsDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc094_regulatory_reports_content');
  static const kpiGridKey = Key('sc094_regulatory_reports_kpi_grid');
  static Key tabKey(String id) => Key('sc094_regulatory_tab_$id');
  static Key rangeKey(String id) => Key('sc094_regulatory_range_$id');
  static Key actionKey(String id) => Key('sc094_regulatory_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RegulatoryReportsDashboardPage> createState() =>
      _RegulatoryReportsDashboardPageState();
}

class _RegulatoryReportsDashboardPageState
    extends ConsumerState<RegulatoryReportsDashboardPage> {
  String _tab = 'overview';
  String _range = '7D';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeRegulatoryReportsDashboardProvider);
    return Material(
      color: _dashBackground,
      child: VitTradeHubScaffold(
        title: 'Regulatory Reports',
        subtitle: 'Dashboard - MiFID II - EMIR',
        semanticLabel: 'Bảng báo cáo tuân thủ quy định',
        semanticIdentifier: 'SC-094',
        contentKey: RegulatoryReportsDashboardPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyTransactionReporting,
          mode: BackNavigationMode.historyThenFallback,
        ),
        headerActions: [
          VitHeaderActionItem(
            type: VitHeaderActionType.export,
            onPressed: () => showVitNoticeSheet(
              context: context,
              title: 'Đã xếp hàng',
              message: 'Export đã được xếp hàng.',
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
              onAction: () =>
                  ref.invalidate(tradeRegulatoryReportsDashboardProvider),
            ),
          ],
          data: (snapshot) => [
            VitTradeSection(
              title: 'KPIs',
              child: _KpiGrid(totals: snapshot.totals),
            ),
            const VitTradeSection(
              title: 'Review',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                density: VitDensity.tool,
                title: 'Regulatory report review',
                message:
                    'Report queue, confirmed count, failed count, export action, ARM route and remediation next step are reviewed before submission follow-up.',
                contractId: 'regulatory-reports-review',
              ),
            ),
            VitTradeComplianceSection(
              title: 'Report review',
              statusPill: const VitStatusPill(
                label: 'SLA and failures visible',
                status: VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Success rate',
                  value: '${snapshot.totals.successRate.toStringAsFixed(1)}%',
                ),
                VitTradeComplianceItem(
                  label: 'Failed',
                  value: '${snapshot.totals.failed}',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Dashboard',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VitTradeComplianceHero(
                    title: '100% SLA Compliance (Last 7 Days)',
                    description:
                        'All reports submitted within T+1. Zero regulatory '
                        'breaches. Avg latency: '
                        '${snapshot.totals.avgLatency.round()}s.',
                    icon: Icons.check_circle_outline,
                    accentColor: AppColors.text1,
                  ),
                  _RangeSelector(
                    ranges: snapshot.timeRanges,
                    activeId: _range,
                    onChanged: (id) => setState(() => _range = id),
                  ),
                  VitTabBar(
                    activeKey: _tab,
                    tabs: [
                      for (final tab in const [
                        ('overview', 'Overview'),
                        ('queue', 'Queue'),
                        ('compliance', 'Compliance'),
                        ('exports', 'Exports'),
                      ])
                        VitTabItem(
                          key: tab.$1,
                          label: tab.$2,
                          widgetKey: RegulatoryReportsDashboardPage.tabKey(
                            tab.$1,
                          ),
                        ),
                    ],
                    onChanged: (id) => setState(() => _tab = id),
                    variant: VitTabBarVariant.segment,
                  ),
                  if (_tab == 'overview')
                    _OverviewTab(snapshot: snapshot)
                  else if (_tab == 'queue')
                    _QueueTab(snapshot: snapshot)
                  else if (_tab == 'compliance')
                    _ComplianceTab(totals: snapshot.totals)
                  else
                    _ExportsTab(
                      onNotice: (text) => showVitNoticeSheet(
                        context: context,
                        title: 'Xuất dữ liệu',
                        message: text,
                        variant: VitBannerVariant.success,
                        ctaVariant: VitCtaButtonVariant.success,
                      ),
                    ),
                  _QuickActions(
                    onQueue: () => context.push(
                      AppRoutePaths.tradeCopyTransactionReporting,
                    ),
                    onArmStatus: () => context.push(
                      AppRoutePaths.tradeCopyArmIntegrationStatus,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
