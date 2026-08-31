import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_high_risk_status_ui.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_empty_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_key_value_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_preset_chip_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_segmented_choice.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

/// Bố cục tablet của Giao dịch Futures (SC-057, 2026-08-31) — cùng route,
/// cùng provider và cùng máy trạng thái ADR-001 với trang phone, nhưng là
/// khối 2 cột của [TradeTabletDetailSurface]: cột chính = quy trình đặt
/// lệnh (rủi ro → hướng → ký quỹ → xem trước → xác nhận), cột phụ = số
/// liệu hợp đồng + vị thế futures đang mở luôn thấy cạnh form.
class FuturesTabletPage extends ConsumerStatefulWidget {
  const FuturesTabletPage({super.key, required this.pairId});

  static const marginFieldKey = Key('sc057_tablet_margin_field');
  static const submitKey = Key('sc057_tablet_submit');

  static Key sideKey(String id) => Key('sc057_tablet_side_$id');
  static Key pctKey(int pct) => Key('sc057_tablet_pct_$pct');

  final String pairId;

  @override
  ConsumerState<FuturesTabletPage> createState() => _FuturesTabletPageState();
}

class _FuturesTabletPageState extends ConsumerState<FuturesTabletPage> {
  final _marginController = TextEditingController();
  TradeFuturesSide _side = TradeFuturesSide.long;
  final int _leverage = 10;

  @override
  void dispose() {
    _marginController.dispose();
    super.dispose();
  }

  TradeFuturesOrderControllerRequest get _orderRequest {
    final margin = double.tryParse(_marginController.text) ?? 0;
    return (
      pairId: widget.pairId,
      draft: TradeFuturesOrderDraft(
        pairId: widget.pairId,
        side: _side,
        type: TradeFuturesOrderType.market,
        margin: margin,
        leverage: _leverage,
      ),
    );
  }

  Future<void> _submit() async {
    final request = _orderRequest;
    final provider = tradeFuturesOrderControllerProvider(request);
    final notifier = ref.read(provider.notifier);
    if (!notifier.canSubmit) return;
    await notifier.submit();
    if (!mounted) return;
    final orderState = ref.read(provider);
    if (orderState.status == TradeHighRiskFlowStatus.success) {
      setState(() => _marginController.clear());
      final orderId = orderState.receipt?.orderId ?? 'lệnh';
      await showVitNoticeSheet(
        context: context,
        title: 'Đã gửi lệnh',
        message: 'Đã gửi $orderId',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      );
      return;
    }
    await showVitNoticeSheet(
      context: context,
      title: 'Gửi lệnh thất bại',
      message:
          orderState.errorMessage ?? 'Không gửi được lệnh. Vui lòng thử lại.',
      variant: VitBannerVariant.error,
    );
  }

