part of '../../phone/pages/security/p2p_device_management_page.dart';

class _DeviceSection extends StatelessWidget {
  const _DeviceSection({
    super.key,
    required this.title,
    required this.devices,
    required this.expandedDeviceId,
    required this.onToggleExpanded,
    required this.onTrust,
    required this.onRevoke,
    required this.onRemove,
  });

  final String title;
  final List<P2PTrustedDeviceDraft> devices;
  final String? expandedDeviceId;
  final ValueChanged<String> onToggleExpanded;
  final ValueChanged<String> onTrust;
  final ValueChanged<String> onRevoke;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (var index = 0; index < devices.length; index++) ...[
          _DeviceCard(
            device: devices[index],
            expanded: expandedDeviceId == devices[index].id,
            onToggleExpanded: () => onToggleExpanded(devices[index].id),
            onTrust: () => onTrust(devices[index].id),
            onRevoke: () => onRevoke(devices[index].id),
            onRemove: () => onRemove(devices[index].id),
          ),
          if (index != devices.length - 1)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onTrust,
    required this.onRevoke,
    required this.onRemove,
  });

  final P2PTrustedDeviceDraft device;
  final bool expanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onTrust;
  final VoidCallback onRevoke;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final color = _deviceColor(device);

    return VitCard(
      key: P2PDeviceManagementPage.deviceKey(device.id),
      radius: VitCardRadius.large,
      variant: VitCardVariant.standard,
      borderColor: device.isTrusted ? null : AppColors.warningBorder,
      padding: AppSpacing.zeroInsets,
      onTap: onToggleExpanded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: P2PSpacingTokens.p2pDevicesCardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DeviceIconBadge(device: device, color: color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: _DeviceMainInfo(device: device)),
                if (!device.isTrusted && !device.isCurrent)
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warn,
                    size: AppSpacing.iconMd,
                  ),
              ],
            ),
          ),
          if (expanded)
            _ExpandedDeviceDetails(
              device: device,
              onTrust: onTrust,
              onRevoke: onRevoke,
              onRemove: onRemove,
            ),
        ],
      ),
    );
  }
}

class _DeviceIconBadge extends StatelessWidget {
  const _DeviceIconBadge({required this.device, required this.color});

  final P2PTrustedDeviceDraft device;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _p2pDevicesIconBox,
      child: Material(
        type: MaterialType.transparency,
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
        child: Icon(
          _deviceIcon(device.type),
          color: color,
          size: P2PSpacingTokens.p2pSecurityDetailsDeviceIcon,
        ),
      ),
    );
  }
}

class _DeviceMainInfo extends StatelessWidget {
  const _DeviceMainInfo({required this.device});

  final P2PTrustedDeviceDraft device;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (device.isCurrent) ...[
              const SizedBox(width: AppSpacing.x2),
              const _TinyBadge(label: 'Hiện tại', color: AppColors.buy),
            ],
            if (device.isTrusted && !device.isCurrent) ...[
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.shield_outlined,
                color: AppModuleAccents.p2p,
                size: P2PSpacingTokens.p2pSecurityDetailsTinyIcon,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          '${device.os} · ${device.browser}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          children: [
            _InlineMeta(
              icon: Icons.location_on_outlined,
              text: device.location,
            ),
            Text(
              '·',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            _InlineMeta(
              icon: Icons.access_time_rounded,
              text: device.lastActive,
            ),
          ],
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
          size: P2PSpacingTokens.p2pSecurityDetailsMetaIcon,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(text, style: AppTextStyles.micro.copyWith(color: AppColors.text3)),
      ],
    );
  }
}

class _ExpandedDeviceDetails extends StatelessWidget {
  const _ExpandedDeviceDetails({
    required this.device,
    required this.onTrust,
    required this.onRevoke,
    required this.onRemove,
  });

  final P2PTrustedDeviceDraft device;
  final VoidCallback onTrust;
  final VoidCallback onRevoke;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          height: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
        Padding(
          padding: P2PSpacingTokens.p2pDevicesCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _DetailValue(label: 'IP Address', value: device.ip),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _DetailValue(
                      label: 'First Seen',
                      value: device.firstSeen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _DetailValue(label: 'Fingerprint', value: device.fingerprint),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              if (device.isCurrent)
                const _CurrentDeviceMessage()
              else
                Row(
                  children: [
                    Expanded(
                      child: device.isTrusted
                          ? _ActionButton(
                              key: P2PDeviceManagementPage.revokeButtonKey(
                                device.id,
                              ),
                              label: 'Hủy tin cậy',
                              icon: Icons.cancel_outlined,
                              color: AppColors.warn,
                              onTap: onRevoke,
                            )
                          : _ActionButton(
                              key: P2PDeviceManagementPage.trustButtonKey(
                                device.id,
                              ),
                              label: 'Đánh dấu tin cậy',
                              icon: Icons.shield_outlined,
                              color: AppColors.buy,
                              onTap: onTrust,
                            ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _ActionButton(
                      key: P2PDeviceManagementPage.removeButtonKey(device.id),
                      label: 'Xóa',
                      icon: Icons.delete_outline_rounded,
                      color: AppColors.sell,
                      compact: true,
                      onTap: onRemove,
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
            fontFeatures: AppTextStyles.tabularFigures,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CurrentDeviceMessage extends StatelessWidget {
  const _CurrentDeviceMessage();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: P2PSpacingTokens.p2pSecurityDetailsActionPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Thiết bị hiện tại',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: true,
      onTap: onTap,
      fullWidth: !compact,
      padding: P2PSpacingTokens.p2pSecurityDetailsDeviceActionPadding(compact),
      accentColor: color,
      leading: Icon(icon),
      semanticLabel: 'Thao tác thiết bị P2P $label',
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({required this.label, required this.color});

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
