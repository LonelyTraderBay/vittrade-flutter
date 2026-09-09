import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

Widget _cdError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _cdSection({required String title, required List<Widget> rows}) {
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

List<Widget> _cdRows(List<(String, String)> pairs) {
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

/// SC-105: Chi phí trước đầu tư (Ex-Ante).
class ExAnteCostsTabletPage extends ConsumerWidget {
  const ExAnteCostsTabletPage({super.key});

  static const contentKey = Key('sc105_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeExAnteCostsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-105',
        semanticLabel: 'Chi phí trước đầu tư',
        title: 'Chi phí trước đầu tư',
        subtitle: 'Ex-Ante',
        contentKey: ExAnteCostsTabletPage.contentKey,
        children: [
          _cdError(
            'Không tải được chi phí',
            () => ref.invalidate(tradeExAnteCostsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-105',
        semanticLabel: 'Chi phí trước đầu tư',
        title: 'Chi phí trước đầu tư',
        subtitle: 'Ex-Ante',
        contentKey: ExAnteCostsTabletPage.contentKey,
        children: [
          _cdSection(
            title:
                'Đầu tư ${formatCdUsd(snapshot.investmentAmount)} · ${snapshot.holdingPeriodYears} năm',
            rows: [
              for (final cost in snapshot.costs)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cost.type,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              cost.description,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCdUsd(cost.amountEur),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                          Text(
                            '${cost.percentOfInvestment.toStringAsFixed(2)}%',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
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

/// SC-106: Bộ tính toán RIY.
class RiyCalculatorTabletPage extends ConsumerWidget {
  const RiyCalculatorTabletPage({super.key});

  static const contentKey = Key('sc106_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeRiyCalculatorProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-106',
        semanticLabel: 'Bộ tính toán RIY',
        title: 'Bộ tính toán RIY',
        subtitle: 'Reduction in Yield',
        contentKey: RiyCalculatorTabletPage.contentKey,
        children: [
          _cdError(
            'Không tải được RIY',
            () => ref.invalidate(tradeRiyCalculatorProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-106',
        semanticLabel: 'Bộ tính toán RIY',
        title: 'Bộ tính toán RIY',
        subtitle: 'Reduction in Yield',
        contentKey: RiyCalculatorTabletPage.contentKey,
        children: [
          _cdSection(
            title: 'Tham số đầu vào',
            rows: _cdRows([
              ('Số tiền đầu tư', formatCdUsd(snapshot.investmentAmount)),
              (
                'Lợi nhuận kỳ vọng',
                '${snapshot.expectedReturnPct.toStringAsFixed(1)}%',
              ),
              ('Tổng chi phí', '${snapshot.totalCostsPct.toStringAsFixed(2)}%'),
              ('Thời gian giữ', '${snapshot.holdingPeriodYears} năm'),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-107: Báo cáo chi phí sau đầu tư (Ex-Post).
class ExPostCostsReportTabletPage extends ConsumerWidget {
  const ExPostCostsReportTabletPage({super.key});

  static const contentKey = Key('sc107_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeExPostCostsReportProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-107',
        semanticLabel: 'Báo cáo chi phí sau đầu tư',
        title: 'Chi phí sau đầu tư',
        subtitle: 'Ex-Post',
        contentKey: ExPostCostsReportTabletPage.contentKey,
        children: [
          _cdError(
            'Không tải được báo cáo chi phí',
            () => ref.invalidate(tradeExPostCostsReportProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-107',
        semanticLabel: 'Báo cáo chi phí sau đầu tư',
        title: 'Chi phí sau đầu tư',
        subtitle: 'Ex-Post',
        contentKey: ExPostCostsReportTabletPage.contentKey,
        children: [
          for (final report in snapshot.reports)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: _cdSection(
                title: 'Năm ${report.year}',
                rows: _cdRows([
                  ('Một lần', formatCdUsd(report.oneOff)),
                  ('Định kỳ', formatCdUsd(report.recurring)),
                  ('Phát sinh', formatCdUsd(report.incidental)),
                  ('Ước tính một lần', formatCdUsd(report.estimatedOneOff)),
                  ('Ước tính định kỳ', formatCdUsd(report.estimatedRecurring)),
                  (
                    'Ước tính phát sinh',
                    formatCdUsd(report.estimatedIncidental),
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

/// SC-108: Trình tạo tài liệu KID.
class KidGeneratorTabletPage extends ConsumerWidget {
  const KidGeneratorTabletPage({super.key});

  static const contentKey = Key('sc108_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeKidGeneratorProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-108',
        semanticLabel: 'Tài liệu KID',
        title: 'Tài liệu KID',
        subtitle: 'Key Information Document',
        contentKey: KidGeneratorTabletPage.contentKey,
        children: [
          _cdError(
            'Không tải được KID',
            () => ref.invalidate(tradeKidGeneratorProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-108',
        semanticLabel: 'Tài liệu KID',
        title: 'Tài liệu KID',
        subtitle: '${snapshot.document.title} · v${snapshot.document.version}',
        contentKey: KidGeneratorTabletPage.contentKey,
        children: [
          _cdSection(
            title: 'Thông tin tài liệu',
            rows: _cdRows([
              ('Loại', snapshot.document.documentType),
              ('Số trang', '${snapshot.document.pages}'),
              ('Tối đa', '${snapshot.document.maxPages}'),
              ('Cập nhật', snapshot.document.lastUpdated),
            ]),
          ),

          for (final section in snapshot.sections)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x2),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.description_outlined,
                      size: TabletSpacingTokens.iconSm,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x2),
                  Expanded(
                    child: Text(
                      section.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  VitStatusPill(
                    label: section.status,
                    status: section.status.contains('Hoàn thành')
                        ? VitStatusPillStatus.success
                        : VitStatusPillStatus.warning,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// SC-109: Kịch bản hiệu suất.
class PerformanceScenariosTabletPage extends ConsumerWidget {
  const PerformanceScenariosTabletPage({super.key});

  static const contentKey = Key('sc109_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradePerformanceScenariosProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-109',
        semanticLabel: 'Kịch bản hiệu suất',
        title: 'Kịch bản hiệu suất',
        subtitle: 'Mô phỏng',
        contentKey: PerformanceScenariosTabletPage.contentKey,
        children: [
          _cdError(
            'Không tải được kịch bản',
            () => ref.invalidate(tradePerformanceScenariosProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-109',
        semanticLabel: 'Kịch bản hiệu suất',
        title: 'Kịch bản hiệu suất',
        subtitle:
            'Đầu tư ${formatCdUsd(snapshot.investment)} · ${snapshot.defaultHoldingPeriod} năm',
        contentKey: PerformanceScenariosTabletPage.contentKey,
        children: [
          _cdSection(
            title: 'Kịch bản mô phỏng',
            rows: [
              for (final scenario in snapshot.scenarios)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          scenario.label,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${scenario.annualReturnPct >= 0 ? '+' : ''}${scenario.annualReturnPct.toStringAsFixed(1)}%/năm',
                        style: AppTextStyles.caption.copyWith(
                          color: scenario.annualReturnPct >= 0
                              ? AppColors.buy
                              : AppColors.sell,
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

/// SC-110: Giải thích chỉ báo rủi ro.
class RiskIndicatorExplainerTabletPage extends ConsumerWidget {
  const RiskIndicatorExplainerTabletPage({super.key});

  static const contentKey = Key('sc110_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeRiskIndicatorExplainerProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-110',
        semanticLabel: 'Giải thích chỉ báo rủi ro',
        title: 'Chỉ báo rủi ro',
        subtitle: 'SRI · Giải thích',
        contentKey: RiskIndicatorExplainerTabletPage.contentKey,
        children: [
          _cdError(
            'Không tải được chỉ báo rủi ro',
            () => ref.invalidate(tradeRiskIndicatorExplainerProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-110',
        semanticLabel: 'Giải thích chỉ báo rủi ro',
        title: 'Chỉ báo rủi ro',
        subtitle: '${snapshot.productName} · SRI ${snapshot.productSri}/7',
        contentKey: RiskIndicatorExplainerTabletPage.contentKey,
        children: [
          _cdSection(
            title: 'Thang SRI',
            rows: [
              for (final level in snapshot.levels)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          level.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _cdSection(
            title: 'Rủi ro bổ sung',
            rows: [
              for (final risk in snapshot.additionalRisks)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    '• ${risk.title}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

String formatCdUsd(num value) => VitFormat.usd(value.toDouble());
