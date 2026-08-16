part of '../phone/pages/device_management_page.dart';

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: _devicesMuted,
          size: ProfileSpacingTokens.profileDevicesMetaIcon,
        ),
        const SizedBox(width: ProfileSpacingTokens.profileDevicesMetaIconGap),
        Text(value, style: AppTextStyles.micro.copyWith(color: _devicesMuted)),
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
      key: DeviceManagementPage.trustKey(device.id),
      onPressed: onTap,
      density: VitDensity.compact,
      variant: trusted
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.warning,
      leading: Icon(
        trusted ? Icons.shield_outlined : Icons.warning_amber_rounded,
      ),
      child: Text(
        trusted ? 'Tin c\u1EADy' : '\u0110\u00E1nh d\u1EA5u tin c\u1EADy',
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.deviceId, required this.onTap});

  final String deviceId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: DeviceManagementPage.logoutKey(deviceId),
      onPressed: onTap,
      density: VitDensity.compact,
      variant: VitCtaButtonVariant.danger,
      fullWidth: false,
      padding: ProfileSpacingTokens.profileDevicesLogoutButtonPadding,
      leading: const Icon(Icons.delete_outline_rounded),
      child: const Text('\u0110\u0103ng xu\u1EA5t'),
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
    'Ho Chi Minh, VN' => 'H\u1ED3 Ch\u00ED Minh, VN',
    'Ha Noi, VN' => 'H\u00E0 N\u1ED9i, VN',
    _ => value,
  };
}

String _lastActiveLabel(String value) {
  return switch (value) {
    'Dang hoat dong' => '\u0110ang ho\u1EA1t \u0111\u1ED9ng',
    '2 gio truoc' => '2 gi\u1EDD tr\u01B0\u1EDBc',
    '3 ngay truoc' => '3 ng\u00E0y tr\u01B0\u1EDBc',
    '5 ngay truoc' => '5 ng\u00E0y tr\u01B0\u1EDBc',
    _ => value,
  };
}
