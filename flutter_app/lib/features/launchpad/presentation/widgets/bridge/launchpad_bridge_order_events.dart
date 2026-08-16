part of '../../phone/pages/bridge/launchpad_bridge_order_page.dart';

class _BridgeEventLog extends StatelessWidget {
  const _BridgeEventLog({
    required this.order,
    required this.events,
    required this.expanded,
    required this.onToggle,
  });

  final LaunchpadBridgeOrderDraft order;
  final List<LaunchpadBridgeEventDraft> events;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeOrderPage.eventLogKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: onToggle,
              child: Padding(
                padding: LaunchpadSpacingTokens.launchpadPaddingX4,
                child: Row(
                  children: [
                    const Icon(
                      Icons.terminal_rounded,
                      color: AppColors.accent,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      'Nhật ký sự kiện',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _ConnectionBadge(state: order.connectionState),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        '${events.length} sự kiện',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconMd,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(
              height: LaunchpadSpacingTokens.launchpadDividerHeight,
              color: AppColors.divider,
            ),
            SizedBox(
              width: double.infinity,
              child: ColoredBox(
                color: AppColors.bg,
                child: Padding(
                  padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                  child: Column(
                    children: [
                      for (final event in events) _EventRow(event: event),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              height: LaunchpadSpacingTokens.launchpadDividerHeight,
              color: AppColors.divider,
            ),
            Padding(
              padding: LaunchpadSpacingTokens.launchpadEventFooterPadding,
              child: Row(
                children: [
                  const SizedBox(
                    width: LaunchpadSpacingTokens.launchpadDotSm,
                    height: LaunchpadSpacingTokens.launchpadDotSm,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: AppColors.buy,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'wss://bridge-relay.vitrading.io',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Text(
                    '${events.length} msgs',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final LaunchpadBridgeEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.level);
    return Padding(
      key: LaunchpadBridgeOrderPage.eventKey(event.id),
      padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: LaunchpadSpacingTokens.launchpadBox68,
            child: Text(
              event.timestamp,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          SizedBox(
            width: LaunchpadSpacingTokens.launchpadBox36,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withValues(alpha: .14),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
              child: Padding(
                padding: LaunchpadSpacingTokens.launchpadEventLevelPadding,
                child: Center(
                  child: Text(
                    _eventLabel(event.level),
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            '[${event.source}]',
            style: AppTextStyles.micro.copyWith(color: AppColors.accent),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              event.message,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionBadge extends StatelessWidget {
  const _ConnectionBadge({required this.state});

  final LaunchpadBridgeConnectionState state;

  @override
  Widget build(BuildContext context) {
    final connected = state == LaunchpadBridgeConnectionState.connected;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: (connected ? AppColors.buy : AppColors.warn).withValues(
          alpha: .12,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadLiveBadgePadding,
        child: Row(
          children: [
            Icon(
              connected ? Icons.wifi_rounded : Icons.wifi_find_rounded,
              color: connected ? AppColors.buy : AppColors.warn,
              size: LaunchpadSpacingTokens.launchpadFontXs,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              connected ? 'Đã kết nối' : 'Đang kết nối',
              style: AppTextStyles.micro.copyWith(
                color: connected ? AppColors.buy : AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
