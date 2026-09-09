import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'compliance_reports_tablet_pages_extra.dart';

Widget _rptError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _rptSection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
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
        ...rows,
      ],
    ),
  );
}

List<Widget> _rptRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

List<Widget> _rptBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.arrow_right_rounded,
                size: TabletSpacingTokens.iconSm,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
            Expanded(
              child: Text(
                note,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

Widget _rptBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

/// SC-094: Bảng điều khiển báo cáo quy định.
class RegulatoryReportsDashboardTabletPage extends ConsumerWidget {
  const RegulatoryReportsDashboardTabletPage({super.key});

  static const contentKey = Key('sc094_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeRegulatoryReportsDashboardProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-094',
        semanticLabel: 'Bảng điều khiển báo cáo quy định',
        title: 'Báo cáo quy định',
        subtitle: 'Dashboard',
        contentKey: RegulatoryReportsDashboardTabletPage.contentKey,
        children: [
          _rptError(
            'Không tải được dashboard',
            () => ref.invalidate(tradeRegulatoryReportsDashboardProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-094',
        semanticLabel: 'Bảng điều khiển báo cáo quy định',
        title: 'Báo cáo quy định',
        subtitle: 'Dashboard',
        contentKey: RegulatoryReportsDashboardTabletPage.contentKey,
        children: [
          _rptSection(
            title: 'Thống kê theo ngày',
            rows: [
              for (final stat in snapshot.dailyStats.take(7))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          stat.date,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Text(
                        '${stat.total} báo cáo',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _rptSection(
            title: 'ARM providers',
            rows: [
              for (final provider in snapshot.providers)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          provider.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      Text(
                        '${provider.reports} báo cáo · ${provider.successRate.toStringAsFixed(1)}% · ${provider.avgLatency}ms',
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

          _rptSection(
            title: 'Khám phá',
            rows: [
              Wrap(
                spacing: TabletSpacingTokens.x2,
                runSpacing: TabletSpacingTokens.x2,
                children: [
                  for (final (label, path) in [
                    (
                      'Báo cáo giao dịch',
                      AppRoutePaths.tradeCopyTransactionReporting,
                    ),
                    (
                      'Trạng thái tích hợp ARM',
                      AppRoutePaths.tradeCopyArmIntegrationStatus,
                    ),
                    (
                      'Báo cáo thực thi tốt nhất',
                      AppRoutePaths.tradeCopyBestExecutionReports,
                    ),
                    (
                      'Phân tích nơi thực thi',
                      AppRoutePaths.tradeCopyExecutionVenueAnalysis,
                    ),
                    (
                      'Giám sát trượt giá',
                      AppRoutePaths.tradeCopySlippageMonitoring,
                    ),
                    (
                      'Phân loại khách hàng',
                      AppRoutePaths.tradeCopyClientCategorization,
                    ),
                    (
                      'Yêu cầu nâng hạng',
                      AppRoutePaths.tradeCopyClientOptUpRequest,
                    ),
                    (
                      'Định nghĩa thị trường mục tiêu',
                      AppRoutePaths.tradeCopyTargetMarketDefinition,
                    ),
                    (
                      'Bảo vệ tiền khách hàng',
                      AppRoutePaths.tradeCopyClientMoneyProtection,
                    ),
                    (
                      'Đối soát CASS',
                      AppRoutePaths.tradeCopyCassReconciliation,
                    ),
                    (
                      'Bồi thường nhà đầu tư',
                      AppRoutePaths.tradeCopyInvestorCompensation,
                    ),
                    (
                      'Chi phí trước giao dịch',
                      AppRoutePaths.tradeCopyExAnteCosts,
                    ),
                    ('Máy tính RIY', AppRoutePaths.tradeCopyRiyCalculator),
                    (
                      'Chi phí sau giao dịch',
                      AppRoutePaths.tradeCopyExPostCostsReport,
                    ),
                    (
                      'Tiết lộ quy định',
                      AppRoutePaths.tradeCopyRegulatoryDisclosures,
                    ),
                    (
                      'Theo dõi khiếu nại',
                      AppRoutePaths.tradeCopyComplaintTrackingBase,
                    ),
                    (
                      'Gửi khiếu nại',
                      AppRoutePaths.tradeCopyComplaintSubmission,
                    ),
                    (
                      'Chuyển tiếp ombudsman',
                      AppRoutePaths.tradeCopyOmbudsmanReferral,
                    ),
                    ('Truy vết kiểm toán', AppRoutePaths.tradeCopyAuditTrail),
                    ('Trình tạo KID', AppRoutePaths.tradeCopyKidGenerator),
                  ])
                    VitFilterChip(
                      label: label,
                      active: false,
                      color: AppColors.primary,
                      onTap: () => context.push(path),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-095: Trạng thái tích hợp ARM.
class ArmIntegrationStatusTabletPage extends ConsumerWidget {
  const ArmIntegrationStatusTabletPage({super.key});

  static const contentKey = Key('sc095_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeArmIntegrationStatusProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-095',
        semanticLabel: 'Trạng thái tích hợp ARM',
        title: 'Tích hợp ARM',
        subtitle: 'Kết nối · SLA',
        contentKey: ArmIntegrationStatusTabletPage.contentKey,
        children: [
          _rptError(
            'Không tải được trạng thái ARM',
            () => ref.invalidate(tradeArmIntegrationStatusProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-095',
        semanticLabel: 'Trạng thái tích hợp ARM',
        title: 'Tích hợp ARM',
        subtitle: 'Kết nối · SLA',
        contentKey: ArmIntegrationStatusTabletPage.contentKey,
        children: [
          _rptSection(
            title: 'Kết nối',
            rows: [
              for (final connection in snapshot.connections)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          connection.provider,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${connection.region} · uptime ${connection.uptime.toStringAsFixed(1)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-116: Sẵn sàng thanh tra.
