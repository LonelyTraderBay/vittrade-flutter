import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pNotificationsVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pNotificationsNativeNavClearance =
    _p2pNotificationsVisualNavClearance - AppSpacing.x4;
const double _p2pNotificationsVisualClearance = AppSpacing.x3;
const double _p2pNotificationsNativeClearance = AppSpacing.x2;
const double _p2pNotificationsDividerExtent = AppSpacing.dividerHairline;

class P2PNotificationsSettingsPage extends ConsumerStatefulWidget {
  const P2PNotificationsSettingsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc278_p2p_notifications_hero');
  static const summaryKey = Key('sc278_p2p_notifications_summary');
  static const settingsKey = Key('sc278_p2p_notifications_settings');

  static Key channelKey(String settingId, String channelId) =>
      Key('sc278_p2p_notifications_${settingId}_$channelId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PNotificationsSettingsPage> createState() =>
      _P2PNotificationsSettingsPageState();
}

class _P2PNotificationsSettingsPageState
    extends ConsumerState<P2PNotificationsSettingsPage> {
  final Map<String, Set<String>> _enabledChannels = {};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pNotificationSettingsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pNotificationsVisualNavClearance +
                  _p2pNotificationsVisualClearance
            : _p2pNotificationsNativeNavClearance +
                  _p2pNotificationsNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cài đặt thông báo P2P',
      semanticIdentifier: 'SC-278',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pSettings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pSettings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pNotificationSettingsProvider),
            ),
          ),
          data: (snapshot) {
            _ensureState(snapshot);
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => context.go(snapshot.parentRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pNotificationsScrollPadding(
                          scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            _Hero(snapshot: snapshot),
                            _EnabledChannelsSummary(
                              key: P2PNotificationsSettingsPage.summaryKey,
                              snapshot: snapshot,
                              enabledChannels: _enabledChannels,
                            ),
                            _SettingsCard(
                              snapshot: snapshot,
                              enabledChannels: _enabledChannels,
                              onToggle: _toggleChannel,
                            ),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Rà soát thông báo P2P',
                              message:
                                  'Kênh Push, Email, SMS cho cập nhật đơn, thanh toán, release, bảo mật và KYC vẫn hiển thị trước khi lưu cài đặt.',
                              contractId: 'SC-278',
                            ),
                          ],
                        ),
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

  void _ensureState(P2PNotificationSettingsSnapshot snapshot) {
    if (_enabledChannels.isNotEmpty) return;
    for (final setting in snapshot.settings) {
      _enabledChannels[setting.id] = {
        for (final entry in setting.channels.entries)
          if (entry.value) entry.key,
      };
    }
  }

  void _toggleChannel(String settingId, String channelId) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      final enabled = _enabledChannels.putIfAbsent(settingId, () => {});
      if (enabled.contains(channelId)) {
        enabled.remove(channelId);
      } else {
        enabled.add(channelId);
      }
    });
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.snapshot});

  final P2PNotificationSettingsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      key: P2PNotificationsSettingsPage.heroKey,
      accentColor: AppModuleAccents.p2p,
      density: VitDensity.compact,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.notifications_none_rounded,
            color: AppModuleAccents.p2p,
            boxSize: AppSpacing.x7,
            iconSize: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.heroSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EnabledChannelsSummary extends StatelessWidget {
  const _EnabledChannelsSummary({
    super.key,
    required this.snapshot,
    required this.enabledChannels,
  });

  final P2PNotificationSettingsSnapshot snapshot;
  final Map<String, Set<String>> enabledChannels;

  @override
  Widget build(BuildContext context) {
    final enabledCount = snapshot.settings.fold<int>(
      0,
      (total, setting) => total + (enabledChannels[setting.id]?.length ?? 0),
    );
    final totalCount = snapshot.settings.length * _channels.length;

    return VitMetricCard(
      label: 'Kênh đang bật',
      value: '$enabledCount/$totalCount',
      accentColor: AppModuleAccents.p2p,
      density: VitDensity.compact,
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.snapshot,
    required this.enabledChannels,
    required this.onToggle,
  });

  final P2PNotificationSettingsSnapshot snapshot;
  final Map<String, Set<String>> enabledChannels;
  final void Function(String settingId, String channelId) onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PNotificationsSettingsPage.settingsKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var index = 0; index < snapshot.settings.length; index++) ...[
            _SettingRow(
              setting: snapshot.settings[index],
              enabled: enabledChannels[snapshot.settings[index].id] ?? {},
              onToggle: onToggle,
            ),
            if (index != snapshot.settings.length - 1)
              const Divider(
                color: AppColors.borderSolid,
                height: _p2pNotificationsDividerExtent,
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.setting,
    required this.enabled,
    required this.onToggle,
  });

  final P2PNotificationSettingDraft setting;
  final Set<String> enabled;
  final void Function(String settingId, String channelId) onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pNotificationsCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            setting.label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            setting.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              for (final channel in _channels) ...[
                Expanded(
                  child: _ChannelButton(
                    settingId: setting.id,
                    channel: channel,
                    selected: enabled.contains(channel.id),
                    onTap: () => onToggle(setting.id, channel.id),
                  ),
                ),
                if (channel != _channels.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ChannelButton extends StatelessWidget {
  const _ChannelButton({
    required this.settingId,
    required this.channel,
    required this.selected,
    required this.onTap,
  });

  final String settingId;
  final _ChannelConfig channel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: P2PNotificationsSettingsPage.channelKey(settingId, channel.id),
      label: channel.label,
      selected: selected,
      onTap: onTap,
      tone: selected ? VitChoicePillTone.success : VitChoicePillTone.primary,
      accentColor: selected ? AppColors.buy : AppModuleAccents.p2p,
      height: AppSpacing.buttonCompact + AppSpacing.x4,
      padding: P2PSpacingTokens.p2pNotificationsChannelPadding,
      leading: Icon(
        channel.icon,
        size: AppSpacing.iconSm,
        color: selected ? AppColors.buy : AppColors.text3,
      ),
      semanticLabel: 'Thông báo ${channel.label}',
    );
  }
}

class _ChannelConfig {
  const _ChannelConfig({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

const List<_ChannelConfig> _channels = [
  _ChannelConfig(id: 'push', label: 'Push', icon: Icons.notifications_none),
  _ChannelConfig(id: 'email', label: 'Email', icon: Icons.mail_outline),
  _ChannelConfig(id: 'sms', label: 'SMS', icon: Icons.chat_bubble_outline),
];
