part of '../../phone/pages/tools/launchpad_webhooks_page.dart';

class _CreateWebhookSheet extends StatefulWidget {
  const _CreateWebhookSheet({
    required this.eventTypes,
    required this.onClose,
    required this.onCreate,
  });

  final List<LaunchpadWebhookEventDraft> eventTypes;
  final VoidCallback onClose;
  final ValueChanged<LaunchpadWebhookSubscriptionDraft> onCreate;

  @override
  State<_CreateWebhookSheet> createState() => _CreateWebhookSheetState();
}

class _CreateWebhookSheetState extends State<_CreateWebhookSheet> {
  final _labelController = TextEditingController();
  final _urlController = TextEditingController();
  final _contractController = TextEditingController();
  final Set<String> _selectedEvents = {};
  var _chain = 'BSC';
  var _retryPolicy = LaunchpadWebhookRetryPolicy.exponential;

  @override
  void dispose() {
    _labelController.dispose();
    _urlController.dispose();
    _contractController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _labelController.text.trim().isNotEmpty &&
      _urlController.text.trim().isNotEmpty &&
      _contractController.text.trim().isNotEmpty &&
      _selectedEvents.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: LaunchpadWebhooksPage.createSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _launchpadWebhooksSheetMaxWidth,
            ),
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.sheetTopLargeRadius,
                ),
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: _launchpadWebhooksSheetPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: SizedBox(
                          width: _launchpadWebhooksSheetHandleWidth,
                          height: _launchpadWebhooksSheetHandleHeight,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: AppColors.borderSolid,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadii.xsRadius,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Tao Webhook moi',
                              style: AppTextStyles.base.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          VitIconButton(
                            key: LaunchpadWebhooksPage.createCloseKey,
                            onPressed: widget.onClose,
                            icon: Icons.close_rounded,
                            tooltip: 'Dong tao webhook',
                            variant: VitIconButtonVariant.transparent,
                            size: VitIconButtonSize.md,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _SheetInputField(
                        label: 'Ten webhook',
                        hint: 'VD: Staking Monitor',
                        controller: _labelController,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _SheetInputField(
                        label: 'Webhook URL',
                        hint: 'https://api.example.com/webhooks',
                        controller: _urlController,
                        monospace: true,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _SheetInputField(
                        label: 'Contract Address',
                        hint: '0x...',
                        controller: _contractController,
                        monospace: true,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _ChoiceGroup(
                        label: 'Chain',
                        items: const ['BSC', 'Ethereum', 'Polygon', 'Arbitrum'],
                        active: _chain,
                        colorFor: _chainColor,
                        onChanged: (value) => setState(() => _chain = value),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      Text(
                        'Events (${_selectedEvents.length})',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      Wrap(
                        spacing: AppSpacing.x2,
                        runSpacing: AppSpacing.x2,
                        children: [
                          for (final event in widget.eventTypes)
                            VitChoicePill(
                              key: LaunchpadWebhooksPage.eventKey(event.type),
                              label: event.label,
                              accentColor: event.accent.resolve(),
                              selected: _selectedEvents.contains(event.type),
                              onTap: () => setState(() {
                                if (!_selectedEvents.add(event.type)) {
                                  _selectedEvents.remove(event.type);
                                }
                              }),
                              padding:
                                  LaunchpadSpacingTokens.launchpadPillPadding,
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      _ChoiceGroup(
                        label: 'Retry Policy',
                        items: const ['none', 'linear', 'exponential'],
                        active: _retryLabel(_retryPolicy),
                        colorFor: (_) => AppColors.primary,
                        onChanged: (value) => setState(() {
                          _retryPolicy = switch (value) {
                            'none' => LaunchpadWebhookRetryPolicy.none,
                            'linear' => LaunchpadWebhookRetryPolicy.linear,
                            _ => LaunchpadWebhookRetryPolicy.exponential,
                          };
                        }),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardSectionGap,
                      ),
                      VitCtaButton(
                        key: LaunchpadWebhooksPage.createSubmitKey,
                        onPressed: _canSubmit ? _submit : null,
                        child: const Text('Tao Webhook'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final now = DateTime.now().millisecondsSinceEpoch;
    widget.onCreate(
      LaunchpadWebhookSubscriptionDraft(
        id: 'wh_new_$now',
        label: _labelController.text.trim(),
        contractAddress: _contractController.text.trim(),
        chain: _chain,
        accent: _chainAccent(_chain),
        eventTypes: _selectedEvents.toList(),
        webhookUrl: _urlController.text.trim(),
        status: LaunchpadWebhookStatus.pending,
        createdAt: 'Hom nay',
        triggerCount: 0,
        errorCount: 0,
        filters: const [],
        retryPolicy: _retryPolicy,
        maxRetries: _retryPolicy == LaunchpadWebhookRetryPolicy.none ? 0 : 3,
      ),
    );
  }
}
