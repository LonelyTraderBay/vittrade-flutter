import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

part '../../widgets/device_management_page_sections.dart';
part '../../widgets/device_management_page_common.dart';

const _devicesBackground = AppColors.bg;
const _devicesPanel3 = AppColors.surface3;
const _devicesBorder = AppColors.cardBorder;
const _devicesDivider = AppColors.divider;
const _devicesPrimary = AppColors.primary;
const _devicesGreen = AppColors.buy;
const _devicesAmber = AppColors.warn;
const _devicesMuted = AppColors.text3;

class DeviceManagementPage extends ConsumerStatefulWidget {
  const DeviceManagementPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc165_devices_content');
  static const summaryKey = Key('sc165_devices_summary');
  static const logoutAllKey = Key('sc165_devices_logout_all');
  static const logoutConfirmKey = Key('sc165_devices_logout_confirm');
  static const logoutCancelKey = Key('sc165_devices_logout_cancel');

  static Key deviceCardKey(String id) => Key('sc165_device_card_$id');
  static Key trustKey(String id) => Key('sc165_device_trust_$id');
  static Key logoutKey(String id) => Key('sc165_device_logout_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DeviceManagementPage> createState() =>
      _DeviceManagementPageState();
}

class _DeviceManagementPageState extends ConsumerState<DeviceManagementPage> {
  bool _initialized = false;
  List<ProfileManagedDevice> _devices = const [];

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileDeviceManagementSnapshotProvider);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quản lý thiết bị',
      semanticIdentifier: 'SC-165',
      child: Material(
        color: _devicesBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Qu\u1EA3n l\u00FD thi\u1EBFt b\u1ECB',
            subtitle: 'B\u1EA3o m\u1EADt \u00B7 Profile',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: DeviceManagementPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: ProfileSpacingTokens.profileDevicesScrollPadding(
                    scrollClearance,
                  ),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: snapshotAsync.when(
                      loading: () => const [VitSkeletonList()],
                      error: (error, stackTrace) => [
                        VitErrorState(
                          title:
                              'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c d\u1EEF li\u1EC7u',
                          message: 'Vui l\u00F2ng th\u1EED l\u1EA1i.',
                          actionLabel: 'Th\u1EED l\u1EA1i',
                          onAction: () => ref.invalidate(
                            profileDeviceManagementSnapshotProvider,
                          ),
                        ),
                      ],
                      data: (snapshot) {
                        _initializeFrom(snapshot);
                        final currentDevice = _currentDevice;
                        final otherDevices = _otherDevices;
                        return [
                          _SecuritySummaryCard(
                            totalDevices: _devices.length,
                            trustedCount: _trustedCount,
                            untrustedCount: _untrustedCount,
                            activeCount: _activeCount,
                          ),
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title:
                                'R\u00E0 so\u00E1t phi\u00EAn thi\u1EBFt b\u1ECB',
                            message:
                                'Ch\u1EC9 tin c\u1EADy thi\u1EBFt b\u1ECB b\u1EA1n s\u1EDF h\u1EEFu; \u0111\u0103ng xu\u1EA5t c\u00E1c phi\u00EAn l\u1EA1 ho\u1EB7c kh\u00F4ng c\u00F2n s\u1EED d\u1EE5ng.',
                            contractId:
                                'Thi\u1EBFt b\u1ECB tin c\u1EADy: $_trustedCount/${_devices.length}',
                            density: VitDensity.compact,
                          ),
                          if (currentDevice != null) ...[
                            const _SectionHeader(
                              label: 'THI\u1EBET B\u1ECA HI\u1EC6N T\u1EA0I',
                            ),
                            _DeviceCard(
                              device: currentDevice,
                              showActions: false,
                              onToggleTrust: () {},
                              onLogout: () {},
                            ),
                          ] else
                            const VitEmptyState(
                              title:
                                  'Kh\u00F4ng c\u00F3 thi\u1EBFt b\u1ECB hi\u1EC7n t\u1EA1i',
                              message:
                                  'Phi\u00EAn \u0111\u0103ng nh\u1EADp s\u1EBD hi\u1EC3n th\u1ECB sau khi \u0111\u1ED3ng b\u1ED9.',
                              icon: Icons.devices_other_outlined,
                            ),
                          _OtherDevicesHeader(
                            count: otherDevices.length,
                            onLogoutAll: otherDevices.isEmpty
                                ? null
                                : _logoutAll,
                          ),
                          if (otherDevices.isEmpty)
                            const VitEmptyState(
                              title:
                                  'Kh\u00F4ng c\u00F3 thi\u1EBFt b\u1ECB kh\u00E1c',
                              message:
                                  'C\u00E1c phi\u00EAn \u0111\u0103ng nh\u1EADp ph\u1EE5 s\u1EBD xu\u1EA5t hi\u1EC7n t\u1EA1i \u0111\u00E2y.',
                              icon: Icons.phone_android_outlined,
                            )
                          else ...[
                            for (final device in otherDevices)
                              _DeviceCard(
                                device: device,
                                showActions: true,
                                onToggleTrust: () => _toggleTrust(device.id),
                                onLogout: () => _logoutDevice(device.id),
                              ),
                          ],
                        ];
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
      confirmKey: DeviceManagementPage.logoutConfirmKey,
      cancelKey: DeviceManagementPage.logoutCancelKey,
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

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}
