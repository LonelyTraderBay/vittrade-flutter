part of '../../phone/pages/staking/staking_notifications_page.dart';

class _SettingsList extends StatelessWidget {
  const _SettingsList({required this.settings, required this.onToggle});

  final List<StakingNotificationSettingDraft> settings;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingNotificationsPage.settingsKey,
      label: 'Cài đặt Thông báo',
      accentColor: AppModuleAccents.earn,
      children: [
        Column(
          children: [
            for (final setting in settings) ...[
              _SettingCard(
                key: StakingNotificationsPage.settingKey(setting.id),
                setting: setting,
                onToggle: () => onToggle(setting.id),
              ),
              if (setting != settings.last)
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            ],
          ],
        ),
      ],
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    super.key,
    required this.setting,
    required this.onToggle,
  });

  final StakingNotificationSettingDraft setting;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(setting.priority);
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      onTap: onToggle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _settingsIcon(setting.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      setting.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (setting.priority == StakingNotificationPriority.high)
                      const VitStatusPill(
                        label: 'Quan trọng',
                        status: VitStatusPillStatus.error,
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  setting.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: EarnSpacingTokens.stakingNotificationsLineHeight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _ToggleSwitch(on: setting.enabled, onTap: onToggle),
        ],
      ),
    );
  }
}

class _ChannelsList extends StatelessWidget {
  const _ChannelsList({required this.channels, required this.onToggle});

  final List<StakingNotificationChannelDraft> channels;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingNotificationsPage.channelsKey,
      label: 'Kênh nhận Thông báo',
      accentColor: AppModuleAccents.earn,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            children: [
              for (final channel in channels) ...[
                _ChannelRow(
                  key: StakingNotificationsPage.channelKey(channel.id),
                  channel: channel,
                  onToggle: () => onToggle(channel.id),
                ),
                if (channel != channels.last)
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({super.key, required this.channel, required this.onToggle});

  final StakingNotificationChannelDraft channel;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            channel.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        _ToggleSwitch(on: channel.enabled, onTap: onToggle),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.history,
    required this.unreadCount,
    required this.onMarkAllRead,
    required this.onMarkRead,
  });

  final List<StakingNotificationHistoryDraft> history;
  final int unreadCount;
  final VoidCallback onMarkAllRead;
  final ValueChanged<String> onMarkRead;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingNotificationsPage.historyKey,
      label: 'Lịch sử ($unreadCount chưa đọc)',
      accentColor: AppModuleAccents.earn,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${history.length} thông báo gần đây',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            if (unreadCount > 0)
              VitCtaButton(
                key: StakingNotificationsPage.markAllReadKey,
                onPressed: onMarkAllRead,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                child: Text(
                  'Đánh dấu tất cả đã đọc',
                  style: AppTextStyles.micro.copyWith(
                    color: AppModuleAccents.earn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Column(
          children: [
            for (final notification in history) ...[
              _NotificationCard(
                key: StakingNotificationsPage.notificationKey(notification.id),
                notification: notification,
                onTap: () => onMarkRead(notification.id),
              ),
              if (notification != history.last)
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            ],
          ],
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final StakingNotificationHistoryDraft notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _notificationColor(notification.type);
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: notification.read
          ? null
          : AppModuleAccents.earn.withValues(alpha: 0.28),
      padding: EarnSpacingTokens.earnCardPaddingX4,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _notificationIcon(notification.type), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: notification.read
                              ? AppTextStyles.medium
                              : AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (!notification.read) const _UnreadDot(),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  notification.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens.stakingNotificationsLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  notification.time,
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

class _DoNotDisturbCard extends StatelessWidget {
  const _DoNotDisturbCard({required this.enabled, required this.onToggle});

  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingNotificationsPage.dndKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chế độ Không làm phiền',
                  style: AppTextStyles.baseMedium,
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Tắt tất cả thông báo từ 22:00-07:00 (trừ High priority)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _ToggleSwitch(on: enabled, onTap: onToggle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
