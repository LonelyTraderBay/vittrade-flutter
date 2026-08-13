import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/common/profile_icon_registry.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

part '../widgets/security_page_sections.dart';
part '../widgets/security_page_common.dart';

const _securityBackground = AppColors.bg;
const _securityBorder = AppColors.cardBorder;
const _securityDivider = AppColors.divider;
const _securityPrimary = AppColors.primary;
const _securityGreen = AppColors.buy;
const _securityAmber = AppColors.warn;
const _securityRed = AppColors.sell;
const _securityMuted = AppColors.text3;

class SecurityPage extends ConsumerStatefulWidget {
  const SecurityPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc158_security_content');
  static const scoreCardKey = Key('sc158_security_score_card');
  static const antiPhishingFieldKey = Key('sc158_security_anti_phishing_field');
  static const antiPhishingSaveKey = Key('sc158_security_anti_phishing_save');
  static const antiPhishingConfirmKey = Key(
    'sc158_security_anti_phishing_confirm',
  );
  static const antiPhishingCancelKey = Key(
    'sc158_security_anti_phishing_cancel',
  );
  static const supportKey = Key('sc158_security_support');

  static Key itemKey(String id) => Key('sc158_security_item_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends ConsumerState<SecurityPage> {
  final TextEditingController _antiPhishingController = TextEditingController();
  bool _showDevices = false;
  bool _saving = false;

  @override
  void dispose() {
    _antiPhishingController.dispose();
    super.dispose();
  }

  String get _routePath => GoRouterState.of(context).uri.path;

  String get _headerSubtitle {
    if (_routePath == AppRoutePaths.settingsSecurityBiometric) {
      return 'Sinh tr\u1EAFc h\u1ECDc \u00B7 C\u00E0i \u0111\u1EB7t';
    }
    if (_routePath == AppRoutePaths.settingsSecurityChangePassword) {
      return 'M\u1EADt kh\u1EA9u \u00B7 C\u00E0i \u0111\u1EB7t';
    }
    if (_routePath.startsWith(AppRoutePaths.settingsSecurity)) {
      return 'C\u00E0i \u0111\u1EB7t \u00B7 Profile';
    }
    return 'B\u1EA3o m\u1EADt \u00B7 Profile';
  }

  String get _semanticLabel {
    if (_routePath == AppRoutePaths.settingsSecurityBiometric) {
      return 'SC-405 SettingsSecurityBiometric';
    }
    if (_routePath == AppRoutePaths.settingsSecurityChangePassword) {
      return 'SC-406 SettingsSecurityChangePassword';
    }
    if (_routePath == AppRoutePaths.settingsSecurity) {
      return 'SC-413 SettingsSecurity';
    }
    return 'SC-158 SecurityPage';
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileSecuritySnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7 + AppSpacing.x1
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.x5 +
                  AppSpacing.x1) +
        MediaQuery.paddingOf(context).bottom;

    return VitAutoHidePageScaffold(
      semanticLabel: _semanticLabel,
      background: _securityBackground,
      header: VitHeader(
        title: 'B\u1EA3o m\u1EADt',
        subtitle: _headerSubtitle,
        showBack: true,
        onBack: _close,
      ),
      body: SingleChildScrollView(
        key: SecurityPage.contentKey,
        physics: const ClampingScrollPhysics(),
        padding: ProfileSpacingTokens.securityScrollPadding(scrollClearance),
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.none,
          density: VitDensity.relaxed,
          fullBleed: true,
          children: snapshotAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title:
                    'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c d\u1EEF li\u1EC7u',
                message: 'Vui l\u00F2ng th\u1EED l\u1EA1i.',
                actionLabel: 'Th\u1EED l\u1EA1i',
                onAction: () => ref.invalidate(profileSecuritySnapshotProvider),
              ),
            ],
            data: (snapshot) => [
              _ScoreCard(snapshot: snapshot),
              if (snapshot.highRiskContractId != null)
                VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title:
                      'C\u1EA7n r\u00E0 so\u00E1t b\u1EA3o m\u1EADt t\u00E0i kho\u1EA3n',
                  message:
                      'X\u00E1c nh\u1EADn 2FA, m\u00E3 ch\u1ED1ng l\u1EEBa \u0111\u1EA3o, phi\u00EAn thi\u1EBFt b\u1ECB v\u00E0 \u0111\u1ED5i m\u1EADt kh\u1EA9u tr\u01B0\u1EDBc thao t\u00E1c nh\u1EA1y c\u1EA3m. '
                      'Kh\u00F4ng ho\u00E0n t\u00E1c sau khi x\u00E1c nh\u1EADn thay \u0111\u1ED5i b\u1EA3o m\u1EADt. '
                      'B\u01B0\u1EDBc ti\u1EBFp theo: b\u1EADt \u0111\u1EE7 l\u1EDBp b\u1EA3o v\u1EC7 c\u00F2n thi\u1EBFu.',
                  contractId: snapshot.highRiskContractId,
                  density: VitDensity.relaxed,
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
        ),
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
      context.go(item.route!);
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
      confirmKey: SecurityPage.antiPhishingConfirmKey,
      cancelKey: SecurityPage.antiPhishingCancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() => _saving = false);
  }

  void _close() {
    final fallback = _routePath.startsWith(AppRoutePaths.settingsSecurity)
        ? AppRoutePaths.profileSettings
        : AppRoutePaths.profile;
    goBackOrFallback(context, fallbackPath: fallback);
  }
}
