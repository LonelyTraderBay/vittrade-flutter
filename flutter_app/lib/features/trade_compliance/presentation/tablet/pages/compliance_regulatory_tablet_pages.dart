import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

part 'compliance_regulatory_tablet_pages_governance.dart';

String _cregDec1(num value) => value.toStringAsFixed(1);

Widget _cregError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _cregSection({required String title, required List<Widget> rows}) {
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

List<Widget> _cregRows(List<(String, String)> pairs) {
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

List<Widget> _cregBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

/// SC-093: Báo cáo giao dịch cho cơ quan quản lý.
class TransactionReportingTabletPage extends ConsumerWidget {
  const TransactionReportingTabletPage({super.key});

  static const contentKey = Key('sc093_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeTransactionReportingProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-093',
        semanticLabel: 'Báo cáo giao dịch',
        title: 'Báo cáo giao dịch',
        subtitle: 'ARM · Trạng thái nộp',
        contentKey: TransactionReportingTabletPage.contentKey,
        children: [
          _cregError(
            'Không tải được báo cáo giao dịch',
            () => ref.invalidate(tradeTransactionReportingProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-093',
        semanticLabel: 'Báo cáo giao dịch',
        title: 'Báo cáo giao dịch',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: TransactionReportingTabletPage.contentKey,
        children: [
          _cregSection(
            title: 'Thống kê',
            rows: _cregRows([
              ('Tổng số báo cáo', '${snapshot.stats.total}'),
              ('Đã xác nhận', '${snapshot.stats.confirmed}'),
              ('Đang chờ', '${snapshot.stats.pending}'),
              ('Thất bại', '${snapshot.stats.failed}'),
              ('Nộp đúng hạn', '${snapshot.stats.onTime}'),
              ('Độ trễ trung bình', '${snapshot.stats.avgLatencySeconds}s'),
              ('Giá trị tổng', snapshot.stats.totalValue.toStringAsFixed(2)),
              ('Báo cáo MiFID', '${snapshot.stats.mifidReports}'),
              ('Báo cáo EMIR', '${snapshot.stats.emirReports}'),
            ]),
          ),

          _cregSection(
            title: 'Báo cáo gần đây',
            rows: [
              for (final report in snapshot.reports.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${report.instrument} · ${report.side}',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              '${report.tradingVenue} · ${report.armProvider} · ${report.executionTime}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${report.status} · ${VitFormat.usd(report.value)}',
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
        ],
      ),
    );
  }
}

/// SC-096: Báo cáo thực thi tốt nhất (best execution).
class BestExecutionReportsTabletPage extends ConsumerWidget {
  const BestExecutionReportsTabletPage({super.key});

  static const contentKey = Key('sc096_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBestExecutionReportsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-096',
        semanticLabel: 'Báo cáo thực thi tốt nhất',
        title: 'Thực thi tốt nhất',
        subtitle: 'Xếp hạng · Lưu trữ',
        contentKey: BestExecutionReportsTabletPage.contentKey,
        children: [
          _cregError(
            'Không tải được báo cáo thực thi',
            () => ref.invalidate(tradeBestExecutionReportsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-096',
        semanticLabel: 'Báo cáo thực thi tốt nhất',
        title: 'Thực thi tốt nhất',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: BestExecutionReportsTabletPage.contentKey,
        children: [
          _cregSection(
            title: 'Tổng quan',
            rows: _cregRows([
              ('Tổng số lệnh', '${snapshot.summary.totalOrders}'),
              ('Giá trị tổng', snapshot.summary.totalValue.toStringAsFixed(2)),
              ('Điểm trung bình', snapshot.summary.avgScore.toStringAsFixed(1)),
            ]),
          ),

          _cregSection(
            title: 'Xếp hạng sàn giao dịch',
            rows: [
              for (final venue in snapshot.venues)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      SizedBox(
                        width: TabletSpacingTokens.x5,
                        child: Text(
                          '#${venue.rank}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.primary,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          venue.venue,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        'Khớp ${VitFormat.percent(venue.fillRate, fractionDigits: 1)} · '
                        'Tốc độ ${_cregDec1(venue.avgSpeed)}s · '
                        'Điểm ${_cregDec1(venue.score)}',
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

          _cregSection(
            title: 'Báo cáo quý đã lưu trữ',
            rows: [
              for (final report in snapshot.archive.take(6))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${report.quarter} ${report.year} · ${report.period}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${report.totalOrders} lệnh · ${report.publishDate} · ${report.status}',
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

/// SC-097: Phân tích sàn thực thi (chi phí, độ trễ, độ tin cậy).
class ExecutionVenueAnalysisTabletPage extends ConsumerWidget {
  const ExecutionVenueAnalysisTabletPage({super.key});

  static const contentKey = Key('sc097_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeExecutionVenueAnalysisProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-097',
        semanticLabel: 'Phân tích sàn thực thi',
        title: 'Phân tích sàn thực thi',
        subtitle: 'Chi phí · Độ trễ',
        contentKey: ExecutionVenueAnalysisTabletPage.contentKey,
        children: [
          _cregError(
            'Không tải được phân tích sàn',
            () => ref.invalidate(tradeExecutionVenueAnalysisProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-097',
        semanticLabel: 'Phân tích sàn thực thi',
        title: 'Phân tích sàn thực thi',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: ExecutionVenueAnalysisTabletPage.contentKey,
        children: [
          for (final venue in snapshot.venues) ...[
            _cregSection(
              title: venue.venue,
              rows: _cregRows([
                ('Khối lượng', '${venue.volume}'),
                ('Giá trị', venue.value.toStringAsFixed(2)),
                ('Phí TB', venue.avgFee.toStringAsFixed(3)),
                ('Chênh lệch giá TB', venue.avgSpread.toStringAsFixed(3)),
                ('Tác động thị trường', venue.marketImpact.toStringAsFixed(3)),
                ('Tổng chi phí', venue.totalCost.toStringAsFixed(3)),
                ('Độ trễ TB', '${venue.avgLatency}ms'),
                ('Thời gian khớp TB', venue.avgFillTime.toStringAsFixed(1)),
                (
                  'Tỷ lệ khớp lệnh',
                  VitFormat.percent(venue.fillRate, fractionDigits: 1),
                ),
                ('Thanh khoản', '${venue.liquidity}'),
                (
                  'Độ tin cậy',
                  VitFormat.percent(venue.reliability, fractionDigits: 1),
                ),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}
