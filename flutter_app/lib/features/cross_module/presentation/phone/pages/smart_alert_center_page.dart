import 'dart:async';

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
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/cross_module_icon_widgets.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/cross_module_spacing_tokens.dart';

part '../../widgets/smart_alert_center_tabs.dart';
part '../../widgets/smart_alert_center_cards.dart';
part '../../widgets/smart_alert_center_history_settings.dart';
part '../../widgets/smart_alert_center_common.dart';

class SmartAlertCenterPage extends ConsumerStatefulWidget {
  const SmartAlertCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc323_smart_alert_center_content');
  static const createButtonKey = Key('sc323_create_alert_button');
  static Key tabKey(SmartAlertTab tab) => Key('sc323_tab_${tab.name}');
  static Key channelKey(String channelId) => Key('sc323_channel_$channelId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SmartAlertCenterPage> createState() =>
      _SmartAlertCenterPageState();
}

class _SmartAlertCenterPageState extends ConsumerState<SmartAlertCenterPage> {
  SmartAlertTab _activeTab = SmartAlertTab.active;
  final Map<String, bool> _channelOverrides = {};

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(smartAlertsControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return controllerAsync.when(
      loading: () => CrossModuleTabbedPageShell(
        semanticLabel: 'Trung tâm cảnh báo thông minh',
        semanticIdentifier: 'SC-323',
        contentKey: SmartAlertCenterPage.contentKey,
        title: 'Smart Alerts',
        onBack: () => context.go(AppRoutePaths.home),
        scrollEndClearance: bottomInset,
        tabs: const SizedBox.shrink(),
        body: const VitSkeletonList(),
      ),
      error: (error, stackTrace) => CrossModuleTabbedPageShell(
        semanticLabel: 'Trung tâm cảnh báo thông minh',
        semanticIdentifier: 'SC-323',
        contentKey: SmartAlertCenterPage.contentKey,
        title: 'Smart Alerts',
        onBack: () => context.go(AppRoutePaths.home),
        scrollEndClearance: bottomInset,
        tabs: const SizedBox.shrink(),
        body: VitErrorState(
          title: 'Smart Alerts',
          message: 'Không tải được dữ liệu.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(smartAlertsSnapshotProvider),
        ),
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        return CrossModuleTabbedPageShell(
          semanticLabel: 'Trung tâm cảnh báo thông minh',
          semanticIdentifier: 'SC-323',
          contentKey: SmartAlertCenterPage.contentKey,
          title: snapshot.title,
          onBack: () => context.go(snapshot.backRoute),
          scrollEndClearance: bottomInset,
          tabs: _SmartAlertTabs(
            tabs: snapshot.tabs,
            active: _activeTab,
            onChanged: (tab) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _activeTab = tab);
            },
          ),
          body: _activeTab == SmartAlertTab.active
              ? _ActiveAlertsTab(snapshot: snapshot)
              : _activeTab == SmartAlertTab.history
              ? _AlertHistoryTab(snapshot: snapshot)
              : _AlertSettingsTab(
                  snapshot: snapshot,
                  isChannelEnabled: (channel) =>
                      _channelOverrides[channel.id] ?? channel.enabled,
                  onToggleChannel: (channel) {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() {
                      final current =
                          _channelOverrides[channel.id] ?? channel.enabled;
                      _channelOverrides[channel.id] = !current;
                    });
                  },
                ),
        );
      },
    );
  }
}
