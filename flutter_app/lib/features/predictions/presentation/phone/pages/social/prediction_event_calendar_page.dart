import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/phone/prediction_enum_tab_bar.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

part '../../../widgets/social/prediction_event_calendar_controls.dart';
part '../../../widgets/social/prediction_event_calendar_events.dart';
part '../../../widgets/social/prediction_event_calendar_notifications.dart';

const _predictionPrimary = AppColors.primary;

enum _CalendarTab { calendar, upcoming, notifications }

class PredictionEventCalendarPage extends ConsumerStatefulWidget {
  const PredictionEventCalendarPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc039_event_calendar_content');
  static const filterButtonKey = Key('sc039_filter_button');
  static const calendarTabKey = Key('sc039_tab_calendar');
  static const upcomingTabKey = Key('sc039_tab_upcoming');
  static const notificationsTabKey = Key('sc039_tab_notifications');

  static Key categoryKey(String category) => Key('sc039_category_$category');
  static Key eventKey(String id) => Key('sc039_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionEventCalendarPage> createState() =>
      _PredictionEventCalendarPageState();
}

class _PredictionEventCalendarPageState
    extends ConsumerState<PredictionEventCalendarPage> {
  _CalendarTab _activeTab = _CalendarTab.calendar;
  bool _showFilter = false;
  String? _category;

  @override
  Widget build(BuildContext context) {
    final calendarAsync = ref.watch(
      predictionsEventCalendarSnapshotProvider(_category),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Lịch sự kiện dự đoán: theo dõi ngày đóng và các yếu tố tác động',
      semanticIdentifier: 'SC-039',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: 'Lịch sự kiện',
            subtitle: 'Theo dõi ngày đóng và catalyst',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
            actions: [
              VitHeaderActionItem(
                key: PredictionEventCalendarPage.filterButtonKey,
                type: VitHeaderActionType.filter,
                active: _showFilter,
                onPressed: () => setState(() => _showFilter = !_showFilter),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EventCalendarTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionEventCalendarPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionCalendarScrollPadding(
                          scrollEndPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      children: calendarAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được lịch sự kiện',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsEventCalendarSnapshotProvider(
                                _category,
                              ),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          if (_showFilter)
                            _CategoryFilters(
                              snapshot: snapshot,
                              selectedCategory: _category,
                              onChanged: (category) =>
                                  setState(() => _category = category),
                            ),
                          ...switch (_activeTab) {
                            _CalendarTab.calendar => [
                              _StatsCard(snapshot: snapshot),
                              for (final month in snapshot.months)
                                _MonthSection(month: month),
                            ],
                            _CalendarTab.upcoming => [
                              _UpcomingSection(snapshot: snapshot),
                            ],
                            _CalendarTab.notifications => [
                              _NotificationSettings(),
                              _WatchingSection(snapshot: snapshot),
                              const _NotificationInfo(),
                            ],
                          },
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Prediction event-calendar review',
                            message:
                                'Category filters, upcoming catalysts, watched events, notification settings, empty results, and calendar state are reviewed before users act on prediction-market timing signals.',
                            contractId: 'SC-039',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
