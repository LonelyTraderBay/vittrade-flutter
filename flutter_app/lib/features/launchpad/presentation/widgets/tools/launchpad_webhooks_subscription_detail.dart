part of '../../phone/pages/tools/launchpad_webhooks_page.dart';

class _SubscriptionExpanded extends StatelessWidget {
  const _SubscriptionExpanded({
    required this.subscription,
    required this.eventTypes,
    required this.copiedField,
    required this.onCopy,
    required this.onToggle,
    required this.onDelete,
  });

  final LaunchpadWebhookSubscriptionDraft subscription;
  final List<LaunchpadWebhookEventDraft> eventTypes;
  final String? copiedField;
  final void Function(String value, String field) onCopy;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: _launchpadWebhooksDividerHeight,
            color: AppColors.divider,
          ),
          Padding(
            padding: _launchpadWebhooksCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final type in subscription.eventTypes)
                      VitAccentPill(
                        label: type,
                        accentColor: _eventColor(type, eventTypes),
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _MetadataRows(
                  rows: [
                    _MetadataRowDraft(
                      label: 'URL',
                      value: subscription.webhookUrl,
                      copyValue: subscription.webhookUrl,
                    ),
                    _MetadataRowDraft(
                      label: 'Contract',
                      value: subscription.maskedContract,
                      copyValue: subscription.contractAddress,
                    ),
                    _MetadataRowDraft(
                      label: 'Retry',
                      value:
                          '${_retryLabel(subscription.retryPolicy)} (max ${subscription.maxRetries})',
                    ),
                    _MetadataRowDraft(
                      label: 'Created',
                      value: subscription.createdAt,
                    ),
                    if (subscription.lastTriggered != null)
                      _MetadataRowDraft(
                        label: 'Last triggered',
                        value: subscription.lastTriggered!,
                      ),
                    if (subscription.lastError != null)
                      _MetadataRowDraft(
                        label: 'Last error',
                        value: subscription.lastError!,
                        danger: true,
                      ),
                  ],
                  copiedField: copiedField,
                  subscriptionId: subscription.id,
                  onCopy: onCopy,
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: VitCtaButton(
                        key: LaunchpadWebhooksPage.toggleKey(subscription.id),
                        onPressed: onToggle,
                        variant:
                            subscription.status == LaunchpadWebhookStatus.active
                            ? VitCtaButtonVariant.warning
                            : VitCtaButtonVariant.success,
                        height: _launchpadWebhooksActionButtonHeight,
                        padding:
                            LaunchpadSpacingTokens.launchpadActionButtonPadding,
                        leading: Icon(
                          subscription.status == LaunchpadWebhookStatus.active
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        child: Text(
                          subscription.status == LaunchpadWebhookStatus.active
                              ? 'Pause'
                              : 'Resume',
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitCtaButton(
                      key: LaunchpadWebhooksPage.deleteKey(subscription.id),
                      onPressed: onDelete,
                      variant: VitCtaButtonVariant.danger,
                      fullWidth: false,
                      height: _launchpadWebhooksActionButtonHeight,
                      padding:
                          LaunchpadSpacingTokens.launchpadActionButtonPadding,
                      leading: const Icon(Icons.delete_outline_rounded),
                      child: const Text('Xoa'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetadataRows extends StatelessWidget {
  const _MetadataRows({
    required this.rows,
    required this.copiedField,
    required this.subscriptionId,
    required this.onCopy,
  });

  final List<_MetadataRowDraft> rows;
  final String? copiedField;
  final String subscriptionId;
  final void Function(String value, String field) onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in rows)
          Column(
            children: [
              Padding(
                padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
                child: Row(
                  children: [
                    Text(
                      row.label,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        row.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style:
                            (row.copyValue == null
                                    ? AppTextStyles.micro
                                    : AppTextStyles.monoCode)
                                .copyWith(
                                  color: row.danger
                                      ? AppColors.sell
                                      : AppColors.text1,
                                  fontWeight: AppTextStyles.medium,
                                ),
                      ),
                    ),
                    if (row.copyValue != null) ...[
                      const SizedBox(width: AppSpacing.x2),
                      _CopyButton(
                        key: LaunchpadWebhooksPage.copyKey(
                          subscriptionId,
                          row.label,
                        ),
                        active: copiedField == '${subscriptionId}_${row.label}',
                        onTap: () => onCopy(
                          row.copyValue!,
                          '${subscriptionId}_${row.label}',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(
                height: _launchpadWebhooksDividerHeight,
                color: AppColors.divider,
              ),
            ],
          ),
      ],
    );
  }
}

final class _MetadataRowDraft {
  const _MetadataRowDraft({
    required this.label,
    required this.value,
    this.copyValue,
    this.danger = false,
  });

  final String label;
  final String value;
  final String? copyValue;
  final bool danger;
}
