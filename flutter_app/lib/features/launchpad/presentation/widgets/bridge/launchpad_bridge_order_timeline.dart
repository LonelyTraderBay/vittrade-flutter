part of '../../phone/pages/bridge/launchpad_bridge_order_page.dart';

class _BridgeTimeline extends StatelessWidget {
  const _BridgeTimeline({required this.order});

  final LaunchpadBridgeOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeOrderPage.timelineKey,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_tree_outlined,
                color: _statusColor(order.status),
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tien trinh',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const _LiveBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Stack(
            children: [
              const Positioned(
                left: 15,
                top: AppSpacing.x3,
                bottom: AppSpacing.x3,
                child: SizedBox(
                  width: LaunchpadSpacingTokens.launchpadDividerWidth,
                  child: ColoredBox(color: AppColors.borderSolid),
                ),
              ),
              Column(
                children: [
                  for (final step in order.steps)
                    _BridgeTimelineStep(step: step, orderStatus: order.status),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BridgeTimelineStep extends StatelessWidget {
  const _BridgeTimelineStep({required this.step, required this.orderStatus});

  final LaunchpadBridgeStepDraft step;
  final LaunchpadBridgeOrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    final isDone = _statusIndex(step.status) < _statusIndex(orderStatus);
    final isActive = step.status == orderStatus;
    final isFuture = _statusIndex(step.status) > _statusIndex(orderStatus);
    final color = isDone
        ? AppColors.buy
        : isActive
        ? _statusColor(step.status)
        : AppColors.borderSolid;
    final opacity = isFuture ? .45 : 1.0;

    return Padding(
      key: LaunchpadBridgeOrderPage.stepKey(step.id),
      padding: LaunchpadSpacingTokens.launchpadBottomPaddingX2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: LaunchpadSpacingTokens.launchpadBox31,
            child: Padding(
              padding: LaunchpadSpacingTokens.launchpadTopPaddingX3,
              child: Icon(
                isDone
                    ? Icons.check_circle_outline_rounded
                    : isActive
                    ? Icons.circle
                    : Icons.circle_outlined,
                color: color.withValues(alpha: opacity),
                size: isActive ? 12 : AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Opacity(
              opacity: opacity,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: isActive
                      ? _statusColor(step.status).withValues(alpha: .08)
                      : AppColors.surface2,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isActive
                          ? _statusColor(step.status).withValues(alpha: .25)
                          : AppColors.transparent,
                    ),
                    borderRadius: AppRadii.smRadius,
                  ),
                ),
                child: Padding(
                  padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              step.label,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          if (step.timestamp != null)
                            Text(
                              step.timestamp!,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        step.detail,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.primary.withValues(alpha: .14),
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadLiveBadgePadding,
        child: Row(
          children: [
            const SizedBox(
              width: LaunchpadSpacingTokens.launchpadDotSm,
              height: LaunchpadSpacingTokens.launchpadDotSm,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: AppColors.primary,
                  shape: CircleBorder(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              'LIVE',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
