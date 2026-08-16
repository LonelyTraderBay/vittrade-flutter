import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_dashboard_state_content.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

export 'admin_settings_page.dart';

part '../../widgets/admin_home_metrics_realtime.dart';
part '../../widgets/admin_home_dashboards_footer.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc180_admin_home_content');
  static const settingsKey = Key('sc180_admin_settings');
  static const pauseKey = Key('sc180_admin_pause_live');

  static Key dashboardKey(String id) => Key('sc180_admin_dashboard_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  bool _isLive = true;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(adminHomeControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return AdminDashboardPageShell(
      semanticLabel: 'Trang tổng quan quản trị',
      semanticIdentifier: 'SC-180',
      scrollKey: AdminHomePage.contentKey,
      scrollBottom: scrollBottom,
      header: VitHeader(
        title: 'Admin Dashboard',
        subtitle: 'DCA Analytics & Monitoring',
        actions: [
          VitHeaderActionItem(
            key: AdminHomePage.settingsKey,
            type: VitHeaderActionType.settings,
            onPressed: () => context.go(AppRoutePaths.adminSettings),
          ),
        ],
      ),
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        children: [
          ...controllerAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title: 'Admin dashboard',
                message: 'Không tải được dữ liệu.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(adminHomeSnapshotProvider),
              ),
            ],
            data: (controller) {
              final snapshot = controller.state.snapshot;
              return [
                AdminDashboardStateContent(
                  status: controller.state.status,
                  title: 'Admin dashboard',
                  message: controller.state.message,
                  children: [
                    _MetricGrid(metrics: snapshot.quickStats),
                    _RealTimeMetricsSection(
                      snapshot: snapshot,
                      isLive: _isLive,
                      onToggleLive: () => setState(() => _isLive = !_isLive),
                    ),
                    _DashboardsSection(dashboards: snapshot.dashboards),
                    _FooterCard(snapshot: snapshot),
                  ],
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class AdminDashboardPageShell extends StatelessWidget {
  const AdminDashboardPageShell({
    super.key,
    required this.semanticLabel,
    this.semanticIdentifier,
    required this.scrollKey,
    required this.scrollBottom,
    required this.header,
    required this.child,
  });

  final String semanticLabel;

  /// Internal screen code (e.g. `SC-007`) for tooling/debugging — see A11Y-1,
  /// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  final String? semanticIdentifier;
  final Key scrollKey;
  final double scrollBottom;
  final VitHeader header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      child: VitAutoHideHeaderScaffold(
        header: header,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: scrollKey,
                physics: const ClampingScrollPhysics(),
                padding: AdminSpacingTokens.adminScrollPadding(scrollBottom),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
