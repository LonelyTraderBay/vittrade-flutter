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

const double _p2pExpressConfirmVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pExpressConfirmNativeNavClearance =
    _p2pExpressConfirmVisualNavClearance - AppSpacing.x4;
const double _p2pExpressConfirmVisualClearance = AppSpacing.x3;
const double _p2pExpressConfirmNativeClearance = AppSpacing.x2;
const double _p2pExpressConfirmDividerHeight = AppSpacing.dividerHairline;

class P2PExpressConfirmPage extends ConsumerStatefulWidget {
  const P2PExpressConfirmPage({
    super.key,
    this.shellRenderMode,
    this.tradeType = P2PTradeType.buy,
    this.asset = 'USDT',
    this.fiatAmount = 0,
    this.cryptoAmount = 0,
    this.adId,
    this.paymentMethod,
  });

  static const contentKey = Key('sc210_p2p_express_confirm_content');
  static const confirmKey = Key('sc210_p2p_express_confirm_submit');
  static const cancelKey = Key('sc210_p2p_express_confirm_cancel');

  final ShellRenderMode? shellRenderMode;
  final P2PTradeType tradeType;
  final String asset;
  final double fiatAmount;
  final double cryptoAmount;
  final String? adId;
  final String? paymentMethod;

  @override
  ConsumerState<P2PExpressConfirmPage> createState() =>
      _P2PExpressConfirmPageState();
}

class _P2PExpressConfirmPageState extends ConsumerState<P2PExpressConfirmPage> {
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pExpressConfirmProvider((
        tradeType: widget.tradeType,
        asset: widget.asset,
        fiatAmount: widget.fiatAmount,
        cryptoAmount: widget.cryptoAmount,
        adId: widget.adId,
        paymentMethod: widget.paymentMethod,
      )),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pExpressConfirmVisualNavClearance +
                  _p2pExpressConfirmVisualClearance
            : _p2pExpressConfirmNativeNavClearance +
                  _p2pExpressConfirmNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Xác nhận giao dịch nhanh P2P',
      semanticIdentifier: 'SC-210',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              subtitle: 'Express - P2P',
              showBack: true,
              onBack: () => _close(context),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              subtitle: 'Express - P2P',
              showBack: true,
              onBack: () => _close(context),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pExpressConfirmProvider((
                  tradeType: widget.tradeType,
                  asset: widget.asset,
                  fiatAmount: widget.fiatAmount,
                  cryptoAmount: widget.cryptoAmount,
                  adId: widget.adId,
                  paymentMethod: widget.paymentMethod,
                )),
              ),
            ),
          ),
          data: (snapshot) {
            final controller = P2PExpressConfirmController(
              state: P2PExpressConfirmViewState(snapshot: snapshot),
            );
            final accent = snapshot.isBuy ? AppColors.buy : AppColors.sell;
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: controller.confirmationTitle,
                subtitle: 'Express - P2P',
                showBack: true,
                onBack: () => _close(context),
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
                        key: P2PExpressConfirmPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsetsDirectional.only(
                          bottom: scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.defaultPadding,
                          density: VitDensity.relaxed,
                          gap: VitContentGap.defaultGap,
                          children: [
                            _Hero(snapshot: snapshot, accent: accent),
                            _SummaryCard(snapshot: snapshot, accent: accent),
                            _MerchantCard(ad: snapshot.ad),
                            P2PNoticeCard(
                              icon: Icons.lock_outline_rounded,
                              title: 'Escrow bảo vệ',
                              message:
                                  '${_formatAmount(snapshot.cryptoAmount)} ${snapshot.asset} ${snapshot.escrowNote}',
                              iconColor: AppColors.buy,
                              titleColor: AppColors.buy,
                              messageColor: AppColors.text2,
                              borderColor: AppColors.buy20,
                            ),
                            P2PNoticeCard(
                              icon: Icons.warning_amber_rounded,
                              message: snapshot.warningNote,
                              iconColor: AppColors.warn,
                              messageColor: AppColors.warn,
                              borderColor: AppColors.warningBorder,
                            ),
                            _ActionRow(
                              processing: _processing,
                              isBuy: snapshot.isBuy,
                              onCancel: () => _close(context),
                              onConfirm: () => _confirm(context, controller),
                            ),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem lại xác nhận đơn Express',
                              message:
                                  'Hướng giao dịch, số tiền fiat, số crypto, merchant, phương thức thanh toán, ghi chú escrow, phí, cảnh báo, hủy và xác nhận đã được xem trước khi tạo đơn.',
                              contractId: 'SC-210',
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

  Future<void> _confirm(
    BuildContext context,
    P2PExpressConfirmController controller,
  ) async {
    if (_processing) return;
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!context.mounted) return;
    context.go(AppRoutePaths.p2pOrder(controller.orderRouteId));
  }

  static void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.p2p);
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.snapshot, required this.accent});

  final P2PExpressConfirmSnapshot snapshot;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitNextActionCard(
      icon: Icons.bolt_outlined,
      title: 'Express ${snapshot.isBuy ? 'Mua' : 'Bán'}',
      subtitle: 'Kiểm tra số tiền, phương thức TT và escrow trước khi xác nhận',
      accentColor: accent,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot, required this.accent});

  final P2PExpressConfirmSnapshot snapshot;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _SummaryRow(
        label: 'Loại giao dịch',
        value: snapshot.isBuy ? 'Mua' : 'Bán',
        color: accent,
      ),
      _SummaryRow(label: 'Tài sản', value: snapshot.asset),
      _SummaryRow(
        label: 'Số lượng',
        value: '${_formatAmount(snapshot.cryptoAmount)} ${snapshot.asset}',
        strong: true,
      ),
      _SummaryRow(
        label: 'Giá',
        value: '${_formatVnd(snapshot.ad.price)} VND/${snapshot.asset}',
      ),
      _SummaryRow(
        label: snapshot.isBuy ? 'Cần thanh toán' : 'Sẽ nhận được',
        value: '${_formatVnd(snapshot.fiatAmount.round())} VND',
        color: accent,
        strong: true,
      ),
      _SummaryRow(label: 'Phương thức TT', value: snapshot.paymentMethod),
      const _SummaryRow(
        label: 'Phí giao dịch',
        value: 'Miễn phí',
        color: AppColors.buy,
      ),
    ];

    return VitCard(
      borderColor: accent.withValues(alpha: .30),
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3),
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++)
            _SummaryLine(row: rows[index], last: index == rows.length - 1),
        ],
      ),
    );
  }
}

