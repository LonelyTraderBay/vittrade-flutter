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
import 'package:vit_trade_flutter/features/profile/presentation/widgets/common/profile_icon_registry.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_navigation.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet account-security detail pane (SC-158) for the Profile
/// master-detail shell — a public port of the phone `SecurityPage`'s content
/// (score card, risk-review panel, security checklist with status pills,
/// expandable device list, anti-phishing code card, support shortcut) into
/// [ProfilePaneScaffold], per R2. Same [profileSecuritySnapshotProvider]
/// data as the phone page.
class ProfileSecurityPane extends ConsumerStatefulWidget {
  const ProfileSecurityPane({super.key});

  @override
  ConsumerState<ProfileSecurityPane> createState() =>
      _ProfileSecurityPaneState();
}

class _ProfileSecurityPaneState extends ConsumerState<ProfileSecurityPane> {
  final TextEditingController _antiPhishingController = TextEditingController();
  bool _showDevices = false;
  bool _saving = false;

  static const _securityBorder = AppColors.cardBorder;
  static const _securityDivider = AppColors.divider;
  static const _securityPrimary = AppColors.primary;
  static const _securityGreen = AppColors.buy;
  static const _securityAmber = AppColors.riskWarning;
  static const _securityRed = AppColors.sell;
  static const _securityMuted = AppColors.text3;

  @override
  void dispose() {
    _antiPhishingController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(profileSecuritySnapshotProvider);
    await ref.read(profileSecuritySnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileSecuritySnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Bảo mật',
      subtitle: 'Bảo mật · 2FA · Thiết bị',
      onBack: () => context.go(AppRoutePaths.profile),
      onRefresh: _refresh,
      scrollKey: ProfileTabletKeys.securityPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 5)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.securityPaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
        data: (snapshot) => [
          _SecurityScoreCard(snapshot: snapshot),
          if (snapshot.highRiskContractId != null)
            VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Cần rà soát bảo mật tài khoản',
              message:
                  'Xác nhận 2FA, mã chống lừa đảo, phiên thiết bị và đổi mật khẩu trước thao tác nhạy cảm. '
                  'Không hoàn tác sau khi xác nhận thay đổi bảo mật. '
                  'Bước tiếp theo: bật đủ lớp bảo vệ còn thiếu.',
              contractId: snapshot.highRiskContractId,
              density: VitDensity.compact,
            ),
          _SecurityList(items: snapshot.items, onItemTap: _handleItemTap),
          if (_showDevices) ...[_DeviceList(devices: snapshot.devices)],
          _AntiPhishingCard(
            controller: _antiPhishingController,
            saving: _saving,
            onSave: _saveAntiPhishingCode,
          ),
          _SecuritySupportCard(supportRoute: snapshot.supportRoute),
        ],
      ),
    );
  }

  void _handleItemTap(ProfileSecurityItem item) {
    unawaited(HapticFeedback.selectionClick());
    if (item.id == 'devices') {
      setState(() => _showDevices = !_showDevices);
      return;
    }
    if (item.route != null) {
      // In-shell rows (activity) and cross-module rows (2FA, password) both
      // need the master-detail helper's back semantics — plain `go` would
      // strand the system back button outside the shell.
      openProfileDetailRoute(context, item.route!);
    }
  }

  Future<void> _saveAntiPhishingCode() async {
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận mã chống lừa đảo',
      rows: [
        VitConfirmDialogRow(
          label: 'Mã chống lừa đảo',
          value: _antiPhishingController.text,
        ),
        const VitConfirmDialogRow(
          label: 'Hiển thị',
          value: 'Email VitTrade thật',
        ),
      ],
      message:
          'Không hoàn tác ngay sau khi lưu. '
          'Bước tiếp theo: mở email VitTrade và kiểm tra mã hiển thị khớp.',
      confirmKey: ProfileTabletKeys.securityAntiPhishingConfirm,
      cancelKey: ProfileTabletKeys.securityAntiPhishingCancel,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() => _saving = false);
  }
}

class _SecurityScoreCard extends StatelessWidget {
  const _SecurityScoreCard({required this.snapshot});

