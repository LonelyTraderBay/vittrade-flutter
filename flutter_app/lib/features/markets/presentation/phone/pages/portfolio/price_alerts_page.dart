import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
part '../../../widgets/portfolio/price_alerts_page_overview.dart';
part '../../../widgets/portfolio/price_alerts_page_details.dart';
part '../../../widgets/portfolio/price_alerts_page_common.dart';

const _marketPrimary = AppColors.primary;
const double _alertsVisualScrollClearance = 108;
const double _alertsNativeScrollClearance = 72;
const double _alertsCardGap = AppSpacing.x3;
const double _alertsFilterHeight = AppSpacing.buttonCompact;
const double _alertsStatGap = AppSpacing.x3;
const double _alertsStatHeight = AppSpacing.ctaHeight;
const double _alertsStatLabelGap = AppSpacing.x1;
const double _alertsAvatar = AppSpacing.buttonCompact;
const double _alertsHeaderGap = AppSpacing.x3;
const double _alertsTrendIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _alertsTrendGap = AppSpacing.x2;
const double _alertsToggleIcon = AppSpacing.buttonCompact;
const double _alertsActionGap = AppSpacing.x2;
const double _alertsProgressGap = AppSpacing.x2;
const double _alertsProgressHeight = AppSpacing.x2;
const double _alertsTargetGap = AppSpacing.x4;
const double _alertsTargetWidth = 58;
const double _alertsTriggeredGap = AppSpacing.x3;
const double _alertsTriggeredDividerGap = AppSpacing.x2;
const double _alertsTriggeredIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _alertsTriggeredIconGap = AppSpacing.x2;
const double _alertsAddIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _alertsLineHeightTight = 1.0;
const double _alertsLineHeightShort = 1.1;
const double _alertsLineHeightCaption = 1.2;
const EdgeInsetsDirectional _alertsNoticePadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x3,
    );
const EdgeInsetsDirectional _alertsFilterHeaderPadding =
    EdgeInsetsDirectional.fromSTEB(
      AppSpacing.contentPad,
      AppSpacing.x3,
      AppSpacing.contentPad,
      AppSpacing.x3,
    );
const EdgeInsetsDirectional _alertsCardPadding = EdgeInsetsDirectional.fromSTEB(
  AppSpacing.x4,
  AppSpacing.x3,
  AppSpacing.x4,
  AppSpacing.x3,
);

enum _AlertFilter { all, active, triggered }

class PriceAlertsPage extends ConsumerStatefulWidget {
  const PriceAlertsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc014_price_alerts_scroll_content');
  static const allFilterKey = Key('sc014_filter_all');
  static const activeFilterKey = Key('sc014_filter_active');
  static const triggeredFilterKey = Key('sc014_filter_triggered');
  static const addAlertKey = Key('sc014_add_alert');
  static const totalCountKey = Key('sc014_total_count');
  static const activeCountKey = Key('sc014_active_count');
  static const triggeredCountKey = Key('sc014_triggered_count');

  static Key cardKey(String id) => Key('sc014_alert_card_$id');

  static Key toggleKey(String id) => Key('sc014_toggle_$id');

  static Key deleteKey(String id) => Key('sc014_delete_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PriceAlertsPage> createState() => _PriceAlertsPageState();
}

class _PriceAlertsPageState extends ConsumerState<PriceAlertsPage> {
  _AlertFilter _filter = _AlertFilter.all;
  bool _showAddNotice = false;

  // STATE-S23: alerts sống ở MarketPriceAlertsStateController (một nguồn sự
  // thật) — hết `late List` seed từ ref.read + setState.

  List<MarketPriceAlert> _filteredAlerts(List<MarketPriceAlert> alerts) {
    return switch (_filter) {
      _AlertFilter.active => [
        for (final alert in alerts)
          if (alert.isActive) alert,
      ],
      _AlertFilter.triggered => [
        for (final alert in alerts)
          if (!alert.isActive && alert.triggeredAt != null) alert,
      ],
      _AlertFilter.all => alerts,
    };
  }

  void _toggleAlert(String id) {
    ref.read(marketPriceAlertsStateControllerProvider.notifier).toggleAlert(id);
  }

  void _deleteAlert(String id) {
    ref.read(marketPriceAlertsStateControllerProvider.notifier).deleteAlert(id);
  }

  void _showAddPlaceholder() {
    setState(() => _showAddNotice = true);
  }

  @override
  Widget build(BuildContext context) {
    // GD4-F3: trang gate qua marketPriceAlertsSnapshotProvider.when() (mục
    // 5+6) trước khi đọc marketPriceAlertsStateControllerProvider.
    final alertsAsync = ref.watch(marketPriceAlertsSnapshotProvider);
    final viewState = ref.watch(marketPriceAlertsStateControllerProvider);
    final snapshot = viewState.snapshot;
    final alerts = viewState.alerts;
    final filteredAlerts = _filteredAlerts(alerts);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _alertsVisualScrollClearance
            : _alertsNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;
    final activeCount = alerts.where((alert) => alert.isActive).length;
    final triggeredCount = alerts
        .where((alert) => !alert.isActive && alert.triggeredAt != null)
        .length;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cảnh báo giá',
      semanticIdentifier: 'SC-014',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Cảnh báo giá',
            subtitle: 'Cảnh báo · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: AppColors.surface,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: _alertsFilterHeaderPadding,
                      child: VitSegmentedTabBar(
                        activeKey: _filter.name,
                        onChanged: (key) => setState(
                          () => _filter = _AlertFilter.values.byName(key),
                        ),
                        tabs: const [
                          VitTabItem(
                            key: 'all',
                            label: 'T\u1EA5t c\u1EA3',
                            widgetKey: PriceAlertsPage.allFilterKey,
                          ),
                          VitTabItem(
                            key: 'active',
                            label: '\u0110ang ho\u1EA1t \u0111\u1ED9ng',
                            widgetKey: PriceAlertsPage.activeFilterKey,
                          ),
                          VitTabItem(
                            key: 'triggered',
                            label: '\u0110\u00E3 k\u00EDch ho\u1EA1t',
                            widgetKey: PriceAlertsPage.triggeredFilterKey,
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: AppSpacing.hairlineStroke,
                      thickness: AppSpacing.hairlineStroke,
                      color: AppColors.divider,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: VitInsetScrollView(
                    key: PriceAlertsPage.contentKey,
                    bottomInset: scrollEndClearance,
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: alertsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được cảnh báo giá',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketPriceAlertsSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (_) => [
                          _StatsSummary(
                            total: alerts.length,
                            active: activeCount,
                            triggered: triggeredCount,
                          ),
                          if (filteredAlerts.isEmpty)
                            const _EmptyAlertsCard()
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final alert in filteredAlerts) ...[
                                  _AlertCard(
                                    alert: alert,
                                    pair: _findPair(
                                      snapshot.marketPairs,
                                      alert.pairId,
                                    ),
                                    onToggle: () => _toggleAlert(alert.id),
                                    onDelete: () => _deleteAlert(alert.id),
                                  ),
                                  if (alert != filteredAlerts.last)
                                    const SizedBox(height: _alertsCardGap),
                                ],
                              ],
                            ),
                          _AddAlertButton(onTap: _showAddPlaceholder),
                          if (_showAddNotice) const _AddAlertNotice(),
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
