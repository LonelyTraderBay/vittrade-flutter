part of '../../phone/pages/tools/launchpad_webhooks_page.dart';

class _CreateWebhookCard extends StatelessWidget {
  const _CreateWebhookCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadWebhooksPage.createKey,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.accent30,
      padding: _launchpadWebhooksCardPadding,
      onTap: onTap,
      child: Row(
        children: [
          const SizedBox(
            width: _launchpadWebhooksPrimaryIconBox,
            height: _launchpadWebhooksPrimaryIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.accent15,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                ),
              ),
              child: Icon(Icons.add_rounded, color: AppColors.accent),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tao webhook moi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Dang ky nhan event tu smart contract',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionsSection extends StatelessWidget {
  const _SubscriptionsSection({
    required this.subscriptions,
    required this.eventTypes,
    required this.expandedId,
    required this.copiedField,
    required this.onExpand,
    required this.onCopy,
    required this.onToggle,
    required this.onDelete,
  });

  final List<LaunchpadWebhookSubscriptionDraft> subscriptions;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String? expandedId;
  final String? copiedField;
  final ValueChanged<String> onExpand;
  final void Function(String value, String field) onCopy;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadWebhooksPage.subscriptionsKey,
      child: subscriptions.isEmpty
          ? const _EmptySubscriptions()
          : VitPageSection(
              label: 'Active Subscriptions',
              accentColor: AppColors.buy,
              density: VitDensity.compact,
              children: [
                for (final subscription in subscriptions)
                  _SubscriptionCard(
                    subscription: subscription,
                    eventTypes: eventTypes,
                    expanded: expandedId == subscription.id,
                    copiedField: copiedField,
                    onExpand: () => onExpand(subscription.id),
                    onCopy: onCopy,
                    onToggle: () => onToggle(subscription.id),
                    onDelete: () => onDelete(subscription.id),
                  ),
              ],
            ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.eventTypes,
    required this.expanded,
    required this.copiedField,
    required this.onExpand,
    required this.onCopy,
    required this.onToggle,
    required this.onDelete,
  });

  final LaunchpadWebhookSubscriptionDraft subscription;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final bool expanded;
  final String? copiedField;
  final VoidCallback onExpand;
  final void Function(String value, String field) onCopy;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(subscription.status);

    return VitCard(
      key: LaunchpadWebhooksPage.subscriptionKey(subscription.id),
      clip: true,
      borderColor: expanded
          ? statusColor.withValues(alpha: .42)
          : AppColors.cardBorder,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _launchpadWebhooksMarkerWidth,
              child: ColoredBox(color: statusColor),
            ),
            Expanded(
              child: Column(
                children: [
                  VitCard(
                    key: LaunchpadWebhooksPage.expandKey(subscription.id),
                    onTap: onExpand,
                    variant: VitCardVariant.ghost,
                    radius: VitCardRadius.standard,
                    padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ChainIcon(subscription: subscription),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(child: _SubscriptionSummary(subscription)),
                        Icon(
                          expanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: AppColors.text3,
                          size: _launchpadWebhooksIcon2xl,
                        ),
                      ],
                    ),
                  ),
                  if (expanded)
                    _SubscriptionExpanded(
                      subscription: subscription,
                      eventTypes: eventTypes,
                      copiedField: copiedField,
                      onCopy: onCopy,
                      onToggle: onToggle,
                      onDelete: onDelete,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionSummary extends StatelessWidget {
  const _SubscriptionSummary(this.subscription);

  final LaunchpadWebhookSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              subscription.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            VitStatusPill(
              label: _statusLabel(subscription.status),
              status: _statusPillStatus(subscription.status),
              icon: _statusIcon(subscription.status),
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            VitAccentPill(
              label: subscription.chain,
              accentColor: subscription.accent.resolve(),
              size: VitStatusPillSize.sm,
            ),
            Text(
              '${subscription.eventTypes.length} events',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _launchpadWebhooksLineHeightShort,
              ),
            ),
            Text(
              '${subscription.triggerCount} triggers',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _launchpadWebhooksLineHeightShort,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChainIcon extends StatelessWidget {
  const _ChainIcon({required this.subscription});

  final LaunchpadWebhookSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _launchpadWebhooksPrimaryIconBox,
      height: _launchpadWebhooksPrimaryIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: subscription.accent.resolve().withValues(alpha: .15),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
          ),
        ),
        child: Icon(
          Icons.hub_outlined,
          color: subscription.accent.resolve(),
          size: _launchpadWebhooksIcon2xl,
        ),
      ),
    );
  }
}
