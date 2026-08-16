part of '../../phone/pages/tools/launchpad_webhooks_page.dart';

class _DeliveriesSection extends StatelessWidget {
  const _DeliveriesSection({
    required this.deliveries,
    required this.eventTypes,
    required this.copiedField,
    required this.onCopy,
  });

  final List<LaunchpadWebhookDeliveryDraft> deliveries;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String? copiedField;
  final void Function(String value, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadWebhooksPage.deliveriesKey,
      child: VitPageSection(
        label: 'Delivery History',
        accentColor: AppColors.primary,
        density: VitDensity.compact,
        children: [
          for (final delivery in deliveries)
            _DeliveryCard(
              delivery: delivery,
              eventTypes: eventTypes,
              copiedField: copiedField,
              onCopy: onCopy,
            ),
        ],
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({
    required this.delivery,
    required this.eventTypes,
    required this.copiedField,
    required this.onCopy,
  });

  final LaunchpadWebhookDeliveryDraft delivery;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String? copiedField;
  final void Function(String value, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    final eventColor = _eventColor(delivery.eventType, eventTypes);

    return VitCard(
      key: LaunchpadWebhooksPage.deliveryKey(delivery.id),
      padding: _launchpadWebhooksCompactCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _launchpadWebhooksDeliveryIconBox,
            height: _launchpadWebhooksDeliveryIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: eventColor.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Icon(
                Icons.bolt_rounded,
                color: eventColor,
                size: _launchpadWebhooksIconLg,
              ),
            ),
          ),
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
                      delivery.eventType,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    VitStatusPill(
                      label: _deliveryStatusLabel(delivery.status),
                      status: _deliveryStatusPillStatus(delivery.status),
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      delivery.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    if (delivery.statusCode != null)
                      Text(
                        delivery.statusCode.toString(),
                        style: AppTextStyles.numericMicro.copyWith(
                          color: delivery.statusCode! < 300
                              ? AppColors.buy
                              : AppColors.sell,
                        ),
                      ),
                    if (delivery.responseTime != null)
                      Text(
                        '${delivery.responseTime}ms',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                  ],
                ),
                if (delivery.txHash != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'tx: ${delivery.txHash}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.monoCode.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      _CopyButton(
                        key: LaunchpadWebhooksPage.deliveryCopyKey(delivery.id),
                        active: copiedField == delivery.id,
                        size: _launchpadWebhooksIcon2xl,
                        onTap: () => onCopy(delivery.txHash!, delivery.id),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
