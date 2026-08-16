import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/admin_home_page.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_dashboard_state_content.dart';
import 'package:vit_trade_flutter/features/admin/presentation/widgets/admin_metric_card.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

part '../../widgets/funnel_dashboard_selector_metrics.dart';
part '../../widgets/funnel_dashboard_waterfall_details.dart';
part '../../widgets/funnel_dashboard_common_painter.dart';

class FunnelDashboardPage extends ConsumerStatefulWidget {
  const FunnelDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc183_funnel_content');

  static Key selectorKey(String id) => Key('sc183_funnel_selector_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<FunnelDashboardPage> createState() =>
      _FunnelDashboardPageState();
}

class _FunnelDashboardPageState extends ConsumerState<FunnelDashboardPage> {
  String? _selectedFunnelId;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(adminFunnelsControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return AdminDashboardPageShell(
      semanticLabel: 'Bảng phân tích phễu chuyển đổi',
      semanticIdentifier: 'SC-183',
      scrollKey: FunnelDashboardPage.contentKey,
      scrollBottom: scrollEndClearance,
      header: VitHeader(
        title: 'Funnel Analytics',
        subtitle: 'Conversion Funnel Tracking',
        showBack: true,
        onBack: () => context.go(AppRoutePaths.admin),
      ),
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        gap: VitContentGap.tight,
        children: [
          ...controllerAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title: 'Funnel dashboard',
                message: 'Không tải được dữ liệu.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(adminFunnelsSnapshotProvider),
              ),
            ],
            data: (controller) {
              final snapshot = controller.state.snapshot;
              _selectedFunnelId ??= snapshot.selectedFunnelId;
              final selectedFunnelId = _selectedFunnelId!;
              final selectedFunnel = controller.selectedFunnel(
                selectedFunnelId,
              );
              return [
                AdminDashboardStateContent(
                  status: controller.state.status,
                  title: 'Funnel dashboard',
                  message: controller.state.message,
                  gap: AppSpacing.x4,
                  children: [
                    _FunnelSelector(
                      funnels: snapshot.funnels,
                      selectedFunnelId: selectedFunnelId,
                      onChanged: (id) => setState(() => _selectedFunnelId = id),
                    ),
                    _MetricsGrid(snapshot: snapshot),
                    _WaterfallCard(funnel: selectedFunnel),
                    _DropoutChartCard(funnel: selectedFunnel),
                    _StepDetailsCard(funnel: selectedFunnel),
                    if (snapshot.totalSessions == 0)
                      const AdminInlineEmptyState(
                        icon: Icons.filter_alt_outlined,
                        title: 'Chưa có dữ liệu funnel',
                        message:
                            'Dữ liệu sẽ xuất hiện khi có người dùng đi qua funnel',
                      ),
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
