import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_notifications_page_sections.dart';
part '../../../widgets/staking/staking_notifications_page_common.dart';

class StakingNotificationsPage extends ConsumerStatefulWidget {
  const StakingNotificationsPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc371_info_banner');
  static const settingsKey = Key('sc371_settings');
  static const channelsKey = Key('sc371_channels');
  static const historyKey = Key('sc371_history');
  static const markAllReadKey = Key('sc371_mark_all_read');
  static const dndKey = Key('sc371_dnd');
  static const footerKey = Key('sc371_footer');

  static Key settingKey(String id) => Key('sc371_setting_$id');

  static Key channelKey(String id) => Key('sc371_channel_$id');

  static Key notificationKey(String id) => Key('sc371_notification_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingNotificationsPage> createState() =>
      _StakingNotificationsPageState();
}

class _StakingNotificationsPageState
    extends ConsumerState<StakingNotificationsPage> {
  List<StakingNotificationSettingDraft>? _settings;
  List<StakingNotificationChannelDraft>? _channels;
  List<StakingNotificationHistoryDraft>? _history;
  bool _dndEnabled = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingNotificationsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cảnh báo APY và sự kiện stake',
      semanticIdentifier: 'SC-371',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingNotificationsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            _settings ??= snapshot.settings;
            _channels ??= snapshot.channels;
            _history ??= snapshot.history;

            final history = _history!;
            final unreadCount = history
                .where((notification) => !notification.read)
                .length;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Cảnh báo APY và sự kiện stake',
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
                          VitInfoCallout(
                            key: StakingNotificationsPage.infoKey,
                            title: snapshot.infoTitle,
                            message: snapshot.infoBody,
                            icon: Icons.notifications_none_rounded,
                            accentColor: AppModuleAccents.earn,
                            padding: EarnSpacingTokens.earnCardPaddingX4,
                          ),
                          _SettingsList(
                            settings: _settings!,
                            onToggle: _toggleSetting,
                          ),
                          _ChannelsList(
                            channels: _channels!,
                            onToggle: _toggleChannel,
                          ),
                          _HistoryList(
                            history: history,
                            unreadCount: unreadCount,
                            onMarkAllRead: _markAllRead,
                            onMarkRead: _markRead,
                          ),
                          _DoNotDisturbCard(
                            enabled: _dndEnabled,
                            onToggle: () {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _dndEnabled = !_dndEnabled);
                            },
                          ),
                          _FooterNote(text: snapshot.footerNote),
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

  void _toggleSetting(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _settings = [
        for (final setting in _settings!)
          setting.id == id
              ? setting.copyWith(enabled: !setting.enabled)
              : setting,
      ];
    });
  }

  void _toggleChannel(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _channels = [
        for (final channel in _channels!)
          channel.id == id
              ? channel.copyWith(enabled: !channel.enabled)
              : channel,
      ];
    });
  }

  void _markRead(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _history = [
        for (final notification in _history!)
          notification.id == id
              ? notification.copyWith(read: true)
              : notification,
      ];
    });
  }

  void _markAllRead() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _history = [
        for (final notification in _history!) notification.copyWith(read: true),
      ];
    });
  }
}
