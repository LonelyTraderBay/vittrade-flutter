part of '../phone/pages/device_management_page.dart';

class _SecuritySummaryCard extends StatelessWidget {
  const _SecuritySummaryCard({
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
      key: DeviceManagementPage.summaryKey,
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
                    color: _devicesPrimary,
                    size: ProfileSpacingTokens.profileDevicesSummaryIcon,
                  ),
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesSummaryGapInline,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'B\u1EA3o m\u1EADt thi\u1EBFt b\u1ECB',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.heavy,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '$totalDevices thi\u1EBFt b\u1ECB \u0111\u00E3 \u0111\u0103ng nh\u1EADp',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Tin c\u1EADy',
                  value: '$trustedCount',
                  color: _devicesGreen,
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesSummaryStatGap,
              ),
              Expanded(
                child: _SummaryStat(
                  label: 'Kh\u00F4ng tin c\u1EADy',
                  value: '$untrustedCount',
                  color: _devicesAmber,
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesSummaryStatGap,
              ),
              Expanded(
                child: _SummaryStat(
                  label: '\u0110ang ho\u1EA1t \u0111\u1ED9ng',
                  value: '$activeCount',
                  color: _devicesPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
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
      color: _devicesPanel3.withValues(alpha: .82),
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
              style: AppTextStyles.micro.copyWith(color: _devicesMuted),
            ),
            const SizedBox(height: AppSpacing.x1),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      bottomGap: AppSpacing.pageRhythmStandardInnerGap,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _devicesPrimary,
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
          child: _SectionHeader(
            label: 'C\u00C1C THI\u1EBET B\u1ECA KH\u00C1C ($count)',
          ),
        ),
        VitCtaButton(
          key: DeviceManagementPage.logoutAllKey,
          onPressed: onLogoutAll,
          variant: VitCtaButtonVariant.destructive,
          fullWidth: false,
          height: AppSpacing.buttonCompact,
          child: const Text('\u0110\u0103ng xu\u1EA5t t\u1EA5t c\u1EA3'),
        ),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
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
    final accent = suspicious ? _devicesAmber : _devicesPrimary;

    return VitCard(
      key: DeviceManagementPage.deviceCardKey(device.id),
      density: VitDensity.compact,
      borderColor: suspicious
          ? _devicesAmber.withValues(alpha: .42)
          : _devicesBorder,
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
              const SizedBox(width: ProfileSpacingTokens.profileDevicesIconGap),
              Expanded(
                child: _DeviceDetails(device: device, suspicious: suspicious),
              ),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: _devicesDivider,
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Row(
              children: [
                Expanded(
                  child: _TrustButton(device: device, onTap: onToggleTrust),
                ),
                const SizedBox(
                  width: ProfileSpacingTokens.profileDevicesActionGap,
                ),
                _LogoutButton(deviceId: device.id, onTap: onLogout),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Escalated preview + confirm sheet for the bulk "log out all other
/// devices" action. Modeled on `WithdrawPreviewSheet` (see
/// `withdraw_preview_sheet.dart`): lists what is about to be revoked, shows a
/// high-risk banner, and only resolves `true` when the user taps Confirm.
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
        children: [
          for (var i = 0; i < devices.length; i++)
            VitInfoRow(
              label: devices[i].name,
              value: '${devices[i].browser} • ${devices[i].os}',
              density: VitDensity.compact,
              showDivider: i != devices.length - 1,
            ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            density: VitDensity.compact,
            borderColor: _devicesAmber.withValues(alpha: .24),
            child: Text(
              'High-risk action: preview + confirm + audit trail required.',
              style: AppTextStyles.caption.copyWith(color: _devicesAmber),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
              const SizedBox(width: AppSpacing.pageRhythmStandardInnerGap),
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
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesNamePillGap,
              ),
              const VitAccentPill(
                label: 'Hi\u1EC7n t\u1EA1i',
                accentColor: _devicesGreen,
              ),
            ],
            if (suspicious) ...[
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesNamePillGap,
              ),
              const Icon(
                Icons.warning_amber_rounded,
                color: _devicesAmber,
                size: ProfileSpacingTokens.profileDevicesWarningIcon,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${device.browser} \u2022 ${device.os}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Wrap(
          spacing: ProfileSpacingTokens.profileDevicesMetaSpacing,
          runSpacing: ProfileSpacingTokens.profileDevicesMetaRunSpacing,
          children: [
            _MetaItem(
              icon: Icons.location_on_outlined,
              value: _locationLabel(device.location),
            ),
            _MetaItem(
              icon: Icons.access_time_rounded,
              value: _lastActiveLabel(device.lastActive),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          'IP: ${device.ip}',
          style: AppTextStyles.micro.copyWith(color: _devicesMuted),
        ),
      ],
    );
  }
}