  final ProfileSecuritySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final scoreColor = Color(snapshot.scoreColorHex);

    return VitCard(
      padding: TabletSpacingTokens.zeroInsets,
      key: ProfileTabletKeys.securityPaneScore,
      density: VitDensity.compact,
      borderColor: _ProfileSecurityPaneState._securityBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Điểm bảo mật',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Text(
                '${snapshot.scoreLabel} (${snapshot.score}/4)',
                style: AppTextStyles.control.copyWith(
                  color: scoreColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          VitSegmentedProgressBar(
            segmentCount: 4,
            filledCount: snapshot.score,
            filledColor: scoreColor,
            unfilledColor: AppColors.surface3,
            height: ProfileSpacingTokens.securityScoreBarHeight,
            gap: ProfileSpacingTokens.securityScoreBarGap,
            borderRadius: AppRadii.pillRadius,
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          // Nested inside the standard-tier score card — tight radius keeps
          // the concentric −8 rule (Tablet-Card-Border-Standard R4).
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            clip: true,
            borderColor: _ProfileSecurityPaneState._securityAmber.withValues(
              alpha: .22,
            ),
            background: ColoredBox(
              color: _ProfileSecurityPaneState._securityAmber.withValues(
                alpha: .12,
              ),
            ),
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _ProfileSecurityPaneState._securityAmber,
                  size: ProfileSpacingTokens.securitySmallIcon,
                ),
                const SizedBox(width: TabletSpacingTokens.x4),
                Expanded(
                  child: Text(
                    'Bật tất cả tính năng bảo mật để bảo vệ tài sản của bạn tốt nhất.',
                    style: AppTextStyles.numericMicro.copyWith(
                      color: _ProfileSecurityPaneState._securityAmber,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityList extends StatelessWidget {
  const _SecurityList({required this.items, required this.onItemTap});

  final List<ProfileSecurityItem> items;
  final ValueChanged<ProfileSecurityItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TabletSpacingTokens.zeroInsets,
      borderColor: _ProfileSecurityPaneState._securityBorder,
      clip: true,
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: Column(
          children: [
            for (final item in items) ...[
              _SecurityRow(item: item, onTap: () => onItemTap(item)),
              if (item != items.last)
                const Divider(
                  height: TabletSpacingTokens.dividerHairline,
                  color: _ProfileSecurityPaneState._securityDivider,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow({required this.item, required this.onTap});

  final ProfileSecurityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = item.danger
        ? _ProfileSecurityPaneState._securityRed
        : _ProfileSecurityPaneState._securityPrimary;

    return VitCard(
      key: ProfileTabletKeys.securityItem(item.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      child: VitIconListRow(
        minHeight: VitDensity.compact.controlHeight + TabletSpacingTokens.x5,
        padding: ProfileSpacingTokens.securityRowPadding,
        gap: TabletSpacingTokens.x3,
        leading: VitAccentIconBox(
          icon: profileIconFor(item.iconKey),
          color: accent,
          boxSize: ProfileSpacingTokens.securityRowIconBox,
          iconSize: ProfileSpacingTokens.securityRowIcon,
          bordered: false,
        ),
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.control.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Text(
          item.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.numericMicro.copyWith(
            color: _ProfileSecurityPaneState._securityMuted,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.status != null) ...[
              const SizedBox(width: TabletSpacingTokens.x4),
              VitAccentPill(
                label: item.status!,
                accentColor: Color(item.statusHex!),
              ),
            ],
            const SizedBox(width: TabletSpacingTokens.x4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: ProfileSpacingTokens.securityChevron,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({required this.devices});

  final List<ProfileDevice> devices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'THIẾT BỊ ĐĂNG NHẬP',
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),

        VitCard(
          padding: TabletSpacingTokens.zeroInsets,
          borderColor: _ProfileSecurityPaneState._securityBorder,
          clip: true,
          child: ClipRRect(
            borderRadius: AppRadii.cardRadius,
            child: Column(
              children: [
                for (final device in devices) ...[
                  _DeviceRow(device: device),
                  if (device != devices.last)
                    const Divider(
                      height: TabletSpacingTokens.dividerHairline,
                      color: _ProfileSecurityPaneState._securityDivider,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device});

  final ProfileDevice device;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: ProfileSpacingTokens.securityDeviceMinHeight,
      ),
      child: Padding(
        padding: TabletSpacingTokens.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.laptop_mac_rounded,
              color: AppColors.text3,
              size: ProfileSpacingTokens.securityDeviceIcon,
            ),
            const SizedBox(width: TabletSpacingTokens.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          device.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (device.isCurrent) ...[
                        const SizedBox(width: TabletSpacingTokens.x4),
                        const VitAccentPill(
                          label: 'Hiện tại',
                          accentColor: _ProfileSecurityPaneState._securityGreen,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Text(
                    '${device.os} • ${device.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: _ProfileSecurityPaneState._securityMuted,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Text(
                    device.lastSeen,
                    style: AppTextStyles.numericMicro.copyWith(
                      color: _ProfileSecurityPaneState._securityMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (!device.isCurrent) ...[
              const SizedBox(width: TabletSpacingTokens.x4),
              const VitAccentPill(
                label: 'Đăng xuất',
                accentColor: _ProfileSecurityPaneState._securityRed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AntiPhishingCard extends StatelessWidget {
  const _AntiPhishingCard({
    required this.controller,
    required this.saving,
    required this.onSave,
  });

  final TextEditingController controller;
  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _ProfileSecurityPaneState._securityBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _ProfileSecurityPaneState._securityPrimary,
                size: ProfileSpacingTokens.securityAntiPhishingIcon,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Text(
                'Mã chống lừa đảo',
                style: AppTextStyles.control.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            'Đặt mã cá nhân. Email từ VitTrade sẽ luôn hiển thị mã này.',
            style: AppTextStyles.numericMicro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            'Trước khi Lưu: xem trước mã · chỉ dùng email VitTrade thật · không hoàn tác ngay sau xác nhận.',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          VitInput(
            fieldKey: ProfileTabletKeys.securityAntiPhishingField,
            controller: controller,
            semanticLabel: 'Mã chống lừa đảo',
            hintText: 'Nhập mã 4–8 ký tự',
            inputFormatters: [LengthLimitingTextInputFormatter(8)],
            suffix: SizedBox(
              width: ProfileSpacingTokens.securitySaveButtonWidth,
              child: Semantics(
                button: true,
                enabled: !saving,
                label: saving
                    ? 'Đang lưu mã chống lừa đảo'
                    : 'Lưu mã chống lừa đảo',
                child: VitCtaButton(
                  key: ProfileTabletKeys.securityAntiPhishingSave,
                  onPressed: saving ? null : onSave,
                  loading: saving,
                  density: VitDensity.compact,
                  padding: EdgeInsets.zero,
                  child: Text(saving ? '...' : 'Lưu'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySupportCard extends StatelessWidget {
  const _SecuritySupportCard({required this.supportRoute});

  final String supportRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.securitySupport,
      onTap: () => context.push(supportRoute),
      density: VitDensity.compact,
      borderColor: _ProfileSecurityPaneState._securityBorder,
      child: VitIconListRow(
        gap: ProfileSpacingTokens.securitySupportGap,
        leading: SizedBox(
          width: ProfileSpacingTokens.securitySupportIconBox,
          height: ProfileSpacingTokens.securitySupportIconBox,
          child: Material(
            color: _ProfileSecurityPaneState._securityPrimary.withValues(
              alpha: .13,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: _ProfileSecurityPaneState._securityPrimary,
              size: ProfileSpacingTokens.securitySupportIcon,
            ),
          ),
        ),
        title: Text(
          'Hỗ trợ bảo mật',
          style: AppTextStyles.control.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Text(
          'Mở hồ sơ hỗ trợ kèm ngữ cảnh tài khoản',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.numericMicro.copyWith(
            color: _ProfileSecurityPaneState._securityMuted,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.text3,
          size: ProfileSpacingTokens.securityChevron,
        ),
      ),
    );
  }
}
