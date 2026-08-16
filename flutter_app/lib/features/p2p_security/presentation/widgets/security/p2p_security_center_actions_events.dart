part of '../../phone/pages/security/p2p_security_center_page.dart';

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.actions, required this.onOpen});

  final List<P2PSecurityQuickActionDraft> actions;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSecurityCenterPage.quickActionsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Thao tác nhanh',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        GridView.builder(
          itemCount: actions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                P2PSpacingTokens.p2pSecurityCenterQuickActionCrossAxisCount,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio:
                P2PSpacingTokens.p2pSecurityCenterQuickActionAspectRatio,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return _QuickActionCard(
              action: action,
              onTap: () => onOpen(action.route),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action, required this.onTap});

  final P2PSecurityQuickActionDraft action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _actionColor(action.colorKey);

    return VitCard(
      key: P2PSecurityCenterPage.quickActionKey(action.id),
      radius: VitCardRadius.large,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.borderSolid,
      padding: _p2pSecurityCompactPadding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IconBadge(icon: _quickActionIcon(action.iconKey), color: color),
          Text(
            action.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: _p2pSecurityLabelLine,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentEvents extends StatelessWidget {
  const _RecentEvents({required this.events});

  final List<P2PSecurityEventDraft> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSecurityCenterPage.eventsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Hoạt động gần đây',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        VitCard(
          radius: VitCardRadius.large,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (var index = 0; index < events.length; index++) ...[
                _SecurityEventRow(event: events[index]),
                if (index != events.length - 1)
                  const Divider(
                    height: _p2pSecurityDividerExtent,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SecurityEventRow extends StatelessWidget {
  const _SecurityEventRow({required this.event});

  final P2PSecurityEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(event.severity);

    return Padding(
      key: P2PSecurityCenterPage.eventKey(event.id),
      padding: _p2pSecurityCompactPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: _eventIcon(event.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.label,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  event.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _p2pSecurityCompactLine,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: P2PSpacingTokens.p2pSecurityCenterTimeIcon,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      event.time,
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
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _p2pSecurityIconBox,
      child: Material(
        type: MaterialType.transparency,
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    this.prominent = false,
  });

  final String label;
  final Color color;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      size: prominent ? VitStatusPillSize.md : VitStatusPillSize.sm,
    );
  }
}

Color _statusColor(P2PSecurityStatus status) {
  return switch (status) {
    P2PSecurityStatus.enabled => AppColors.buy,
    P2PSecurityStatus.warning => AppColors.warn,
    P2PSecurityStatus.disabled => AppColors.text3,
  };
}

String _statusLabel(P2PSecurityStatus status) {
  return switch (status) {
    P2PSecurityStatus.enabled => 'Đã bật',
    P2PSecurityStatus.warning => 'Cần xem lại',
    P2PSecurityStatus.disabled => 'Chưa bật',
  };
}

Color _severityColor(P2PSecurityEventSeverity severity) {
  return switch (severity) {
    P2PSecurityEventSeverity.info => AppColors.buy,
    P2PSecurityEventSeverity.warning => AppColors.warn,
    P2PSecurityEventSeverity.critical => AppColors.sell,
  };
}

Color _actionColor(String colorKey) {
  return switch (colorKey) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    'danger' => AppColors.sell,
    'p2p' => AppModuleAccents.p2p,
    _ => AppColors.primary,
  };
}

IconData _featureIcon(String key) {
  return switch (key) {
    'phone' => Icons.phone_iphone_rounded,
    'anti_phishing' => Icons.gpp_good_outlined,
    'devices' => Icons.desktop_windows_rounded,
    'whitelist' => Icons.shield_outlined,
    'biometric' => Icons.fingerprint_rounded,
    _ => Icons.security_rounded,
  };
}

IconData _quickActionIcon(String key) {
  return switch (key) {
    'password' => Icons.key_rounded,
    'history' => Icons.history_rounded,
    'devices' => Icons.desktop_windows_rounded,
    'alert' => Icons.warning_amber_rounded,
    _ => Icons.security_rounded,
  };
}

IconData _eventIcon(String key) {
  return switch (key) {
    'success' => Icons.check_circle_outline_rounded,
    'device' => Icons.desktop_windows_rounded,
    'failed' => Icons.cancel_outlined,
    _ => Icons.info_outline_rounded,
  };
}
