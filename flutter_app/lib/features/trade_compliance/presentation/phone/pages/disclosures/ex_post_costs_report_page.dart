import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/disclosures/ex_post_costs_report_summary.dart';
part '../../../widgets/disclosures/ex_post_costs_report_variance_common.dart';

const _reportBorder = AppColors.borderSolid;
const _reportPrimary = AppColors.primary;
const _reportGreen = AppColors.buy;
const _reportAmber = AppColors.caution;
const _reportRed = AppColors.sell;

class ExPostCostsReportPage extends ConsumerStatefulWidget {
  const ExPostCostsReportPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc107_ex_post_content');
  static const downloadKey = Key('sc107_ex_post_download');
  static Key tabKey(int year) => Key('sc107_ex_post_tab_$year');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExPostCostsReportPage> createState() =>
      _ExPostCostsReportPageState();
}

class _ExPostCostsReportPageState extends ConsumerState<ExPostCostsReportPage> {
  int _selectedYear = 2025;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeExPostCostsReportProvider);
    return VitTradeHubScaffold(
      title: 'Ex-Post Cost Report',
      subtitle: 'Annual Actual Costs',
      semanticLabel: 'Báo cáo chi phí thực tế hằng năm sau đầu tư',
      semanticIdentifier: 'SC-107',
      contentKey: ExPostCostsReportPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyExAnteCosts,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.export,
          onPressed: () => ref
              .read(tradeRegulatoryRepositoryProvider)
              .createExPostCostsReportExport(year: _selectedYear),
        ),
      ],
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeExPostCostsReportProvider),
          ),
        ],
        data: (snapshot) {
          final report = snapshot.reportForYear(_selectedYear);
          return [
            VitTradeSection(
              title: 'Review',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Actual cost report ready',
                message:
                    'Review actual versus estimated costs, variance drivers, fee impact, and next-step export before using this report for disclosure.',
                contractId: 'SC-107 ${report.year} report',
                density: VitDensity.tool,
              ),
            ),
            VitTradeComplianceSection(
              title: 'Report status',
              statusPill: VitStatusPill(
                label: '${report.year} report',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
              items: const [
                VitTradeComplianceItem(
                  label: 'Framework',
                  value: 'MiFID II cost disclosure',
                ),
                VitTradeComplianceItem(
                  label: 'Action',
                  value: 'Review variance before export',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Notice',
              child: VitTradeComplianceHero(
                title: 'Annual Cost Report Available',
                description:
                    'This report shows the actual costs you paid in '
                    '${report.year}. Required by PRIIPs regulation.',
                icon: Icons.check_circle_outline_rounded,
                accentColor: _reportPrimary,
              ),
            ),
            VitTradeSection(
              title: 'Report',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          label: 'Total Actual Costs',
                          value: _formatEur(report.totalActual),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: _SummaryCard(
                          label: 'Estimated Costs',
                          value: _formatEur(report.totalEstimated),
                          muted: true,
                        ),
                      ),
                    ],
                  ),
                  _YearTabs(
                    reports: snapshot.reports,
                    activeYear: _selectedYear,
                    onChanged: (year) => setState(() {
                      _selectedYear = year;
                    }),
                  ),
                  const VitSectionHeader(
                    title: 'Actual vs. Estimated',
                    bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                    variant: VitSectionHeaderVariant.accentBar,
                    accentColor: _reportPrimary,
                  ),
                  _CostBreakdownCard(
                    title: 'One-off Costs',
                    actual: report.oneOff,
                    estimate: report.estimatedOneOff,
                  ),
                  _CostBreakdownCard(
                    title: 'Recurring Costs',
                    actual: report.recurring,
                    estimate: report.estimatedRecurring,
                    note: _VarianceNote.lower(
                      report.estimatedRecurring - report.recurring,
                    ),
                  ),
                  _CostBreakdownCard(
                    title: 'Incidental Costs',
                    actual: report.incidental,
                    estimate: report.estimatedIncidental,
                    note: _VarianceNote.higher(
                      report.incidental - report.estimatedIncidental,
                    ),
                  ),
                  const VitSectionHeader(
                    title: 'Variance Analysis',
                    bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                    variant: VitSectionHeaderVariant.accentBar,
                    accentColor: _reportPrimary,
                  ),
                  _VarianceCard(report: report),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
