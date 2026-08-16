import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/admin_home_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_dashboard_state_content.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_metric_card.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

part '../../widgets/analytics_dashboard_sections.dart';
part '../../widgets/analytics_dashboard_common.dart';

class AnalyticsDashboardPage extends ConsumerStatefulWidget {
  const AnalyticsDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc181_analytics_content');
  static const refreshKey = Key('sc181_refresh');
  static const exportKey = Key('sc181_export');

  static Key rangeKey(AdminAnalyticsRange range) =>
      Key('sc181_range_${range.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AnalyticsDashboardPage> createState() =>
      _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState
    extends ConsumerState<AnalyticsDashboardPage> {
  AdminAnalyticsRange _activeRange = AdminAnalyticsRange.sevenDays;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(adminAnalyticsControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return AdminDashboardPageShell(
      semanticLabel: 'Bảng phân tích dữ liệu',
      semanticIdentifier: 'SC-181',
      scrollKey: AnalyticsDashboardPage.contentKey,
      scrollBottom: scrollBottom,
      header: VitHeader(
        title: 'Analytics Dashboard',
        subtitle: 'DCA Event Analytics',
        showBack: true,
        onBack: () => context.go(AppRoutePaths.admin),
      ),
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        children: [
          ...controllerAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title: 'Analytics dashboard',
                message: 'Không tải được dữ liệu.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(adminAnalyticsSnapshotProvider),
              ),
            ],
            data: (controller) {
              final snapshot = controller.state.snapshot;
              return [
                AdminDashboardStateContent(
                  status: controller.state.status,
                  title: 'Analytics dashboard',
                  message: controller.state.message,
                  children: [
                    _Controls(
                      ranges: snapshot.ranges,
                      activeRange: _activeRange,
                      onRangeChanged: (range) {
                        setState(() => _activeRange = range);
                      },
                    ),
                    _KeyMetrics(snapshot: snapshot),
                    _EventVolumeCard(stats: snapshot.dailyStats),
                    _TopEventsCard(events: snapshot.topEvents),
                    _DistributionCard(events: snapshot.topEvents),
                    _RecentEventsCard(events: snapshot.recentEvents),
                    _QueueSummaryCard(text: snapshot.queueSummary),
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
