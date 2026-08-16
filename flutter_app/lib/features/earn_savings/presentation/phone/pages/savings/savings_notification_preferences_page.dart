import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_delivery.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_events.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_summary.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsNotificationPreferencesPage extends ConsumerStatefulWidget {
  const SavingsNotificationPreferencesPage({super.key, this.shellRenderMode});

  static const summaryKey = SavingsNotificationPreferencesKeys.summary;
  static const statsKey = SavingsNotificationPreferencesKeys.stats;
  static const eventsListKey = SavingsNotificationPreferencesKeys.eventsList;
  static const productsListKey =
      SavingsNotificationPreferencesKeys.productsList;
  static const deliveryListKey =
      SavingsNotificationPreferencesKeys.deliveryList;
  static const masterToggleKey =
      SavingsNotificationPreferencesKeys.masterToggle;

  static Key alertKey(String id) =>
      SavingsNotificationPreferencesKeys.alert(id);
  static Key productKey(String id) =>
      SavingsNotificationPreferencesKeys.product(id);
  static Key channelKey(String id) =>
      SavingsNotificationPreferencesKeys.channel(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsNotificationPreferencesPage> createState() =>
      _SavingsNotificationPreferencesPageState();
}

class _SavingsNotificationPreferencesPageState
    extends ConsumerState<SavingsNotificationPreferencesPage> {
  String? _tab;

  // STATE-S23: masterEnabled/alerts/channels sống ở
  // SavingsNotificationPreferencesStateController (một nguồn sự thật) — hết
  // `late List` seed từ ref.read + setState.

  @override
  Widget build(BuildContext context) {
    // Bẫy (GD4 playbook mục 6, biến thể A): Notifier chỉ đọc `.value` an
    // toàn (không null) SAU KHI snapshot provider đã resolve — trang PHẢI
    // gate qua `.when()` trên chính snapshot provider trước khi đọc
    // Notifier, nếu không sẽ dính state rỗng khi provider còn loading.
    final snapshotAsync = ref.watch(
      savingsNotificationPreferencesSnapshotProvider,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cài đặt thông báo',
      semanticIdentifier: 'SC-345',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                savingsNotificationPreferencesSnapshotProvider,
              ),
            ),
          ),
          data: (_) {
            final viewState = ref.watch(
              savingsNotificationPreferencesStateControllerProvider,
            );
            final snapshot = viewState.snapshot;
            final activeTab = _tab ?? snapshot.defaultTab;
            final masterEnabled = viewState.masterEnabled;
            final enabledAlerts = viewState.alerts
                .where((item) => item.enabled)
                .length;
            final enabledChannels = viewState.channels
                .where((item) => item.enabled)
                .length;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: kSavingsToolsHeaderSubtitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColoredBox(
                    color: AppColors.surface,
                    child: SavingsNotificationTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        unawaited(HapticFeedback.selectionClick());
                        setState(() => _tab = tab);
                      },
                    ),
                  ),
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    thickness: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
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
                          VitCard(
                            variant: VitCardVariant.standard,
                            radius: VitCardRadius.standard,
                            padding: AppSpacing.zeroInsets,
                            child: SavingsNotificationMasterSummaryCard(
                              masterEnabled: masterEnabled,
                              enabledAlerts: enabledAlerts,
                              totalAlerts: viewState.alerts.length,
                              onChanged: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                ref
                                    .read(
                                      savingsNotificationPreferencesStateControllerProvider
                                          .notifier,
                                    )
                                    .setMasterEnabled(value);
                              },
                            ),
                          ),
                          SavingsNotificationQuickStats(
                            enabledChannels: enabledChannels,
                            totalChannels: viewState.channels.length,
                            digestFrequency: snapshot.digestFrequency,
                            quietHours: snapshot.quietHours,
                          ),
                          if (activeTab == 'events')
                            SavingsNotificationEventsTab(
                              alerts: viewState.alerts,
                              masterEnabled: masterEnabled,
                              onToggle: _toggleAlert,
                            )
                          else if (activeTab == 'products')
                            SavingsNotificationProductsTab(
                              products: snapshot.productAlerts,
                            )
                          else
                            SavingsNotificationDeliveryTab(
                              channels: viewState.channels,
                              digestFrequency: snapshot.digestFrequency,
                              quietHours: snapshot.quietHours,
                              onToggle: _toggleChannel,
                            ),
                          const SavingsToolsYieldFooter(),
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

  void _toggleAlert(String id) {
    unawaited(HapticFeedback.selectionClick());
    ref
        .read(savingsNotificationPreferencesStateControllerProvider.notifier)
        .toggleAlert(id);
  }

  void _toggleChannel(String id) {
    unawaited(HapticFeedback.selectionClick());
    ref
        .read(savingsNotificationPreferencesStateControllerProvider.notifier)
        .toggleChannel(id);
  }
}