  Future<void> _openConfirm(
    TradeFuturesPreview preview,
    bool submitting,
  ) async {
    if (!preview.canOpen || submitting) return;
    final orderNotifier = ref.read(
      tradeFuturesOrderControllerProvider(_orderRequest).notifier,
    );
    orderNotifier.enterPreview();
    final sideLabel = _side == TradeFuturesSide.long ? 'Giá tăng' : 'Giá giảm';
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại hợp đồng',
      lines: [
        const VitTradeConfirmLine(label: 'Hướng', value: 'Hợp đồng tương lai'),
        VitTradeConfirmLine(label: 'Cặp', value: widget.pairId.toUpperCase()),
        VitTradeConfirmLine(label: 'Chiều', value: sideLabel),
        VitTradeConfirmLine(label: 'Đòn bẩy', value: '$_leverage x'),
        VitTradeConfirmLine(
          label: 'Ký quỹ',
          value: '${_marginController.text} USDT',
        ),
        VitTradeConfirmLine(
          label: 'Quy mô vị thế',
          value: formatTradeMoney(preview.positionSize),
        ),
        VitTradeConfirmLine(
          label: 'Giá thanh lý',
          value: formatTradePrice(preview.liquidationPrice),
        ),
      ],
      riskMessage:
          'Hợp đồng tương lai có rủi ro cao. Bạn có thể mất toàn bộ ký quỹ. '
          'Không hoàn tác sau khi xác nhận gửi.',
    );
    if (!mounted) return;
    if (confirmed) {
      unawaited(_submit());
    } else {
      orderNotifier.cancelPreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final futuresAsync = ref.watch(tradeFuturesProvider(widget.pairId));
    return futuresAsync.when(
      loading: () => TradeTabletDetailSurface(
        semanticLabel: 'Giao dịch hợp đồng tương lai',
        semanticIdentifier: 'SC-057',
        title: 'Futures ${widget.pairId.toUpperCase()}',
        subtitle: 'Hợp đồng tương lai',
        onBack: () => context.go(AppRoutePaths.tradePair(widget.pairId)),
        primary: const VitSkeletonList(rows: 5),
        secondary: const VitSkeletonList(rows: 4),
      ),
      error: (error, stackTrace) => TradeTabletDetailSurface(
        semanticLabel: 'Giao dịch hợp đồng tương lai',
        semanticIdentifier: 'SC-057',
        title: 'Futures ${widget.pairId.toUpperCase()}',
        subtitle: 'Hợp đồng tương lai',
        onBack: () => context.go(AppRoutePaths.tradePair(widget.pairId)),
        primary: VitErrorState(
          title: 'Không tải được màn hình futures',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(tradeFuturesProvider(widget.pairId)),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: _buildContent,
    );
  }

  Widget _buildContent(TradeFuturesSnapshot snapshot) {
    final orderRequest = _orderRequest;
    final orderState = ref.watch(
      tradeFuturesOrderControllerProvider(orderRequest),
    );
    final orderNotifier = ref.read(
      tradeFuturesOrderControllerProvider(orderRequest).notifier,
    );
    final preview = orderState.preview;
    final submitting = orderState.status.isBusy;
    final available = snapshot.accountBalance - snapshot.usedMargin;
    final margin = double.tryParse(_marginController.text) ?? 0;

    return TradeTabletDetailSurface(
      semanticLabel: 'Giao dịch hợp đồng tương lai',
      semanticIdentifier: 'SC-057',
      title: 'Futures ${snapshot.pair.symbol}',
      subtitle: 'Hợp đồng tương lai · đòn bẩy $_leverage x',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradePair(widget.pairId),
        mode: BackNavigationMode.historyThenFallback,
      ),
      primary: VitCard(
        radius: VitCardRadius.tight,
        density: VitDensity.tool,
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitHighRiskStatePanel(
              state: orderState.status.uiState,
              density: VitDensity.tool,
              title: switch (orderState.status.uiState) {
                VitHighRiskUiState.submitting => 'Đang gửi lệnh',
                VitHighRiskUiState.success => 'Đã gửi lệnh',
                VitHighRiskUiState.error => 'Gửi lệnh thất bại',
                VitHighRiskUiState.offline => 'Mất kết nối',
                _ => 'Rủi ro cao',
              },
              message: switch (orderState.status.uiState) {
                VitHighRiskUiState.submitting =>
                  'Đang gửi lệnh tới sàn. Vui lòng chờ trong giây lát.',
                VitHighRiskUiState.success =>
                  'Đã gửi ${orderState.receipt?.orderId ?? 'lệnh'}.',
                VitHighRiskUiState.error || VitHighRiskUiState.offline =>
                  orderState.errorMessage ??
                      'Không gửi được lệnh. Vui lòng thử lại.',
                _ =>
                  'Hợp đồng tương lai có thể làm bạn mất toàn bộ ký quỹ. Chỉ dùng số tiền bạn chấp nhận mất.',
              },
              contractId: snapshot.highRiskContractId,
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            Text(
              'Chọn hướng',
              style: AppTextStyles.control.copyWith(color: AppColors.text1),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitSegmentedChoice<TradeFuturesSide>(
              selected: _side,
              onChanged: (side) => setState(() => _side = side),
              options: [
                VitSegmentedChoiceOption(
                  key: FuturesTabletPage.sideKey('long'),
                  value: TradeFuturesSide.long,
                  label: 'Giá tăng',
                  accentColor: AppColors.buy,
                  leading: const Icon(Icons.trending_up_rounded),
                ),
                VitSegmentedChoiceOption(
                  key: FuturesTabletPage.sideKey('short'),
                  value: TradeFuturesSide.short,
                  label: 'Giá giảm',
                  accentColor: AppColors.sell,
                  leading: const Icon(Icons.trending_down_rounded),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitInput(
              key: FuturesTabletPage.marginFieldKey,
              label: 'Số tiền ký quỹ (USDT)',
              semanticLabel: 'Số tiền ký quỹ USDT',
              controller: _marginController,
              onChanged: (_) => setState(() {}),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitPresetChipRow.percentBalance(
              onTap: (pct) => setState(() {
                _marginController.text = (available * pct / 100)
                    .toStringAsFixed(0);
              }),
              keyFor: FuturesTabletPage.pctKey,
              accentColor: AppColors.primary,
            ),
            if (margin > 0) ...[
              const SizedBox(height: TabletSpacingTokens.x4),
              _FuturesPreviewRows(preview: preview),
            ],
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              key: FuturesTabletPage.submitKey,
              onPressed: preview.canOpen && !submitting
                  ? () => _openConfirm(preview, submitting)
                  : null,
              loading: submitting,
              density: VitDensity.tool,
              variant: _side == TradeFuturesSide.long
                  ? VitCtaButtonVariant.success
                  : VitCtaButtonVariant.danger,
              child: Text(
                submitting
                    ? 'Đang gửi lệnh…'
                    : preview.canOpen
                    ? 'Xem lại & xác nhận'
                    : 'Nhập ký quỹ để tiếp tục',
              ),
            ),
            // Bậc thang canSubmit của máy ADR-001 — hiển thị lỗi validate
            // gần nút bấm (form feedback chuẩn).
            if (!orderNotifier.canSubmit && margin > 0) ...[
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(
                orderNotifier.validationMessage() ?? '',
                style: AppTextStyles.caption.copyWith(color: AppColors.caution),
              ),
            ],
          ],
        ),
      ),
      secondary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            radius: VitCardRadius.tight,
            density: VitDensity.tool,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (label, value) in [
                  ('Giá đánh dấu', formatTradePrice(snapshot.markPrice)),
                  ('Giá chỉ số', formatTradePrice(snapshot.indexPrice)),
                  (
                    'Phí vốn (funding)',
                    '${snapshot.fundingRate.toStringAsFixed(4)}%',
                  ),
                  (
                    'Số dư tài khoản',
                    '${formatTradeMoney(snapshot.accountBalance)} USDT',
                  ),
                  (
                    'Ký quỹ đã dùng',
                    '${formatTradeMoney(snapshot.usedMargin)} USDT',
                  ),
                  ('Khả dụng', '${formatTradeMoney(available)} USDT'),
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: TabletSpacingTokens.x1,
                    ),
                    child: VitKeyValueRow(
                      label: label,
                      value: value,
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                      valueStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: TabletSpacingTokens.pageRhythmStandardSectionGap,
          ),
          if (snapshot.positions.isEmpty)
            const VitEmptyState(
              icon: Icons.insights_outlined,
              title: 'Chưa có vị thế futures',
              message: 'Vị thế mở sẽ hiện tại đây với giá thanh lý.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              density: VitDensity.tool,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Vị thế futures đang mở',
                    style: AppTextStyles.control.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  for (final position in snapshot.positions)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: TabletSpacingTokens.x1,
                      ),
                      child: _FuturesPositionRow(position: position),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FuturesPreviewRows extends StatelessWidget {
  const _FuturesPreviewRows({required this.preview});

  final TradeFuturesPreview preview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (label, value, color) in [
          (
            'Quy mô vị thế',
            formatTradeMoney(preview.positionSize),
            AppColors.text1,
          ),
          (
            'Số hợp đồng',
            preview.contractQty.toStringAsFixed(3),
            AppColors.text2,
          ),
          (
            'Giá thanh lý',
            formatTradePrice(preview.liquidationPrice),
            AppColors.caution,
          ),
          ('Phí mở lệnh', formatTradeMoney(preview.openFee), AppColors.text2),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: TabletSpacingTokens.x1,
            ),
            child: VitKeyValueRow(
              label: label,
              value: value,
              labelStyle: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
              ),
              valueStyle: AppTextStyles.caption.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
      ],
    );
  }
}

class _FuturesPositionRow extends StatelessWidget {
  const _FuturesPositionRow({required this.position});

  final TradeFuturesPosition position;

  @override
  Widget build(BuildContext context) {
    final positive = position.pnl >= 0;
    final sideColor = position.side == TradeFuturesSide.long
        ? AppColors.buy
        : AppColors.sell;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text.rich(
            TextSpan(
              text: position.side == TradeFuturesSide.long ? 'LÊN ' : 'XUỐNG ',
              style: AppTextStyles.caption.copyWith(
                color: sideColor,
                fontWeight: AppTextStyles.bold,
              ),
              children: [
                TextSpan(
                  text: '${position.symbol} · ${position.leverage}x',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'TL ${position.liquidPrice.toStringAsFixed(0)}',
            maxLines: 1,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '${positive ? '▲' : '▼'} ${formatTradeSignedMoney(position.pnl)}',
            textAlign: TextAlign.right,
            maxLines: 1,
            style: AppTextStyles.caption.copyWith(
              color: positive ? AppColors.buy : AppColors.sell,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
