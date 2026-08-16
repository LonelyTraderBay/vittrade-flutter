import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

part '../../widgets/activity_log_page_sections.dart';
part '../../widgets/activity_log_page_common.dart';

const _activityBackground = AppColors.bg;
const _activityPanel2 = AppColors.surface2;
const _activityBorder = AppColors.cardBorder;
const _activityDivider = AppColors.divider;
const _activityPrimary = AppColors.primary;
const _activityGreen = AppColors.buy;
const _activityRed = AppColors.sell;
const _activityAmber = AppColors.warn;
const _activityGray = AppColors.text2;
const _activityPurple = AppColors.accent;
const _activityMuted = AppColors.text3;

class ActivityLogPage extends ConsumerStatefulWidget {
  const ActivityLogPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc161_activity_content');
  static const warningKey = Key('sc161_activity_warning');
  static Key filterKey(String id) => Key('sc161_activity_filter_$id');
  static Key logKey(String id) => Key('sc161_activity_log_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends ConsumerState<ActivityLogPage> {
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileActivitySnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitAutoHidePageScaffold(
      semanticLabel: 'Nhật ký hoạt động tài khoản',
      semanticIdentifier: 'SC-161',
      background: _activityBackground,
      header: VitHeader(
        title: 'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng',
        subtitle: 'Ho\u1EA1t \u0111\u1ED9ng \u00B7 Profile',
        showBack: true,
        onBack: _close,
      ),
      body: SingleChildScrollView(
        key: ActivityLogPage.contentKey,
        physics: const ClampingScrollPhysics(),
        padding: ProfileSpacingTokens.profileActivityScrollPadding(
          scrollClearance,
        ),
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.compact,
          density: VitDensity.compact,
          children: snapshotAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title: 'Không tải được dữ liệu',
                message: 'Vui lòng thử lại.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(profileActivitySnapshotProvider),
              ),
            ],
            data: (snapshot) {
              final logs = _filteredLogs(snapshot.logs);
              final suspiciousCount = snapshot.logs
                  .where((log) => log.status == 'suspicious')
                  .length;
              return [
                if (suspiciousCount > 0)
                  _SuspiciousBanner(count: suspiciousCount),
                _ActivityFilterRow(
                  filters: snapshot.filters,
                  activeFilter: _activeFilter,
                  onChanged: _setFilter,
                ),
                if (logs.isEmpty)
                  const _EmptyActivity()
                else
                  for (final log in logs) _ActivityCard(log: log),
                const _ActivityFooter(),
              ];
            },
          ),
        ),
      ),
    );
  }

  List<ProfileActivityLog> _filteredLogs(List<ProfileActivityLog> logs) {
    return switch (_activeFilter) {
      'login' =>
        logs
            .where((log) => log.type == 'login' || log.type == 'logout')
            .toList(),
      'security' =>
        logs
            .where((log) => log.type != 'login' && log.type != 'logout')
            .toList(),
      _ => logs,
    };
  }

  void _setFilter(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _activeFilter = id);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}
