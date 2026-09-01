import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/execution/execution_venue_summary.dart';
part '../../../widgets/execution/execution_venue_comparison.dart';
part '../../../widgets/execution/execution_venue_speed_trends.dart';
part '../../../widgets/execution/execution_venue_common.dart';

const _venueBackground = AppColors.bg;
const _venuePanel2 = AppColors.surface2;
const _venueBorder = AppColors.borderSolid;
const _venueGreen = AppColors.buy;
const _venueAmber = AppColors.caution;
const _venuePrimary = AppColors.primary;

class ExecutionVenueAnalysisPage extends ConsumerStatefulWidget {
  const ExecutionVenueAnalysisPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc097_execution_venue_content');
  static Key tabKey(String id) => Key('sc097_execution_venue_tab_$id');
  static Key sortKey(String id) => Key('sc097_execution_venue_sort_$id');
  static Key venueKey(String venue) => Key('sc097_execution_venue_$venue');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExecutionVenueAnalysisPage> createState() =>
      _ExecutionVenueAnalysisPageState();
}

class _ExecutionVenueAnalysisPageState
    extends ConsumerState<ExecutionVenueAnalysisPage> {
  String _tab = 'comparison';
  String _sort = 'volume';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeExecutionVenueAnalysisProvider);
    return Material(
      color: _venueBackground,
      child: VitTradeHubScaffold(
        title: 'Execution Venue Analysis',
        subtitle: 'Detailed Comparison',
        semanticLabel: 'Phân tích chi tiết các sàn thực thi lệnh giao dịch',
        semanticIdentifier: 'SC-097',
        contentKey: ExecutionVenueAnalysisPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyBestExecutionReports,
          mode: BackNavigationMode.historyThenFallback,
        ),
        headerActions: [
          VitHeaderActionItem(
            type: VitHeaderActionType.export,
            onPressed: () => showVitNoticeSheet(
              context: context,
              title: 'Đã xếp hàng',
              message: 'Export phân tích đã được xếp hàng.',
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
                  ref.invalidate(tradeExecutionVenueAnalysisProvider),
            ),
          ],
          data: (snapshot) {
            final venues = _sorted(snapshot.venues);
            return [
              VitTradeSection(
                title: 'Summary',
                child: _SummaryGrid(summary: snapshot.summary),
              ),
              VitTradeComplianceSection(
                title: 'Venue review',
                statusPill: const VitStatusPill(
                  label: 'Review required',
                  status: VitStatusPillStatus.info,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Venues',
                    value: '${venues.length} compared',
                  ),
                  VitTradeComplianceItem(label: 'Sort', value: _sort),
                ],
              ),
              VitTradeSection(
                title: 'Analysis',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      density: VitDensity.tool,
                      title: 'Execution venue review',
                      message:
                          'Compare fill quality, total cost, speed, venue concentration, fee impact, and next-step export before changing routing decisions.',
                      contractId: 'SC-097 venue analysis review',
                    ),
                    _SortSelector(
                      activeId: _sort,
                      onChanged: (id) => setState(() => _sort = id),
                    ),
                    VitCard(
                      density: VitDensity.tool,
                      radius: VitCardRadius.tight,
                      child: VitTabBar(
                        activeKey: _tab,
                        onChanged: (id) => setState(() => _tab = id),
                        variant: VitTabBarVariant.underline,
                        tabs: [
                          for (final tab in const [
                            ('comparison', 'Comparison'),
                            ('costs', 'Costs'),
                            ('speed', 'Speed'),
                            ('trends', 'Trends'),
                          ])
                            VitTabItem(
                              key: tab.$1,
                              label: tab.$2,
                              widgetKey: ExecutionVenueAnalysisPage.tabKey(
                                tab.$1,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (_tab == 'comparison')
                      _ComparisonTab(venues: venues)
                    else if (_tab == 'costs')
                      _CostsTab(venues: venues)
                    else if (_tab == 'speed')
                      _SpeedTab(venues: venues)
                    else
                      _TrendsTab(trends: snapshot.costTrends),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }

  List<TradeExecutionVenueAnalysisMetric> _sorted(
    List<TradeExecutionVenueAnalysisMetric> venues,
  ) {
    final sorted = [...venues];
    switch (_sort) {
      case 'cost':
        sorted.sort((a, b) => a.totalCost.compareTo(b.totalCost));
      case 'speed':
        sorted.sort((a, b) => a.avgFillTime.compareTo(b.avgFillTime));
      case 'fill-rate':
        sorted.sort((a, b) => b.fillRate.compareTo(a.fillRate));
      default:
        sorted.sort((a, b) => b.volume.compareTo(a.volume));
    }
    return sorted;
  }
}
