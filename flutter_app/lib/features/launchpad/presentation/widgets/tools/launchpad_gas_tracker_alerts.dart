part of '../../phone/pages/tools/launchpad_gas_tracker_page.dart';

class _AlertsTab extends StatelessWidget {
  const _AlertsTab({
    required this.alerts,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  final List<LaunchpadGasAlertDraft> alerts;
  final VoidCallback onAdd;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AddAlertCard(onTap: onAdd),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        KeyedSubtree(
          key: LaunchpadGasTrackerPage.alertsKey,
          child: alerts.isEmpty
              ? const _EmptyAlerts()
              : VitPageSection(
                  label: 'Canh bao hien tai',
                  accentColor: AppColors.warn,
                  children: [
                    for (final alert in alerts)
                      _AlertCard(
                        alert: alert,
                        onToggle: () => onToggle(alert.id),
                        onDelete: () => onDelete(alert.id),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _AddAlertCard extends StatelessWidget {
  const _AddAlertCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.addAlertKey,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.primary30,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      onTap: onTap,
      child: Row(
        children: [
          const SizedBox.square(
            dimension: LaunchpadSpacingTokens.launchpadBox40,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.primary15,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                ),
              ),
              child: Icon(Icons.add_rounded, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Them canh bao gas',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Thong bao khi gas dat nguong',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.onToggle,
    required this.onDelete,
  });

  final LaunchpadGasAlertDraft alert;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final trendIcon = alert.direction == LaunchpadGasAlertDirection.below
        ? Icons.trending_down_rounded
        : Icons.trending_up_rounded;

    return VitCard(
      key: LaunchpadGasTrackerPage.alertKey(alert.id),
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Row(
        children: [
          SizedBox.square(
            dimension: LaunchpadSpacingTokens.launchpadBox34,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: alert.accent.resolve().withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Icon(
                trendIcon,
                color: alert.accent.resolve(),
                size:
                    LaunchpadSpacingTokens.launchpadIconXl +
                    AppSpacing.hairlineStroke,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.chain} ${alert.direction == LaunchpadGasAlertDirection.below ? '<' : '>'} ${_formatGasValue(alert.threshold)} ${alert.unit}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  '${alert.triggerCount} lan kich hoat${alert.lastTriggered == null ? '' : ' - ${alert.lastTriggered}'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          VitIconButton(
            key: LaunchpadGasTrackerPage.alertToggleKey(alert.id),
            onPressed: onToggle,
            icon: alert.enabled
                ? Icons.notifications_active_outlined
                : Icons.notifications_off_outlined,
            tooltip: alert.enabled ? 'Tat canh bao gas' : 'Bat canh bao gas',
            variant: alert.enabled
                ? VitIconButtonVariant.success
                : VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
          VitIconButton(
            key: LaunchpadGasTrackerPage.alertDeleteKey(alert.id),
            onPressed: onDelete,
            icon: Icons.delete_outline_rounded,
            tooltip: 'Xoa canh bao gas',
            variant: VitIconButtonVariant.danger,
            size: VitIconButtonSize.sm,
          ),
        ],
      ),
    );
  }
}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: LaunchpadSpacingTokens.launchpadPaddingX6,
      child: Column(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.text3,
            size: LaunchpadSpacingTokens.launchpadIconHuge,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Chua co canh bao nao',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Them canh bao de biet khi gas giam',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
