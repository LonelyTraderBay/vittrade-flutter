import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/phone/p2p_settings_trade_security.dart';
part '../../../widgets/phone/p2p_settings_hours_common.dart';

const double _p2pSettingsVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pSettingsNativeNavClearance =
    _p2pSettingsVisualNavClearance - AppSpacing.x4;
const double _p2pSettingsVisualClearance = AppSpacing.x3;
const double _p2pSettingsNativeClearance = AppSpacing.x2;
const double _p2pSettingsAutoReplyLineHeight = 1.34;
const double _p2pSettingsSwitchWidth = 40;
const double _p2pSettingsSwitchHeight = 22;
const double _p2pSettingsSwitchThumbSize = 16;

class P2PSettingsPage extends ConsumerStatefulWidget {
  const P2PSettingsPage({super.key, this.shellRenderMode});

  static const tradeOptionsKey = Key('sc279_p2p_settings_trade_options');
  static const notificationsKey = Key('sc279_p2p_settings_notifications');
  static const privacyKey = Key('sc279_p2p_settings_privacy');
  static const securityKey = Key('sc279_p2p_settings_security');
  static const hoursKey = Key('sc279_p2p_settings_hours');
  static const autoReplyKey = Key('sc279_p2p_settings_auto_reply');
  static const saveKey = Key('sc279_p2p_settings_save');
  static const blacklistKey = Key('sc279_p2p_settings_blacklist');
  static const trustedDevicesKey = Key('sc279_p2p_settings_devices');

  static Key optionKey(String group, String id) =>
      Key('sc279_p2p_settings_${group}_$id');

  static Key toggleKey(String id) => Key('sc279_p2p_settings_toggle_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PSettingsPage> createState() => _P2PSettingsPageState();
}

class _P2PSettingsPageState extends ConsumerState<P2PSettingsPage> {
  final Map<String, bool> _toggles = {};
  late String _asset;
  late String _currency;
  late String _paymentWindow;
  String _hoursMode = '247';
  bool _saved = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pSettingsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pSettingsVisualNavClearance + _p2pSettingsVisualClearance
            : _p2pSettingsNativeNavClearance + _p2pSettingsNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cài đặt P2P',
      semanticIdentifier: 'SC-279',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pSettingsProvider),
            ),
          ),
          data: (snapshot) {
            _ensureState(snapshot);
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => context.go(snapshot.parentRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pSettingsPageScrollPadding(
                          scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            const VitSectionHeader(
                              title: 'Tùy chọn giao dịch',
                              icon: Icons.tune_rounded,
                              iconColor: AppColors.primary,
                              iconSize: AppSpacing.iconSm,
                              titleColor: AppColors.text2,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _TradeOptionsCard(
                              snapshot: snapshot,
                              asset: _asset,
                              currency: _currency,
                              paymentWindow: _paymentWindow,
                              autoConfirm: _toggles['auto_confirm'] ?? false,
                              onAsset: (value) =>
                                  setState(() => _asset = value),
                              onCurrency: (value) =>
                                  setState(() => _currency = value),
                              onPaymentWindow: (value) =>
                                  setState(() => _paymentWindow = value),
                              onToggleAutoConfirm: () =>
                                  _toggle('auto_confirm'),
                            ),
                            _ToggleSection(
                              key: P2PSettingsPage.notificationsKey,
                              icon: Icons.notifications_none_rounded,
                              label: 'Thông báo',
                              color: AppColors.warn,
                              toggles: snapshot.notificationToggles,
                              values: _toggles,
                              onToggle: _toggle,
                            ),
                            _ToggleSection(
                              key: P2PSettingsPage.privacyKey,
                              icon: Icons.visibility_outlined,
                              label: 'Quyền riêng tư',
                              color: AppColors.accent,
                              toggles: snapshot.privacyToggles,
                              values: _toggles,
                              onToggle: _toggle,
                            ),
                            _SecuritySection(
                              snapshot: snapshot,
                              values: _toggles,
                              onToggle: _toggle,
                            ),
                            _HoursSection(
                              mode: _hoursMode,
                              onChanged: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _hoursMode = value);
                              },
                            ),
                            _AutoReplySection(
                              autoReply: snapshot.autoReply,
                              enabled: _toggles['auto_reply'] ?? true,
                              onToggle: () => _toggle('auto_reply'),
                            ),
                            VitCtaButton(
                              key: P2PSettingsPage.saveKey,
                              variant: _saved
                                  ? VitCtaButtonVariant.success
                                  : VitCtaButtonVariant.primary,
                              onPressed: () {
                                unawaited(HapticFeedback.mediumImpact());
                                setState(() => _saved = true);
                              },
                              child: Text(
                                _saved ? 'Đã lưu thành công!' : 'Lưu cài đặt',
                              ),
                            ),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem lại cài đặt P2P',
                              message:
                                  'Mặc định giao dịch, thông báo, quyền riêng tư, bảo mật, giờ hoạt động, tin nhắn tự động và trạng thái lưu được xem lại trước khi áp dụng.',
                              contractId: 'SC-279',
                            ),
                            Text(
                              snapshot.contractNotes,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _ensureState(P2PSettingsSnapshot snapshot) {
    if (_initialized) return;
    _asset = snapshot.defaultAsset;
    _currency = snapshot.defaultCurrency;
    _paymentWindow = snapshot.defaultPaymentWindow;
    _toggles['auto_confirm'] = false;
    _toggles['auto_reply'] = snapshot.autoReply.enabled;
    for (final toggle in [
      ...snapshot.notificationToggles,
      ...snapshot.privacyToggles,
      ...snapshot.securityToggles,
    ]) {
      _toggles[toggle.id] = toggle.enabled;
    }
    _initialized = true;
  }

  void _toggle(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _toggles[id] = !(_toggles[id] ?? false));
  }
}
