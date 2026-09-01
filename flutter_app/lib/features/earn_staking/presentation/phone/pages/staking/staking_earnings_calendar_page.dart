import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
part '../../../widgets/staking/staking_earnings_summary_tabs.dart';
part '../../../widgets/staking/staking_earnings_calendar_grid.dart';
part '../../../widgets/staking/staking_earnings_events_common.dart';

class StakingEarningsCalendarPage extends ConsumerStatefulWidget {
  const StakingEarningsCalendarPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc361_summary_card');
  static const notificationKey = Key('sc361_notification_toggle');
  static const exportKey = Key('sc361_export_button');
  static const tabsKey = Key('sc361_tabs');
  static const calendarCardKey = Key('sc361_calendar_card');
  static const nextMonthKey = Key('sc361_next_month');
  static const previousMonthKey = Key('sc361_previous_month');
  static const legendKey = Key('sc361_legend_card');
  static const infoKey = Key('sc361_info_banner');
  static const listKey = Key('sc361_upcoming_list');

  static Key dayKey(int day) => Key('sc361_day_$day');
  static Key eventKey(String id) => Key('sc361_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingEarningsCalendarPage> createState() =>
      _StakingEarningsCalendarPageState();
}

class _StakingEarningsCalendarPageState
    extends ConsumerState<StakingEarningsCalendarPage> {
  String _tab = 'calendar';
  bool _notificationsEnabled = true;
  // Bẫy 14 (GD4 playbook): repo giờ đã async — seed 1 lần trong nhánh
  // data: bên dưới thay vì initState.
  DateTime? _visibleMonth;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingEarningsCalendarSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch nhận lãi staking — xem sự kiện sắp tới và xuất lịch',
      semanticIdentifier: 'SC-361',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingEarningsCalendarSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            _visibleMonth ??= DateTime(
              snapshot.currentYear,
              snapshot.currentMonth,
            );
            final today = DateTime.parse(snapshot.todayIso);
            final upcoming = _upcomingEvents(snapshot.events, today);
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _SummaryCard(
                            snapshot: snapshot,
                            upcomingCount: upcoming.length,
                            notificationsEnabled: _notificationsEnabled,
                            onToggleNotifications: _toggleNotifications,
                            onExport: _exportCalendar,
                          ),
                          _CalendarTabs(
                            key: StakingEarningsCalendarPage.tabsKey,
                            tabs: snapshot.tabs,
                            active: _tab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (_tab == 'calendar') ...[
                            _CalendarCard(
                              snapshot: snapshot,
                              visibleMonth: _visibleMonth!,
                              today: today,
                              onPrevious: _previousMonth,
                              onNext: _nextMonth,
                            ),
                            const _LegendCard(),
                          ] else
                            _UpcomingList(events: upcoming),
                          const EarnDisclaimerBanner(
                            text:
                                'APY là ước tính tham khảo và có thể thay đổi. '
                                'Giá tài sản và APY có thể biến động; DeFi có rủi ro smart contract.',
                          ),
                          VitInfoCallout(
                            key: StakingEarningsCalendarPage.infoKey,
                            title: snapshot.infoTitle,
                            message: snapshot.infoBullets.join('\n'),
                            icon: Icons.calendar_month_rounded,
                            accentColor: AppColors.primarySoft,
                            padding: EarnSpacingTokens.earnCardPaddingX4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleNotifications() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _notificationsEnabled = !_notificationsEnabled);
  }

  void _exportCalendar() {
    unawaited(HapticFeedback.selectionClick());
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sẽ sớm ra mắt',
        message: 'Xuất lịch nhận lãi (.ics) sẽ sớm ra mắt',
      ),
    );
  }

  void _previousMonth() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _visibleMonth = DateTime(_visibleMonth!.year, _visibleMonth!.month - 1);
    });
  }

  void _nextMonth() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _visibleMonth = DateTime(_visibleMonth!.year, _visibleMonth!.month + 1);
    });
  }
}
