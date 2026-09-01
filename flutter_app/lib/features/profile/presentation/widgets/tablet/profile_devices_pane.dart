import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'profile_devices_pane_sections.dart';

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
