part of '../../phone/pages/security/p2p_login_history_page.dart';

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.event});

  final P2PLoginEventDraft event;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: event.statusLabel,
      status: _statusPillStatus(event.status),
      icon: _statusIcon(event.status),
      size: VitStatusPillSize.sm,
    );
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});

  final String label;
  final String value;

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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _InlineMeta extends StatelessWidget {
  const _InlineMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: P2PSpacingTokens.p2pLoginHistoryMetaIcon,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      size: VitStatusPillSize.sm,
    );
  }
}

class _SecurityInfo extends StatelessWidget {
  const _SecurityInfo({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PLoginHistoryPage.infoKey,
      type: MaterialType.transparency,
      color: AppModuleAccents.p2p.withValues(alpha: .10),
      borderRadius: AppRadii.lgRadius,
      child: Padding(
        padding: P2PSpacingTokens.p2pLoginHistoryNoticePadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.infoTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  for (final tip in snapshot.securityTips) ...[
                    Text(
                      tip,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.35,
                      ),
                    ),
                    if (tip != snapshot.securityTips.last)
                      const SizedBox(height: AppSpacing.x1),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: P2PLoginHistoryPage.emptyKey,
      padding: P2PSpacingTokens.p2pLoginHistoryEmptyPadding,
      child: Column(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.emptyTitle,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) {
  return switch (status) {
    'failed' => AppColors.sell,
    'suspicious' => AppColors.warn,
    _ => AppColors.buy,
  };
}

VitStatusPillStatus _statusPillStatus(String status) {
  return switch (status) {
    'failed' => VitStatusPillStatus.error,
    'suspicious' => VitStatusPillStatus.warning,
    _ => VitStatusPillStatus.success,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'failed' => Icons.cancel_outlined,
    'suspicious' => Icons.warning_amber_rounded,
    _ => Icons.check_circle_outline_rounded,
  };
}

IconData _deviceIcon(String type) {
  return switch (type) {
    'desktop' => Icons.desktop_windows_rounded,
    'tablet' => Icons.tablet_mac_rounded,
    _ => Icons.phone_iphone_rounded,
  };
}
