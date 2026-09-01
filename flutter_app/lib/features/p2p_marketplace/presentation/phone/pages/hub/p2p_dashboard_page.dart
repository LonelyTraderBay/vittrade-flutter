import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/phone/p2p_dashboard_overview_cards.dart';
part '../../../widgets/phone/p2p_dashboard_activity_cards.dart';
part '../../../widgets/phone/p2p_dashboard_row_widgets.dart';
part '../../../widgets/phone/p2p_dashboard_page_common.dart';

const double _p2pDashboardVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pDashboardNativeNavClearance =
    _p2pDashboardVisualNavClearance - AppSpacing.x4;
const double _p2pDashboardVisualClearance = AppSpacing.x3;
const double _p2pDashboardNativeClearance = AppSpacing.x2;
const double _p2pDashboardDividerHeight = AppSpacing.dividerHairline;

class P2PDashboardPage extends ConsumerStatefulWidget {
  const P2PDashboardPage({super.key, this.shellRenderMode});

  static const filterKey = Key('sc274_p2p_dashboard_filters');
  static const volumeHeroKey = Key('sc274_p2p_dashboard_volume_hero');
  static const metricsKey = Key('sc274_p2p_dashboard_metrics');
  static const weeklyChartKey = Key('sc274_p2p_dashboard_weekly_chart');
  static const monthlyChartKey = Key('sc274_p2p_dashboard_monthly_chart');
  static const assetDistributionKey = Key(
    'sc274_p2p_dashboard_asset_distribution',
  );
  static const levelKey = Key('sc274_p2p_dashboard_level');
  static const comparisonKey = Key('sc274_p2p_dashboard_comparison');
  static const breakdownKey = Key('sc274_p2p_dashboard_breakdown');
  static const merchantsKey = Key('sc274_p2p_dashboard_merchants');
  static const activityKey = Key('sc274_p2p_dashboard_activity');
  static const quickNavKey = Key('sc274_p2p_dashboard_quick_nav');
  static const myOrdersKey = Key('sc274_p2p_dashboard_my_orders');

  static Key filterChipKey(String id) => Key('sc274_p2p_dashboard_filter_$id');

  static Key merchantKey(String id) => Key('sc274_p2p_dashboard_merchant_$id');

  static Key quickActionKey(String id) => Key('sc274_p2p_dashboard_quick_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDashboardPage> createState() => _P2PDashboardPageState();
}

class _P2PDashboardPageState extends ConsumerState<P2PDashboardPage> {
  String _timeFilter = '30d';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pDashboardProvider(_timeFilter));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pDashboardVisualNavClearance + _p2pDashboardVisualClearance
            : _p2pDashboardNativeNavClearance + _p2pDashboardNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tổng quan P2P',
      semanticIdentifier: 'SC-274',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pDashboardProvider(_timeFilter)),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pDashboardPageScrollPadding(
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _DashboardFilterRow(
                            snapshot: snapshot,
                            onChanged: (id) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _timeFilter = id);
                            },
                          ),
                          _VolumeHero(snapshot: snapshot),
                          _MetricsGrid(snapshot: snapshot),
                          _WeeklyVolumeCard(snapshot: snapshot),
                          _MonthlyOrdersCard(snapshot: snapshot),
                          _AssetDistributionCard(snapshot: snapshot),
                          _LevelCard(snapshot: snapshot),
                          _PlatformComparisonCard(snapshot: snapshot),
                          _ExtraStats(snapshot: snapshot),
                          _OrderBreakdownCard(snapshot: snapshot),
                          _TopMerchantsCard(snapshot: snapshot),
                          _RecentActivityCard(snapshot: snapshot),
                          _QuickNavigation(snapshot: snapshot),
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
