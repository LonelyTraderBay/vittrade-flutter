import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

part '../../../widgets/bridge/launchpad_bridge_compare_hero.dart';
part '../../../widgets/bridge/launchpad_bridge_compare_quick_compare.dart';
part '../../../widgets/bridge/launchpad_bridge_compare_route_list.dart';
part '../../../widgets/bridge/launchpad_bridge_compare_route_metrics.dart';
part '../../../widgets/bridge/launchpad_bridge_compare_route_details.dart';
part '../../../widgets/bridge/launchpad_bridge_compare_confirm.dart';
part '../../../widgets/bridge/launchpad_bridge_compare_common.dart';

class LaunchpadBridgeComparePage extends ConsumerStatefulWidget {
  const LaunchpadBridgeComparePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc305_launchpad_bridge_compare_content');
  static const heroKey = Key('sc305_launchpad_bridge_compare_hero');
  static const quickCompareKey = Key(
    'sc305_launchpad_bridge_compare_quick_compare',
  );
  static const sortKeyPrefix = 'sc305_launchpad_bridge_compare_sort_';
  static const footerKey = Key('sc305_launchpad_bridge_compare_footer');
  static const confirmKey = Key('sc305_launchpad_bridge_compare_confirm');
  static const riskKey = Key('sc305_launchpad_bridge_compare_risk');

