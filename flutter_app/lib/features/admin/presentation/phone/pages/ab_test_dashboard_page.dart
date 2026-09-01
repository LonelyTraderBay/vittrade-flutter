import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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

part '../../widgets/ab_test_dashboard_sections.dart';
part '../../widgets/ab_test_dashboard_common.dart';

class ABTestDashboardPage extends ConsumerStatefulWidget {
  const ABTestDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc182_abtests_content');

  static Key testKey(String id) => Key('sc182_abtest_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ABTestDashboardPage> createState() =>
      _ABTestDashboardPageState();
}

class _ABTestDashboardPageState extends ConsumerState<ABTestDashboardPage> {
  String? _selectedTestId;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(adminAbTestsControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x6 +
        MediaQuery.paddingOf(context).bottom;

    return AdminDashboardPageShell(
      semanticLabel: 'Bảng điều khiển thử nghiệm A/B',
      semanticIdentifier: 'SC-182',
      scrollKey: ABTestDashboardPage.contentKey,
      scrollBottom: scrollBottom,
      header: VitHeader(
        title: 'A/B Test Dashboard',
        subtitle: 'Test Results & Analysis',
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
                title: 'A/B test dashboard',
                message: 'Không tải được dữ liệu.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(adminAbTestsSnapshotProvider),
              ),
            ],
            data: (controller) {
              final snapshot = controller.state.snapshot;
              return [
                AdminDashboardStateContent(
                  status: controller.state.status,
                  title: 'A/B test dashboard',
                  message: controller.state.message,
                  gap: AppSpacing.x4,
                  children: [
                    _SummaryGrid(snapshot: snapshot),
                    const VitSectionHeader(
                      title: 'Tất cả A/B Tests',
                      bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    if (snapshot.tests.isEmpty)
                      const AdminInlineEmptyState(
                        icon: Icons.science_outlined,
                        title: 'Chưa có A/B test nào',
                        message: 'Tạo test mới để bắt đầu thử nghiệm',
                      )
                    else
                      for (final test in snapshot.tests) ...[
                        _ABTestCard(
                          test: test,
                          selected: test.id == _selectedTestId,
                          onTap: () {
                            setState(() {
                              _selectedTestId = test.id == _selectedTestId
                                  ? null
                                  : test.id;
                            });
                          },
                        ),
                      ],
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
