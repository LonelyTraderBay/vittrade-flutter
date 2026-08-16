part of '../phone/pages/smart_alert_center_page.dart';

class _AlertHistoryTab extends StatelessWidget {
  const _AlertHistoryTab({required this.snapshot});

  final SmartAlertsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Alert History',
          children: [
            for (final entry in snapshot.history)
              VitCard(
                padding: CrossModuleSpacingTokens.crossModuleCardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.alertName,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(
                                height: AppSpacing.pageRhythmCompactInnerGap,
                              ),
                              VitAccentPill(
                                label: entry.moduleName,
                                accentColor: AppColors.text2,
                                size: VitStatusPillSize.sm,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.buy,
                          size: AppSpacing.iconMd,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Text(
                      entry.action,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: AppSpacing.iconSm,
                          color: AppColors.text3,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          entry.triggeredAtLabel,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          padding: CrossModuleSpacingTokens.crossModuleCardPadding,
          radius: VitCardRadius.large,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alert Statistics (30 days)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: VitMetricColumn(
                      label: 'Total Triggered',
                      value: '${snapshot.totalTriggers}',
                      valueStyle: VitMetricValueStyle.sectionTitle,
                    ),
                  ),
                  Expanded(
                    child: VitMetricColumn(
                      label: 'Avg per Day',
                      value: (snapshot.totalTriggers / 30).toStringAsFixed(1),
                      valueStyle: VitMetricValueStyle.sectionTitle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertSettingsTab extends StatelessWidget {
  const _AlertSettingsTab({
    required this.snapshot,
    required this.isChannelEnabled,
    required this.onToggleChannel,
  });

  final SmartAlertsSnapshot snapshot;
  final bool Function(SmartAlertChannelDraft channel) isChannelEnabled;
  final ValueChanged<SmartAlertChannelDraft> onToggleChannel;

  @override
  Widget build(BuildContext context) {
    final categories = snapshot.templates
        .map((template) => template.category)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Notification Channels',
          children: [
            for (final channel in snapshot.channels)
              _ChannelCard(
                channel: channel,
                enabled: isChannelEnabled(channel),
                onTap: () => onToggleChannel(channel),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Alert Templates',
          children: [
            for (final category in categories)
              _TemplateCategory(
                category: category,
                templates: snapshot.templates
                    .where((template) => template.category == category)
                    .toList(),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const CrossModuleInfoPanel(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warn,
          border: AppColors.warn15,
          text:
              'SMS alerts may incur additional charges. Check with your mobile provider.',
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.channel,
    required this.enabled,
    required this.onTap,
  });

  final SmartAlertChannelDraft channel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  enabled ? 'Enabled' : 'Disabled',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _ToggleSwitch(
            key: SmartAlertCenterPage.channelKey(channel.id),
            enabled: enabled,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      width: AppSpacing.inputHeight,
      height: AppSpacing.x6,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: enabled ? AppColors.primary : AppColors.toggleTrackOff,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
        ),
        child: Padding(
          padding: CrossModuleSpacingTokens.crossModuleTogglePadding,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 160),
            alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
            child: const SizedBox.square(
              dimension: AppSpacing.x5,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: AppColors.navCenterIcon,
                  shape: CircleBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TemplateCategory extends StatelessWidget {
  const _TemplateCategory({required this.category, required this.templates});

  final String category;
  final List<SmartAlertTemplateDraft> templates;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          category,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final template in templates) ...[
          _TemplateCard(template: template),
          if (template != templates.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final SmartAlertTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: CrossModuleSpacingTokens.crossModulePanelPadding,
      radius: VitCardRadius.standard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.name,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            template.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              const Icon(
                Icons.stacked_line_chart_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '${template.popularity}% users',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const VitCtaButton(
                onPressed: HapticFeedback.selectionClick,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                padding: CrossModuleSpacingTokens.crossModuleTextButtonPadding,
                child: Text('Use'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