  static Key sortKey(String value) => Key('$sortKeyPrefix$value');
  static Key routeKey(String id) =>
      Key('sc305_launchpad_bridge_compare_route_$id');
  static Key routeSelectKey(String id) =>
      Key('sc305_launchpad_bridge_compare_route_select_$id');
  static Key expandKey(String id) =>
      Key('sc305_launchpad_bridge_compare_expand_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadBridgeComparePage> createState() =>
      _LaunchpadBridgeComparePageState();
}

class _LaunchpadBridgeComparePageState
    extends ConsumerState<LaunchpadBridgeComparePage> {
  var _sortMode = 'recommended';
  String? _selectedRouteId;
  String? _expandedRouteId;

  @override
  Widget build(BuildContext context) {
    final bridgeCompareAsync = ref.watch(
      launchpadBridgeCompareSnapshotProvider,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final chromeReserve = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'So sánh route bridge trước khi chuyển',
      semanticIdentifier: 'SC-305',
      child: Material(
        type: MaterialType.transparency,
        child: bridgeCompareAsync.when(
          loading: () => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: chromeReserve + safeBottom + AppSpacing.x3,
                semanticLabel: 'So sánh route bridge – vùng cuộn nội dung',
                semanticIdentifier: 'SC-305',
                header: VitHeader(
                  title: 'So sánh routes',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: const VitSkeletonList(),
              ),
            ],
          ),
          error: (error, stackTrace) => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: chromeReserve + safeBottom + AppSpacing.x3,
                semanticLabel: 'So sánh route bridge – vùng cuộn nội dung',
                semanticIdentifier: 'SC-305',
                header: VitHeader(
                  title: 'So sánh routes',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: VitErrorState(
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(launchpadBridgeCompareSnapshotProvider),
                ),
              ),
            ],
          ),
          data: (snapshot) {
            final footerHeight = _selectedRouteId == null ? 0.0 : 122.0;
            final scrollTailReserve =
                chromeReserve + safeBottom + AppSpacing.x3 + footerHeight;
            final routes = _sortedRoutes(snapshot.comparison.routes);
            final selectedRoutes = snapshot.comparison.routes
                .where((route) => route.id == _selectedRouteId)
                .toList();
            final selectedRoute = selectedRoutes.isEmpty
                ? null
                : selectedRoutes.first;

            return Stack(
              children: [
                VitAutoHideHeaderScaffold(
                  bottomInset: scrollTailReserve,
                  semanticLabel: 'So sánh route bridge – vùng cuộn nội dung',
                  semanticIdentifier: 'SC-305',
                  header: VitHeader(
                    title: snapshot.title,
                    subtitle:
                        'So sánh route bridge · Xác nhận trước khi chuyển',
                    showBack: true,
                    onBack: () => context.go(snapshot.backRoute),
                    actions: [
                      VitHeaderActionItem(
                        type: VitHeaderActionType.refresh,
                        onPressed: () {
                          setState(() {
                            _sortMode = 'recommended';
                            _selectedRouteId = null;
                            _expandedRouteId = null;
                          });
                        },
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    key: LaunchpadBridgeComparePage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: [
                        _InputSummaryHero(comparison: snapshot.comparison),
                        _QuickComparisonCard(comparison: snapshot.comparison),
                        _SortSelector(
                          options: snapshot.sortOptions,
                          activeValue: _sortMode,
                          onChanged: (value) =>
                              setState(() => _sortMode = value),
                        ),
                        for (final route in routes)
                          _RouteCard(
                            route: route,
                            rank: routes.indexOf(route) + 1,
                            comparison: snapshot.comparison,
                            selected: _selectedRouteId == route.id,
                            expanded: _expandedRouteId == route.id,
                            onSelect: () => setState(() {
                              _selectedRouteId = _selectedRouteId == route.id
                                  ? null
                                  : route.id;
                            }),
                            onExpand: () => setState(() {
                              _expandedRouteId = _expandedRouteId == route.id
                                  ? null
                                  : route.id;
                            }),
                          ),
                        const _RiskDisclosure(),
                      ],
                    ),
                  ),
                ),
                if (selectedRoute != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: chromeReserve + safeBottom,
                    child: _SelectedRouteFooter(
                      route: selectedRoute,
                      outputToken: snapshot.comparison.outputToken,
                      onConfirm: () =>
                          unawaited(_confirmRoute(selectedRoute, snapshot)),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<LaunchpadBridgeRouteOptionDraft> _sortedRoutes(
    List<LaunchpadBridgeRouteOptionDraft> routes,
  ) {
    final sorted = [...routes];
    switch (_sortMode) {
      case 'output':
        sorted.sort((a, b) => b.outputAmount.compareTo(a.outputAmount));
        break;
      case 'fee':
        sorted.sort((a, b) => a.totalFee.compareTo(b.totalFee));
        break;
      case 'speed':
        sorted.sort((a, b) => a.estimatedSeconds.compareTo(b.estimatedSeconds));
        break;
      case 'security':
        sorted.sort((a, b) => b.securityScore.compareTo(a.securityScore));
        break;
      case 'recommended':
      default:
        sorted.sort(
          (a, b) => _recommendedRank(a).compareTo(_recommendedRank(b)),
        );
        break;
    }
    return sorted;
  }

  int _recommendedRank(LaunchpadBridgeRouteOptionDraft route) {
    if (route.recommended) return 0;
    return route.id.codeUnitAt(route.id.length - 1);
  }

  Future<void> _confirmRoute(
    LaunchpadBridgeRouteOptionDraft route,
    LaunchpadBridgeCompareSnapshot snapshot,
  ) async {
    final comparison = snapshot.comparison;
    final confirmed = await showVitPreviewConfirmSheet(
      context: context,
      title: 'Xác nhận route',
      confirmKey: LaunchpadBridgeComparePage.confirmKey,
      confirmLabel: 'Xác nhận Bridge qua ${route.provider}',
      items: [
        VitFinancialSafetyItem(
          label: 'Bạn gửi',
          value:
              '${_formatNumber(comparison.inputAmount)} '
              '${comparison.inputToken} (${comparison.sourceChain})',
        ),
        VitFinancialSafetyItem(
          label: 'Nhận',
          value:
              '${_formatNumber(route.outputAmount)} '
              '${comparison.outputToken} (${comparison.targetChain})',
          valueColor: AppColors.buy,
        ),
        VitFinancialSafetyItem(
          label: 'Price impact',
          value: '${_trimDouble(route.priceImpact)}%',
        ),
        VitFinancialSafetyItem(label: 'Tổng phí', value: route.totalFeeUsd),
        VitFinancialSafetyItem(
          label: 'Security',
          value: '${route.securityScore}/100',
        ),
      ],
      footer: '${route.hops} hops · ${route.estimatedTime}',
    );
    if (!confirmed) return;
    if (!mounted) return;
    context.go(snapshot.bridgeOrderRoute);
  }
}
