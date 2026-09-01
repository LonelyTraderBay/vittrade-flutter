import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/ads/p2p_ad_analytics_overview_cards.dart';
part '../../../widgets/ads/p2p_ad_analytics_breakdown_cards.dart';
part '../../../widgets/ads/p2p_ad_analytics_charts_common.dart';

const double _p2pAdAnalyticsIdentityExtent =
    P2PSpacingTokens.p2pMarketplaceAnalyticsIdentityHeight;
const double _p2pAdAnalyticsMetricCardExtent =
    P2PSpacingTokens.p2pMarketplaceAnalyticsMetricCardHeight;
const double _p2pAdAnalyticsMetricIconExtent = AppSpacing.x6;
const double _p2pAdAnalyticsQuickStatsExtent =
    P2PSpacingTokens.p2pMarketplaceAnalyticsQuickStatsHeight;
const double _p2pAdAnalyticsLegendDotExtent =
    P2PSpacingTokens.p2pMarketplaceAnalyticsLegendDot;
const double _p2pAdAnalyticsDividerExtent =
    P2PSpacingTokens.p2pMarketplaceAnalyticsDividerHeight;
const double _p2pAdAnalyticsChartLargeExtent =
    P2PSpacingTokens.p2pMarketplaceAnalyticsChartLargeHeight;
const double _p2pAdAnalyticsChartTallExtent =
    P2PSpacingTokens.p2pMarketplaceAnalyticsChartTallHeight;
const double _p2pAdAnalyticsRadarExtent =
    P2PSpacingTokens.p2pMarketplaceAnalyticsRadarHeight;
const double _p2pAdAnalyticsTightLine =
    P2PSpacingTokens.p2pMarketplaceAnalyticsTightLineHeight;
const double _p2pAdAnalyticsBodyLine =
    P2PSpacingTokens.p2pMarketplaceAnalyticsBodyLineHeight;

class P2PAdAnalyticsPage extends ConsumerWidget {
  const P2PAdAnalyticsPage({
    super.key,
    required this.adId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc223_p2p_ad_analytics_content');
  static const funnelKey = Key('sc223_p2p_ad_analytics_funnel');

  final String adId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pAdAnalyticsProvider(adId));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích quảng cáo P2P',
      semanticIdentifier: 'SC-223',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích quảng cáo',
            subtitle: 'Phân tích · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pAdAnalyticsProvider(adId)),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: P2PAdAnalyticsPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsetsDirectional.fromSTEB(
                        AppSpacing.contentPad,
                        AppSpacing.x3,
                        AppSpacing.contentPad,
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        density: VitDensity.compact,
                        children: [
                          _AdIdentityCard(snapshot: snapshot),
                          _KpiGrid(snapshot: snapshot),
                          _QuickStats(snapshot: snapshot),
                          _ConversionFunnel(snapshot: snapshot),
                          _PerformanceCard(snapshot: snapshot),
                          _VolumeCard(points: snapshot.dailyPerformance),
                          _HeatmapCard(points: snapshot.hourlyHeatmap),
                          _PaymentBreakdownCard(snapshot: snapshot),
                          _CompetitorCard(rows: snapshot.competitorComparison),
                          _TipsCard(tips: snapshot.optimizationTips),
                          const VitPageSection(
                            density: VitDensity.compact,
                            children: [
                              VitCard(
                                variant: VitCardVariant.inner,
                                padding: P2PSpacingTokens
                                    .p2pMarketplaceAnalyticsCompactPadding,
                                child: VitHighRiskStatePanel(
                                  density: VitDensity.compact,
                                  state: VitHighRiskUiState.riskReview,
                                  title: 'Ad performance review',
                                  message:
                                      'Đã xem danh tính tin, phễu chuyển đổi, xu hướng khối lượng, tỷ lệ thanh toán, khoảng đối thủ và bước tối ưu trước khi thay đổi.',
                                  contractId: 'p2p-ad-analytics-review',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
