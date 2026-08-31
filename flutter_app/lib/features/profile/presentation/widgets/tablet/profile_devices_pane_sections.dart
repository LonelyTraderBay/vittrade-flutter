part of 'profile_devices_pane.dart';

class _DevicesSummaryCard extends StatelessWidget {
  const _DevicesSummaryCard({
    required this.totalDevices,
    required this.trustedCount,
    required this.untrustedCount,
    required this.activeCount,
  });

  final int totalDevices;
  final int trustedCount;
  final int untrustedCount;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.devicesSummary,
      density: VitDensity.compact,
      borderColor: AppColors.primary20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesSummaryIconBox,
                height: ProfileSpacingTokens.profileDevicesSummaryIconBox,
                child: Material(
                  color: AppColors.primary15,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    color: AppColors.primary,
                    size: ProfileSpacingTokens.profileDevicesSummaryIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bảo mật thiết bị',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.heavy,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      '$totalDevices thiết bị đã đăng nhập',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _DevicesSummaryStat(
                  label: 'Tin cậy',
                  value: '$trustedCount',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _DevicesSummaryStat(
                  label: 'Không tin cậy',
                  value: '$untrustedCount',
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _DevicesSummaryStat(
                  label: 'Đang hoạt động',
                  value: '$activeCount',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DevicesSummaryStat extends StatelessWidget {
  const _DevicesSummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface3.withValues(alpha: .82),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.x2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.heavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DevicesSectionHeader extends StatelessWidget {
  const _DevicesSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      bottomGap: AppSpacing.pageRhythmStandardInnerGap,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: AppColors.primary,
      density: VitDensity.compact,
    );
  }
}

class _OtherDevicesHeader extends StatelessWidget {
  const _OtherDevicesHeader({required this.count, required this.onLogoutAll});

  final int count;
  final VoidCallback? onLogoutAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DevicesSectionHeader(label: 'CÁC THIẾT BỊ KHÁC ($count)'),
        ),
        VitCtaButton(
          key: ProfileTabletKeys.devicesLogoutAll,
          onPressed: onLogoutAll,
          variant: VitCtaButtonVariant.destructive,
          fullWidth: false,
          height: AppSpacing.buttonCompact,
          child: const Text('Đăng xuất tất cả'),
        ),
      ],
    );
  }
}

class _DevicesDeviceCard extends StatelessWidget {
  const _DevicesDeviceCard({
    required this.device,
    required this.showActions,
    required this.onToggleTrust,
    required this.onLogout,
  });

  final ProfileManagedDevice device;
  final bool showActions;
  final VoidCallback onToggleTrust;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final suspicious = !device.isTrusted && !device.isCurrent;
    final accent = suspicious ? AppColors.warn : AppColors.primary;

