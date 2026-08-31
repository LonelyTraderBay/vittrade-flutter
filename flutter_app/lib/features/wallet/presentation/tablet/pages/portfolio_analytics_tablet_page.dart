import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for wallet portfolio analytics SC-142.
class PortfolioAnalyticsTabletPage extends ConsumerStatefulWidget {
  const PortfolioAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc142_portfolio_analytics_tablet_content');
  static Key periodKey(String period) =>
      Key('sc142_portfolio_period_tablet_$period');
  static Key viewKey(String id) => Key('sc142_portfolio_view_tablet_$id');

  @override
  ConsumerState<PortfolioAnalyticsTabletPage> createState() =>
      _PortfolioAnalyticsTabletPageState();
}

class _PortfolioAnalyticsTabletPageState
    extends ConsumerState<PortfolioAnalyticsTabletPage> {
  String _period = '1M';
  String _view = 'overview';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletPortfolioAnalyticsProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được phân tích danh mục',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletPortfolioAnalyticsProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) => _frame(
        primary: _buildPrimary(snapshot),
        secondary: _buildSecondary(snapshot),
      ),
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Phân tích danh mục trên tablet',
      semanticIdentifier: 'SC-142-TABLET',
      title: 'Phân tích danh mục',
      subtitle: 'Tổng quan tài sản · Ví',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(WalletPortfolioAnalyticsSnapshot snapshot) {
    return Column(
      key: PortfolioAnalyticsTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng giá trị danh mục'),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      VitFormat.usd(snapshot.totalUsd),
                      style: AppTextStyles.heroNumber.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              VitMetricDeltaPill(
                label: VitFormat.signedPercent(
                  snapshot.totalReturnPct,
                  fractionDigits: 2,
                ),
                tone: snapshot.totalReturnPct >= 0
                    ? VitMetricDeltaTone.positive
                    : VitMetricDeltaTone.negative,
              ),
            ],
          ),
        ),
        VitPageSection(
          innerGap: AppSpacing.x4,
          label: 'Góc nhìn',
          headerIcon: Icons.dashboard_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitTabBar(
              tabs: [
                for (final item in const [
                  ('overview', 'Tổng quan'),
                  ('performance', 'Hiệu suất'),
                  ('risk', 'Rủi ro'),
                ])
                  VitTabItem(
                    key: item.$1,
                    label: item.$2,
                    widgetKey: PortfolioAnalyticsTabletPage.viewKey(item.$1),
                  ),
              ],
              activeKey: _view,
              onChanged: (view) => setState(() => _view = view),
              variant: VitTabBarVariant.pill,
            ),
          ],
        ),
        if (_view == 'overview') ...[
          VitPageSection(
            innerGap: AppSpacing.x4,
            label: 'Lịch sử giá trị',
            headerIcon: Icons.show_chart_rounded,
            headerIconColor: AppColors.primary,
            headerVariant: VitSectionHeaderVariant.plain,
            accentColor: AppColors.primary,
            rhythm: VitPageRhythm.standard,
            children: [
              VitTabBar(
                tabs: [
                  for (final period in snapshot.periods)
                    VitTabItem(
                      key: period,
                      label: period,
                      widgetKey: PortfolioAnalyticsTabletPage.periodKey(period),
                    ),
                ],
                activeKey: _period,
                onChanged: (period) => setState(() => _period = period),
                variant: VitTabBarVariant.segment,
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                child: SizedBox(
                  height: AppSpacing.x7 * 3,
                  child: VitSparkline(
                    values: [for (final point in snapshot.history) point.value],
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          VitPageSection(
            innerGap: AppSpacing.x4,
            label: 'Chỉ số chính',
            headerIcon: Icons.insights_outlined,
            headerIconColor: AppColors.primary,
            headerVariant: VitSectionHeaderVariant.plain,
            accentColor: AppColors.primary,
            rhythm: VitPageRhythm.standard,
            children: [
              Wrap(
                spacing: AppSpacing.gridGap,
                runSpacing: AppSpacing.gridGap,
                children: [
                  for (final metric in snapshot.metrics)
                    SizedBox(
                      width: AppSpacing.serviceTileMinHeight * 2,
                      child: VitCard(
                        variant: VitCardVariant.inner,
                        density: VitDensity.compact,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metric.label,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x4),
                            Text(
                              metric.value,
                              style: AppTextStyles.sectionTitle.copyWith(
                                color: Color(metric.colorHex),
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ] else
          const VitEmptyState(
            title: 'Góc nhìn đang được chuẩn bị',
            message:
                'Các chỉ số chi tiết sẽ được bổ sung theo dữ liệu vận hành.',
            icon: Icons.insights_outlined,
          ),
      ],
    );
  }

  Widget _buildSecondary(WalletPortfolioAnalyticsSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Đọc số liệu có trách nhiệm',
          message:
              'Lợi nhuận quá khứ không đảm bảo kết quả tương lai. Kiểm tra phân bổ, thanh khoản và rủi ro trước quyết định.',
          contractId: 'Phân tích danh mục',
        ),
        VitPageSection(
          innerGap: AppSpacing.x4,
          label: 'Tài sản nổi bật',
          headerIcon: Icons.pie_chart_outline_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.assets.length; i++)
                    VitInfoRow(
                      label: snapshot.assets[i].symbol,
                      value: VitFormat.usd(snapshot.assets[i].usdValue),
                      leading: VitAssetAvatar(
                        label: snapshot.assets[i].symbol,
                        accentColor: Color(snapshot.assets[i].colorHex),
                        size: AppSpacing.iconLg,
                      ),
                      density: VitDensity.compact,
                      showDivider: i != snapshot.assets.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tốt nhất'),
              const SizedBox(height: AppSpacing.x4),
              Text(
                '${snapshot.bestProfitAsset} · ${VitFormat.usdSigned(snapshot.bestProfitUsd)}',
                style: AppTextStyles.caption.copyWith(color: AppColors.buy),
              ),
              const SizedBox(height: AppSpacing.x4),
              const Text('Cần theo dõi'),
              const SizedBox(height: AppSpacing.x4),
              Text(
                '${snapshot.worstLossAsset} · ${VitFormat.usdSigned(-snapshot.worstLossUsd)}',
                style: AppTextStyles.caption.copyWith(color: AppColors.sell),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
