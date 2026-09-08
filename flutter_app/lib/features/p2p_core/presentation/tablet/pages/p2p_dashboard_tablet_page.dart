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

/// Bố cục tablet của Dashboard P2P (SC-274): banner thống kê + lọc thời gian,
/// cột chính là bảng đơn hàng theo tháng + hoạt động gần đây, cột phụ là cấp
/// bậc + top merchant + phân bổ tài sản + quick actions.
class P2PDashboardTabletPage extends ConsumerStatefulWidget {
  const P2PDashboardTabletPage({super.key});

  static const contentKey = Key('sc274_tablet_content');

  @override
  ConsumerState<P2PDashboardTabletPage> createState() =>
      _P2PDashboardTabletPageState();
}

class _P2PDashboardTabletPageState
    extends ConsumerState<P2PDashboardTabletPage> {
  String _timeFilter = '30d';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pDashboardProvider(_timeFilter));
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Bảng điều khiển P2P',
      semanticIdentifier: 'SC-274',
      child: Column(
        children: [
          VitHeader(
            title: 'Dashboard P2P',
            subtitle: 'Hiệu suất · Hoạt động',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2p,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được dashboard',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(p2pDashboardProvider(_timeFilter)),
                ),
              ),
              data: (snapshot) => VitTwoColumnTabletDashboard(
                onRefresh: () async {
                  ref.invalidate(p2pDashboardProvider(_timeFilter));
                  await ref.read(p2pDashboardProvider(_timeFilter).future);
                },
                banner: _StatsStrip(
                  stats: snapshot.stats,
                  filters: snapshot.filters,
                  selected: snapshot.selectedFilter,
                  onFilterChanged: (filter) => setState(() {
                    _timeFilter = filter.id;
                  }),
                ),
                primaryChildren: [
                  _MonthlyOrdersCard(orders: snapshot.monthlyOrders),
                  _P2PDashActivityCard(activity: snapshot.recentActivity),
                ],
                secondaryChildren: [
                  _P2PDashLevelCard(
                    current: snapshot.currentLevel,
                    next: snapshot.nextLevel,
                  ),
                  _TopMerchantsCard(merchants: snapshot.topMerchants),
                  _P2PDashAssetDistributionCard(
                    distribution: snapshot.assetDistribution,
                  ),
                  for (final action in snapshot.quickActions)
                    VitCard(
                      radius: VitCardRadius.tight,
                      padding: TabletSpacingTokens.cardPaddingCompact,
                      child: InkWell(
                        onTap: () => context.go(action.route),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                action.label,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: TabletSpacingTokens.iconMd,
                              color: AppColors.text3,
                            ),
                          ],
                        ),
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

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({
    required this.stats,
    required this.filters,
    required this.selected,
    required this.onFilterChanged,
  });

  final P2PDashboardStatsDraft stats;
  final List<P2PDashboardFilterDraft> filters;
  final P2PDashboardFilterDraft selected;
  final ValueChanged<P2PDashboardFilterDraft> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _P2PDashStatCell(
                  label: 'Tổng đơn',
                  value: '${stats.totalOrders}',
                ),
              ),
              Expanded(
                child: _P2PDashStatCell(
                  label: 'Hoàn tất',
                  value:
                      '${stats.completedOrders} (${stats.completionRate.toStringAsFixed(1)}%)',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _P2PDashStatCell(
                  label: 'Volume 7 ngày',
                  value: formatP2PVnd(stats.totalVolume7d),
                ),
              ),
              Expanded(
                child: _P2PDashStatCell(
                  label: 'Trung bình TB hoàn tất',
                  value: stats.avgCompletionTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            children: [
              for (final filter in filters)
                VitFilterChip(
                  label: filter.label,
                  active: selected.id == filter.id,
                  onTap: () => onFilterChanged(filter),
                  color: AppColors.primary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _P2PDashStatCell extends StatelessWidget {
  const _P2PDashStatCell({
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

class _MonthlyOrdersCard extends StatelessWidget {
  const _MonthlyOrdersCard({required this.orders});

  final List<P2PDashboardMonthlyOrdersDraft> orders;

  @override
  Widget build(BuildContext context) {
    final maxCount = orders.fold<int>(
      0,
      (max, order) =>
          order.buy + order.sell > max ? order.buy + order.sell : max,
    );
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đơn hàng theo tháng',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (final order in orders)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  SizedBox(
                    width: TabletSpacingTokens.x7,
                    child: Text(
                      order.month,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    child: VitProgressBar(
                      progress: maxCount == 0
                          ? 0
                          : (order.buy + order.sell) / maxCount,
                      height: TabletSpacingTokens.x3,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x3),
                  SizedBox(
                    width: TabletSpacingTokens.x7 * 1.5,
                    child: Text(
                      '${order.buy} mua · ${order.sell} bán',
                      textAlign: TextAlign.end,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
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

class _P2PDashActivityCard extends StatelessWidget {
  const _P2PDashActivityCard({required this.activity});

  final List<P2PDashboardActivityDraft> activity;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: TabletSpacingTokens.tableCellPadding,
            child: Text(
              'Hoạt động gần đây',
              style: AppTextStyles.control.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
              ),
            ),
          ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          for (final item in activity.take(8))
            Padding(
              padding: TabletSpacingTokens.tableCellPadding,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.date,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.type,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.asset,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      formatP2PVnd(item.amount),
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
        ],
      ),
    );
  }
}

class _P2PDashLevelCard extends StatelessWidget {
  const _P2PDashLevelCard({required this.current, required this.next});

  final P2PDashboardLevelDraft current;
  final P2PDashboardLevelDraft next;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cấp bậc: ${current.name}',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          VitProgressBar(
            progress: current.progress.clamp(0.0, 1.0),
            label: 'Hạn mức ngày',
            trailingLabel:
                '${formatP2PVnd(current.dailyUsed)} / ${formatP2PVnd(current.dailyLimit)}',
            color: AppColors.primary,
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            'Cấp tiếp theo: ${next.name}',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _TopMerchantsCard extends StatelessWidget {
  const _TopMerchantsCard({required this.merchants});

  final List<P2PDashboardMerchantDraft> merchants;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top merchant',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final merchant in merchants.take(5))
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      merchant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '${merchant.trades} đơn · ${merchant.rating.toStringAsFixed(1)}★',
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
    );
  }
}

class _P2PDashAssetDistributionCard extends StatelessWidget {
  const _P2PDashAssetDistributionCard({required this.distribution});

  final List<P2PDashboardAssetDraft> distribution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ tài sản',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final asset in distribution)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: VitProgressBar(
                progress: asset.percentage / 100,
                label: asset.asset,
                trailingLabel: '${asset.percentage.toStringAsFixed(1)}%',
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
