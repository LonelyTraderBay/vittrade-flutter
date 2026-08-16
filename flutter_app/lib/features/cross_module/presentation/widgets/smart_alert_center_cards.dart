part of '../phone/pages/smart_alert_center_page.dart';

class _SmartAlertCard extends StatelessWidget {
  const _SmartAlertCard({required this.alert});

  final SmartAlertDraft alert;

  @override
  Widget build(BuildContext context) {
    final module = _moduleVisual(alert.module);

    return VitCard(
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CrossModuleIconBadge(
                icon: module.icon,
                color: module.color,
                background: module.background,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        Text(
                          alert.type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _StatusBadge(status: alert.status),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      alert.moduleName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const CrossModuleIconAction(
                icon: Icons.edit_outlined,
                color: AppColors.text3,
                background: AppColors.surface2,
                onTap: HapticFeedback.selectionClick,
              ),
              const SizedBox(width: AppSpacing.x2),
              const CrossModuleIconAction(
                icon: Icons.delete_outline_rounded,
                color: AppColors.sell,
                background: AppColors.sell10,
                onTap: HapticFeedback.selectionClick,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _DetailBlock(label: 'Condition', value: alert.condition),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _DetailBlock(label: 'Action', value: alert.action),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _DetailBlock(
                  label: 'Triggered',
                  value: '${alert.triggerCount} times',
                  emphasize: true,
                ),
              ),
              if (alert.lastTriggeredLabel != null)
                Expanded(
                  child: _DetailBlock(
                    label: 'Last Trigger',
                    value: alert.lastTriggeredLabel!,
                    emphasize: true,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SmartAlertStatus status;

  @override
  Widget build(BuildContext context) {
    // `paused` uses a solid neutral surface background (not a tint derived
    // from its own foreground color), so it can't be expressed through
    // VitAccentPill's single-accentColor tint model — kept as local
    // rendering; `active`/`triggered` are plain color-tinted-at-alpha pairs
    // and migrate cleanly.
    if (status == SmartAlertStatus.paused) {
      return DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.surface3,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
        ),
        child: Padding(
          padding: CrossModuleSpacingTokens.crossModulePillPadding,
          child: Text(
            status.name.toUpperCase(),
            style: AppTextStyles.chartLabelTiny.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      );
    }

    final color = switch (status) {
      SmartAlertStatus.active => AppColors.buy,
      SmartAlertStatus.triggered => AppColors.primary,
      SmartAlertStatus.paused => AppColors.text3, // unreachable, see above
    };
    final backgroundAlpha = switch (status) {
      SmartAlertStatus.active => 26 / 255, // matches AppColors.buy10
      SmartAlertStatus.triggered => 31 / 255, // matches AppColors.primary12
      SmartAlertStatus.paused => 0.0, // unreachable, see above
    };

    return VitAccentPill(
      label: status.name.toUpperCase(),
      accentColor: color,
      backgroundAlpha: backgroundAlpha,
      radiusOverride: AppRadii.xlRadius,
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: emphasize ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _CreateAlertButton extends StatelessWidget {
  const _CreateAlertButton();

  @override
  Widget build(BuildContext context) {
    return const VitCtaButton(
      key: SmartAlertCenterPage.createButtonKey,
      onPressed: HapticFeedback.selectionClick,
      leading: Icon(Icons.add_rounded),
      child: Text('Create Alert'),
    );
  }
}
