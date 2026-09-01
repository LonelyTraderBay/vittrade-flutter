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
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_notice_widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

class P2POrderCancelPage extends ConsumerStatefulWidget {
  const P2POrderCancelPage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc214_p2p_order_cancel_content');
  static const confirmKey = Key('sc214_p2p_order_cancel_confirm');
  static const backKey = Key('sc214_p2p_order_cancel_back');

  static Key reasonKey(String reason) => Key('sc214_p2p_cancel_$reason');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderCancelPage> createState() => _P2POrderCancelPageState();
}

class _P2POrderCancelPageState extends ConsumerState<P2POrderCancelPage> {
  String _cancelReason = '';
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pOrderCancelProvider(widget.orderId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hủy đơn hàng P2P',
      semanticIdentifier: 'SC-214',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Hủy đơn hàng',
            subtitle: 'Đơn hàng - P2P',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(p2pOrderCancelProvider(widget.orderId)),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: P2POrderCancelPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding:
                          P2PSpacingTokens.p2pRiskControlsBottomScrollPadding(
                            bottomInset,
                          ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          const _CancelHero(),
                          _OrderSummary(order: snapshot.order),
                          _ReasonSelector(
                            reasons: snapshot.reasons,
                            selectedReason: _cancelReason,
                            onSelected: _setReason,
                          ),
                          _CancelWarning(
                            title: snapshot.warningTitle,
                            message: snapshot.warningMessage,
                          ),
                          _ActionRow(
                            enabled: _cancelReason.isNotEmpty,
                            loading: _isSubmitting,
                            onBack: () => _close(context),
                            onConfirm: () =>
                                _confirmCancel(context, snapshot.order),
                          ),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại trạng thái hủy đơn',
                            message:
                                'Tóm tắt đơn, lý do hủy, cảnh báo uy tín, xác nhận bị vô hiệu hóa, trạng thái đang gửi và đường quay lại vẫn hiển thị trước khi hủy đơn P2P.',
                            contractId: 'SC-214',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setReason(String reason) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _cancelReason = reason);
  }

  Future<void> _confirmCancel(
    BuildContext context,
    P2POrderCancelDraft order,
  ) async {
    if (_cancelReason.isEmpty || _isSubmitting) return;
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!context.mounted) return;
    context.go(AppRoutePaths.p2pOrder(order.id));
  }

  void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.p2pOrder(widget.orderId),
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}

class _CancelHero extends StatelessWidget {
  const _CancelHero();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        children: [
          const SizedBox.square(
            dimension: AppSpacing.buttonCompact,
            child: Material(
              color: AppColors.sell10,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.sell,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Hủy đơn hàng?',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: P2PSpacingTokens.p2pRiskControlsOrderHeroMaxWidth,
            ),
            child: Text(
              'Vui lòng chọn lý do hủy. Hủy đơn quá nhiều có thể ảnh hưởng đến uy tín.',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.order});

  final P2POrderCancelDraft order;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _SummaryRowDraft(label: 'Mã đơn', value: order.orderNumber),
      _SummaryRowDraft(
        label: 'Giao dịch',
        value: [
          order.typeLabel,
          _formatAmount(order.amount),
          order.asset,
        ].join(' '),
      ),
      _SummaryRowDraft(
        label: 'Tổng tiền',
        value: '${_formatVnd(order.totalVnd)} ${order.currency}',
      ),
      _SummaryRowDraft(label: 'Merchant', value: order.merchant),
    ];
    return VitCard(
      padding: P2PSpacingTokens.p2pRiskControlsInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THÔNG TIN ĐƠN HÀNG',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var index = 0; index < rows.length; index++)
            _SummaryRow(row: rows[index], showDivider: index < rows.length - 1),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.row, required this.showDivider});

  final _SummaryRowDraft row;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pRiskControlsSummaryRowPadding,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  row.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Flexible(
                child: Text(
                  row.value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: AppSpacing.dividerHairline),
      ],
    );
  }
}

class _SummaryRowDraft {
  const _SummaryRowDraft({required this.label, required this.value});

  final String label;
  final String value;
}

class _ReasonSelector extends StatelessWidget {
  const _ReasonSelector({
    required this.reasons,
    required this.selectedReason,
    required this.onSelected,
  });

  final List<String> reasons;
  final String selectedReason;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lý do hủy',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final reason in reasons)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.x1),
            child: _ReasonButton(
              reason: reason,
              selected: selectedReason == reason,
              onPressed: () => onSelected(reason),
            ),
          ),
      ],
    );
  }
}

class _ReasonButton extends StatelessWidget {
  const _ReasonButton({
    required this.reason,
    required this.selected,
    required this.onPressed,
  });

  final String reason;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: P2POrderCancelPage.reasonKey(reason),
      label: reason,
      selected: selected,
      onTap: onPressed,
      fullWidth: true,
      height: AppSpacing.buttonCompact,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3),
      tone: VitChoicePillTone.danger,
      showSelectedIcon: true,
      selectedIcon: Icons.check_rounded,
      semanticLabel: 'Lý do hủy: $reason',
    );
  }
}

class _CancelWarning extends StatelessWidget {
  const _CancelWarning({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return P2PNoticeCard(
      icon: Icons.warning_amber_rounded,
      title: title,
      message: message,
      iconColor: AppColors.warn,
      titleColor: AppColors.warn,
      messageColor: AppColors.warn,
      borderColor: AppColors.warningBorder,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pRiskControlsInnerPadding,
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.enabled,
    required this.loading,
    required this.onBack,
    required this.onConfirm,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2POrderCancelPage.backKey,
            onPressed: onBack,
            variant: VitCtaButtonVariant.secondary,
            child: const Text('Quay lại'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: P2POrderCancelPage.confirmKey,
            onPressed: enabled ? onConfirm : null,
            loading: loading,
            variant: VitCtaButtonVariant.danger,
            child: const Text('Xác nhận hủy'),
          ),
        ),
      ],
    );
  }
}

String _formatAmount(double value) {
  return value.toStringAsFixed(4);
}

String _formatVnd(int value) => formatP2PVnd(value);
