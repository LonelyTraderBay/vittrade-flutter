import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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

part '../../../widgets/security/p2p_2fa_settings_page_sections.dart';
part '../../../widgets/security/p2p_2fa_settings_page_common.dart';

const double _p2pTwoFactorHeroIconBox = AppSpacing.x6;
const double _p2pTwoFactorCaptionLineHeight = 1.34;
const double _p2pTwoFactorNoticeLineHeight = 1.35;

class P2P2FASettingsPage extends ConsumerStatefulWidget {
  const P2P2FASettingsPage({super.key, this.shellRenderMode});

  static const statusKey = Key('sc254_p2p_2fa_status');
  static const methodsKey = Key('sc254_p2p_2fa_methods');
  static const thresholdsKey = Key('sc254_p2p_2fa_thresholds');
  static const recommendationKey = Key('sc254_p2p_2fa_recommendation');

  static Key methodKey(String id) => Key('sc254_p2p_2fa_method_$id');
  static Key methodSwitchKey(String id) =>
      Key('sc254_p2p_2fa_method_switch_$id');
  static Key thresholdKey(String id) => Key('sc254_p2p_2fa_threshold_$id');
  static Key thresholdSwitchKey(String id) =>
      Key('sc254_p2p_2fa_threshold_switch_$id');

  /// Shared confirm-dialog action keys. Only one [showVitConfirmDialog] can
  /// ever be open at a time across the three security actions on this page
  /// (toggle method, set primary, toggle threshold), so a single reused pair
  /// is sufficient — no need for one pair per action.
  static const dialogConfirmKey = Key('sc254_p2p_2fa_dialog_confirm');
  static const dialogCancelKey = Key('sc254_p2p_2fa_dialog_cancel');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2P2FASettingsPage> createState() => _P2P2FASettingsPageState();
}

class _P2P2FASettingsPageState extends ConsumerState<P2P2FASettingsPage> {
  // STATE-S23: methods/thresholds sống ở P2P2FASettingsStateController (một
  // nguồn sự thật) — hết `late List` seed từ ref.read + setState.

  @override
  Widget build(BuildContext context) {
    // GD4 bẫy 21: trang chỉ watch Notifier (không watch provider async trực
    // tiếp) — bọc .when() trên snapshot provider gốc để tránh render
    // fallback rỗng trong cửa sổ loading; Notifier giữ nguyên (biến thể A).
    final snapshotAsync = ref.watch(p2pTwoFactorSettingsProvider);

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        title: 'Đang tải…',
        semanticLabel: 'Cài đặt 2FA cho P2P',
        semanticIdentifier: 'SC-254',
        onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        title: 'Không tải được',
        semanticLabel: 'Cài đặt 2FA cho P2P',
        semanticIdentifier: 'SC-254',
        onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pTwoFactorSettingsProvider),
          ),
        ],
      ),
      data: (_) {
        final viewState = ref.watch(p2p2FASettingsStateControllerProvider);
        final snapshot = viewState.snapshot;
        final methods = viewState.methods;
        final enabledMethods = methods.where((method) => method.enabled).length;
        final primaryMethod = methods.firstWhere(
          (method) => method.isPrimary,
          orElse: () => methods.first,
        );
        return VitP2PFlowScaffold(
          title: '2FA cho P2P',
          subtitle: 'Bảo mật · P2P',
          semanticLabel: 'Cài đặt 2FA cho P2P',
          semanticIdentifier: 'SC-254',
          shellRenderMode: widget.shellRenderMode,
          onBack: () => context.go(snapshot.parentRoute),
          children: [
            _TwoFactorStatusCard(
              enabledMethods: enabledMethods,
              primaryMethod: primaryMethod.label,
            ),
            _MethodSection(
              methods: methods,
              onToggle: _toggleMethod,
              onSetPrimary: _setPrimaryMethod,
            ),
            _ThresholdSection(
              thresholds: viewState.thresholds,
              onToggle: _toggleThreshold,
            ),
            _SecurityRecommendation(text: snapshot.recommendation),
            const VitCard(
              variant: VitCardVariant.inner,
              padding: P2PSpacingTokens.p2pTwoFactorInnerPadding,
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Rà soát thay đổi 2FA P2P',
                message:
                    'Phương thức bật, yếu tố chính, ngưỡng giao dịch, trạng thái thiết lập và bước bảo mật tiếp theo được rà soát trước khi đổi bảo vệ P2P.',
                contractId: 'SC-254',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleMethod(String methodId) async {
    final methods = ref.read(p2p2FASettingsStateControllerProvider).methods;
    final target = methods.firstWhere((method) => method.id == methodId);
    final willEnable = !target.enabled;
    final willDisableLastMethod =
        target.enabled && methods.where((method) => method.enabled).length == 1;

    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận thay đổi phương thức 2FA',
      message: willDisableLastMethod
          ? 'Đây là phương thức xác thực duy nhất đang bật. Tắt phương thức này sẽ tắt toàn bộ bảo vệ 2FA cho P2P.'
          : null,
      rows: [
        VitConfirmDialogRow(label: 'Phương thức', value: target.label),
        VitConfirmDialogRow(
          label: 'Trạng thái mới',
          value: willEnable ? 'Bật' : 'Tắt',
          valueColor: willEnable ? AppColors.buy : AppColors.text3,
        ),
      ],
      confirmVariant: willDisableLastMethod
          ? VitCtaButtonVariant.warning
          : VitCtaButtonVariant.primary,
      confirmKey: P2P2FASettingsPage.dialogConfirmKey,
      cancelKey: P2P2FASettingsPage.dialogCancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    ref
        .read(p2p2FASettingsStateControllerProvider.notifier)
        .toggleMethod(methodId);
  }

  Future<void> _setPrimaryMethod(String methodId) async {
    final methods = ref.read(p2p2FASettingsStateControllerProvider).methods;
    final target = methods.firstWhere((method) => method.id == methodId);

    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Đặt ${target.label} làm phương thức xác thực chính?',
      confirmKey: P2P2FASettingsPage.dialogConfirmKey,
      cancelKey: P2P2FASettingsPage.dialogCancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    ref
        .read(p2p2FASettingsStateControllerProvider.notifier)
        .setPrimaryMethod(methodId);
  }

  Future<void> _toggleThreshold(String thresholdId) async {
    final thresholds = ref
        .read(p2p2FASettingsStateControllerProvider)
        .thresholds;
    final target = thresholds.firstWhere(
      (threshold) => threshold.id == thresholdId,
    );

    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận ngưỡng xác thực cho ${target.label}',
      rows: [
        VitConfirmDialogRow(label: 'Hành động', value: target.label),
        VitConfirmDialogRow(
          label: 'Ngưỡng áp dụng',
          value: target.valueLabel.isEmpty ? 'Luôn áp dụng' : target.valueLabel,
        ),
      ],
      confirmKey: P2P2FASettingsPage.dialogConfirmKey,
      cancelKey: P2P2FASettingsPage.dialogCancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    ref
        .read(p2p2FASettingsStateControllerProvider.notifier)
        .toggleThreshold(thresholdId);
  }
}
