import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/cross_module_spacing_tokens.dart';
part '../../widgets/cross_module_analytics_tabs.dart';
part '../../widgets/cross_module_analytics_cards.dart';
part '../../widgets/cross_module_analytics_common.dart';
part '../../widgets/cross_module_analytics_painters.dart';

class CrossModuleAnalyticsPage extends ConsumerStatefulWidget {
  const CrossModuleAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc322_cross_module_analytics_content');
  static Key tabKey(CrossModuleAnalyticsTab tab) =>
      Key('sc322_tab_${tab.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CrossModuleAnalyticsPage> createState() =>
      _CrossModuleAnalyticsPageState();
}

class _CrossModuleAnalyticsPageState
    extends ConsumerState<CrossModuleAnalyticsPage> {
  CrossModuleAnalyticsTab _activeTab = CrossModuleAnalyticsTab.performance;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(crossModuleAnalyticsControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return controllerAsync.when(
      loading: () => CrossModuleTabbedPageShell(
        semanticLabel: 'Phân tích liên module',
        semanticIdentifier: 'SC-322',
        contentKey: CrossModuleAnalyticsPage.contentKey,
        title: 'Cross-Module Analytics',
        onBack: () => context.go(AppRoutePaths.home),
        scrollEndClearance: scrollEndClearance,
        tabs: const SizedBox.shrink(),
        contentGap: VitContentGap.tight,
        body: const VitSkeletonList(),
      ),
      error: (error, stackTrace) => CrossModuleTabbedPageShell(
        semanticLabel: 'Phân tích liên module',
        semanticIdentifier: 'SC-322',
        contentKey: CrossModuleAnalyticsPage.contentKey,
        title: 'Cross-Module Analytics',
        onBack: () => context.go(AppRoutePaths.home),
        scrollEndClearance: scrollEndClearance,
        tabs: const SizedBox.shrink(),
        contentGap: VitContentGap.tight,
        body: VitErrorState(
          title: 'Cross-Module Analytics',
          message: 'Không tải được dữ liệu.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(crossModuleAnalyticsSnapshotProvider),
        ),
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        return CrossModuleTabbedPageShell(
          semanticLabel: 'Phân tích liên module',
          semanticIdentifier: 'SC-322',
          contentKey: CrossModuleAnalyticsPage.contentKey,
          title: snapshot.title,
          onBack: () => context.go(snapshot.backRoute),
          scrollEndClearance: scrollEndClearance,
          tabs: _AnalyticsTabs(
            tabs: snapshot.tabs,
            active: _activeTab,
            onChanged: (tab) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _activeTab = tab);
            },
          ),
          contentGap: VitContentGap.tight,
          body: _activeTab == CrossModuleAnalyticsTab.performance
              ? _PerformanceTab(snapshot: snapshot)
              : _activeTab == CrossModuleAnalyticsTab.metrics
              ? _MetricsTab(snapshot: snapshot)
              : _ComparisonTab(snapshot: snapshot),
        );
      },
    );
  }
}
