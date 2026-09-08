import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Phân tích quảng cáo (SC-223): banner chỉ số chính +
/// bảng hiệu suất theo ngày + phân bổ phương thức thanh toán.
class P2PAdAnalyticsTabletPage extends ConsumerWidget {
  const P2PAdAnalyticsTabletPage({super.key, required this.adId});

  static const contentKey = Key('sc223_tablet_content');

  final String adId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(p2pAdAnalyticsProvider(adId));
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích quảng cáo P2P',
      semanticIdentifier: 'SC-223',
      child: Column(
        children: [
          VitHeader(
            title: 'Phân tích quảng cáo',
            subtitle: 'Hiệu suất · Chuyển đổi',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pMyAds,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: analyticsAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được phân tích quảng cáo',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(p2pAdAnalyticsProvider(adId)),
                ),
              ),
              data: (snapshot) => VitTwoColumnTabletDashboard(
                onRefresh: () async {
                  ref.invalidate(p2pAdAnalyticsProvider(adId));
                  await ref.read(p2pAdAnalyticsProvider(adId).future);
                },
                banner: VitCard(
                  radius: VitCardRadius.tight,
                  padding: TabletSpacingTokens.cardPaddingCompact,
                  child: Row(
                    children: [
                      Expanded(
                        child: _AdAnalyticsMetricCell(
                          label: 'Lượt hiển thị',
                          value: '${snapshot.impressions}',
                        ),
                      ),
                      Expanded(
                        child: _AdAnalyticsMetricCell(
                          label: 'Lượt nhấp',
                          value: '${snapshot.clicks}',
                        ),
                      ),
                      Expanded(
                        child: _AdAnalyticsMetricCell(
                          label: 'Chuyển đổi',
                          value:
                              '${snapshot.conversionRate.toStringAsFixed(1)}%',
                          color: AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: _AdAnalyticsMetricCell(
                          label: 'Doanh thu',
                          value: formatP2PVnd(snapshot.totalRevenue),
                        ),
                      ),
                    ],
                  ),
                ),
                primaryChildren: [
                  _DailyPerformanceCard(performance: snapshot.dailyPerformance),
                  _PaymentBreakdownCard(breakdown: snapshot.paymentBreakdown),
                ],
                secondaryChildren: [
                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đơn hàng',
                          style: AppTextStyles.control.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        for (final (label, value, color) in [
                          (
                            'Đã tạo',
                            '${snapshot.ordersCreated}',
                            AppColors.text1,
                          ),
                          (
                            'Hoàn tất',
                            '${snapshot.ordersCompleted}',
                            AppColors.buy,
                          ),
                          (
                            'Tranh chấp',
                            '${snapshot.ordersDisputed}',
                            AppColors.sell,
                          ),
                          (
                            'Đã hủy',
                            '${snapshot.ordersCancelled}',
                            AppColors.text3,
                          ),
                        ])
                          Padding(
                            padding: TabletSpacingTokens.tableCellPaddingV,
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
                                    color: color,
                                    fontWeight: AppTextStyles.bold,
                                    fontFeatures: AppTextStyles.tabularFigures,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (label, value) in [
                          ('Giá TB/đơn', formatP2PVnd(snapshot.avgOrderValue)),
                          (
                            'Phản hồi TB',
                            '${snapshot.avgResponseTimeSeconds}s',
                          ),
                          (
                            'Hoàn tất TB',
                            '${snapshot.avgCompletionMinutes.toStringAsFixed(0)} phút',
                          ),
                          (
                            'Đánh giá',
                            '${snapshot.rating.toStringAsFixed(1)}★ (${snapshot.reviewsCount})',
                          ),
                        ])
                          Padding(
                            padding: TabletSpacingTokens.tableCellPaddingV,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdAnalyticsMetricCell extends StatelessWidget {
  const _AdAnalyticsMetricCell({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.control.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _DailyPerformanceCard extends StatelessWidget {
  const _DailyPerformanceCard({required this.performance});

  final List<P2PAdDailyPerformanceDraft> performance;

  @override
  Widget build(BuildContext context) {
    final maxValue = performance.fold<int>(
      0,
      (max, item) => item.orders > max ? item.orders : max,
    );
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hiệu suất theo ngày',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (final item in performance.take(14))
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  SizedBox(
                    width: TabletSpacingTokens.x7,
                    child: Text(
                      item.date,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    child: VitProgressBar(
                      progress: maxValue == 0 ? 0 : item.orders / maxValue,
                      height: TabletSpacingTokens.x3,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x3),
                  SizedBox(
                    width: TabletSpacingTokens.x7,
                    child: Text(
                      '${item.orders} đơn',
                      textAlign: TextAlign.end,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
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

class _PaymentBreakdownCard extends StatelessWidget {
  const _PaymentBreakdownCard({required this.breakdown});

  final List<P2PAdPaymentBreakdownDraft> breakdown;

  @override
  Widget build(BuildContext context) {
    final totalVolume = breakdown.fold<int>(
      0,
      (sum, item) => sum + item.volume,
    );
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phương thức thanh toán',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final item in breakdown)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: VitProgressBar(
                progress: totalVolume == 0 ? 0 : item.volume / totalVolume,
                label: item.method,
                trailingLabel: '${item.count} đơn',
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
