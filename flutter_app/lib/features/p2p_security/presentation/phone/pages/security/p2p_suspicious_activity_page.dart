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

const double _p2pSuspiciousIconBox = AppSpacing.buttonCompact + AppSpacing.x1;

class P2PSuspiciousActivityPage extends ConsumerStatefulWidget {
  const P2PSuspiciousActivityPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc258_p2p_suspicious_summary');
  static const alertsKey = Key('sc258_p2p_suspicious_alerts');
  static const emptyKey = Key('sc258_p2p_suspicious_empty');

  static Key alertKey(String id) => Key('sc258_p2p_suspicious_alert_$id');

  static Key dismissKey(String id) => Key('sc258_p2p_suspicious_dismiss_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PSuspiciousActivityPage> createState() =>
      _P2PSuspiciousActivityPageState();
}

class _P2PSuspiciousActivityPageState
    extends ConsumerState<P2PSuspiciousActivityPage> {
  // STATE-S23: alerts sống ở P2PSuspiciousActivityStateController (một
  // nguồn sự thật) — hết `late List` seed từ ref.read + setState.

  @override
  Widget build(BuildContext context) {
    // GD4 bẫy 21: trang chỉ watch Notifier — bọc .when() trên snapshot
    // provider gốc để tránh render fallback rỗng trong cửa sổ loading.
    final snapshotAsync = ref.watch(p2pSuspiciousActivityProvider);

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        title: 'Đang tải…',
        semanticLabel: 'Hoạt động đáng ngờ',
        semanticIdentifier: 'SC-258',
        onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        title: 'Không tải được',
        semanticLabel: 'Hoạt động đáng ngờ',
        semanticIdentifier: 'SC-258',
        onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pSuspiciousActivityProvider),
          ),
        ],
      ),
      data: (_) {
        final viewState = ref.watch(
          p2pSuspiciousActivityStateControllerProvider,
        );
        final snapshot = viewState.snapshot;
        final alerts = viewState.alerts;
        final unreviewedCount = alerts.where((alert) => !alert.reviewed).length;
        return VitP2PFlowScaffold(
          title: 'Hoạt động đáng ngờ',
          subtitle: 'An toàn · P2P',
          semanticLabel: 'Hoạt động đáng ngờ',
          semanticIdentifier: 'SC-258',
          shellRenderMode: widget.shellRenderMode,
          onBack: () => context.go(snapshot.parentRoute),
          onRefresh: () async {
            unawaited(HapticFeedback.selectionClick());
            await Future<void>.delayed(const Duration(milliseconds: 120));
          },
          children: [
            _SummaryCard(
              unreviewedCount: unreviewedCount,
              subtitle: snapshot.summarySubtitle,
            ),
            if (alerts.isEmpty)
              _EmptyState(snapshot: snapshot)
            else
              _AlertList(alerts: alerts, onDismiss: _markReviewed),
            const VitCard(
              variant: VitCardVariant.inner,
              padding: P2PSpacingTokens.p2pComplianceCompactCardPadding,
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại trạng thái cảnh báo',
                message:
                    'Mức độ cảnh báo, trạng thái đã xem, thao tác bỏ qua, rủi ro tài khoản và bước bảo mật tiếp theo đã được xem trước khi xóa cảnh báo.',
                contractId: 'p2p-suspicious-activity-review',
              ),
            ),
          ],
        );
      },
    );
  }

  void _markReviewed(String alertId) {
    unawaited(HapticFeedback.selectionClick());
    ref
        .read(p2pSuspiciousActivityStateControllerProvider.notifier)
        .markReviewed(alertId);
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.unreviewedCount, required this.subtitle});

  final int unreviewedCount;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSuspiciousActivityPage.summaryKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.warningBorder,
      padding: P2PSpacingTokens.p2pComplianceCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: AppColors.warn.withValues(alpha: .18),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
            ),
            child: const SizedBox(
              width: _p2pSuspiciousIconBox,
              height: _p2pSuspiciousIconBox,
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: P2PSpacingTokens.p2pComplianceUnavailableIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$unreviewedCount cảnh báo mới',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.warn,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertList extends StatelessWidget {
  const _AlertList({required this.alerts, required this.onDismiss});

  final List<P2PSuspiciousAlertDraft> alerts;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSuspiciousActivityPage.alertsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < alerts.length; index++) ...[
          _AlertCard(alert: alerts[index], onDismiss: onDismiss),
          if (index != alerts.length - 1)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.onDismiss});

  final P2PSuspiciousAlertDraft alert;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(alert.severity);

    return VitCard(
      key: P2PSuspiciousActivityPage.alertKey(alert.id),
      radius: VitCardRadius.large,
      borderColor: alert.reviewed ? null : color,
      padding: P2PSpacingTokens.p2pComplianceCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: color.withValues(alpha: .14),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: _p2pSuspiciousIconBox,
              height: _p2pSuspiciousIconBox,
              child: Icon(
                Icons.warning_amber_rounded,
                color: color,
                size: P2PSpacingTokens.p2pComplianceUnavailableIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.message,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: P2PSpacingTokens.p2pComplianceMetaIcon,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      alert.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                if (alert.reviewed) ...[
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  const _ReviewedBadge(),
                ],
              ],
            ),
          ),
          if (!alert.reviewed)
            _DismissButton(alertId: alert.id, onDismiss: onDismiss),
        ],
      ),
    );
  }
}

class _DismissButton extends StatelessWidget {
  const _DismissButton({required this.alertId, required this.onDismiss});

  final String alertId;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: P2PSpacingTokens.p2pComplianceDismissButton,
      child: VitInlineIconAction(
        key: P2PSuspiciousActivityPage.dismissKey(alertId),
        icon: Icons.close_rounded,
        tooltip: 'Đóng cảnh báo',
        onPressed: () => onDismiss(alertId),
        color: AppColors.text3,
        size: AppSpacing.iconSm,
        padding: 0,
      ),
    );
  }
}

class _ReviewedBadge extends StatelessWidget {
  const _ReviewedBadge();

  @override
  Widget build(BuildContext context) {
    return const VitAccentPill(
      label: 'Đã xem lại',
      accentColor: AppColors.buy,
      semanticStatus: VitStatusPillStatus.success,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.snapshot});

  final P2PSuspiciousActivitySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSuspiciousActivityPage.emptyKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pComplianceCardPadding,
      child: Column(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.emptyTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _severityColor(String severity) {
  return switch (severity) {
    'high' => AppColors.sell,
    'medium' => AppColors.warn,
    _ => AppModuleAccents.p2p,
  };
}
