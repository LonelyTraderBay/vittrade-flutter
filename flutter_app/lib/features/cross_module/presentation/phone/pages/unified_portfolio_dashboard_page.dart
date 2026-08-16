import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_analysis.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_history.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_overview.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/unified_portfolio_tabs.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class UnifiedPortfolioDashboardPage extends ConsumerStatefulWidget {
  const UnifiedPortfolioDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc321_unified_portfolio_content');
  static const refreshKey = Key('sc321_refresh_data');
  static Key tabKey(UnifiedPortfolioTab tab) => Key('sc321_tab_${tab.name}');
  static Key moduleKey(UnifiedPortfolioModuleId id) =>
      Key('sc321_module_${id.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<UnifiedPortfolioDashboardPage> createState() =>
      _UnifiedPortfolioDashboardPageState();
}

class _UnifiedPortfolioDashboardPageState
    extends ConsumerState<UnifiedPortfolioDashboardPage> {
  UnifiedPortfolioTab _activeTab = UnifiedPortfolioTab.overview;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(unifiedPortfolioControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return controllerAsync.when(
      loading: () => CrossModuleTabbedPageShell(
        semanticLabel: 'Danh mục đầu tư hợp nhất',
        semanticIdentifier: 'SC-321',
        contentKey: UnifiedPortfolioDashboardPage.contentKey,
        title: 'Unified Portfolio',
        onBack: () => context.go(AppRoutePaths.home),
        scrollEndClearance: bottomInset,
        tabs: const SizedBox.shrink(),
        body: const VitSkeletonList(),
      ),
      error: (error, stackTrace) => CrossModuleTabbedPageShell(
        semanticLabel: 'Danh mục đầu tư hợp nhất',
        semanticIdentifier: 'SC-321',
        contentKey: UnifiedPortfolioDashboardPage.contentKey,
        title: 'Unified Portfolio',
        onBack: () => context.go(AppRoutePaths.home),
        scrollEndClearance: bottomInset,
        tabs: const SizedBox.shrink(),
        body: VitErrorState(
          title: 'Unified Portfolio',
          message: 'Không tải được dữ liệu.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(unifiedPortfolioSnapshotProvider),
        ),
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        return CrossModuleTabbedPageShell(
          semanticLabel: 'Danh mục đầu tư hợp nhất',
          semanticIdentifier: 'SC-321',
          contentKey: UnifiedPortfolioDashboardPage.contentKey,
          title: snapshot.title,
          onBack: () => context.go(snapshot.backRoute),
          scrollEndClearance: bottomInset,
          tabs: UnifiedPortfolioTabs(
            tabs: snapshot.tabs,
            active: _activeTab,
            tabKey: UnifiedPortfolioDashboardPage.tabKey,
            onChanged: _changeTab,
          ),
          body: _activeTab == UnifiedPortfolioTab.overview
              ? UnifiedPortfolioOverview(
                  snapshot: snapshot,
                  refreshKey: UnifiedPortfolioDashboardPage.refreshKey,
                  moduleKey: UnifiedPortfolioDashboardPage.moduleKey,
                  onRefresh: () => HapticFeedback.lightImpact(),
                  onOpenRoute: (route) => context.go(route),
                )
              : _activeTab == UnifiedPortfolioTab.analysis
              ? UnifiedPortfolioAnalysis(snapshot: snapshot)
              : UnifiedPortfolioHistory(snapshot: snapshot),
        );
      },
    );
  }

  void _changeTab(UnifiedPortfolioTab tab) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _activeTab = tab);
  }
}
