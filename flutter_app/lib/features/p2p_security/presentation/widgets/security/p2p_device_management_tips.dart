part of '../../phone/pages/security/p2p_device_management_page.dart';

class _SecurityTips extends StatelessWidget {
  const _SecurityTips({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDeviceManagementPage.tipsKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pDevicesCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Mẹo bảo mật',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final tip in tips) ...[
            _TipRow(text: tip),
            if (tip != tips.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: P2PSpacingTokens.p2pSecurityDetailsBulletPadding,
          child: Icon(
            Icons.circle,
            color: AppColors.text3,
            size: P2PSpacingTokens.p2pSecurityDetailsBullet,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _p2pDevicesBodyLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

Color _deviceColor(P2PTrustedDeviceDraft device) {
  if (device.isCurrent) return AppColors.buy;
  if (device.isTrusted) return AppModuleAccents.p2p;
  return AppColors.text3;
}

IconData _deviceIcon(String type) {
  return switch (type) {
    'mobile' => Icons.phone_iphone_rounded,
    'tablet' => Icons.tablet_mac_rounded,
    _ => Icons.desktop_windows_rounded,
  };
}