class _SummaryRow {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.color,
    this.strong = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool strong;
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.row, required this.last});

  final _SummaryRow row;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.x2,
          ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.caption.copyWith(
                    color: row.color ?? AppColors.text1,
                    fontWeight: row.strong
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                    fontFeatures: row.strong
                        ? AppTextStyles.tabularFigures
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!last)
          const Divider(
            height: _p2pExpressConfirmDividerHeight,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _MerchantCard extends StatelessWidget {
  const _MerchantCard({required this.ad});

  final P2PAdDraft ad;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pExpressConfirmCompactCardPadding,
      child: Row(
        children: [
          VitAssetAvatar(
            label: ad.merchant,
            accentColor: AppColors.accent,
            size: AppSpacing.x6,
            radius: AppRadii.avatarRadius,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        ad.merchant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (ad.merchantVerified) ...[
                      const SizedBox(width: AppSpacing.x1),
                      const Icon(
                        Icons.verified_outlined,
                        color: AppColors.primary,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      '${ad.completedOrders} đơn',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      '${ad.completionRate.toStringAsFixed(1)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const VitStatusPill(
            label: 'Escrow',
            status: VitStatusPillStatus.success,
            size: VitStatusPillSize.sm,
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.processing,
    required this.isBuy,
    required this.onCancel,
    required this.onConfirm,
  });

  final bool processing;
  final bool isBuy;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2PExpressConfirmPage.cancelKey,
            onPressed: processing ? null : onCancel,
            variant: VitCtaButtonVariant.ghost,
            child: const Text('Hủy bỏ'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: P2PExpressConfirmPage.confirmKey,
            onPressed: processing ? null : onConfirm,
            loading: processing,
            variant: isBuy
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger,
            child: Text(processing ? 'Đang tạo đơn...' : 'Xác nhận'),
          ),
        ),
      ],
    );
  }
}

P2PTradeType parseP2PTradeType(String? value) {
  return value == 'sell' ? P2PTradeType.sell : P2PTradeType.buy;
}

double parseP2PAmount(String? value) {
  if (value == null || value.isEmpty) return 0;
  return double.tryParse(value) ?? 0;
}

String _formatVnd(int value) => formatP2PVnd(value);

String _formatAmount(double value) {
  if (value == 0) return '0.00';
  if (value == value.roundToDouble()) return value.toStringAsFixed(2);
  return value.toStringAsFixed(6);
}
