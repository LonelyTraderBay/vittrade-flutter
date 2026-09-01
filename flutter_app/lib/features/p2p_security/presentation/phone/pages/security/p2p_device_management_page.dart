import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/security/p2p_device_management_overview.dart';
part '../../../widgets/security/p2p_device_management_cards.dart';
part '../../../widgets/security/p2p_device_management_tips.dart';

const double _p2pDevicesIconBox = AppSpacing.x6;
const double _p2pDevicesBodyLineHeight = 1.35;
const double _p2pDevicesNoticeLineHeight = 1.35;

class P2PDeviceManagementPage extends ConsumerStatefulWidget {
  const P2PDeviceManagementPage({super.key, this.shellRenderMode});

  static const statsKey = Key('sc255_p2p_devices_stats');
  static const infoKey = Key('sc255_p2p_devices_info');
  static const trustedSectionKey = Key('sc255_p2p_devices_trusted_section');
  static const otherSectionKey = Key('sc255_p2p_devices_other_section');
  static const tipsKey = Key('sc255_p2p_devices_tips');

  static Key deviceKey(String id) => Key('sc255_p2p_device_$id');
  static Key trustButtonKey(String id) => Key('sc255_p2p_device_trust_$id');
  static Key revokeButtonKey(String id) => Key('sc255_p2p_device_revoke_$id');
  static Key removeButtonKey(String id) => Key('sc255_p2p_device_remove_$id');

  static const revokeConfirmKey = Key('sc255_p2p_devices_revoke_confirm');
  static const revokeCancelKey = Key('sc255_p2p_devices_revoke_cancel');
  static const removeConfirmKey = Key('sc255_p2p_devices_remove_confirm');
  static const removeCancelKey = Key('sc255_p2p_devices_remove_cancel');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDeviceManagementPage> createState() =>
      _P2PDeviceManagementPageState();
}

class _P2PDeviceManagementPageState
    extends ConsumerState<P2PDeviceManagementPage> {
  // STATE-S23: devices sống ở P2PDeviceManagementStateController (một
  // nguồn sự thật) — hết `late List` seed từ ref.read + setState.
  String? _expandedDeviceId;

  @override
  Widget build(BuildContext context) {
    // GD4 bẫy 21: trang chỉ watch Notifier — bọc .when() trên snapshot
    // provider gốc để tránh render fallback rỗng trong cửa sổ loading.
    final snapshotAsync = ref.watch(p2pDeviceManagementProvider);

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        title: 'Đang tải…',
        semanticLabel: 'Quản lý thiết bị',
        semanticIdentifier: 'SC-255',
        onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        title: 'Không tải được',
        semanticLabel: 'Quản lý thiết bị',
        semanticIdentifier: 'SC-255',
        onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pDeviceManagementProvider),
          ),
        ],
      ),
      data: (_) {
        final viewState = ref.watch(p2pDeviceManagementStateControllerProvider);
        final snapshot = viewState.snapshot;
        final devices = viewState.devices;
        final trustedDevices = devices
            .where((device) => device.isTrusted)
            .toList(growable: false);
        final otherDevices = devices
            .where((device) => !device.isTrusted)
            .toList(growable: false);
        return VitP2PFlowScaffold(
          title: 'Quản lý thiết bị',
          subtitle: 'Bảo mật · P2P',
          semanticLabel: 'Quản lý thiết bị',
          semanticIdentifier: 'SC-255',
          shellRenderMode: widget.shellRenderMode,
          onBack: () => context.go(snapshot.parentRoute),
          onRefresh: () async {
            unawaited(HapticFeedback.selectionClick());
            await Future<void>.delayed(const Duration(milliseconds: 120));
          },
          children: [
            _DeviceStatsCard(
              total: devices.length,
              trusted: trustedDevices.length,
              untrusted: otherDevices.length,
            ),
            _TrustedDeviceNotice(snapshot: snapshot),
            _DeviceSection(
              key: P2PDeviceManagementPage.trustedSectionKey,
              title: 'Thiết bị tin cậy (${trustedDevices.length})',
              devices: trustedDevices,
              expandedDeviceId: _expandedDeviceId,
              onToggleExpanded: _toggleExpanded,
              onTrust: _trustDevice,
              onRevoke: _revokeTrust,
              onRemove: _removeDevice,
            ),
            _DeviceSection(
              key: P2PDeviceManagementPage.otherSectionKey,
              title: 'Thiết bị khác (${otherDevices.length})',
              devices: otherDevices,
              expandedDeviceId: _expandedDeviceId,
              onToggleExpanded: _toggleExpanded,
              onTrust: _trustDevice,
              onRevoke: _revokeTrust,
              onRemove: _removeDevice,
            ),
            _SecurityTips(tips: snapshot.securityTips),
            const VitCard(
              variant: VitCardVariant.inner,
              padding: P2PSpacingTokens.p2pDevicesInnerPadding,
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Rà soát thiết bị tin cậy',
                message:
                    'Trạng thái tin cậy, thu hồi/xóa thiết bị, bằng chứng thiết bị, rủi ro bảo mật và bước xác minh tiếp theo được rà soát trước khi thay đổi.',
                contractId: 'SC-255',
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleExpanded(String deviceId) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _expandedDeviceId = _expandedDeviceId == deviceId ? null : deviceId;
    });
  }

  void _trustDevice(String deviceId) {
    unawaited(HapticFeedback.selectionClick());
    ref
        .read(p2pDeviceManagementStateControllerProvider.notifier)
        .trustDevice(deviceId);
    setState(() => _expandedDeviceId = deviceId);
  }

  Future<void> _revokeTrust(String deviceId) async {
    final devices = ref
        .read(p2pDeviceManagementStateControllerProvider)
        .devices;
    final targetDevice = devices.firstWhere((device) => device.id == deviceId);
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Thu hồi tin cậy thiết bị?',
      rows: [VitConfirmDialogRow(label: 'Thiết bị', value: targetDevice.name)],
      message:
          'Thiết bị này có thể cần xác minh bổ sung ở lần đăng nhập tiếp theo.',
      confirmKey: P2PDeviceManagementPage.revokeConfirmKey,
      cancelKey: P2PDeviceManagementPage.revokeCancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    ref
        .read(p2pDeviceManagementStateControllerProvider.notifier)
        .revokeTrust(deviceId);
    setState(() => _expandedDeviceId = deviceId);
  }

  Future<void> _removeDevice(String deviceId) async {
    final devices = ref
        .read(p2pDeviceManagementStateControllerProvider)
        .devices;
    final targetDevice = devices.firstWhere((device) => device.id == deviceId);
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xóa thiết bị?',
      rows: [VitConfirmDialogRow(label: 'Thiết bị', value: targetDevice.name)],
      message:
          'Thao tác này không thể hoàn tác. Thiết bị sẽ mất quyền truy cập ngay lập tức.',
      confirmLabel: 'Xóa',
      confirmVariant: VitCtaButtonVariant.destructive,
      confirmKey: P2PDeviceManagementPage.removeConfirmKey,
      cancelKey: P2PDeviceManagementPage.removeCancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    ref
        .read(p2pDeviceManagementStateControllerProvider.notifier)
        .removeDevice(deviceId);
    if (_expandedDeviceId == deviceId) setState(() => _expandedDeviceId = null);
  }
}
