part of '../../phone/pages/hub/copy_notifications_page.dart';

class _UnreadSummary extends StatelessWidget {
  const _UnreadSummary({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed summary row, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      height: TradeSpacingTokens.tradeBotSheetActionHeight,
      padding: TradeSpacingTokens.tradeBotChipPadding,
      borderColor: _notificationPrimary,
      child: Row(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: _notificationPrimary,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.statusPillHorizontalPaddingMd),
          Expanded(
            child: Text(
              '$unreadCount thông báo chưa đọc',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: _notificationPrimary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Flexible(
            child: VitCtaButton(
              key: CopyNotificationsPage.markAllReadKey,
              onPressed: onMarkAllRead,
              variant: VitCtaButtonVariant.ghost,
              density: VitDensity.tool,
              height: AppSpacing.buttonCompact,
              fullWidth: false,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x2,
              ),
              child: Text(
                'Đánh dấu tất cả đã đọc',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: _notificationPrimary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final TradeCopyNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _notificationColor(notification);
    final read = notification.read;
    return VitCard(
      variant: read ? VitCardVariant.standard : VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: read ? AppColors.cardBorder : color,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: ColoredBox(
              color: color.withValues(alpha: .18),
              child: SizedBox.square(
                dimension: WalletSpacingTokens.walletAddressIconSize,
                child: Icon(
                  _notificationIcon(notification),
                  color: color,
                  size: SharedSpacingTokens.homeNextActionIconSize,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Opacity(
              opacity: read ? .7 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: read
                                ? AppTextStyles.bold
                                : AppTextStyles.extraBold,
                          ),
                        ),
                      ),
                      if (!read) ...[
                        const SizedBox(width: AppSpacing.x2),
                        const ClipOval(
                          child: ColoredBox(
                            color: _notificationPrimary,
                            child: SizedBox.square(dimension: AppSpacing.x2),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    notification.message,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.normal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Wrap(
                    spacing: AppSpacing.statusPillHorizontalPaddingMd,
                    runSpacing: AppSpacing.statusPillGapMd,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _MetaItem(
                        icon: Icons.access_time_rounded,
                        label: notification.timestamp,
                      ),
                      if (notification.providerName != null)
                        _MetaItem(
                          icon: Icons.group_outlined,
                          label: notification.providerName!,
                        ),
                      if (notification.pnl != null)
                        Text(
                          _formatPnl(notification.pnl!),
                          style: AppTextStyles.caption.copyWith(
                            color: notification.pnl! >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                            fontWeight: AppTextStyles.extraBold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                    ],
                  ),
                  if (notification.pair != null) ...[
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    _PairChip(notification: notification, color: color),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: AppSpacing.statusPillIconSizeMd,
        ),
        const SizedBox(width: AppSpacing.statusPillGapMd),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _PairChip extends StatelessWidget {
  const _PairChip({required this.notification, required this.color});

  final TradeCopyNotification notification;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final side = notification.side == TradeOrderSide.sell ? 'SELL' : 'BUY';
    return VitAccentPill(
      label: '$side ${notification.pair}',
      accentColor: color,
      size: VitStatusPillSize.md,
    );
  }
}
