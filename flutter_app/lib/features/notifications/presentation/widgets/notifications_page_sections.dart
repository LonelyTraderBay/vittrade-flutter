part of '../phone/pages/notifications_page.dart';

class _NotificationFilterBand extends StatelessWidget {
  const _NotificationFilterBand({
    required this.filter,
    required this.onChanged,
  });

  final _NotificationFilter filter;
  final ValueChanged<_NotificationFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: NotificationsSpacingTokens.notificationsToolbarPadding,
        child: VitSegmentedChoice<_NotificationFilter>(
          selected: filter,
          onChanged: onChanged,
          options: const [
            VitSegmentedChoiceOption(
              value: _NotificationFilter.all,
              label: 'Tất cả',
              accentColor: AppModuleAccents.notifications,
            ),
            VitSegmentedChoiceOption(
              key: NotificationsPage.filterKey,
              value: _NotificationFilter.unread,
              label: 'Chưa đọc',
              accentColor: AppModuleAccents.notifications,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnreadSummaryBar extends StatelessWidget {
  const _UnreadSummaryBar({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: NotificationsPage.toolbarKey,
      width: double.infinity,
      radius: VitCardRadius.standard,
      variant: VitCardVariant.ghost,
      borderColor: AppModuleAccents.notifications.withValues(alpha: .32),
      padding: NotificationsSpacingTokens.notificationsToolbarPadding,
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_rounded,
            color: AppModuleAccents.notifications,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              '$unreadCount chưa đọc',
              style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
            ),
          ),
          if (onMarkAllRead != null)
            VitCtaButton(
              key: NotificationsPage.markAllReadKey,
              onPressed: onMarkAllRead,
              variant: VitCtaButtonVariant.ghost,
              height: AppSpacing.buttonCompact,
              fullWidth: false,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x2,
              ),
              child: Text(
                'Đọc tất cả',
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.notifications,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            )
          else
            Text(
              'Đã xem hết',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
        ],
      ),
    );
  }
}

class _NotificationFeed extends StatelessWidget {
  const _NotificationFeed({
    required this.notifications,
    required this.onOpen,
    required this.onDelete,
  });

  final List<AppNotificationDraft> notifications;
  final ValueChanged<AppNotificationDraft> onOpen;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      density: VitDensity.compact,
      children: [
        const VitModuleSectionHeader(
          title: 'THÔNG BÁO GẦN ĐÂY',
          accentColor: AppModuleAccents.notifications,
          density: VitDensity.compact,
        ),
        for (var i = 0; i < notifications.length; i++)
          _NotificationRow(
            notification: notifications[i],
            highlighted: i < 3 && !notifications[i].isRead,
            showDivider: i < notifications.length - 1,
            onTap: () => onOpen(notifications[i]),
            onDelete: () => onDelete(notifications[i].id),
          ),
        _ListFooter(count: notifications.length),
      ],
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.notification,
    required this.highlighted,
    required this.showDivider,
    required this.onTap,
    required this.onDelete,
  });

  final AppNotificationDraft notification;
  final bool highlighted;
  final bool showDivider;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final style = _typeStyle(notification.type);
    return VitCard(
      key: NotificationsPage.notificationKey(notification.id),
      width: double.infinity,
      radius: VitCardRadius.standard,
      variant: highlighted ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: showDivider ? AppColors.divider : AppColors.transparent,
      padding: NotificationsSpacingTokens.notificationsRowPadding,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitAccentIconBox(
            icon: style.icon,
            color: style.color,
            iconSize: NotificationsSpacingTokens.notificationsTypeIcon,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      const Padding(
                        padding: NotificationsSpacingTokens
                            .notificationsUnreadDotMargin,
                        child: SizedBox.square(
                          dimension: NotificationsSpacingTokens
                              .notificationsUnreadDotSize,
                          child: Material(
                            color: AppModuleAccents.notifications,
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: NotificationsSpacingTokens
                        .notificationsMessageLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    VitAccentPill(label: style.label, accentColor: style.color),
                    const SizedBox(width: AppSpacing.x3),
                    Flexible(
                      child: Text(
                        notification.time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _DeleteButton(id: notification.id, onDelete: onDelete),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.id, required this.onDelete});

  final String id;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      key: NotificationsPage.deleteKey(id),
      icon: Icons.delete_outline_rounded,
      tooltip: 'Xóa thông báo',
      size: VitIconButtonSize.md,
      variant: VitIconButtonVariant.danger,
      onPressed: onDelete,
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: NotificationsSpacingTokens.notificationsFooterPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: NotificationsSpacingTokens.notificationsFooterDividerWidth,
            height: NotificationsSpacingTokens.notificationsFooterDividerHeight,
            child: ColoredBox(color: AppColors.borderSolid),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            '$count thông báo',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x3),
          const SizedBox(
            width: NotificationsSpacingTokens.notificationsFooterDividerWidth,
            height: NotificationsSpacingTokens.notificationsFooterDividerHeight,
            child: ColoredBox(color: AppColors.borderSolid),
          ),
        ],
      ),
    );
  }
}
