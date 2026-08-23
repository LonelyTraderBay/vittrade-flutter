import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet device-management detail pane (SC-165) for the Profile
/// master-detail shell — a public port of the phone `DeviceManagementPage`'s
/// content (security summary metrics, risk-review panel, current-device
/// card, other-device cards with trust toggle + per-device logout confirm,
/// and the escalated logout-all preview sheet) into [ProfilePaneScaffold],
/// per R2: the phone page and its `part` family stay untouched. Same
/// [profileDeviceManagementSnapshotProvider] data as the phone page.
class ProfileDevicesPane extends ConsumerStatefulWidget {
  const ProfileDevicesPane({super.key});

  @override
  ConsumerState<ProfileDevicesPane> createState() => _ProfileDevicesPaneState();
}

class _ProfileDevicesPaneState extends ConsumerState<ProfileDevicesPane> {
  bool _initialized = false;
  List<ProfileManagedDevice> _devices = const [];

  Future<void> _refresh() async {
    ref.invalidate(profileDeviceManagementSnapshotProvider);
    await ref.read(profileDeviceManagementSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileDeviceManagementSnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Quản lý thiết bị',
      subtitle: 'Thiết bị · phiên đăng nhập',
      onBack: () => context.go(AppRoutePaths.profile),
      onRefresh: _refresh,
      scrollKey: ProfileTabletKeys.devicesPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 5)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.devicesPaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
        data: (snapshot) {
          _initializeFrom(snapshot);
          final currentDevice = _currentDevice;
          final otherDevices = _otherDevices;
          return [
            _DevicesSummaryCard(
              totalDevices: _devices.length,
              trustedCount: _trustedCount,
              untrustedCount: _untrustedCount,
              activeCount: _activeCount,
            ),
            VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Rà soát phiên thiết bị',
              message:
                  'Chỉ tin cậy thiết bị bạn sở hữu; đăng xuất các phiên lạ '
                  'hoặc không còn sử dụng.',
              contractId: 'Thiết bị tin cậy: $_trustedCount/${_devices.length}',
              density: VitDensity.compact,
            ),
            if (currentDevice != null) ...[
              const _DevicesSectionHeader(label: 'THIẾT BỊ HIỆN TẠI'),
              _DevicesDeviceCard(
                device: currentDevice,
                showActions: false,
                onToggleTrust: () {},
                onLogout: () {},
              ),
            ] else
              const VitEmptyState(
                title: 'Không có thiết bị hiện tại',
                message: 'Phiên đăng nhập sẽ hiển thị sau khi đồng bộ.',
                icon: Icons.devices_other_outlined,
              ),
            _OtherDevicesHeader(
              count: otherDevices.length,
              onLogoutAll: otherDevices.isEmpty ? null : _logoutAll,
            ),
            if (otherDevices.isEmpty)
              const VitEmptyState(
                title: 'Không có thiết bị khác',
                message: 'Các phiên đăng nhập phụ sẽ xuất hiện tại đây.',
                icon: Icons.phone_android_outlined,
              )
            else
              for (final device in otherDevices)
                _DevicesDeviceCard(
                  device: device,
                  showActions: true,
                  onToggleTrust: () => _toggleTrust(device.id),
                  onLogout: () => _logoutDevice(device.id),
                ),
          ];
        },
      ),
    );
  }

  ProfileManagedDevice? get _currentDevice {
    for (final device in _devices) {
      if (device.isCurrent) return device;
    }
    return null;
  }

  List<ProfileManagedDevice> get _otherDevices =>
      _devices.where((device) => !device.isCurrent).toList(growable: false);

  int get _trustedCount => _devices.where((device) => device.isTrusted).length;
  int get _untrustedCount =>
      _devices.where((device) => !device.isTrusted).length;
  int get _activeCount => _devices.where((device) => device.isCurrent).length;

  void _initializeFrom(ProfileDeviceManagementSnapshot snapshot) {
    if (_initialized) return;
    _devices = List<ProfileManagedDevice>.of(snapshot.devices);
    _initialized = true;
  }

  void _toggleTrust(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _devices = [
        for (final device in _devices)
          if (device.id == id)
            device.copyWith(isTrusted: !device.isTrusted)
          else
            device,
      ];
    });
  }

  ProfileManagedDevice? _deviceById(String id) {
    for (final device in _devices) {
      if (device.id == id) return device;
    }
    return null;
  }

  Future<void> _logoutDevice(String id) async {
    final device = _deviceById(id);
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Đăng xuất thiết bị?',
      message: 'Phiên đăng nhập trên thiết bị này sẽ bị thu hồi ngay lập tức.',
      rows: [
        if (device != null)
          VitConfirmDialogRow(label: 'Tên thiết bị', value: device.name),
        if (device != null)
          VitConfirmDialogRow(
            label: 'Loại thiết bị',
            value: '${device.browser} • ${device.os}',
          ),
      ],
      confirmLabel: 'Đăng xuất',
      confirmVariant: VitCtaButtonVariant.danger,
      confirmKey: ProfileTabletKeys.devicesLogoutConfirm,
      cancelKey: ProfileTabletKeys.devicesLogoutCancel,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _devices = _devices.where((device) => device.id != id).toList();
    });
  }

  Future<void> _logoutAll() async {
    final targets = _otherDevices;
    if (targets.isEmpty) return;

    final confirmed = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _LogoutAllDevicesPreviewSheet(devices: targets),
    );
    if (!mounted || confirmed != true) return;

    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _devices = _devices.where((device) => device.isCurrent).toList();
    });
  }
}

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
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesSummaryGapInline,
              ),
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
                    const SizedBox(height: AppSpacing.x1),
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
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _DevicesSummaryStat(
                  label: 'Tin cậy',
                  value: '$trustedCount',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesSummaryStatGap,
              ),
              Expanded(
                child: _DevicesSummaryStat(
                  label: 'Không tin cậy',
                  value: '$untrustedCount',
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesSummaryStatGap,
              ),
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
              color: AppColors.divider,
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
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            density: VitDensity.compact,
            borderColor: AppColors.warn.withValues(alpha: .22),
            child: Text(
              'Thao tác rủi ro cao: xem trước, xác nhận và lưu vết kiểm toán.',
              style: AppTextStyles.caption.copyWith(color: AppColors.warn),
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
                label: 'Hiện tại',
                accentColor: AppColors.buy,
              ),
            ],
            if (suspicious) ...[
              const SizedBox(
                width: ProfileSpacingTokens.profileDevicesNamePillGap,
              ),
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: ProfileSpacingTokens.profileDevicesWarningIcon,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${device.browser} • ${device.os}',
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
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
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
        const SizedBox(width: ProfileSpacingTokens.profileDevicesMetaIconGap),
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