    return VitCard(
      key: ProfileTabletKeys.deviceCard(device.id),
      density: VitDensity.compact,
      borderColor: suspicious
          ? AppColors.warn.withValues(alpha: .34)
          : AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ProfileSpacingTokens.profileDevicesIconBox,
                height: ProfileSpacingTokens.profileDevicesIconBox,
                child: Material(
                  color: accent.withValues(alpha: .14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: Icon(
                    _deviceIcon(device.type),
                    color: accent,
                    size: ProfileSpacingTokens.profileDevicesIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _DeviceDetails(device: device, suspicious: suspicious),
              ),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: AppSpacing.x4),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: _TrustButton(device: device, onTap: onToggleTrust),
                ),
                const SizedBox(width: AppSpacing.x4),
                _DeviceLogoutButton(deviceId: device.id, onTap: onLogout),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Escalated preview + confirm sheet for the bulk "log out all other
/// devices" action — mirrors the phone page's sheet: lists what is about to
/// be revoked, shows a high-risk banner, and only resolves `true` when the
/// user taps Confirm.
class _LogoutAllDevicesPreviewSheet extends StatelessWidget {
  const _LogoutAllDevicesPreviewSheet({required this.devices});

  static const confirmKey = Key('sc165_devices_logout_all_confirm');
  static const cancelKey = Key('sc165_devices_logout_all_cancel');

  final List<ProfileManagedDevice> devices;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'Xác nhận đăng xuất tất cả',
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < devices.length; i++)
            VitInfoRow(
              label: devices[i].name,
              value: '${devices[i].browser} • ${devices[i].os}',
              density: VitDensity.compact,
              showDivider: i != devices.length - 1,
            ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            density: VitDensity.compact,
            borderColor: AppColors.warn.withValues(alpha: .22),
            child: Text(
              'Thao tác rủi ro cao: xem trước, xác nhận và lưu vết kiểm toán.',
              style: AppTextStyles.caption.copyWith(color: AppColors.warn),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: cancelKey,
                  onPressed: () => Navigator.of(context).pop(false),
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.ctaHeight,
                  child: const Text('Hủy'),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: VitCtaButton(
                  key: confirmKey,
                  onPressed: () => Navigator.of(context).pop(true),
                  variant: VitCtaButtonVariant.destructive,
                  height: AppSpacing.ctaHeight,
                  child: const Text('Đăng xuất tất cả'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeviceDetails extends StatelessWidget {
  const _DeviceDetails({required this.device, required this.suspicious});

  final ProfileManagedDevice device;
  final bool suspicious;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.heavy,
                ),
              ),
            ),
            if (device.isCurrent) ...[
              const SizedBox(width: AppSpacing.x4),
              const VitAccentPill(
                label: 'Hiện tại',
                accentColor: AppColors.buy,
              ),
            ],
            if (suspicious) ...[
              const SizedBox(width: AppSpacing.x4),
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: ProfileSpacingTokens.profileDevicesWarningIcon,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '${device.browser} • ${device.os}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Wrap(
          spacing: ProfileSpacingTokens.profileDevicesMetaSpacing,
          runSpacing: ProfileSpacingTokens.profileDevicesMetaRunSpacing,
          children: [
            _DevicesMetaItem(
              icon: Icons.location_on_outlined,
              value: _locationLabel(device.location),
            ),
            _DevicesMetaItem(
              icon: Icons.access_time_rounded,
              value: _lastActiveLabel(device.lastActive),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'IP: ${device.ip}',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _DevicesMetaItem extends StatelessWidget {
  const _DevicesMetaItem({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: ProfileSpacingTokens.profileDevicesMetaIcon,
        ),
        const SizedBox(width: AppSpacing.x4),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _TrustButton extends StatelessWidget {
  const _TrustButton({required this.device, required this.onTap});

  final ProfileManagedDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final trusted = device.isTrusted;

    return VitCtaButton(
      key: ProfileTabletKeys.deviceTrust(device.id),
      onPressed: onTap,
      density: VitDensity.compact,
      variant: trusted
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.warning,
      leading: Icon(
        trusted ? Icons.shield_outlined : Icons.warning_amber_rounded,
      ),
      child: Text(trusted ? 'Tin cậy' : 'Đánh dấu tin cậy'),
    );
  }
}

class _DeviceLogoutButton extends StatelessWidget {
  const _DeviceLogoutButton({required this.deviceId, required this.onTap});

  final String deviceId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: ProfileTabletKeys.deviceLogout(deviceId),
      onPressed: onTap,
      density: VitDensity.compact,
      variant: VitCtaButtonVariant.danger,
      fullWidth: false,
      padding: ProfileSpacingTokens.profileDevicesLogoutButtonPadding,
      leading: const Icon(Icons.delete_outline_rounded),
      child: const Text('Đăng xuất'),
    );
  }
}

IconData _deviceIcon(String type) {
  return switch (type) {
    'mobile' => Icons.phone_iphone_rounded,
    'tablet' => Icons.tablet_mac_rounded,
    _ => Icons.desktop_windows_outlined,
  };
}

String _locationLabel(String value) {
  return switch (value) {
    'Ho Chi Minh, VN' => 'Hồ Chí Minh, VN',
    'Ha Noi, VN' => 'Hà Nội, VN',
    _ => value,
  };
}

String _lastActiveLabel(String value) {
  return switch (value) {
    'Dang hoat dong' => 'Đang hoạt động',
    '2 gio truoc' => '2 giờ trước',
    '3 ngay truoc' => '3 ngày trước',
    '5 ngay truoc' => '5 ngày trước',
    _ => value,
  };
}
